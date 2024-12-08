import Data.List qualified as List
import Data.Map qualified as Map
import Data.Set qualified as Set

type Pos = (Int, Int)

getAntinodePos :: Int -> Pos -> Pos -> Pos
getAntinodePos n (a1y, a1x) (a2y, a2x) = (a1y + n * (a1y - a2y), a1x + n * (a1x - a2x))

inBounds :: Int -> Pos -> Bool
inBounds size (y, x) = y >= 0 && y < size && x >= 0 && x < size

getAntinodesInBounds :: Int -> Int -> Pos -> Pos -> Set.Set Pos
getAntinodesInBounds size maxn a1 a2 = do
  Set.fromList $ antinodes a1 a2 ++ antinodes a2 a1
  where
    antinodes b1 b2 =
      takeWhile (inBounds size) [getAntinodePos n b1 b2 | n <- [1 .. maxn]]

combinations :: Int -> [a] -> [[a]]
combinations k ns = filter ((k ==) . length) $ List.subsequences ns

enumerateGrid :: [[Char]] -> [(Char, Pos)]
enumerateGrid grid = do
  foldl1 (++) $
    zipWith
      (\r yidx -> zipWith (\a xidx -> (a, (yidx, xidx))) r ([0 ..] :: [Int]))
      grid
      ([0 ..] :: [Int])

countAntinodes :: [[Char]] -> Bool -> Int
countAntinodes grid part2 = do
  let maxn = if part2 then 100 else 1
  let freqs = Map.fromListWith (++) $ map (\(k, a) -> (k, [a])) $ filter (\(c, _) -> c /= '.') $ enumerateGrid grid
  let nodePairs = foldl1 (++) $ map (combinations 2 . snd) $ Map.toList freqs
  let antinodes = foldl1 Set.union $ map (\[a1, a2] -> getAntinodesInBounds (length grid) maxn a1 a2) nodePairs
  let allAntinodes = if part2 then Set.union antinodes $ Set.fromList $ foldl1 (++) nodePairs else antinodes
  length allAntinodes

main = do
  contents <- getContents
  print $ countAntinodes (lines contents) False
  print $ countAntinodes (lines contents) True
