import os
import strscans
import strutils
import sequtils
import strformat
import tables

let input = readFile(paramStr(1)).strip().split(',')

proc solve(input: seq[string], max: int): int =
  var recents: Table[int, int]
  var prev: int

  for i in 0..<input.len:
    recents[prev] = i
    prev = parseInt input[i]

  var gap: int
  for i in input.len..<max:
    gap = i - recents.getOrDefault(prev, i)
    recents[prev] = i
    prev = gap

  prev

echo solve(input, 2020)
echo solve(input, 30_000_000)

