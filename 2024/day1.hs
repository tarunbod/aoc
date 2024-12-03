import Data.List

readInts = map (read :: String -> Int) . words

dist :: Int -> Int -> Int
dist x y = abs $ x - y

count :: (Eq a) => a -> [a] -> Int
count x = length . filter (x ==)

main = do
  contents <- getContents
  let pairs = map readInts $ lines contents
  let list1 = sort $ map head pairs
  let list2 = sort $ map last pairs
  print $ sum $ zipWith dist list1 list2
  print $ sum $ map (\x -> x * count x list2) list1
