#!/usr/bin/env python3
import sys
from functools import reduce

lines = sys.stdin.readlines()
sequences = [[int(x) for x in line.strip().split(" ")] for line in lines]

def diffs(seq):
    d = []
    for i in range(len(seq) - 1):
        d.append(seq[i + 1] - seq[i])
    return d

def part1():
    total = 0
    for seq in sequences:
        d = seq
        end_values = []
        while True:
            end_values.append(d[-1])
            d = diffs(d)
            if len(set(d)) == 1 and d[0] == 0:
                break
        total += sum(end_values)
    print(total)

def part2():
    total = 0
    for seq in sequences:
        d = seq
        start_values = []
        while True:
            start_values.append(d[0])
            d = diffs(d)
            if len(set(d)) == 1 and d[0] == 0:
                break
        total += reduce(lambda x, y: y - x, start_values[::-1])
    print(total)

part1()
part2()
