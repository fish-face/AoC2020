import os
import strutils
import sequtils

proc max[T](s: seq[T]): T =
  foldl(s, max(a, b))
proc min[T](s: seq[T]): T =
  foldl(s, min(a, b))

let input = readFile(paramStr(1)).strip().splitlines().map(parseInt)

const window = 25

var idx, val: int

for i, N in input:
  if i < window:
    continue
  var valid = false
  for j, M in input[i-window..i-2]:
    for k, P in input[i-window+j+1..i-1]:
      if M + P == N:
        valid = true
        break
    if valid:
      break
  if not valid:
    echo "Invalid value at index ", i, ": ", N
    idx = i
    val = N

for j in 0..idx-2:
  for k in j+1..idx-1:
    let subseq = input[j..k]
    if subseq.foldl(a + b) == val:
      echo "Sum found in range ", j, "..", k, " = ", subseq
      echo "Weakness: ", min(subseq) + max(subseq)
