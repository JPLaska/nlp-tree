#! /bin/bash

source ../../conf.sh

corpus="$corpus_dir/corpus.t2c"
output="$results_dir/tgrep2/output/nt.txt"
result="$results_dir/tgrep2/results/nt.txt"

before_time=$(date +%s%N)
$tgrep2 -l -c $corpus '/^NP$/' > $output
after_time=$(date +%s%N)
elapsed_time=$(expr $after_time - $before_time)

echo "START: $before_time ns, END: $after_time ns, TOTAL: $elapsed_time ns" > $result

