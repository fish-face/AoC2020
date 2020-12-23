import lists
import math
import os
import strformat
import strutils

proc `%`[T: SomeNumber](x, y: T): T {.inline.} =
  floorMod(x, y)

type
  Cup = DoublyLinkedNode[int]
  Cups = object
    data: DoublyLinkedRing[int]
    cur: Cup
    map: seq[Cup]
    len: int

proc toCups(s: string): Cups =
  result.data = initDoublyLinkedRing[int]()
  for c in s:
    result.data.append(($c).parseInt - 1)
  result.len = s.len
  result.cur = result.data.head

proc initMap(c: var Cups) =
  c.map = newSeq[Cup](c.len)
  for n in c.data.nodes:
    c.map[n.value] = n

proc `$`(cups: Cups): string =
  for c in cups.data.nodes:
    if c == cups.cur:
      result &= fmt"({c.value+1}) "
    else:
      result &= $(c.value+1) & " "

proc shift3(cups: var Cups, destnode: Cup) {.inline.} =
  let
    startcup = cups.cur.next
    endcup = cups.cur.next.next.next
    afterdest = destnode.next
    aftersel = endcup.next
  cups.cur.next = aftersel
  aftersel.prev = cups.cur

  destnode.next = startcup
  startcup.prev = destnode

  afterdest.prev = endcup
  endcup.next = afterdest


proc find(cups: Cups, target: int): Cup {.inline.} =
  result = cups.map[target]

proc round(cups: var Cups) =
  let
    curval = cups.cur.value
    selected = [cups.cur.next.value, cups.cur.next.next.value, cups.cur.next.next.next.value]
  #echo "Pick up ", selected.mapIt(it + 1).join(", ")
  var destval = (curval - 1) % cups.len
  while destval == selected[0] or destval == selected[1] or destval == selected[2]:
    dec destval
    destval = destval % cups.len

  #echo "Destination: ", destval+1
  let destidx = cups.find(destval)
  cups.shift3(destidx)
  cups.cur = cups.cur.next

let input = readFile(paramStr(1))
var
  cups1 = input.toCups
  cups2 = input.toCups

for i in 9..999_999:
  cups2.data.append(i)
  cups2.len += 1

cups1.initMap
cups2.initMap

for i in 0..<100:
  cups1.round
# Human can rotate and concatenate itself
echo cups1

for i in 0..<10_000_000:
  cups2.round

let cup1 = cups2.find(0)
echo cup1.next.value + 1, " * ", cup1.next.next.value + 1, " = ", (cup1.next.value + 1) * (cup1.next.next.value + 1)
