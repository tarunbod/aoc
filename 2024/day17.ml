type computer = { a : int; b : int; c : int; pc : int; program: int list; output: string; halt : bool; }

let string_of_computer { a; b; c; pc; program; output; halt } =
    Printf.sprintf "{ %d, %d, %d, %d, [%s], %s }\n%s" a b c pc (List.map string_of_int program |> String.concat ",") (string_of_bool halt) output

let combo comp op = match op with
| n when 0 <= n && n <= 3 -> n
| 4 -> comp.a
| 5 -> comp.b
| 6 -> comp.c
| _ -> raise @@ Invalid_argument "combo op not implemented"

let append_int str i = if str = "" then string_of_int i else Printf.sprintf "%s,%d" str i

let next comp =
    if comp.halt then comp else
        let opcode = List.nth_opt comp.program comp.pc in
        let operand = List.nth_opt comp.program @@ succ comp.pc in
        match (opcode, operand) with
        | Some 0, Some op -> { comp with a = comp.a / (Int.shift_left 1 @@ combo comp op); pc = comp.pc + 2 }
        | Some 1, Some op -> { comp with b = Int.logxor comp.b op; pc = comp.pc + 2 }
        | Some 2, Some op -> { comp with b = (combo comp op) mod 8; pc = comp.pc + 2 }
        | Some 3, Some op -> { comp with pc = if comp.a = 0 then comp.pc + 2 else op }
        | Some 4, Some _  -> { comp with b = Int.logxor comp.b comp.c; pc = comp.pc + 2 }
        | Some 5, Some op -> { comp with output = append_int comp.output @@ (combo comp op) mod 8; pc = comp.pc + 2 }
        | Some 6, Some op -> { comp with b = comp.a / (Int.shift_left 1 @@ combo comp op); pc = comp.pc + 2 }
        | Some 7, Some op -> { comp with c = comp.a / (Int.shift_left 1 @@ combo comp op); pc = comp.pc + 2 }
        | _ -> { comp with halt = true }

let rec run comp = if comp.halt then string_of_computer comp else run @@ next comp

let parse_computer input = match String.split_on_char '\n' input with
| la :: lb :: lc :: _ :: lprog :: _ ->
    {
        a = String.split_on_char ' ' la |> List.tl |> List.tl |> List.hd |> int_of_string;
        b = String.split_on_char ' ' lb |> List.tl |> List.tl |> List.hd |> int_of_string;
        c = String.split_on_char ' ' lc |> List.tl |> List.tl |> List.hd |> int_of_string;
        pc = 0;
        program = String.split_on_char ' ' lprog |> List.tl |> List.hd |> String.split_on_char ',' |> List.map int_of_string;
        output = "";
        halt = false;
    }
| _ -> raise @@ Invalid_argument "invalid input"

let () = In_channel.input_all stdin |> parse_computer |> run |> print_endline
