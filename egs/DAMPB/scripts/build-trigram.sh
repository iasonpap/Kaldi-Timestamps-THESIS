#!/bin/bash

# Copyright 2017  Speech Lab, EE Dept., IITM (Author: Srinivas Venkattaramanujam)

. ./path.sh
. ./longaudio_vars.sh
working_dir=$1
input_file=$2
if [ -f "${working_dir}/lm.gz" ]; then
	rm -v ${working_dir}/lm.gz
	rm -v ${working_dir}/lm.arpa.gz
fi
echo "building LM"
build-lm.sh -i $input_file -o $working_dir/lm.gz -n 3
echo "compiling LM"
compile-lm $working_dir/lm.gz -t=yes /dev/stdout | grep -v unk | gzip -c > $working_dir/lm.arpa.gz

gunzip -c $working_dir/lm.arpa.gz | arpa2fst --disambig-symbol='#0' --read-symbol-table=$lang_dir/words.txt - $lang_dir/G.fst

