import Data.List

readInt x = read x :: Int
readLine = map readInt . words
dist x y = abs $ x - y
count x = length . filter (x==)

main = do
    contents <- getContents
    let pairs = map readLine $ lines contents
    let list1 = sort $ map head pairs
    let list2 = sort $ map last pairs
    print $ sum $ zipWith dist list1 list2
    print $ sum $ map (\x -> x * count x list2) list1
