### Filter by motif

***

Motif that should appear in either interactor or interactee's sequence. Only interactions between 
those sequences will be displayed on graph and in table.

Motif should consist of letters representing aminoacids with possibility of using the following 
ambiguous letters:
* "B" -- either "D" or "N"
* "J" -- either "I" or "L"
* "Z" -- either "E" or "Q"
* "X" -- any standard aminoacid

Additionally, character "*" may be used for a subsequence of any (possible distinct) aminoacids
of any length. Character "\^" may be used as the first character of the motif to mark the beggining
of the sequence. Similarily, "$" may be used as the last character of the motif to mark the end
of the sequence.


Exemplary motifs:

* "A" -- any sequence containing "A"
* "GLAAALGA" -- any sequence containing "GLAAALGA"
* "\^AAAAA" -- any sequence starting with "AAAAA"
* "AXXXA" -- any sequence containing "AXXXA", where "X" is any single aminoacid
* "A*A" -- any sequence containing two "A" and any number of any aminoacids between them
* "\^A*GG$" -- any sequence starting with single "A" and ending with double "G"
* "\^AG$" -- sequence that is exactly equal to "AG"