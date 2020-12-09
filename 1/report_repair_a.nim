import strformat
import strutils

let input = readFile("input").strip().splitlines()

for i, line1 in input[0..^2]:
  for line2 in input[i+1..^1]:
    #echo parseInt(line1) + parseInt(line2)
    #echo parseInt(line1) + parseInt(line2) - 2020
    if parseInt(line1) + parseInt(line2) == 2020:
      echo fmt"{line1}×{line2} = {parseInt(line1) * parseInt(line2)}"
