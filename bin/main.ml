(* corpus_diff: print corpus words that never appear in the text *)

let () =
  if Array.length Sys.argv <> 4 then (
    prerr_endline "Usage: corpus_diff <corpus.txt> <sentences.txt> <output.txt>";
    exit 2
  );
  let corpus_path = Sys.argv.(1) in
  let text_path = Sys.argv.(2) in
  let out_path = Sys.argv.(3) in

  Corpus_intersector.corpus_diff
    ~corpus_path
    ~text_path
    ~output_path:out_path

