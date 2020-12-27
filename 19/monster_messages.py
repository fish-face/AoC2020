#!/usr/bin/env python3

import re
import sys

from lark import Lark, tree

input = open(sys.argv[1]).read().split("\n\n")

numberre = re.compile('(\\d+)')
grammar = (
    input[0]
    .replace("8: 42", "8: 42 | 42 8")
    .replace("11: 42 31", "11: 42 31 | 42 11 31")
)
grammar = re.sub(r'(\d+)', r'r\1', grammar)
parser = Lark(grammar, start='r0', ambiguity='auto')

acc = 0
for msg in input[1].split('\n'):
    try:
        if parser.parse(msg):
            acc += 1
    except Exception:
        pass
print(acc)
