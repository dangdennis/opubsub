module Chan = Domainslib.Chan

type 'a subscription = {
  id : string;
  (* publish to this channel to fan out messages to subscribers *)
  c : 'a Chan.t;
  conns : 'a Chan.t list;
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
    | Some _ -> ()
  in
  chan

let publish subs id content =
  let sub = Hashtbl.find subs id in
  Chan.send sub.c content
