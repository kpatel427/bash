#!/usr/bin/bash
#SBATCH --job-name=QC
#SBATCH --cpus-per-task=2
#SBATCH -a 1-75
#SBATCH --mem=128G
#SBATCH -t 96:00:00

SECONDS=0
dir="~/WGS/BAM/bwa"


function runQC () {

	name=$(basename ${1})
	filename="${name%.*}"

	echo "filename = $filename"

	name=$(echo $filename | sed s/.readgroup.sorted//)
	echo $name

	# samtools flagstat
	echo "Running samtools flagstat..."
	samtools flagstat ${dir}/${name}.readgroup.sorted.bam > ~/KP/QC/${name}_merged_flagstat.txt

	# Picard CollectInsertSizeMetrics
	echo "Running CollectInsertSizeMetrics..."
	java -jar ~/apps/picard.jar CollectInsertSizeMetrics I=${dir}/${name}.readgroup.sorted.bam O=~/KP/QC/${name}_insert_size_metrics.txt H=~/KP/QC/${name}_insert_size_metrics.pdf

	# Picard CollectAlignmentSummaryMetrics
	echo "Running CollectAlignmentSummaryMetrics..."
	java -jar ~/apps/picard.jar CollectAlignmentSummaryMetrics I=${dir}/${name}.readgroup.sorted.bam O=~/KP/QC/${name}_alignment_metrics.txt R=~/KP/hg19/hg38.fa

	#Picard CollectGcBiasMetrics
	#WGS only
	echo "Running CollectGcBiasMetrics..."
	java -jar ~/apps/picard.jar CollectGcBiasMetrics I=${dir}/${name}.readgroup.sorted.bam O=~/KP/QC/${name}_merged_gc_bias_metrics.txt R=~/KP/hg19/hg38.fa CHART=~/KP/QC/${name}_merged_gc_bias_metrics.pdf S=~/KP/QC/${name}_merged_gc_bias_summary.txt

	# fastqc
	echo "Running fastqc..."
	fastqc -t 8 ${dir}/${name}.readgroup.sorted.bam -o ~/KP/QC/


	duration=$SECONDS
	echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."


}


IFS=$'\n' read -d '' -r -a arr < tumors.txt

# calling function and assigning jobs from arrays to cluster
runQC ${arr[$SLURM_ARRAY_TASK_ID-1]}
