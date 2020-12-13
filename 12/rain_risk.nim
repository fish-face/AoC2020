import os
import sequtils
import strutils
import tables

type
  vec = (int, int)

proc `*`(v: vec, x: int): vec =
  return (v[0] * x, v[1] * x)
proc `+=`(v: var vec, w: vec) =
  v = (v[0] + w[0], v[1] + w[1])
const sin = {0: 0, 90: 1, 180: 0, 270: -1}.toTable
const cos = {0: 1, 90: 0, 180: -1, 270: 0}.toTable
proc rotate(v: vec, t: int, origin: vec = (0, 0)): vec =
  let
    ct = cos[t]
    st = sin[t]
  (v[0] * ct - v[1] * st, v[0] * st + v[1] * ct)

let input = readFile(paramStr(1)).strip().splitlines().mapIt((it[0], it[1..^1].parseInt()))

proc partOne() =
  var pos = (0, 0)
  var dir = (1, 0)
  for line in input:
    let (instr, val) = line
    case instr:
      of 'N':
        pos[1] += val
      of 'S':
        pos[1] -= val
      of 'E':
        pos[0] += val
      of 'W':
        pos[0] -= val
      of 'F':
        pos += dir * val
      of 'R':
        dir = dir.rotate(360 - val)
      of 'L':
        dir = dir.rotate(val)
      else:
        discard
  echo abs(pos[0]) + abs(pos[1])

proc partTwo() =
  var pos = (0, 0)
  var waypoint = (10, 1)
  for line in input:
    let (instr, val) = line
    case instr:
      of 'N':
        waypoint[1] += val
      of 'S':
        waypoint[1] -= val
      of 'E':
        waypoint[0] += val
      of 'W':
        waypoint[0] -= val
      of 'F':
        pos += waypoint * val
      of 'R':
        waypoint = waypoint.rotate(360 - val, pos)
      of 'L':
        waypoint = waypoint.rotate(val, pos)
      else:
        discard
  echo abs(pos[0]) + abs(pos[1])

partOne()
partTwo()
