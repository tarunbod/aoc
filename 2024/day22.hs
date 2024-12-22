import Data.Bits (xor)
import Data.List (zip4)
import qualified Data.Map as Map

prune :: Int -> Int
prune n = n `mod` 16777216

evolve a =
  let step1 = prune $ xor a $ a * 64
      step2 = prune $ xor step1 $ step1 `div` 32
   in prune $ xor step2 $ step2 * 2048

nEvolve :: Int -> Int -> Int
nEvolve n a = iterate evolve a !! max 0 n

price :: Int -> Int
price n = n `mod` 10

type Diffs = (Int, Int, Int, Int)

nPriceDiffs :: Int -> Int -> [(Diffs, Int)]
nPriceDiffs n a = do
  let prices = map price $ take (n + 1) $ iterate evolve a
  let drop1 = drop 1 prices
  let pricediffs = zipWith (flip (-)) prices drop1
  let pricediffs4 = zip4 pricediffs (drop 1 pricediffs) (drop 2 pricediffs) (drop 3 pricediffs)
  zip pricediffs4 (drop 4 prices)

findMaxDiffs :: [[(Diffs, Int)]] -> Int
findMaxDiffs dl = do
  let idk = map (Map.fromList . reverse) dl
  let bruh = foldl1 (Map.unionWith (+)) idk
  maximum $ map snd $ Map.toList bruh

main = do
  contents <- getContents
  let nums = map (read :: String -> Int) $ lines contents
  print $ sum $ map (nEvolve 2000) nums
  print $ findMaxDiffs $ map (nPriceDiffs 2000) nums
