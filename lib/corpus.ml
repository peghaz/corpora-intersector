(** Corpus module: manages the word set using a hash table for O(1) operations *)

type t = (string, unit) Hashtbl.t

let create ?(initial_size = 2_000_000) () : t =
  Hashtbl.create initial_size

let add (corpus : t) (word : string) : unit =
  Hashtbl.replace corpus word ()

let remove (corpus : t) (word : string) : unit =
  Hashtbl.remove corpus word

let mem (corpus : t) (word : string) : bool =
  Hashtbl.mem corpus word

let size (corpus : t) : int =
  Hashtbl.length corpus

let iter (f : string -> unit) (corpus : t) : unit =
  Hashtbl.iter (fun w () -> f w) corpus

let fold (f : string -> 'a -> 'a) (corpus : t) (init : 'a) : 'a =
  Hashtbl.fold (fun w () acc -> f w acc) corpus init

let to_list (corpus : t) : string list =
  fold (fun w acc -> w :: acc) corpus []

let load_from_file (path : string) : t =
  let ic = open_in_bin path in
  let corpus = create () in
  let rec loop () =
    match input_line ic with
    | line ->
        Tokenizer.iter_words_in_line (add corpus) line;
        loop ()
    | exception End_of_file -> ()
  in
  loop ();
  close_in ic;
  corpus

let remove_words_from_file (corpus : t) (path : string) : unit =
  let ic = open_in_bin path in
  let rec loop () =
    match input_line ic with
    | line ->
        Tokenizer.iter_words_in_line (remove corpus) line;
        loop ()
    | exception End_of_file -> ()
  in
  loop ();
  close_in ic
