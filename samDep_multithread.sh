#!/usr/bin/bash
#$ -j y
#$ -V
#$ -t 1-222
#$ -l m_mem_free=16G,h_vmem=16G
#$ -pe smp 4
#$ -cwd

# script to run samtools depth for regions specified in bed file and running 222 samples in parallel on multiple threads

function back_ground_process () {
	name=$(basename ${1})
	filename="${name%.*}"
	dir=$(dirname ${1})

	cd ${dir}
	samtools depth -b ~/KP/ExomeDepth/patient/mycn_coord.bed ${name} | awk '{sum+=$3} END { print "Average '${name}'= ",sum/NR}' >> ~/KP/ExomeDepth/patient/${filename}_mycnCoverages.txt
	#samtools depth -b ~/KP/ExomeDepth/patient/mycn_coord.bed ${name} | awk '{sum+=$3} END { print "Average = ",sum/NR}' >> ~/KP/ExomeDepth/patient/${filename}_mycnCoverages.txt

	echo "$filename done!"
}


IFS=$'\n' read -d '' -r -a arr < target_bams.txt

# calling function and assigning jobs from arrays to cluster
back_ground_process ${arr[$SGE_TASK_ID-1]}
