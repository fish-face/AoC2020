import os
import sequtils
import patty
import strutils

import nimly

variant MyToken:
  PLUS
  MULTI
  NUM(val: int)
  LPAREN
  RPAREN
  IGNORE

niml lexer[MyToken]:
  r"\+":
    return PLUS()
  r"\*":
    return MULTI()
  r"\d*":
    return NUM(parseInt(token.token))
  r"\(":
    return LPAREN()
  r"\)":
    return RPAREN()
  r"\s":
    return IGNORE()

nimy parser[MyToken]:
  top[int]:
    expr:
      return $1
  expr[int]:
    expr MULTI plus:
      return $1 * $3
    plus:
      return $1
  plus[int]:
    plus PLUS term:
      return $1 + $3
    term:
      return $1
  term[int]:
    NUM:
      return ($1).val
    LPAREN expr RPAREN:
      return $2

let input = readFile(paramStr(1)).strip().splitlines()

var acc = 0
for line in input:
  var lex = lexer.newWithString(line)
  lex.ignoreIf = proc(r: MyToken): bool = r.kind == MyTokenKind.IGNORE
  # HACK: copy the parser because after parsing it is not ready to use again
  var p = parser
  acc += p.parse(lex)

echo acc
