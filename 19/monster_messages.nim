import nre
import os
import sequtils
import strutils

import pegs

proc toPegs(rules: string): string =
  result = (
    # Move r0 to top because that's what pegs wants
    "r0 <- r8 r11 !.\n" &
    rules
    # Get rid of old rule 0
    .replace("0: 8 11\n", "")
    # Everything else is just converting input grammar into pegs-compatible format
    .replace(": ", " <- ")
    .replace("|", "/")
    .replace('"', '\'')
    .replace(re"(\d+)", "r$1")
  )

proc partOne(rules: string, messages: string): int =
  let pattern = peg rules.toPegs
  return messages.splitlines().countIt(it =~ pattern)

proc partTwo(rules: string, messages: string): int =
  let
    myrules = (rules
      # Rewrite rule 8 as per instructions, and *also* perform a lookahead to ensure we can
      # match rule 11 afterwards (rule 8 is only ever called immediately before rule 11) -
      # this works around PEGs having only limited backtracking (they will never try a different
      # choice after one has matched)
      .replace("8: 42", "8: 42 &11 | 42 8 &11")
      # Rewrite rule 11 - no hacks required here
      .replace("11: 42 31", "11: 42 31 | 42 11 31")
      .toPegs
    )
  let pattern = peg myrules
  return messages.splitlines().countIt(it =~ pattern)

let
  input = readFile(paramStr(1)).strip().split("\n\n")
  rules = input[0]
  messages = input[1]

echo partOne(rules, messages)
echo partTwo(rules, messages)

