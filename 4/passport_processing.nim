import os
import strutils
import sequtils
import sugar
import sets
import tables

let
  fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"].toHashSet()
  allowed_missing = ["cid"].toHashSet()
  colour_chars = "0123456789abcdef"
  eye_colours = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].toHashSet()
  rules: Table[string, proc (v: string) : bool{.nimcall.}] = {
    "byr": (v: string) => (block:
        let n = v.parseInt()
        1920 <= n and n <= 2002
      ),
    "iyr": (v: string) => (block:
        let n = v.parseInt()
        2010 <= n and n <= 2020
      ),
    "eyr": (v: string) => (block:
        let n = v.parseInt()
        2020 <= n and n <= 2030
      ),
    "hgt": (v: string) => (block:
        if v.len() <= 2:
          return false
        let
          n =
            try:
              v[0..^3].parseInt()
            except ValueError:
              -1
          unit = v[^2..^1]
        if n == -1:
          false
        elif unit == "cm":
          150 <= n and n <= 193
        elif unit == "in":
          59 <= n and n <= 76
        else:
          false
      ),
    "hcl": (v: string) => (block:
        if v.len() != 7:
          false
        elif v[0] != '#':
          false
        else:
          all(v[1..^1], (c: char) => (c in colour_chars))
      ),
    "ecl": (v: string) => (v in eye_colours),
    "pid": (v: string) => (block:
        if v.len() != 9:
          return false
        try:
          let _ = parseInt(v)
        except ValueError:
          return false
        return true
      ),
    "cid": (v: string) => true,
  }.toTable()

let input: seq[seq[seq[string]]] = readFile(paramStr(1)).strip().split("\n\n").map(
  (line: string) => line.split().map(
    (part: string) => part.split(":", 1)
  )
)

var valid = 0

for i, pass in input:
  # If the fields are wrong, skip the whole record
  let fs = pass.map(part => part[0]).toHashSet()
  let missing = fields - fs
  if (missing - allowed_missing).len() != 0:
    continue

  var good = true
  # iterate over the bits of the record and check each value for correctness
  for part in pass:
    let
      field = part[0]
      value = part[1]
    if field == "cid":
      continue
    if field notin fields:
      good = false
      break
    if not rules[field](value):
      good = false
      break

  if good:
    inc valid

echo valid
