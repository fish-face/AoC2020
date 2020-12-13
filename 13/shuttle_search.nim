import os
import sequtils
import strutils

# Added in Nim 1.1
proc minIndex[T](s: openArray[T]): int =
  for i in 1..high(s):
    if s[i] < s[result]: result = i

# Compute Bezout's coefficients
proc bezout(u, v: int): (int, int) =
  var (old_r, r) = (u, v)
  var (old_s, s) = (1, 0)
  var (old_t, t) = (0, 1)
  
  while r != 0:
    var q = old_r div r
    (old_r, r) = (r, old_r - q * r)
    (old_s, s) = (s, old_s - q * s)
    (old_t, t) = (t, old_t - q * t)

  (old_s, old_t)

# Apply Chinese Remainder Theorem
proc crt(moduli: seq[(int, int)]): int =
  # solve x = moduli[i][0] mod moduli[i][1] for all i
  var acc: int
  let N = moduli.foldl((a * b[1]), 1)
  for (a, n) in moduli:
    let
      y = N div n
      (m1, _) = bezout(y, n)
    acc += a * y * m1
  max(acc mod N, acc mod N + N)


let
  input = readFile(paramStr(1)).strip().splitlines()
  earliest = input[0].parseInt
  raw_ids = input[1].split(',')
  ids = raw_ids.filterIt(it != "x").map(parseInt)

# part 1
let next = ids[ids.mapIt(it - (earliest mod it)).minIndex()]
echo next * (next - earliest mod next)

# part 2
let moduli = zip(
  toSeq(0..<raw_ids.len),
  raw_ids
).filterIt(
  it[1] != "x"
).mapIt(
  # negate first element because the solution is the number of minutes *before* the bus arrives
  (-it[0], it[1].parseInt)
)
echo crt(moduli)
