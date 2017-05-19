#!/bin/bash

csv_file=$1
search_str=$2

if [ $# -ne 2 ]; then
    echo Insufficient arguments: $0 input.csv string_to_search
    exit
fi

if [ ! -f $csv_file ]; then
    echo "$csv_file not Found"
    exit
fi

header_str=`head -1 $csv_file | cut -d, -f 1`
num_col=`head -1 $csv_file | xargs -d"," -n 1| grep -v "^$" |wc -l`

match_str=`cat $csv_file  | grep "$search_str\|^$header_str" |head -2 | sed 's/\"/\\\"/g' | sed 's/\ /\\\ /g'`
for idx in `seq 1 $num_col`; do echo $match_str | xargs -n 1 |awk -v idx2=$idx -F',' '{ print $idx2 }'; done | xargs -n 2 | less -N

# Slow implementation
# for idx in `seq 1 $num_col`; do cat $csv_file  | grep "$search_str\|^$header_str" |head -2 |awk -v idx2=$idx -F',' '{ print $idx2 }'; done | xargs -n 2 | less -N

# String output to run directly
#echo "for idx in \`seq 1 $((num_col))\`; do cat $csv_file  | grep --line-buffered \"$search_str|^$header_str\" |head -2 | awk -v idx2=\$idx -F',' '{ print \$idx2 }'; done | xargs -n 2 |less -N"

