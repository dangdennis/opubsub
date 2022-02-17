open Pubsub
module C = Domainslib.Chan

let subs : (string, string subscription) Hashtbl.t = Hashtbl.create 1000

let () =
  let chan1 = subscribe subs "topic-1" in
  let chan2 = subscribe subs "topic-2" in

  let rec rcv ch =
    let v = C.recv ch in
    Format.printf "received val=%s" v;
    rcv ch
  in

  let _d1 = Domain.spawn (fun _ -> rcv chan1) in
  let _d2 = Domain.spawn (fun _ -> rcv chan2) in

  publish subs "topic-1" "hello";
  publish subs "topic-2" "world";

  print_string "hello";

  ()
