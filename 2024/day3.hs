import Data.List
import qualified Text.Regex.PCRE as R

readInt = read :: String -> Int

groupHeader :: String -> Bool
groupHeader s = s == "do()" || s == "don't()"

isDoGroup :: String -> Bool
isDoGroup s = s == "do()"

main = do
  contents <- getContents
  let part1Regex = "mul\\(([0-9]+),([0-9]+)\\)"
  let part1Matches = contents R.=~ part1Regex :: [[String]]
  let part1 = sum $ map (product . map readInt . tail) part1Matches
  print part1

  let part2Regex = "do\\(\\)|don't\\(\\)|mul\\(([0-9]+),([0-9]+)\\)"
  let part2Matches = ["do()", "", ""] : contents R.=~ part2Regex :: [[String]]
  let groups = groupBy (\a b -> not . groupHeader . head $ b) part2Matches
  let doGroups = filter (isDoGroup . head . head) groups
  print $ sum $ map (product . map readInt . concat . tail . map tail) doGroups
