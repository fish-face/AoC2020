import os
import sequtils
import strformat
import strutils
import tables

type
  State = enum
    ACTIVE = "#"
    INACTIVE = "."
  Space = object
    lx, lz, ly, lw: int
    #data: seq[seq[seq[State]]]
    #data: seq[State]
    data: Table[(int, int, int, int), State]
  SpaceRef = ref Space

proc toState(c: char): State =
  case c:
    of '.': INACTIVE
    of '#': ACTIVE
    else:
      raise newException(ValueError, "invalid state " & c)

proc pair(x, y: int): int {.inline.} =
  let
    xx = if x >= 0: 2 * x else: -2 * x - 1
    yy = if y >= 0: 2 * y else: -2 * y - 1
  (xx + yy) * (xx + yy + 1) div 2 + yy

proc triple(x, y, z: int): int {.inline.} =
  pair(pair(x, y), z)

proc quad(x, y, z, w: int): int {.inline.} =
  pair(pair(pair(x, y), z), w)

proc `[]`(sr: SpaceRef, x, y, z, w: int): State =
  if x < -sr.lx or
    y < -sr.ly or
    z < -sr.lz or
    w < -sr.lw or
    x > sr.lx or
    y > sr.ly or
    z > sr.lz or
    w > sr.lw:
    return INACTIVE
  try:
    sr[].data[(x, y, z, w)]
  except KeyError:
    return INACTIVE
    raise

proc `[]=`(sr: var SpaceRef, x, y, z, w: int, v: State) =
  sr.data[(x, y, z, w)] = v

proc fromInput(input: seq[seq[State]]): SpaceRef =
  let
    lx = input[0].len div 2
    ly = input.len div 2
    lz = 0
    lw = 0

  result = SpaceRef(
    lx: lx,
    ly: ly,
    lz: lz,
    lw: lw,
    data: initTable[(int, int, int, int), State]()
  )

  for y, row in input:
    for x, state in row:
      result[x-lx, y-ly, 0, 0] = state

iterator keys(s: SpaceRef): (int, int, int, int) =
  for w in -s.lw..s.lw:
    for z in -s.lz..s.lz:
      for y in -s.ly..s.ly:
        for x in -s.lx..s.lx:
          yield (x, y, z, w)

proc copy(a: SpaceRef): SpaceRef =
  result = SpaceRef(
    lx: a.lx,
    ly: a.ly,
    lz: a.lz,
    lw: a.lw,
    data: a.data
  )

proc expand(sr: SpaceRef) =
  sr.lx += 1
  sr.ly += 1
  sr.lz += 1
  sr.lw += 1
  #sr.data &= INACTIVE.repeat(quad(sr.lx, sr.ly, sr.lz, sr.lw) + 1 - sr.data.len)

const adj = [
  (-1, -1, -1, -1), (-1, -1, -1, 0), (-1, -1, -1, 1), (-1, -1, 0, -1),
  (-1, -1, 0, 0), (-1, -1, 0, 1), (-1, -1, 1, -1), (-1, -1, 1, 0),
  (-1, -1, 1, 1), (-1, 0, -1, -1), (-1, 0, -1, 0), (-1, 0, -1, 1),
  (-1, 0, 0, -1), (-1, 0, 0, 0), (-1, 0, 0, 1), (-1, 0, 1, -1),
  (-1, 0, 1, 0), (-1, 0, 1, 1), (-1, 1, -1, -1), (-1, 1, -1, 0),
  (-1, 1, -1, 1), (-1, 1, 0, -1), (-1, 1, 0, 0), (-1, 1, 0, 1),
  (-1, 1, 1, -1), (-1, 1, 1, 0), (-1, 1, 1, 1), (0, -1, -1, -1),
  (0, -1, -1, 0), (0, -1, -1, 1), (0, -1, 0, -1), (0, -1, 0, 0),
  (0, -1, 0, 1), (0, -1, 1, -1), (0, -1, 1, 0), (0, -1, 1, 1),
  (0, 0, -1, -1), (0, 0, -1, 0), (0, 0, -1, 1), (0, 0, 0, -1),
  (0, 0, 0, 1), (0, 0, 1, -1), (0, 0, 1, 0), (0, 0, 1, 1),
  (0, 1, -1, -1), (0, 1, -1, 0), (0, 1, -1, 1), (0, 1, 0, -1),
  (0, 1, 0, 0), (0, 1, 0, 1), (0, 1, 1, -1), (0, 1, 1, 0),
  (0, 1, 1, 1), (1, -1, -1, -1), (1, -1, -1, 0), (1, -1, -1, 1),
  (1, -1, 0, -1), (1, -1, 0, 0), (1, -1, 0, 1), (1, -1, 1, -1),
  (1, -1, 1, 0), (1, -1, 1, 1), (1, 0, -1, -1), (1, 0, -1, 0),
  (1, 0, -1, 1), (1, 0, 0, -1), (1, 0, 0, 0), (1, 0, 0, 1),
  (1, 0, 1, -1), (1, 0, 1, 0), (1, 0, 1, 1), (1, 1, -1, -1),
  (1, 1, -1, 0), (1, 1, -1, 1), (1, 1, 0, -1), (1, 1, 0, 0),
  (1, 1, 0, 1), (1, 1, 1, -1), (1, 1, 1, 0), (1, 1, 1, 1)
]

proc adjActive(a: SpaceRef, x, y, z, w: int): int =
  for (px, py, pz, pw) in adj:
    if a[x+px, y+py, z+pz, w+pw] == ACTIVE:
      result += 1

proc next(s: SpaceRef, x, y, z, w: int): State =
  let neighbours = s.adjActive(x, y, z, w)
  if s[x,y,z,w] == ACTIVE:
    if neighbours == 2 or neighbours == 3:
      return ACTIVE
    else:
      return INACTIVE
  else:
    if neighbours == 3:
      return ACTIVE
    else:
      return INACTIVE

proc cycle(s: SpaceRef): SpaceRef =
  result = SpaceRef(
    lx: s.lx,
    ly: s.ly,
    lz: s.lz,
    lw: s.lw,
    data: initTable[(int, int, int, int), State]()
  )
  result.expand

  for (x, y, z, w) in result.keys:
    result[x, y, z, w] = s.next(x, y, z, w)

proc `$`(sr: SpaceRef): string =
  for w in -sr.lw..sr.lw:
    for z in -sr.lz..sr.lz:
      result &= fmt"z={z}, w={w}" & "\n"
      #result &= "z=" & $z & "\n"
      for y in -sr.ly..sr.ly:
        result &= toSeq(-sr.lx..sr.lx).mapIt(sr[it,y,z,w]).join("") & "\n"

proc count(s: SpaceRef): int =
  #toSeq(s.keys).mapIt(s[it[0], it[1], it[2], it[3]]).foldl(a + ord(b == ACTIVE), 0)
  toSeq(s.data.values).foldl(a + ord(b == ACTIVE), 0)

let input = readFile(paramStr(1)).strip().splitlines().mapIt(it.map(toState))

var data = input.fromInput

for i in 0..<6:
  #echo data
  data = cycle data
  echo count data
