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
  let min = parseInt(r[0])
  let max = parseInt(r[1])

  let n = password.count(letter) 
  if min <= n and n <= max:
    echo line
    count += 1

echo count
  
