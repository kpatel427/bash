#!/usr/bin/bash

#echo "Hello!"

while read p; do
  echo "samtools depth -r chr2:16080559-16087129 /mnt/isilon/maris_lab/target_nbl_ngs/CellLineExome/aligned_2019/${p}.sorted.reheader.bam  |  awk '{sum+=$3} END { print "$p Average = ",sum/NR}' >> mycn_depths.txt"
  samtools depth -r chr2:16080559-16087129 /mnt/isilon/maris_lab/target_nbl_ngs/CellLineExome/aligned_2019/${p}.sorted.reheader.bam  |  awk '{sum+=$3} END { print  "'$p' Average = ",sum/NR}' >> mycn_depths.txt
  echo "done - $p"
done </mnt/isilon/maris_lab/target_nbl_ngs/CellLineExome/aligned_2019/SampleNames.txt
