import os
import sequtils
import strutils
import sugar

type
  State = enum
    FULL = "#"
    FLOOR = "."
    EMPTY = "L"
  Map = seq[seq[State]]
  Pos = object
    x: int
    y: int

proc toState(c: char): State =
  case c:
    of '.': FLOOR
    of 'L': EMPTY
    of '#': FULL
    else:
      raise newException(ValueError, "invalid state " & c)

proc w(m: Map): int =
  m[0].len
proc h(m: Map): int =
  m.len

proc `+`(p: Pos, q: array[2, int]): Pos =
  result.x = p.x + q[0]
  result.y = p.y + q[1]

proc contains(m: Map, p: Pos): bool =
  p.x >= 0 and p.y >= 0 and p.y < m.h() and p.x < m.w()
proc `[]`(m: Map, p: Pos): State =
  if p notin m:
    return FLOOR
  m[p.y][p.x]
proc `[]=`(m: var Map, p: Pos, v: State) =
  m[p.y][p.x] = v

iterator pairs(m: Map): tuple[key: Pos, val: State] =
  let w = m.w()
  for y in 0..<m.h():
    for x in 0..<w:
      yield (Pos(x: x, y: y), m[y][x])

proc toString(m: Map): string =
  m.mapIt(
    # it = line
    it.mapIt($it).join()
  ).join("\n")

proc adj(m: Map, p: Pos): seq[State] =
  return @[# m[p],
    m[p + [ 0,  1]],
    m[p + [ 0, -1]],
    m[p + [ 1,  1]],
    m[p + [ 1,  0]],
    m[p + [ 1, -1]],
    m[p + [-1,  1]],
    m[p + [-1,  0]],
    m[p + [-1, -1]],
  ]

var vismap: seq[seq[seq[Pos]]]

proc createVisMap(m: Map): seq[seq[seq[Pos]]] =
  result = newSeqWith(m.h(), newSeqWith(m.w(), newSeq[Pos]()))
  let vecs = [
    [ 0,  1],
    [ 1,  1],
    [ 1,  0],
    [ 1, -1],
  ]
  for p, s in m:
    for v in vecs:
      var pv = p
      while pv.in(m):
        pv = pv + v
        if m[pv] == EMPTY:
          result[p.y][p.x].add(pv)
          result[pv.y][pv.x].add(p)
          break

proc visible(m: Map, p: Pos): seq[State] =
  return vismap[p.y][p.x].mapIt(m[it])

proc countFull(cells: seq[State]): int =
  cells.mapIt(if it == FULL: 1 else: 0).foldl(a + b)

proc stepOne(m: Map): Map =
  result = m
  for p, s in m:
    let total = m.adj(p).countFull()
    if s == EMPTY and total == 0:
      result[p] = FULL
    elif s == FULL and total >= 4:
      result[p] = EMPTY

proc stepTwo(m: Map): Map =
  result = m
  for p, s in m:
    let total = m.visible(p).countFull()
    if s == EMPTY and total == 0:
      result[p] = FULL
    elif s == FULL and total >= 5:
      result[p] = EMPTY

proc iterateUntilSteady(m: Map, stepper: Map -> Map, animate: bool = false): Map =
  var m_prev = m
  var m_next: Map
  while true:
    m_next = m_prev.stepper()
    if animate:
      echo m_prev.toString()
      echo ""
      sleep 100
    if m_next == m_prev:
      return m_next
    m_prev = m_next

let input: Map = readFile(paramStr(1)).strip().splitlines().mapIt(it.map(toState))
vismap = input.createVisMap()
var result = input.iterateUntilSteady(stepOne)
echo result.mapIt(it.countFull()).foldl(a + b)
result = input.iterateUntilSteady(stepTwo)
echo result.mapIt(it.countFull()).foldl(a + b)
