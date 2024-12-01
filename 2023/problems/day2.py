import sys
import re

lines = sys.stdin.readlines()

def part1():
    gameids = []
    for line in lines:
        line = line.strip()
        gameid, game, *_ = line.split(': ')
        gamenum = int(gameid.split(' ')[1])
        rounds = game.split('; ')
        invalid = False
        for r in rounds:
            red, green, blue = 12, 13, 14
            draws = r.split(', ')
            for draw in draws:
                count, color, *_ = draw.split(' ')
                if color == 'red':
                    red -= int(count)
                elif color == 'green':
                    green -= int(count)
                elif color == 'blue':
                    blue -= int(count)
                if red < 0 or green < 0 or blue < 0:
                    invalid = True
                    break
            if invalid:
                break
        if not invalid:
            gameids.append(gamenum)
    print(sum(gameids))

def part2():
    total = 0
    for line in lines:
        line = line.strip()
        gameid, game, *_ = line.split(': ')
        gamenum = int(gameid.split(' ')[1])
        rounds = game.split('; ')
        max_red, max_green, max_blue = 0, 0, 0
        for r in rounds:
            draws = r.split(', ')
            for draw in draws:
                count, color, *_ = draw.split(' ')
                if color == 'red':
                    max_red = max(max_red, int(count))
                elif color == 'green':
                    max_green = max(max_green, int(count))
                elif color == 'blue':
                    max_blue = max(max_blue, int(count))
        total += max_red * max_green * max_blue
    print(total)

part1()
part2()
