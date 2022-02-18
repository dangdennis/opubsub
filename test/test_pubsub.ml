(* dune runtest --no-buffer *)

open Pubsub
module C = Domainslib.Chan

let subs : (string, string subscription) Hashtbl.t = Hashtbl.create 1000

let () =
  let chan1 = subscribe subs "topic-1" in
  let chan2 = subscribe subs "topic-2" in

  let rec receive ch =
    let v = C.recv ch in
    Format.printf "received val=%s@." v;
    (* print_endline v; *)
    receive ch
  in

  publish subs "topic-1" "hello1";
  publish subs "topic-1" "hello2";
  publish subs "topic-1" "hello3";
  publish subs "topic-1" "hello4";
  publish subs "topic-1" "hello5";
  publish subs "topic-1" "hello6";

  publish subs "topic-2" "world1";
  publish subs "topic-2" "world2";
  publish subs "topic-2" "world3";
  publish subs "topic-2" "world4";
  publish subs "topic-2" "world5";
  publish subs "topic-2" "world6";

  let d1 = Domain.spawn (fun _ -> receive chan1) in
  let d2 = Domain.spawn (fun _ -> receive chan2) in

  Domain.join d1;
  Domain.join d2;

  print_string "pubsub job done"
