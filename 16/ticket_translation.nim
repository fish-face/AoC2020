import algorithm
import os
import sequtils
import strutils
import sets
import strscans
import sugar

import manu

type
  InputStage = enum
    VALIDATION, MYTICKET, TICKETS
  Rule = object
    field: string
    range_a: HSlice[int, int]
    range_b: HSlice[int, int]

proc parseRule(line: string): Rule =
  var lo_a, lo_b, hi_a, hi_b: int
  discard scanf(line, "$*: $i-$i or $i-$i", result.field, lo_a, hi_a, lo_b, hi_b)
  result.range_a = lo_a..hi_a
  result.range_b = lo_b..hi_b

proc contains(r: Rule, v: int): bool =
  return v in r.range_a or v in r.range_b

proc `+=`(s: var HashSet[int], r: Rule) =
  for x in r.range_a:
    s.incl(x)
  for x in r.range_b:
    s.incl(x)

let input = readFile(paramStr(1)).strip().splitlines()

var
  stage = VALIDATION
  possible_nums = initHashSet[int]()
  invalid_sum = 0
  mine: seq[int]
  # what numbers are allowed in the j'th rule from the input
  rules: seq[Rule] = @[]
  # possible_fields[i][j] iff the i'th field on the ticket adheres to the
  # j'th rule
  possible_fields: seq[seq[bool]]
for line in input:
  if line == "":
    continue
  if line == "your ticket:":
    stage = MYTICKET
    possible_fields = newSeqWith(rules.len, newSeqWith(rules.len, true))
    continue
  elif line == "nearby tickets:":
    stage = TICKETS
    continue

  if stage == VALIDATION:
    rules.add(parseRule line)
    possible_nums += rules[^1]
  if stage == MYTICKET:
    mine = line.split(',').map(parseInt)
  elif stage == TICKETS:
    let
      nums = line.split(',').map(parseInt)
      invalid = nums.filterIt(it notin possible_nums)
      
    invalid_sum += invalid.foldl(a + b, 0)
    if invalid.len > 0:
      continue

    for i, n in nums:
      for j, rule in rules:
        if possible_fields[i][j] and n notin rule:
          possible_fields[i][j] = false

echo "Part One: ", invalid_sum

let
  data = possible_fields.mapIt(it.mapIt(float(it)))
  M = matrix(data).inverse

var prod = 1
echo "Departure fields:"

# The first six rows of the inverted assignments matrix contain the
# information on the first six named fields (i.e. the "departure"
# ones) - the assignment is the column of the unique 1 entry.
for i in 0..5:
  for j in 0..<M.columnDimension:
    if M[i,j] == 1:
      echo "  ", j, ": ", mine[j]
      prod *= mine[j]
      break

echo "Part Two: ", prod
