import deques
import hashes
import os
import sequtils
import strutils
import sets
import nimprof

proc `&`[T](d: Deque[T], s: openArray[T]): Deque[T] =
  result = d
  for x in s:
    result.addLast(x)

proc add[T](d: var Deque[T], s: openArray[T]) =
  for x in s:
    d.addLast(x)

proc hash[T](d: Deque[T]): Hash =
  result = 0
  for x in d:
    result = result !& x
  result = !$result

proc `[]`[T](d: Deque[T], r: HSlice[int, int]): Deque[T] =
  result = d
  result.shrink(r.a, d.len - r.b - 1)
  #result = initDeque[T](r.b - r.a)
  #for i in r:
    #result.addLast(d[i])

proc score(s: Deque[int]): int =
  if s.len == 0:
    return 0
  toSeq(s.pairs).mapIt((s.len - it[0]) * it[1]).foldl(a + b)

### PART 1 ###

proc round(deck1: var Deque[int], deck2: var Deque[int]) =
  let
    c1 = deck1.popFirst
    c2 = deck2.popFirst
  if c1 > c2:
    deck1 &= @[c1, c2]
  else:
    deck2 &= @[c2, c1]

proc game(deck1: Deque[int], deck2: Deque[int]) =
  var
    d1 = deck1
    d2 = deck2
  while d1.len > 0 and d2.len > 0:
    round(d1, d2)

  echo d1.score + d2.score

### PART 2 ###

proc recursiveRound(deck1: var Deque[int], deck2: var Deque[int])

var gameNum = 0
proc recursiveGame(deck1: Deque[int], deck2: Deque[int], first: bool = false): bool =
  echo "Game ", gameNum
  gameNum += 1
  var
    d1 = deck1
    d2 = deck2
    hist1 = @[deck1].toHashSet
    hist2 = @[deck2].toHashSet
  while d1.len > 0 and d2.len > 0:
    recursiveRound(d1, d2)
    if d1 in hist1 and d2 in hist2:
      return true
    hist1.incl(d1)
    hist2.incl(d2)
  if first:
    echo d1.score + d2.score
  return d1.len > 0

proc recursiveRound(deck1: var Deque[int], deck2: var Deque[int]) =
  let
    c1 = deck1.popFirst
    c2 = deck2.popFirst
  var p1win: bool
  echo deck1
  echo deck2
  echo c1
  echo c2
  if c1 <= deck1.len and c2 <= deck2.len:
    p1win = recursiveGame(deck1[0..<c1], deck2[0..<c2])
  else:
    p1win = c1 > c2

  if p1win:
    echo "Player 1 wins"
    deck1 &= @[c1, c2]
  else:
    echo "Player 2 wins"
    deck2 &= @[c2, c1]

### SETUP ###

let
  input = readFile(paramStr(1)).strip().split("\n\n").mapIt(it.splitlines)
var
  deck1 = input[0][1..^1].map(parseInt).toDeque
  deck2 = input[1][1..^1].map(parseInt).toDeque

game(deck1, deck2)
discard recursiveGame(deck1, deck2, true)

