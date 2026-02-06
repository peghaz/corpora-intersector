(** Main library module - re-exports all submodules *)

module Tokenizer = Tokenizer
module Corpus = Corpus
module File_io = File_io

(** High-level function to compute corpus difference *)
let corpus_diff ~corpus_path ~text_path ~output_path =
  (* Load corpus into hash table - O(n) where n = corpus size *)
  let corpus = Corpus.load_from_file corpus_path in
  
  (* Remove words found in text - O(m) where m = text words *)
  Corpus.remove_words_from_file corpus text_path;
  
  (* Write remaining words - O(k) where k = remaining words *)
  File_io.write_corpus_to_file corpus output_path
