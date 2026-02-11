(* Tests for corpus_intersector library *)

(* Get project root directory (parent of _build) *)
let project_root =
  let cwd = Sys.getcwd () in
  (* When running via dune test, we're in _build/default/test *)
  if Filename.basename cwd = "test" then
    Filename.dirname (Filename.dirname (Filename.dirname cwd))
  else if String.length cwd >= 6 && String.sub cwd (String.length cwd - 6) 6 = "_build" then
    Filename.dirname cwd
  else
    (* Fallback: assume we're at project root or find it *)
    let rec find_root dir =
      if Sys.file_exists (Filename.concat dir "dune-project") then dir
      else
        let parent = Filename.dirname dir in
        if parent = dir then cwd (* give up, use cwd *)
        else find_root parent
    in
    find_root cwd

let samples_dir = Filename.concat project_root "samples"

let test_tokenizer () =
  let open Corpus_intersector.Tokenizer in
  
  (* Test normalization *)
  assert (normalize "Hello" = "hello");
  assert (normalize "WORLD" = "world");
  
  (* Test tokenize_line *)
  assert (tokenize_line "hello world" = ["hello"; "world"]);
  assert (tokenize_line "one,two,three" = ["one"; "two"; "three"]);
  assert (tokenize_line "  spaces  " = ["spaces"]);
  assert (tokenize_line "don't" = ["don't"]);
  assert (tokenize_line "well-known" = ["well-known"]);
  
  (* Test Unicode tokenization - Chinese *)
  assert (tokenize_line "你好世界" = ["你好世界"]);
  assert (tokenize_line "学习 编程" = ["学习"; "编程"]);
  
  print_endline "Tokenizer tests passed!"

let test_corpus () =
  let open Corpus_intersector.Corpus in
  
  let c = create () in
  add c "hello";
  add c "world";
  
  assert (mem c "hello");
  assert (mem c "world");
  assert (not (mem c "foo"));
  assert (size c = 2);
  
  remove c "hello";
  assert (not (mem c "hello"));
  assert (size c = 1);
  
  print_endline "Corpus tests passed!"

let read_lines_sorted (path : string) : string list =
  let ic = open_in path in
  let rec loop acc =
    match input_line ic with
    | line ->
        let trimmed = String.trim line in
        if trimmed = "" then loop acc
        else loop (trimmed :: acc)
    | exception End_of_file -> acc
  in
  let lines = loop [] in
  close_in ic;
  List.sort String.compare lines

let test_integration () =
  let corpus_path = Filename.concat samples_dir "corpus.txt" in
  let sentences_path = Filename.concat samples_dir "sentences.txt" in
  let expected_path = Filename.concat samples_dir "missing.txt" in
  let output_path = Filename.temp_file "corpus_test_" ".txt" in

  (* Run the corpus diff *)
  Corpus_intersector.corpus_diff
    ~corpus_path
    ~text_path:sentences_path
    ~output_path;

  (* Read expected and actual output, sort for comparison *)
  let expected = read_lines_sorted expected_path in
  let actual = read_lines_sorted output_path in

  (* Clean up temp file *)
  Sys.remove output_path;

  (* Compare *)
  if expected <> actual then (
    Printf.eprintf "Integration test FAILED!\n";
    Printf.eprintf "Expected %d words:\n" (List.length expected);
    List.iter (Printf.eprintf "  %s\n") expected;
    Printf.eprintf "Got %d words:\n" (List.length actual);
    List.iter (Printf.eprintf "  %s\n") actual;
    
    (* Show differences *)
    let missing_from_actual = List.filter (fun w -> not (List.mem w actual)) expected in
    let extra_in_actual = List.filter (fun w -> not (List.mem w expected)) actual in
    if missing_from_actual <> [] then (
      Printf.eprintf "Missing from output:\n";
      List.iter (Printf.eprintf "  %s\n") missing_from_actual
    );
    if extra_in_actual <> [] then (
      Printf.eprintf "Extra in output:\n";
      List.iter (Printf.eprintf "  %s\n") extra_in_actual
    );
    
    assert false
  );

  print_endline "Integration test passed!"

let () =
  test_tokenizer ();
  test_corpus ();
  test_integration ();
  print_endline "All tests passed!"