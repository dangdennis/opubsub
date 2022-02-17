open Pubsub
module C = Domainslib.Chan

let subs : (string, string subscription) Hashtbl.t = Hashtbl.create 1000

let () =
  let chan1 = subscribe subs "topic-1" in

  let receive ch =
    print_endline "receive msg";
    let v = C.recv_poll ch in
    match v with
    | None -> ()
    | Some v ->
        Format.printf "received val=%s\n" v;
        ()
    (* how do i continue to listen onto this channel for new messages *)
    (* receive ch *)
  in

  publish subs "topic-1" "hello1";
  publish subs "topic-1" "hello2";
  publish subs "topic-1" "hello3";
  publish subs "topic-1" "hello4";
  publish subs "topic-1" "hello5";
  publish subs "topic-1" "hello6";
  publish subs "topic-2" "world1";

  let d1 = Domain.spawn (fun _ -> receive chan1) in

  (* will be blocked forever because d1 never finishes *)
  Domain.join d1;

  print_string "pubsub job done"
