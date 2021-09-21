### Filter by motif

***

A motif that should appear in either interactor's or interactee's sequence. Only interactions between those sequences will be displayed on the graph and in the table.

A motif should consist of the letters representing amino acids with possibility of using the following ambiguous letters:
* "B" -- either "D" or "N"
* "J" -- either "I" or "L"
* "Z" -- either "E" or "Q"
* "X" -- any standard amino acid

Additionally, the character "*" may be used for a subsequence of any (possibly distinct) amino acids of any length. The character "\^" may be used as the first character of a motif to mark the beginning of the sequence. Similarly, "$" may be used as the last character of a motif to mark the end of a sequence.


Some exemplary motifs:

* "A" -- any sequence containing "A"
* "GLAAALGA" -- any sequence containing "GLAAALGA"
* "\^AAAAA" -- any sequence starting with "AAAAA"
* "AXXXA" -- any sequence containing two "A"s with exactly three amino acids between them
* "A*A" -- any sequence containing two "A"s and any number of any amino acids between them
* "\^A*GG$" -- any sequence starting with a single "A" and ending with a double "G"
* "\^AG$" -- a sequence that is exactly "AG"