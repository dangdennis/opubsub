open Ocaml_channels

let subscriptions : (int, string subscription) Hashtbl.t = Hashtbl.create 1000

let _ =
  Hashtbl.add subscriptions 1
    {
      id = 1;
      c = Domainslib.Chan.make_unbounded ();
      conns =
        [ Domainslib.Chan.make_unbounded (); Domainslib.Chan.make_unbounded () ];
      listening = false;
    }

let _ =
  Hashtbl.add subscriptions 2
    {
      id = 2;
      c = Domainslib.Chan.make_unbounded ();
      conns =
        [ Domainslib.Chan.make_unbounded (); Domainslib.Chan.make_unbounded () ];
      listening = false;
    }

let _ =
  publish subscriptions 1 "hello";
  publish subscriptions 2 "world"

