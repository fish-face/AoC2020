import os
import sequtils
import strutils

type
  State = enum
    ACTIVE = "#"
    INACTIVE = "."
  Space = object
    w, d, h: int
    xo, yo, zo: int
    #data: seq[seq[seq[State]]]
    data: seq[State]
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

proc `[]`(sr: SpaceRef, x, y, z: int): State =
  let
    px = x + sr.xo
    py = y + sr.yo
    pz = z + sr.zo
  if px < -sr.w or
    py < -sr.h or
    pz < -sr.d or
    px > sr.w or
    py > sr.h or
    pz > sr.d:
    return INACTIVE
  try:
    sr[].data[triple(px, py, pz)]
  except IndexDefect:
    echo (px, py, pz, len(sr.data))
    raise

proc `[]=`(sr: var SpaceRef, x, y, z: int, v: State) =
  let p = triple(x, y, z)
  if p >= sr.data.len:
    let delta = p - sr.data.len + 1
    sr.data &= INACTIVE.repeat(delta)
  sr.data[p] = v

proc fromInput(input: seq[seq[State]]): SpaceRef =
  let
    w = input[0].len div 2
    h = input.len div 2
    d = 0

  result = SpaceRef(
    w: w,
    h: h,
    d: d,
    data: newSeqWith(triple(w, h, d) + 1, INACTIVE)
  )

  for y, row in input:
    for x, state in row:
      result[x-w, y-h, 0] = state

iterator keys(s: SpaceRef): (int, int, int) =
  for z in -s.d..s.d:
    for y in -s.h..s.h:
      for x in -s.w..s.w:
        yield (x, y, z)

proc copy(a: SpaceRef): SpaceRef =
  result = SpaceRef(
    w: a.w,
    h: a.h,
    d: a.d,
    data: a.data
  )

proc expand(sr: SpaceRef) =
  sr.w += 1
  sr.h += 1
  sr.d += 1
  sr.data &= INACTIVE.repeat(triple(sr.w, sr.h, sr.d) + 1 - sr.data.len)

proc adjActive(a: SpaceRef, x, y, z: int): int =
  for px in x-1..x+1:
    for py in y-1..y+1:
      for pz in z-1..z+1:
        if (px, py, pz) == (x, y, z):
          continue
        if a[px, py, pz] == ACTIVE:
          result += 1

proc next(s: SpaceRef, x, y, z: int): State =
  let neighbours = s.adjActive(x, y, z)
  if s[x,y,z] == ACTIVE:
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
    w: s.w,
    h: s.h,
    d: s.d,
    data: newSeq[State](s.data.len)
  )
  result.expand

  for (x, y, z) in result.keys:
    result[x, y, z] = s.next(x, y, z)

proc `$`(sr: SpaceRef): string =
  for z in -sr.d..sr.d:
    result &= "z=" & $z & "\n"
    for y in -sr.h..sr.h:
      result &= toSeq(-sr.w..sr.w).mapIt(sr[it,y,z]).join("") & "\n"

proc count(s: SpaceRef): int =
  toSeq(s.keys).mapIt(s[it[0], it[1], it[2]]).foldl(a + ord(b == ACTIVE), 0)

let input = readFile(paramStr(1)).strip().splitlines().mapIt(it.map(toState))

var data = input.fromInput

echo data
echo count cycle cycle cycle cycle cycle cycle data
