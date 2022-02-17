module Chan = Domainslib.Chan

type 'a subscription = {
  id : string;
  (* publish to this channel to fan out messages to subscribers *)
  c : 'a Chan.t;
  mutable conns : 'a Chan.t list;
  mutable listening : bool;
}

let subscribe subs topic : 'a Chan.t =
  let chan = Chan.make_unbounded () in
  let () =
    match Hashtbl.find_opt subs topic with
    | None ->
        Hashtbl.add subs topic
          {
            id = topic;
            c = Chan.make_unbounded ();
            conns = [ chan ];
            listening = false;
          }
    | Some sub ->
        sub.conns <- List.append [ chan ] sub.conns;
        ()
  in
  chan

let publish subs topic content =
  let sub = Hashtbl.find subs topic in
  List.iter (fun conn -> Chan.send conn content) sub.conns
