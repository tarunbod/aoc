import qualified Data.Map as Map
import Data.Graph
import Data.List.Split

readInt :: String -> Int
readInt = read :: String -> Int

parseRule :: String -> (Int, Int)
parseRule str = let (a:b:_) = map readInt $ splitOn "|" str in (a, b)

parseUpdate :: String -> [Int]
parseUpdate str = map readInt $ splitOn "," str

fst3 :: (a, b, c) -> a
fst3 (a, _, _) = a

snd3 :: (a, b, c) -> b
snd3 (_, b, _) = b

middle :: [a] -> a
middle list = list !! (length list `div` 2)

tsort :: [(Int, Int)] -> [Int] -> [Int]
tsort rules nums =
  let validRules = filter (\(a, b) -> a `elem` nums && b `elem` nums) rules
      dependencyMap = Map.fromListWith (++) $ map (\(a, b) -> (a, [b])) validRules
      leftovers = Map.fromListWith (++) $ map (\(a, b) -> (b, [] :: [Int])) validRules
      ruleMap = Map.unionWith (++) dependencyMap leftovers
      (graph, vertex, _) = graphFromEdges $ map (\(n, d) -> (n, n, d)) $ Map.toList ruleMap
  in map (fst3 . vertex) $ topSort graph

main = do
  contents <- getContents
  let (ruleStrs:updateStrs:_) = splitOn [""] $ init $ splitOn "\n" contents
  let rules = map parseRule ruleStrs
  let updates = map parseUpdate updateStrs
  print $ sum $ map middle $ filter (\u -> u == tsort rules u) updates
  print $ sum $ map (middle . tsort rules) $ filter (\u -> u /= tsort rules u) updates
