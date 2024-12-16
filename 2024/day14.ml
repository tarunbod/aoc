type point = { x: int; y: int; vx: int; vy: int }

let point_id a = 1000 * (succ a.x) + (succ a.y)

let parse3 str sep = match String.split_on_char sep str with
    | a :: b :: t -> (a, b, t)
    | _ -> raise @@ Invalid_argument ""

let parse_point point_str : point =
    let (p, v, _) = parse3 point_str ' ' in
    let (_, pnums, _) = parse3 p '=' in
    let (_, vnums, _) = parse3 v '=' in
    let (p1, p2, _) = parse3 pnums ',' in
    let (v1, v2, _) = parse3 vnums ',' in
    { x = int_of_string p1; y = int_of_string p2; vx = int_of_string v1; vy = int_of_string v2 }

let rec iterate n maxn f a = match n with
| n when n <= maxn -> iterate (n + 1) maxn f (f n a)
| n -> a

let modulo x y =
    let m = x mod y in
    if m >= 0 then m else y + m

let step_grid maxx maxy p =
    { x = modulo (p.x + p.vx) maxx; y = modulo (p.y + p.vy) maxy; vx = p.vx; vy = p.vy }

let safety_factor maxx maxy l =
    let q1 = List.length @@ List.filter (fun p -> p.x < maxx / 2 && p.y < maxy / 2) l in
    let q2 = List.length @@ List.filter (fun p -> p.x < maxx / 2 && p.y > maxy / 2) l in
    let q3 = List.length @@ List.filter (fun p -> p.x > maxx / 2 && p.y < maxy / 2) l in
    let q4 = List.length @@ List.filter (fun p -> p.x > maxx / 2 && p.y > maxy / 2) l in
    q1 * q2 * q3 * q4

let string_of_point p = Printf.sprintf "{%d, %d} at {%d, %d}" p.x p.y p.vx p.vy

let print_grid maxx maxy points =
    for y = 0 to pred maxy do
        for x = 0 to pred maxx do
            if List.exists (fun p -> p.x == x && p.y == y) points then
                print_char 'X'
            else
                print_char '.';
        done;
        print_newline ()
    done;
    print_newline ()

let () =
    let points = In_channel.input_lines stdin |> List.map parse_point in
    let maxx = List.fold_left (fun acc p -> (max p.x acc)) 0 points |> succ in
    let maxy = List.fold_left (fun acc p -> (max p.y acc)) 0 points |> succ in
    let print_and_step i l =
        let il = List.map (step_grid maxx maxy) l in
        let il_count = List.length il in
        let uniq_count = List.map point_id il |> List.sort_uniq Int.compare |> List.length in
        if uniq_count = il_count then
            begin
                Printf.printf "%d\n" i;
                print_grid maxx maxy il;
            end;
        il
    in
    iterate 1 100 print_and_step points |> safety_factor maxx maxy |> Printf.printf "%d";
    let _ = iterate 101 10000 print_and_step points in
    ()
