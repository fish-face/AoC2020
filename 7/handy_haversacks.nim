import os
import nre
import strutils
import sequtils
import sets
import sugar
import tables

let input = readFile(paramStr(1)).strip().splitlines()
var edges: Table[string, HashSet[string]]
for line in input:
  let
    match = line.match(re"(.*) bags contain (.*)\.").get()
    container = match.captures[0]
    right = match.captures[1]
    contained = right.split(", ").map(x => (block:
      if x == "no other bags":
        ""
      else:
        x.match(re"[0-9]+ (.*) bags?").get().captures[0]
    ))
  for c in contained:
    if c notin edges:
      # why do I need to specify type of hashset here? is there a better way to set the initial value?
      edges[c] = initHashSet[string]()
    edges[c].incl(container)

let target = "shiny gold"

var
  found: HashSet[string]
  queue = @[target]
  m: string

while queue.len() != 0:
  m = queue.pop()
  if m notin found:
    found.incl(m)
    if m notin edges:
      # leaf
      continue
    for ma in edges[m]:
      queue.add(ma)

echo found.len()
