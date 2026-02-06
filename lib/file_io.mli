(** File I/O module: efficient buffered file operations.

    Uses buffered I/O to minimize system calls, which is critical for
    performance when writing large amounts of data. Default buffer size
    is 1MB which provides good balance between memory usage and I/O efficiency.
*)

val default_buffer_size : int
(** Default buffer size (1MB) *)

val write_words_to_file : ?buffer_size:int -> string list -> string -> unit
(** [write_words_to_file ~buffer_size words path] writes words to file,
    one per line, using buffered I/O for efficiency *)

val write_corpus_to_file : ?buffer_size:int -> Corpus.t -> string -> unit
(** [write_corpus_to_file ~buffer_size corpus path] writes corpus words to file,
    one per line. More efficient than converting to list first. *)

val iter_lines : (string -> unit) -> string -> unit
(** [iter_lines f path] applies [f] to each line in the file *)

val fold_lines : ('a -> string -> 'a) -> 'a -> string -> 'a
(** [fold_lines f init path] folds over lines in the file *)
