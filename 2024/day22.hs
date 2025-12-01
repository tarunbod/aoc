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
nEvolve n a = iterate evolve a !! n

price :: Int -> Int
price n = n `mod` 10

type DiffSeq = (Int, Int, Int, Int)

nPriceDiffs :: Int -> Int -> [(DiffSeq, Int)]
nPriceDiffs n a = do
  let prices = map price $ take (n + 1) $ iterate evolve a
  let pricediffs = zipWith (flip (-)) prices $ drop 1 prices
  let pricediffs4 = zip4 pricediffs (drop 1 pricediffs) (drop 2 pricediffs) (drop 3 pricediffs)
  zip pricediffs4 (drop 4 prices)

findMaxDiffs :: [[(DiffSeq, Int)]] -> Int
findMaxDiffs dl = do
  let allMaps = map (Map.fromList . reverse) dl
  let combinedMap = foldl1 (Map.unionWith (+)) allMaps
  maximum $ map snd $ Map.toList combinedMap

main = do
  contents <- getContents
  let nums = map (read :: String -> Int) $ lines contents
  print $ sum $ map (nEvolve 2000) nums
  print $ findMaxDiffs $ map (nPriceDiffs 2000) nums
