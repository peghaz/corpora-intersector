(** File I/O module: efficient buffered file operations *)

(** Default buffer size: 1MB for efficient I/O *)
let default_buffer_size = 1024 * 1024

let write_words_to_file ?(buffer_size = default_buffer_size) (words : string list) (path : string) : unit =
  let oc = open_out_bin path in
  let buf = Buffer.create buffer_size in
  let flush () =
    if Buffer.length buf > 0 then (
      output_string oc (Buffer.contents buf);
      Buffer.clear buf
    )
  in
  List.iter
    (fun w ->
      Buffer.add_string buf w;
      Buffer.add_char buf '\n';
      if Buffer.length buf >= buffer_size then flush ()
    )
    words;
  flush ();
  close_out oc

let write_corpus_to_file ?(buffer_size = default_buffer_size) (corpus : Corpus.t) (path : string) : unit =
  let oc = open_out_bin path in
  let buf = Buffer.create buffer_size in
  let flush () =
    if Buffer.length buf > 0 then (
      output_string oc (Buffer.contents buf);
      Buffer.clear buf
    )
  in
  Corpus.iter
    (fun w ->
      Buffer.add_string buf w;
      Buffer.add_char buf '\n';
      if Buffer.length buf >= buffer_size then flush ()
    )
    corpus;
  flush ();
  close_out oc

let iter_lines (f : string -> unit) (path : string) : unit =
  let ic = open_in_bin path in
  let rec loop () =
    match input_line ic with
    | line -> f line; loop ()
    | exception End_of_file -> ()
  in
  loop ();
  close_in ic

let fold_lines (f : 'a -> string -> 'a) (init : 'a) (path : string) : 'a =
  let ic = open_in_bin path in
  let rec loop acc =
    match input_line ic with
    | line -> loop (f acc line)
    | exception End_of_file -> acc
  in
  let result = loop init in
  close_in ic;
  result
