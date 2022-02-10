type 'a subscription = {
  id : int;
  (* publish to this channel to fan out messages to subscribers *)
  c : 'a Domainslib.Chan.t;
  conns : 'a Domainslib.Chan.t list;
  mutable listening : bool;
}

(* subscribe adds the given websocket as a subscriber to the topic denoted by id *)
let subscribe subs id chan =
  Hashtbl.remove subs id;
  Hashtbl.add subs id
    {
      id;
      c = Domainslib.Chan.make_unbounded ();
      conns = [ chan ];
      listening = false;
    }

(* publish publishes content to all subscribers of the topic denoted by id *)
let publish subs id content =
  let sub = Hashtbl.find subs id in
  Domainslib.Chan.send sub.c content
