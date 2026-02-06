(** Tokenizer module: handles word extraction and normalization *)

let normalize (s : string) : string =
  String.lowercase_ascii s

let is_word_char (c : char) : bool =
  match c with
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '\'' | '-' -> true
  | _ -> false

let tokenize_line (line : string) : string list =
  let buf = Buffer.create 32 in
  let words = ref [] in
  let flush_word () =
    if Buffer.length buf > 0 then (
      let w = normalize (Buffer.contents buf) in
      Buffer.clear buf;
      words := w :: !words
    )
  in
  let n = String.length line in
  for i = 0 to n - 1 do
    let c = line.[i] in
    if is_word_char c then
      Buffer.add_char buf c
    else
      flush_word ()
  done;
  flush_word ();
  List.rev !words

let iter_words_in_line (f : string -> unit) (line : string) : unit =
  let buf = Buffer.create 32 in
  let flush_word () =
    if Buffer.length buf > 0 then (
      let w = normalize (Buffer.contents buf) in
      Buffer.clear buf;
      f w
    )
  in
  let n = String.length line in
  for i = 0 to n - 1 do
    let c = line.[i] in
    if is_word_char c then
      Buffer.add_char buf c
    else
      flush_word ()
  done;
  flush_word ()
