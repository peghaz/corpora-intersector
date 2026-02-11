(** Tokenizer module: handles word extraction and normalization *)

(** Decode a UTF-8 string into a list of Unicode code points (Uchar.t) *)
let decode_utf8 (s : string) : Uchar.t list =
  let decoder = Uutf.decoder ~encoding:`UTF_8 (`String s) in
  let rec loop acc =
    match Uutf.decode decoder with
    | `Uchar u -> loop (u :: acc)
    | `End -> List.rev acc
    | `Malformed _ -> loop (Uchar.of_int 0xFFFD :: acc) (* replacement char *)
    | `Await -> assert false (* not using manual source *)
  in
  loop []

(** Encode a list of Unicode code points back to a UTF-8 string *)
let encode_utf8 (uchars : Uchar.t list) : string =
  let buf = Buffer.create (List.length uchars * 4) in
  List.iter (fun u -> Uutf.Buffer.add_utf_8 buf u) uchars;
  Buffer.contents buf

(** Check if a Unicode code point is a "word character":
    - Letters (any script: Latin, Cyrillic, Arabic, CJK, etc.)
    - Numbers
    - Apostrophe and hyphen (for contractions and compound words) *)
let is_word_uchar (u : Uchar.t) : bool =
  let cat = Uucp.Gc.general_category u in
  match cat with
  | `Lu | `Ll | `Lt | `Lm | `Lo  (* Letters: uppercase, lowercase, titlecase, modifier, other *)
  | `Nd | `Nl | `No              (* Numbers: decimal, letter, other *)
    -> true
  | _ ->
    (* Also allow apostrophe and hyphen *)
    let cp = Uchar.to_int u in
    cp = 0x27 || cp = 0x2D || cp = 0x2019 (* ' - ' (curly apostrophe) *)

(** Normalize a Unicode string: convert to lowercase using Unicode case folding *)
let normalize (s : string) : string =
  let uchars = decode_utf8 s in
  let lowered = List.concat_map (fun u ->
    match Uucp.Case.Map.to_lower u with
    | `Self -> [u]
    | `Uchars us -> us
  ) uchars in
  encode_utf8 lowered

let tokenize_line (line : string) : string list =
  let uchars = decode_utf8 line in
  let buf = ref [] in
  let words = ref [] in
  let flush_word () =
    if !buf <> [] then (
      let word_uchars = List.rev !buf in
      let word_str = encode_utf8 word_uchars in
      let w = normalize word_str in
      buf := [];
      words := w :: !words
    )
  in
  List.iter (fun u ->
    if is_word_uchar u then
      buf := u :: !buf
    else
      flush_word ()
  ) uchars;
  flush_word ();
  List.rev !words

let iter_words_in_line (f : string -> unit) (line : string) : unit =
  let uchars = decode_utf8 line in
  let buf = ref [] in
  let flush_word () =
    if !buf <> [] then (
      let word_uchars = List.rev !buf in
      let word_str = encode_utf8 word_uchars in
      let w = normalize word_str in
      buf := [];
      f w
    )
  in
  List.iter (fun u ->
    if is_word_uchar u then
      buf := u :: !buf
    else
      flush_word ()
  ) uchars;
  flush_word ()
