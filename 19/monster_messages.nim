import nre
import os
import options
import sequtils
import strutils
import strformat
import tables

import pegs
import npeg

type
  Rule = ref object
    id: int
    choices: seq[seq[Rule]]
    value: string
  RuleContext = object
    rules: Table[int,Rule]
    current: Rule
    nums: seq[int]

proc newRule(id: int): Rule =
  var choices: seq[seq[Rule]] = @[]
  choices.add(@[])
  Rule(
    id: id,
    choices: choices
  )

proc `$`(r: Rule): string =
  if r.value.len > 0:
    return fmt"Rule(id: {r.id}, value: {r.value})"
  else:
    var ids = r.choices.mapIt(it.mapIt(it.id))
    return fmt"Rule(id: {r.id}, choices: {ids})"

proc regex(r: Rule): string =
  if r.value.len > 0:
    r.value
  else:
    "(" & r.choices.mapIt(
      it.mapIt(
        it.regex
      ).join("")
    ).filterIt(it.len > 0).join("|") & ")"

proc match(s: string, r: Rule, maxLen: int = -1): int

proc tryMatch(s: string, r: seq[Rule], maxLen: int): int =
  if r.len == 0:
    return 0
  var matchLen, subMatchLen: int
  for tryMax in countdown(maxLen, 1):
    matchLen = s.match(r[0], tryMax)
    #echo s, ": ", $(r[0]), " = ", matchLen, "/", tryMax
    if matchLen == -1:
      return -1
    if matchLen > trymax:
      return -1
    if matchLen == trymax and r.len > 1:
      return -1

    subMatchLen = s[matchLen..^1].tryMatch(r[1..^1], trymax - matchLen)
    if subMatchLen == -1:
      echo s, " failed remainder after ", r[0]
      continue
    else:
      return matchLen + subMatchLen

proc match(s: string, r: Rule, maxLen: int = -1): int =
  echo s, ": ", r, " <= ", maxLen
  if r.value.len > 0:
    if s.startswith(r.value):
      return r.value.len
    else:
      return -1
  var
    pos = 0
    matchLen: int
    locMaxLen = if maxLen == -1: s.len else: maxLen
  for choice in r.choices:
    matchLen = s[pos..^1].tryMatch(choice, locMaxLen)
    echo s, " seq ", choice, " got ", matchLen
    if matchLen == -1:
      continue
    if matchLen > locMaxLen:
      continue
    return matchLen
  return -1

let parser = peg("grammar", ctxt: RuleContext):
  grammar <- rule * *("\n" * rule)
  rule <- comment | identifier * ": " * ruleexpr
  comment <- '#' * *1
  identifier <- >+Digit:
    if ctxt.current != nil:
      ctxt.current.choices.delete(ctxt.current.choices.len - 1, ctxt.current.choices.len - 1)
    let id = parseInt $1
    var rule: Rule
    if id notin ctxt.rules:
      rule = newRule(id)
      ctxt.rules[id] = rule
    else:
      rule = ctxt.rules[id]
    ctxt.current = rule
  ruleexpr <- (choiceexpr | literalexpr)
  literalexpr <- "\"" * >Alpha * "\"":
    ctxt.current.value = $1
  choiceexpr <- choiceleft * *choiceright
  choiceleft <- pairexpr * *Blank:
    ctxt.current.choices.add(@[])
  choiceright <-  "|" * Blank * pairexpr:
    ctxt.current.choices.add(@[])
  pairexpr <- num * *(Blank * num):
    var rule: Rule
    for id in ctxt.nums:
      if id notin ctxt.rules:
        rule = newRule(id)
        ctxt.rules[id] = rule
      else:
        rule = ctxt.rules[id]
      ctxt.current.choices[^1].add(rule)
    ctxt.nums = @[]
  num <- >+Digit:
    let id = parseInt $1
    ctxt.nums.add(id)

proc partOne(rules: string, messages: string): int =
  var ctxt: RuleContext
  assert parser.match(rules, ctxt).ok

  let pattern = re "^" & ctxt.rules[0].regex & "$"
  var acc = 0
  for i, msg in toSeq(messages.splitlines()).pairs:
    if msg.match(pattern).isSome:
      acc += 1
  acc

proc partTwo(rules: string, messages: string): int =
  let
    myrules = (
      # Move r0 to top because that's what pegs wants
      "r0 <- r8 r11 !.\n" &
      rules
      # Rewrite rule 8 as per instructions, and *also* perform a lookahead to ensure we can
      # match rule 11 afterwards (rule 8 is only ever called immediately before rule 11) -
      # this works around PEGs having only limited backtracking (they will never try a different
      # choice after one has matched)
      .replace("8: 42", "8: 42 &11 | 42 8 &11")
      # Rewrite rule 11 - no hacks required here
      .replace("11: 42 31", "11: 42 31 | 42 11 31")
      # Get rid of old rule 0
      .replace("0: 8 11\n", "")
      # Everything else is just converting input grammar into pegs-compatible format
      .replace(": ", " <- ")
      .replace("|", "/")
      .replace('"', '\'')
      .replace(re"(\d+)", "r$1")
    )
  let pattern = peg myrules
  return messages.splitlines().countIt(it =~ pattern)

let
  input = readFile(paramStr(1)).strip().split("\n\n")
  rules = input[0]
  messages = input[1]

echo partOne(rules, messages)
echo partTwo(rules, messages)

