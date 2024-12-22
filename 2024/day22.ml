let mix = Int.logxor
let prune n = n mod 16777216

let evolve a =
  let step1 = a * 64 |> mix a |> prune in
  let step2 = step1 / 32 |> mix step1 |> prune in
  step2 * 2048 |> mix step2 |> prune

let nevolve n a =
  Seq.iterate evolve a |> Seq.drop n |> Seq.take 1 |> List.of_seq |> List.hd

let price n = n mod 10

type diffs = int * int * int * int

let npricediffs n a =
  let prices = Seq.iterate evolve a |> Seq.take (n + 1) |> Seq.map price in
  let drop1 = Seq.drop 1 prices in
  let pricediffs = Seq.map2 (fun a b -> b - a) prices drop1 in
  let pricediffs4 =
    Seq.zip pricediffs (Seq.drop 1 pricediffs)
    |> Seq.zip (Seq.drop 2 pricediffs)
    |> Seq.zip (Seq.drop 3 pricediffs)
  in
  Seq.zip pricediffs4 (Seq.drop 4 prices)
  |> Seq.map (fun ((a, (b, (c, d))), p) -> ((c, d, b, a), p))
  |> List.of_seq

module DiffsMap = Map.Make (struct
  type t = diffs

  let compare = compare
end)

let max_diffs m =
  DiffsMap.fold
    (fun d v (dacc, vacc) ->
      let m = max vacc v in
      if m == v then (d, v) else (dacc, vacc))
    m
    ((0, 0, 0, 0), 0)

let find_max_diffs (diffslists : (diffs * int) list list) =
  let combined =
    List.map (fun dl -> List.rev dl |> DiffsMap.of_list) diffslists
    |> List.fold_left
         (DiffsMap.union (fun k v1 v2 -> Some (v1 + v2)))
         DiffsMap.empty
  in
  max_diffs combined

let printkv ((a, b, c, d), value) =
  Printf.printf "%d (%d, %d, %d, %d)\n" value a b c d

let () =
  let file = open_in "/Users/tarunbod/Documents/aoc/2024/inputs/day22.txt" in
  let secrets = In_channel.input_lines file |> List.map int_of_string in
  secrets
  |> List.map (nevolve 2000)
  |> List.fold_left ( + ) 0 |> Printf.printf "%d\n";

  secrets |> List.map (npricediffs 2000) |> find_max_diffs |> printkv
