(** Corpus module: manages the word set using a hash table for O(1) operations.
    
    Algorithm choice: Hash table provides O(1) average case for:
    - Lookup (mem)
    - Insertion (add)  
    - Deletion (remove)
    
    This is optimal for large datasets compared to:
    - Set (balanced tree): O(log n) operations
    - List: O(n) operations
*)

type t
(** Abstract type representing a corpus (set of words) *)

val create : ?initial_size:int -> unit -> t
(** [create ~initial_size ()] creates an empty corpus.
    [initial_size] is a hint for hash table sizing (default: 2M) *)

val add : t -> string -> unit
(** [add corpus word] adds a word to the corpus *)

val remove : t -> string -> unit
(** [remove corpus word] removes a word from the corpus *)

val mem : t -> string -> bool
(** [mem corpus word] checks if word exists in corpus *)

val size : t -> int
(** [size corpus] returns the number of words in corpus *)

val iter : (string -> unit) -> t -> unit
(** [iter f corpus] applies [f] to each word in corpus *)

val fold : (string -> 'a -> 'a) -> t -> 'a -> 'a
(** [fold f corpus init] folds over all words in corpus *)

val to_list : t -> string list
(** [to_list corpus] returns all words as a list *)

val load_from_file : string -> t
(** [load_from_file path] loads corpus from file.
    Words can be separated by commas, spaces, or newlines. *)

val remove_words_from_file : t -> string -> unit
(** [remove_words_from_file corpus path] removes all words found in the 
    text file from the corpus. This is the core intersection operation. *)
