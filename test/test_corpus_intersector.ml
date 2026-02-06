(* Tests for corpus_intersector library *)

let test_tokenizer () =
  let open Corpus_intersector.Tokenizer in
  
  (* Test normalization *)
  assert (normalize "Hello" = "hello");
  assert (normalize "WORLD" = "world");
  
  (* Test word char detection *)
  assert (is_word_char 'a');
  assert (is_word_char 'Z');
  assert (is_word_char '\'');
  assert (is_word_char '-');
  assert (not (is_word_char ' '));
  assert (not (is_word_char ','));
  
  (* Test tokenize_line *)
  assert (tokenize_line "hello world" = ["hello"; "world"]);
  assert (tokenize_line "one,two,three" = ["one"; "two"; "three"]);
  assert (tokenize_line "  spaces  " = ["spaces"]);
  assert (tokenize_line "don't" = ["don't"]);
  assert (tokenize_line "well-known" = ["well-known"]);
  
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

let () =
  test_tokenizer ();
  test_corpus ();
  print_endline "All tests passed!"