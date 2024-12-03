import Data.List

readInts :: String -> [Integer]
readInts = map (read :: String -> Integer) . words

negative :: Integer -> Bool
negative x = x < 0

positive :: Integer -> Bool
positive x = x > 0

smallDiff :: Integer -> Bool
smallDiff x = 1 <= x && x <= 3

isSafe :: [Integer] -> Bool
isSafe diffs =
  (all negative diffs || all positive diffs)
    && all (smallDiff . abs . fromIntegral) diffs

removeOne :: [a] -> [[a]]
removeOne list = do
  [take i list ++ drop (i + 1) list | i <- [0 .. length list - 1]]

diffs :: (Integral a) => [a] -> [a]
diffs = map (\x -> last x - head x) . init . transpose . take 2 . tails

main = do
  contents <- getContents
  let reports = map readInts $ lines contents
  let reportDiffs = map diffs reports
  print $ length $ filter id $ map isSafe reportDiffs

  let removeOneReports = map removeOne reports
  let removeOneDiffs = map (map diffs) removeOneReports
  print $ length $ filter id $ map (any isSafe) removeOneDiffs
