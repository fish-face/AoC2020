import strformat
import strutils

let input = readFile("input").strip().splitlines()

for i, line1 in input[0..^3]:
  let x = parseInt(line1)
  for j, line2 in input[i+1..^2]:
    let y = parseInt(line2)
    if x + y >= 2020:
      #echo fmt"{x}, {y}: {x + y}"
      continue
    for line3 in input[j+1..^1]:
      let z = parseInt(line3)
      #echo fmt"{x}, {y}, {z}: {x + y + z}"
      if x + y + z == 2020:
        echo x * y * z
