import hashes
import os
import nre
import strutils
import sequtils
import sugar
import tables

type
  BagSpec = object
    number: int
    colour: string

let input = readFile(paramStr(1)).strip().splitlines()

let leaf_text = "no other bags"
var edges: Table[string, Table[string, int]]
for line in input:
  let
    match = line.match(re"(.*) bags contain (.*)\.").get()
    container = match.captures[0]
    right = match.captures[1]
    contained = right.split(", ").map(x => (block:
      if x == leaf_text:
        BagSpec(number: 0, colour: "")
      else:
        let captures = x.match(re"([0-9]+) (.*) bags?").get().captures
        BagSpec(number: captures[0].parseInt(), colour: captures[1])
    ))
  for c in contained:
    if container notin edges:
      # why do I need to specify type of table here? is there a better way to set the initial value?
      edges[container] = initTable[string, int]()
    if c.colour notin edges[container]:
      edges[container][c.colour] = 0
    edges[container][c.colour] += c.number

let target = "shiny gold"

var
  queue = @[BagSpec(number: 1, colour: target)]
  b: BagSpec
  total = 0

while queue.len() != 0:
  b = queue.pop()
  # This is where we would see if we've visited the node before, but because the
  # graph is not a tree, we actually need to traverse every branch, not just visit
  # every node.
  if b.number == 0:
    # leaf
    continue
  for colour, number in edges[b.colour]:
    # echo b.colour, " -> ", colour, ": +", b.number * number
    total += b.number * number
    queue.add(BagSpec(number: b.number * number, colour: colour))

echo total
