open Pubsub
module C = Domainslib.Chan

let subs : (string, string subscription) Hashtbl.t = Hashtbl.create 1000

let () =
  let chan1 = subscribe subs "topic-1" in
  let chan2 = subscribe subs "topic-2" in

  let rec receive ch =
    let v = C.recv ch in
    Format.printf "received val=%s" v;
    receive ch
  in

  publish subs "topic-1" "hello1";
  publish subs "topic-2" "world1";

  let _ = Domain.spawn (fun _ -> receive chan1) in
  let _ = Domain.spawn (fun _ -> receive chan2) in

  publish subs "topic-1" "hello2";
  publish subs "topic-2" "world2";

  print_string "ran pubsub";

  ()
