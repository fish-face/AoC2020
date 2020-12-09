import os
import strutils
import parseutils
import sequtils
import sets

proc parse(pass: string): int =
  let pass_num = pass.replace('B', '1').replace('F', '0').replace('L', '0').replace('R', '1')
  let row = pass_num[0..6]
  let col = pass_num[7..9]
  
  var
    rown: int
    coln: int
  discard parseBin(row, rown)
  discard parseBin(col, coln)
  rown * 8 + coln

let input: seq[string] = readFile(paramStr(1)).strip().splitlines()
var present: HashSet[int]

for pass in input:
  present.incl(parse(pass))

let maxid = foldl(present.toSeq(), max(a, b))
echo maxid

for i in 1..<maxid-1:
  if i notin present and i-1 in present and i+1 in present:
    echo i
