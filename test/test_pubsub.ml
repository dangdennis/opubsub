open Pubsub
module C = Domainslib.Chan

let subs : (string, string subscription) Hashtbl.t = Hashtbl.create 1000

let () =
  let chan1 = subscribe subs "topic-1" in

  let rec receive ch =
    print_endline "receive msg";
    let v = C.recv ch in
    Format.printf "received val=%s\n" v;
    receive ch
  in

  publish subs "topic-1" "hello1";
  publish subs "topic-1" "hello2";
  publish subs "topic-1" "hello3";
  publish subs "topic-1" "hello4";
  publish subs "topic-1" "hello5";
  publish subs "topic-1" "hello6";
  publish subs "topic-2" "world1";

  let _d1 = Domain.spawn (fun _ -> receive chan1) in

  (* The trigger button *)
  (* Domain.join _d1; *)

  (* 
  Really interesting behavior:

  First run `dune runtest` with the Domain.join. The process rightfully never shuts down, but no messages
  are ever printed.

  Now comment out the Domain.join line. Run `dune runtest` again and now you'll see something like:
  ```
  test_pubsub alias test/runtest
  receive msg
  pubsub job donereceive msg
  receive msg
  receive msg
  receive msg
  receive msg
  receive msg
  ```

  And again, run `dune runtest` for the third time. This time there are no messages.
   *)


  print_string "pubsub job done"
