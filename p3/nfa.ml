(* CMSC 330 / Fall 2017 / Project 3 *)
(* Name: ?? *)

type transition = int * char option * int
type stats = {num_states : int; num_finals : int; outgoing_counts : (int * int) list}

let get_next_gen () =
  let x = ref 0 in
  (fun () -> let r = !x in x := !x + 1; r)
let next = get_next_gen ()

let int_list_to_int =
  let next' = get_next_gen () in
  let tbl = Hashtbl.create 10 in
  let compare a b = if a < b then -1 else if a = b then 0 else 1 in
  (fun lst ->
      let slst = List.sort_uniq compare lst in
      if Hashtbl.mem tbl slst then Hashtbl.find tbl slst
    else let n = next' () in Hashtbl.add tbl slst n; n)

(* YOUR CODE BEGINS HERE *)

type nfa_t = bool (* Must put your own type here! *)

let get_start m = failwith "Unimplemented"
let get_finals m = failwith "Unimplemented"
let get_transitions m = failwith "Unimplemented"

let make_nfa ss fs ts = failwith "Unimplemented"

let nfa_to_dfa m = failwith "Unimplemented" 

let e_closure m l = failwith "Unimplemented"

let move m l c = failwith "Unimplemented"

let accept m s = failwith "Unimplemented"

let stats m = failwith "Unimplemented"

