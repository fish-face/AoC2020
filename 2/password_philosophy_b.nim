import os
import strformat
import strutils

let input = readFile(paramStr(1)).strip().splitlines()

var count: int

for line in input:
  let split = line.split()
  let password = split[2]
  let letter = split[1][0]
  let r = split[0].split("-")
  let posa = parseInt(r[0]) - 1
  let posb = parseInt(r[1]) - 1

  if password[posa] == letter xor password[posb] == letter:
    count += 1

echo count
  
