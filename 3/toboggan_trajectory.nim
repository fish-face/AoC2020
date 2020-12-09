import os
import strutils

let map = readFile(paramStr(1)).strip().splitlines()
let width = map[0].len()
let height = map.len()

type
  Pos[T] = object
    x: T
    y: T
    w: T

proc newPos[T](x: T, y: T, w: T): Pos[T] =
  result.x = x
  result.y = y
  result.w = x

proc `+=`[T](a: var Pos[T], b: Pos[T]) =
  a.x = (a.x + b.x) mod a.w
  a.y += b.y

let dirs = @[
  Pos[int](x: 1, y: 1),
  Pos[int](x: 3, y: 1),
  Pos[int](x: 5, y: 1),
  Pos[int](x: 7, y: 1),
  Pos[int](x: 1, y: 2)
]

var acc = 1

for dir in dirs:
  var pos = Pos[int](x: 0, y: 0, w: width)
  var count = 0

  while pos.y < height:
    if map[pos.y][pos.x] == '#':
      inc count
    pos += dir

  echo dir, ": ", count
  acc *= count
echo acc
