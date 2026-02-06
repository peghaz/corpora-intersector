(** Corpus Intersector Library
    
    A tool to find words in a corpus that don't appear in a given text.
    
    {1 Algorithm}
    
    Uses a hash table for O(1) average case lookups, insertions, and deletions.
    Overall complexity: O(n + m) where n = corpus size, m = text words.
    
    {1 Usage}
    
    {[
      Corpus_intersector.corpus_diff
        ~corpus_path:"corpus.txt"
        ~text_path:"sentences.txt"
        ~output_path:"missing_words.txt"
    ]}
    
    {1 Modules}
*)

module Tokenizer = Tokenizer
(** Word extraction and normalization *)

module Corpus = Corpus  
(** Corpus management with hash table *)

module File_io = File_io
(** Efficient buffered file I/O *)

val corpus_diff : corpus_path:string -> text_path:string -> output_path:string -> unit
(** [corpus_diff ~corpus_path ~text_path ~output_path] computes words in corpus
    that never appear in the text and writes them to output file. *)
