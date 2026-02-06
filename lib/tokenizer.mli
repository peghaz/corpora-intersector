(** Tokenizer module: handles word extraction and normalization *)

val normalize : string -> string
(** [normalize s] converts string to lowercase for comparison *)

val is_word_char : char -> bool
(** [is_word_char c] returns true if character is part of a word *)

val tokenize_line : string -> string list
(** [tokenize_line line] extracts all normalized words from a line *)

val iter_words_in_line : (string -> unit) -> string -> unit
(** [iter_words_in_line f line] applies [f] to each normalized word in line.
    More efficient than tokenize_line when you don't need the list. *)
