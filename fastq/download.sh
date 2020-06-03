#!/usr/bin/env bash

set -e -o pipefail

echo "Downloading $(tail -n +2 ../ena_manifest.txt|wc -l) fastq files from ENA..."
tail -n +2 ../ena_manifest.txt | cut -f 7,8 | while read l; do

    url=$(echo $l|cut -f 1 -d\  )
    orig_url=$(echo $l|cut -f 2 -d\  )
    echo "$url -> $(basename $orig_url)"
    wget -c $url -O $(basename $orig_url) &> $O.log
done
exit 0
