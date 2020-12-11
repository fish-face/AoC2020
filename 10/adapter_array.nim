import algorithm
import os
import sequtils
import strutils
import tables

iterator diffs[T](s: seq[T]): T =
  var prev = s[0]
  for x in s[1..^1]:
    yield x - prev
    prev = x

iterator runsOfOnes(diffs: seq[int]): int =
  var prev = 0
  var acc = 0
  for x in diffs[0..^1]:
    if x == 1:
      acc += 1
    elif x != 1:
      if prev == 1:
        yield acc
        acc = 0
    prev = x

var cache = {0: 0, 1: 0, 2: 1}.toTable()

# Calculate tribonacci number
proc trib(n: int): int =
  if n in cache:
    return cache[n]
  let res = trib(n-3) + trib(n-2) + trib(n-1)
  cache[n] = res
  return res

let input = readFile(paramStr(1)).strip().splitlines().map(parseInt).sorted()

let jolts = @[0] & input & @[input[^1]+3]
let runs = toSeq(runsOfOnes(toSeq(diffs(jolts))))
let n_runs = runs.foldl(a + b)

echo n_runs * (jolts.len - n_runs - 1)
# The number of possibilities for a run of n consecutive numbers (bounded by a gap of 3
# on each side) is the (n+2)nd tribonacci number (see: OEIS A000073)
echo runs.mapIt(trib(it + 2)).foldl(a * b)
