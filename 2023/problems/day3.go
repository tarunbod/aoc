package main

import (
	"fmt"
	"io"
	"os"
	"slices"
	"strings"
)

func isDigit(c byte) bool {
	return c >= '0' && c <= '9'
}

func isSymbol(c byte) bool {
	return !isDigit(c) && c != '.'
}

type Grid struct {
	Size  int
	Cells [][]byte
}

type Pos struct {
	Row int
	Col int
}

var NullPos = Pos{-1, -1}

type Gear struct {
	Count int
	Value int
}

func NewGrid(lines []string) *Grid {
	size := len(lines[0])
	grid := &Grid{
		Size:  size,
		Cells: make([][]byte, size),
	}
	for i := 0; i < size; i++ {
		grid.Cells[i] = make([]byte, size)
		for j := 0; j < size; j++ {
			grid.Cells[i][j] = lines[i][j]
		}
	}
	return grid
}

func (g *Grid) At(row, col int) byte {
	return g.Cells[row][col]
}

func (g *Grid) FindAdjacent(row, col int, predicate func(char byte) bool) []Pos {
	var matches []Pos
	for i := row - 1; i <= row+1; i++ {
		if i < 0 || i >= g.Size {
			continue
		}
		for j := col - 1; j <= col+1; j++ {
			if j < 0 || j >= g.Size {
				continue
			}
			if i == row && j == col {
				continue
			}
			if predicate(g.At(i, j)) {
				matches = append(matches, Pos{i, j})
			}
		}
	}
	return matches
}

func (g *Grid) IsSymbolAdjacent(row, col int) bool {
	return len(g.FindAdjacent(row, col, isSymbol)) > 0
}

func main() {
	bytes, err := io.ReadAll(os.Stdin)
	if err != nil {
		panic(err)
	}

	lines := strings.Split(strings.TrimSpace(string(bytes)), "\n")
	g := NewGrid(lines)

	numbers := []int{}
	gears := map[Pos]*Gear{}

	for row := 0; row < g.Size; row++ {
		currNum := 0
		symbolAdjacent := false
		var starPoses []Pos
		for col := 0; col < g.Size; col++ {
			char := g.At(row, col)
			if isDigit(char) {
				symbolAdjacent = symbolAdjacent || g.IsSymbolAdjacent(row, col)
				digit := int(char - '0')
				currNum = currNum*10 + digit

				adjacentStarPos := g.FindAdjacent(row, col, func(char byte) bool {
					return char == '*'
				})
				for _, pos := range adjacentStarPos {
					if !slices.Contains(starPoses, pos) {
						starPoses = append(starPoses, pos)
					}
				}
			}
			if !isDigit(char) || col == g.Size-1 {
				if currNum != 0 && symbolAdjacent {
					numbers = append(numbers, currNum)
					for _, pos := range starPoses {
						if gear, ok := gears[pos]; ok {
							gear.Count++
							gear.Value *= currNum
						} else {
							gears[pos] = &Gear{
								Count: 1,
								Value: currNum,
							}
						}
					}
				}
				currNum = 0
				symbolAdjacent = false
				starPoses = []Pos{}
			}
		}
	}

	// Part 1
	sum := 0
	for _, num := range numbers {
		sum += num
	}
	fmt.Println(sum)

	// Part 2
	sum = 0
	for _, gear := range gears {
		if gear.Count == 2 {
			sum += gear.Value
		}
	}
	fmt.Println(sum)
}
