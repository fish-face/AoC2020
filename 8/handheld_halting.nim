import os
import strutils
import sets
import sequtils
import sugar

type
  Instr = object
    opcode: string
    value: int
  Machine = object
    p_instr: int
    acc: int
    executed: HashSet[int]
  State = enum
    OK, HALT, LOOPED

proc toInstr(line: string): Instr =
  let words = line.split(' ')
  result.opcode = words[0]
  result.value = words[1].parseInt()

proc cycle(M: var Machine, instructions: seq[Instr]): State =
  let instr = instructions[M.p_instr]
  # echo p_instr, ": ", instr, ", ", acc
  if instr.opcode == "jmp":
    M.p_instr += instr.value
  else:
    M.p_instr += 1
  if instr.opcode == "acc":
    M.acc += instr.value

  if M.p_instr in M.executed:
    return LOOPED
  elif M.p_instr == instructions.len():
    echo "Terminated. acc = ", M.acc
    return HALT

  M.executed.incl(M.p_instr)
  return OK

proc run(instructions: seq[Instr]): State =
  var
    instr: Instr
    M: Machine
    state: State

  while true:
    state = M.cycle(instructions)
    if state != OK:
      break

  state

let input = readFile(paramStr(1)).strip().splitlines()

let instructions = input.map(toInstr)

for i, instr in instructions:
  if instr.opcode == "nop":
    if run(toSeq(instructions.pairs).map(
      pair => (if pair[0] == i: Instr(opcode: "jmp", value: pair[1].value) else: pair[1])
    )) == HALT:
      break
  elif instr.opcode == "jmp":
    if run(toSeq(instructions.pairs).map(
      pair => (if pair[0] == i: Instr(opcode: "nop", value: pair[1].value) else: pair[1])
    )) == HALT:
      break

