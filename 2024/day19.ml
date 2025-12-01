let remove_prefix p s = String.(sub s (length p) (length s - length p))
let remove_suffix p s = String.(sub s 0 (length s - length p))

module StringMap = Map.Make (struct
  type t = string

  let compare = compare
end)

let rec valid_design patterns design =
  let memo = StringMap.empty in
  let check_valid design =
    match StringMap.find_opt design memo with
    | Some v -> v
    | _ -> (
        if design = "" then true
        else
          match
            List.filter (fun p -> String.ends_with ~suffix:p design) patterns
          with
          | [] -> false
          | l ->
              List.map
                (fun p -> valid_design patterns (remove_suffix p design))
                l
              |> List.exists Fun.id)
  in
  check_valid design

let () =
  let lines = In_channel.input_lines stdin in
  let patterns, designs =
    match lines with
    | patternsStr :: _ :: designs ->
        let patterns =
          String.split_on_char ',' patternsStr |> List.map String.trim
        in
        (patterns, designs)
    | _ -> failwith "invalid input"
  in
  List.map (valid_design patterns) designs
  |> List.filter Fun.id |> List.length |> print_int
