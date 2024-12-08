import Data.List
import Data.List.Split
import System.IO

readInt :: String -> Int
readInt = read :: String -> Int

parseEquation :: String -> (Int, [Int])
parseEquation str =
  let (val : numsStr : _) = splitOn ":" str
      nums = map readInt $ tail $ splitOn " " numsStr
   in (readInt val, nums)

validEquation2 :: Bool -> (Int, [Int]) -> Bool
validEquation2 _ (val, [num]) = val == num
validEquation2 withConcat (val, nums) = do
  let end = last nums
  let rest = init nums
  ((val `mod` end == 0 && validEquation2 withConcat (val `div` end, rest)) || validEquation2 withConcat (val - end, rest))
    || ( do
           let endStr = show end
           let valStr = show val
           withConcat && val > 0 && isSuffixOf endStr valStr && endStr /= valStr && validEquation2 withConcat (readInt $ take (length valStr - length endStr) valStr, rest)
       )

main = do
  contents <- getContents
  let equations = map parseEquation $ lines contents
  print $ sum $ map fst $ filter (validEquation2 False) equations
  print $ sum $ map fst $ filter (validEquation2 True) equations
