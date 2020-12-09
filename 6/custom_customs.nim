import os
import strutils
import sequtils
import sets
import sugar

let input: seq[string] = readFile(paramStr(1)).strip().split("\n\n").map(line => line.replace("\n"))

# Why can't I just pass `toHashSet` to map here?
let answermaps = map(input, proc (x: string): HashSet[char] = x.toHashSet())
let n_answers = answermaps.map(len)
echo n_answers
echo n_answers.foldl(a + b)

