module StringMap = Map.Make (struct
  type t = string

  let compare = compare
end)

module StringSet = Set.Make (struct
  type t = string

  let compare = compare
end)

type op = And | Or | Xor
type calc = { a : string; b : string; op : op }
type wiring = (calc, bool) Either.t

let as_calc w =
  match w with Either.Left c -> c | _ -> failwith "Not a calc wiring"

let op_of_str s =
  match s with
  | "AND" -> And
  | "OR" -> Or
  | "XOR" -> Xor
  | _ -> failwith "Invalid operation"

let wiring_of_str s =
  match String.split_on_char ' ' s with
  | [ a; b ] -> (String.sub a 0 3, Either.Right (b = "1"))
  | [ a; op_str; b; _; output ] ->
      (output, Either.Left { a; b; op = op_of_str op_str })
  | _ -> Printf.sprintf "Invalid wiring spec: '%s'" s |> failwith

let parse_input l =
  let wiring_strs = List.filter (fun s -> s <> "") l in
  List.map wiring_of_str wiring_strs |> StringMap.of_list

let rec visit n l perm temp graph =
  match StringSet.find_opt n perm with
  | Some _ -> (l, perm, temp, graph)
  | _ -> (
      match StringSet.find_opt n temp with
      | Some _ -> failwith "Cycle detected"
      | _ ->
          let temp = StringSet.add n temp in
          (*Printf.printf "Looking up %s\n%!" n;*)
          let edges = StringMap.find n graph in
          let l, perm, temp, graph =
            List.fold_left
              (fun (l1, perm1, temp1, graph1) edge ->
                visit edge l1 perm1 temp1 graph1)
              (l, perm, temp, graph) edges
          in
          let temp = StringSet.remove n temp in
          let perm = StringSet.add n perm in
          let l = n :: l in
          (l, perm, temp, graph))

let sort_wirings ws =
  let adj_map =
    StringMap.bindings ws
    |> List.map (fun (n, w) ->
           match w with
           | Either.Left calc -> (n, [ calc.a; calc.b ])
           | Either.Right _ -> (n, []))
    |> StringMap.of_list
  in
  let init_nodes =
    StringMap.filter
      (fun k _ ->
        not
        @@ StringMap.exists (fun k2 v -> List.exists (fun n -> n = k) v) adj_map)
      adj_map
  in
  let l, perm, temp, graph =
    List.fold_left
      (fun (l1, perm1, temp1, graph1) key -> visit key l1 perm1 temp1 graph1)
      ([], StringSet.empty, StringSet.empty, adj_map)
      (StringMap.to_list init_nodes |> List.map (fun (k, v) -> k))
  in
  l

let perform_op op a b =
  match op with And -> a && b | Or -> a || b | Xor -> a != b

let rec evaluate wirings n =
  let w =
    match StringMap.find_opt n wirings with
    | Some w -> w
    | None -> failwith "Node not found"
  in
  match w with
  | Either.Left c ->
      perform_op c.op (evaluate wirings c.a) (evaluate wirings c.b)
  | Either.Right v -> v

let part1 wirings =
  let zwires =
    List.filter_map (fun (k, _) ->
        if String.starts_with ~prefix:"z" k then Some k else None)
    @@ StringMap.bindings wirings
  in
  let bits = List.mapi (fun i w -> (i, evaluate wirings w)) zwires in
  print_int @@ List.fold_left (fun acc (i, bit) -> acc + Int.shift_left (if bit then 1 else 0) i) 0 bits

let () =
  let wirings = In_channel.input_lines stdin |> parse_input in
  (*let wirings = sort_wirings wirings in*)
  part1 wirings;
  ()
