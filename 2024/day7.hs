import Data.List.Split

data Op = Add | Mul | Concat | End deriving Show

concatInts :: Int -> Int -> Int
concatInts a b = a * 10^(if b > 0 then floor (logBase 10 $ fromIntegral b) + 1 else 1) + b

perform :: Op -> Int -> Int -> Int
perform Add a b = a + b
perform Mul a b = a * b
perform Concat a b = concatInts a b
perform End _ _ = 0

performOps :: [Int] -> [Op] -> Int
performOps nums ops =
  fst $ foldl1 (\(n1, op1) (n2, op2) -> (perform op1 n1 n2, op2)) $ zip nums ops

generateOps :: Bool -> Int -> [[Op]]
generateOps withConcat n = case n of
  0 -> [[]]
  n -> let recOps = generateOps withConcat (n - 1)
           adds = map (\l -> l ++ [Add]) recOps
           muls = map (\l -> l ++ [Mul]) recOps
           concats = if withConcat then map (\l -> l ++ [Concat]) recOps else []
        in adds ++ muls ++ concats

readInt :: String -> Int
readInt = read :: String -> Int

parseEquation :: String -> (Int, [Int])
parseEquation str = let (val:numsStr:_) = splitOn ":" str
                        nums = map readInt $ tail $ splitOn " " numsStr
                     in (readInt val, nums)

validEquation :: Bool -> (Int,[Int]) -> Bool
validEquation withConcat (val, nums) = do
  let ops = map (\ops -> ops ++ [End]) $ generateOps withConcat $ length nums - 1
  elem val $ map (performOps nums) ops

main = do
  contents <- getContents
  let equations = map parseEquation $ lines contents
  print $ sum $ map fst $ filter (validEquation False) equations
  print $ sum $ map fst $ filter (validEquation True) equations
