(** Tokenizer module: handles word extraction and normalization.
    Supports Unicode text including Russian, Chinese, and other scripts. *)

val normalize : string -> string
(** [normalize s] converts string to lowercase using Unicode case folding *)

val tokenize_line : string -> string list
(** [tokenize_line line] extracts all normalized words from a line.
    Works with any Unicode script (Latin, CJK, Arabic, etc.) *)

val iter_words_in_line : (string -> unit) -> string -> unit
(** [iter_words_in_line f line] applies [f] to each normalized word in line.
    More efficient than tokenize_line when you don't need the list. *)
