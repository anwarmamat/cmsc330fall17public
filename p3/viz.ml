let init_str = "digraph G { \n rankdir=LR; -1 [style=\"invis\"]; \n";;
let end_str = "\n}";;
let nodup x lst = if List.mem x lst then lst else x::lst;;
let string_of_vtx lst = List.fold_left (fun acc (v, f) ->
  let shape = if f then "doublecircle" else "circle" in
  acc ^ (Printf.sprintf "%d [shape=%s];\n" v shape)) "" lst;;
let string_of_ed lst = List.fold_left (fun acc ((s1, _), c, p, (s2, _)) ->
  let ports =
    if p then
      (if s1 > s2 then "tailport=s, headport=s" else "tailport=n, headport=n")
    else "" in
  acc ^ (Printf.sprintf "%d -> %d [label=\"%s\", %s];\n" s1 s2 c ports)) "" lst;;

let write_nfa_to_graphviz (nfa : Nfa.nfa_t) : bool =
  let name = "output.viz" in
  let ss, fs, ts = Nfa.get_start nfa, Nfa.get_finals nfa, Nfa.get_transitions nfa in
  let (vt, ed) = List.fold_left (fun (vt, ed) (v1, c, v2) ->
      let v1' = (v1, List.mem v1 fs) in
      let v2' = (v2, List.mem v2 fs) in
      let c' = match c with
        | None -> "ε"
        | Some x -> String.make 1 x in
      let pair = List.mem (v2, c, v1) ts in
      let e = (v1', c', pair, v2') in
      (nodup v2' (nodup v1' vt), nodup e ed)) ([], []) ts in
  let (vt, ed) = (vt, ((-1, false), " ", false, (ss, List.mem ss fs))::ed) in
  let dot = init_str ^ (string_of_vtx vt) ^ (string_of_ed ed) ^ end_str in
  let file = open_out_bin name in
  output_string file dot;
  flush file;
  Sys.command (Printf.sprintf "dot %s -Tpng -o output.png && rm %s" name name) = 0;;

print_string "Type regexp to visualize: ";;
let line = read_line ();;
print_string "Convert to DFA (y/n)? ";;
let line2 = read_line ();;
let nfa = Regexp.string_to_nfa line;;
let nfa = if line2 = "y" then Nfa.nfa_to_dfa nfa else nfa;;
if write_nfa_to_graphviz nfa then
  print_string "Success! Open 'output.png' to see your visualized NFA.\n"
else
  print_string "Failure! Are you sure you have graphviz installed on your machine?\n"
