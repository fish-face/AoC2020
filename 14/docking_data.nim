import bitops
import os
import parseutils
import strscans
import strutils
import sequtils
import strformat
import tables

const BITS = 36

proc `:=`(a: var int, b: int): int =
  a = b
  a

# get locations of all occurrences of c in s, indexed from the right
proc findrAll(s: string, c: char): seq[int] =
  let l = s.len
  var start = -1
  while (start := s.find(c, start+1)) != -1:
    result.add(l - start - 1)

iterator bits(x: int): bool =
  for i in 0..<BITS:
    yield bool(bitsliced(x, i..i))

proc setBits(x: int, locs: seq[int], vals: int): int =
  result = x
  for i, (loc, val) in zip(locs, toSeq(bits(vals))):
    if val:
      setBit(result, loc)
    else:
      clearBit(result, loc)

let input = readFile(paramStr(1)).strip().splitlines()

var instructions: Table[int, (int, int, int)]
var instructionsPtTwo: Table[int, int]
var
  val = ""
  mask0: int
  mask1: int
  memmask: string
  loc: int
  numfloat: int
  floatmap: seq[int]
for line in input:
  val = line.split(" = ")[1]
  if line.startswith("mask"):
    discard val.replace('X', '1').parseBin(mask0)
    discard val.replace('X', '0').parseBin(mask1)
    memmask = val
    numfloat = memmask.count('X')
    floatmap = memmask.findrAll('X')
  else:
    discard scanf(line, "mem[$i]", loc)
    instructions[loc] = (val.parseInt, mask0, mask1)

    for locmod in 0..<1 shl numfloat:
      instructionsPtTwo[setBits(loc, floatmap, locmod) or mask1] = val.parseInt

var partOne = 0
for (val, mask0, mask1) in instructions.values:
  partOne += (val and mask0) or mask1

echo partOne

echo toSeq(instructionsPtTwo.values).foldl(a + b)
