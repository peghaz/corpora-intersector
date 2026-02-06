(lang dune 3.21)

(name corpus_intersector)

(generate_opam_files true)

(source
 (github peghaz/corpora-intersector))

(authors "Mehdi Yaminli mehdiyamin@gmail.com")

(maintainers "Mehdi Yaminli mehdiyamin@gmail.com")

(license MIT)

(documentation https://github.com/peghaz/corpora-intersector#readme)

(package
 (name corpus_intersector)
 (synopsis "High-performance tool to find corpus words missing from a text")
 (description
  "A fast OCaml tool that identifies words from a language corpus that never appear in a given text. Uses O(1) hash table lookups for efficient comparison. Useful for vocabulary analysis, language learning, and corpus linguistics research.")
 (depends
  (ocaml (>= 4.14))
  dune)
 (tags
  (ocaml nlp corpus linguistics vocabulary text-analysis)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
