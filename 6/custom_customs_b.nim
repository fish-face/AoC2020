import os
import strutils
import sequtils
import sets
import sugar

let input = readFile(paramStr(1)).strip()

# each inner seq is the answers of one person within the group
let groups: seq[seq[string]] = input.split("\n\n").map(line => line.split("\n"))

# convert each person's answers to a set, then reduce each group's sets
# via set-intersection to find the common answers
let answernums = input.map(group => group.map(
  p => p.toHashSet()
).foldl(a * b)).map(len)
echo answernums
echo answernums.foldl(a + b)
