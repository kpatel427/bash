#!/usr/bin/bash
# script to iterate through a list of bam files and get average depth in the region of interest using samtools depth
# results in a text file with average depth for each bam file

while read p; do
  echo "samtools depth -r chr2:16080559-16087129 /path/to/bam/${p}.sorted.reheader.bam  |  awk '{sum+=$3} END { print "$p Average = ",sum/NR}' >> depths.txt"
  samtools depth -r chr2:16080559-16087129 /path/to/bam/${p}.sorted.reheader.bam  |  awk '{sum+=$3} END { print  "'$p' Average = ",sum/NR}' >> depths.txt
  echo "done - $p"
done </path/to/bam/bamFileNames.txt
