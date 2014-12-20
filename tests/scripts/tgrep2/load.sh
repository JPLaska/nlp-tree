#! /bin/bash

corpus_dir="../../../corpus/"
text_filename="tgrep2-corpus.txt"
filepath="$corpus_dir$text_filename"

results_dir="../../

tgrep2="~/tgrep2/TGrep2/tgrep2"


before_time=$(date +%s)

eval $tgrep2 -p $corpus


