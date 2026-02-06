# Corpus Intersector

A high-performance OCaml tool that finds words in a language corpus that never appear in a given text. Useful for vocabulary analysis, language learning applications, and corpus linguistics research.

## What It Does

Given:
1. **A corpus file** — a large list of words from a language (e.g., an English dictionary)
2. **A text file** — sentences or paragraphs (e.g., a book, article collection, or dataset)

The tool outputs all words from the corpus that **do not appear** anywhere in the text.

### Example Use Cases

- **Language Learning**: Find vocabulary words a student hasn't encountered yet
- **Text Coverage Analysis**: Determine what percentage of a dictionary a text covers
- **Corpus Linguistics**: Analyze which words are absent from a particular genre or author's work
- **Content Gap Analysis**: Identify terminology missing from documentation

## Algorithm & Efficiency

### Data Structure: Hash Table

The tool uses OCaml's `Hashtbl` for O(1) average-case operations:

| Operation | Time Complexity |
|-----------|-----------------|
| Insert word into corpus | O(1) |
| Check if word exists | O(1) |
| Remove word | O(1) |

### Overall Algorithm

```
1. Load corpus into hash table    → O(n) where n = corpus words
2. Stream through text file       → O(m) where m = text words  
3. Remove each text word from set → O(1) per word
4. Write remaining words          → O(k) where k = remaining words

Total: O(n + m) — linear time complexity
```

### Why Hash Table Over Alternatives?

| Data Structure | Lookup | Insert | Delete | Space |
|----------------|--------|--------|--------|-------|
| **Hash Table** ✓ | O(1) avg | O(1) avg | O(1) avg | O(n) |
| Balanced Tree (Set) | O(log n) | O(log n) | O(log n) | O(n) |
| Sorted Array | O(log n) | O(n) | O(n) | O(n) |
| Linked List | O(n) | O(1) | O(n) | O(n) |

For large corpora (millions of words), hash tables significantly outperform tree-based structures.

### I/O Optimization

- **Buffered Output**: Uses 1MB buffer to minimize system calls
- **Streaming Input**: Processes text line-by-line without loading entire file into memory
- **Binary Mode**: Uses `open_in_bin`/`open_out_bin` for consistent cross-platform behavior

## Installation

### Prerequisites

You need **opam** (OCaml Package Manager) and **dune** (build system).

#### Installing opam

##### Linux (Debian/Ubuntu)
```bash
sudo apt update
sudo apt install opam
opam init
eval $(opam env)
```

##### Linux (Fedora)
```bash
sudo dnf install opam
opam init
eval $(opam env)
```

##### Linux (Arch)
```bash
sudo pacman -S opam
opam init
eval $(opam env)
```

##### macOS (Homebrew)
```bash
brew install opam
opam init
eval $(opam env)
```

##### macOS (MacPorts)
```bash
port install opam
opam init
eval $(opam env)
```

##### Windows (WSL recommended)
Use Windows Subsystem for Linux and follow the Linux instructions above.

Alternatively, use [DkML](https://diskuv.com/dkmlbook/) for native Windows:
```powershell
winget install Diskuv.OCaml
```

##### From Source (Any Platform)
See the [official opam installation guide](https://opam.ocaml.org/doc/Install.html).

#### Installing OCaml and Dune

After opam is set up:
```bash
# Install OCaml compiler (if not already installed)
opam switch create 5.1.0  # or latest version
eval $(opam env)

# Install dune build system
opam install dune
```

### Building the Project

```bash
# Clone the repository
git clone https://github.com/yourusername/CorpusIntersector.git
cd CorpusIntersector

# Build the project
dune build

# (Optional) Install globally
dune install
```

## Usage

### Command Line

```bash
# Using dune exec
dune exec corpus_intersector -- <corpus.txt> <sentences.txt> <output.txt>

# Or if installed globally
corpus_intersector <corpus.txt> <sentences.txt> <output.txt>

# Or run the binary directly
./_build/default/bin/main.exe <corpus.txt> <sentences.txt> <output.txt>
```

### Arguments

| Argument | Description |
|----------|-------------|
| `corpus.txt` | Word list file (words separated by commas, spaces, or newlines) |
| `sentences.txt` | Text file to analyze (one sentence per line) |
| `output.txt` | Output file for words not found in text |

### Example

```bash
# Using the included sample files
dune exec corpus_intersector -- samples/corpus.txt samples/sentences.txt output.txt

# View results
cat output.txt
```

### As a Library

You can also use this as a library in your OCaml projects:

```ocaml
(* High-level API *)
Corpus_intersector.corpus_diff
  ~corpus_path:"corpus.txt"
  ~text_path:"sentences.txt"
  ~output_path:"missing.txt"

(* Or use individual modules for more control *)
let corpus = Corpus_intersector.Corpus.load_from_file "corpus.txt" in
Corpus_intersector.Corpus.remove_words_from_file corpus "text.txt";
Printf.printf "Remaining words: %d\n" (Corpus_intersector.Corpus.size corpus)
```

## Project Structure

```
CorpusIntersector/
├── bin/
│   ├── dune              # Binary build config
│   └── main.ml           # CLI entry point
├── lib/
│   ├── dune              # Library build config
│   ├── tokenizer.ml/i    # Word extraction & normalization
│   ├── corpus.ml/i       # Hash table-based word set
│   ├── file_io.ml/i      # Buffered file operations
│   └── corpus_intersector.ml/i  # Main library interface
├── test/
│   ├── dune              # Test build config
│   └── test_corpus_intersector.ml  # Unit & integration tests
├── samples/
│   ├── corpus.txt        # Sample word list
│   ├── sentences.txt     # Sample text
│   └── missing.txt       # Expected output
├── dune-project          # Dune project metadata
└── corpus_intersector.opam  # Package metadata
```

### Module Responsibilities

| Module | Purpose |
|--------|---------|
| `Tokenizer` | Extracts words from text, handles normalization (lowercase), defines word boundaries |
| `Corpus` | Manages the word set using hash table, provides load/save/query operations |
| `File_io` | Efficient buffered I/O for reading and writing large files |

## Running Tests

```bash
dune test
```

This runs:
- **Unit tests**: Tokenizer and Corpus module functionality
- **Integration test**: End-to-end test using sample files in `samples/`

## Input File Formats

### Corpus File
Words can be separated by:
- Newlines (one word per line)
- Commas
- Spaces
- Any combination

```
apple, banana, cherry
dog
cat, mouse
```

### Text File
Plain text, typically one sentence per line:
```
The quick brown fox jumps over the lazy dog.
A cat sleeps near the river.
```

### Word Normalization
- All comparisons are **case-insensitive** ("Hello" matches "hello")
- Word characters: `a-z`, `A-Z`, `0-9`, `'` (apostrophe), `-` (hyphen)
- Everything else is treated as a word separator

## Performance Tips

1. **Pre-size the hash table**: For very large corpora, modify `Corpus.create ~initial_size:N ()` to avoid rehashing
2. **Use SSDs**: I/O bound operations benefit from fast storage
3. **Increase buffer size**: For huge outputs, adjust `File_io.default_buffer_size`

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
