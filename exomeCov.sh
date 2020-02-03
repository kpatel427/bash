#!/usr/bin/bash
#$ -j y
#$ -V
#$ -l m_mem_free=32G,h_vmem=64G
#$ -pe smp 1
#$ -cwd

# script extracts regions of interest specified in a bed file, from bam file
# samtools and bedtools are used to calculate depth of coverage for the regions extracted
# results in a ROI_bam file, and two text files with results from samtools and bedtools respectively
# all the processes run in parallel

function back_ground_process () {
	# fetch regions of interest from BAM files to speed up the process
	samtools view -bh /path/to/bam/${1}.sorted.reheader.bam -L allExons.bed > ROI_bams/${1}_regionofinterest.bam

	# Calculate average exome coverage
	samtools depth -b allExons.bed ROI_bams/${1}_regionofinterest.bam | awk '{sum+=$3} END { print "Average = ",sum/NR}' >> ${1}_samtools_exomCoverage.txt

	# output the mean depth of coverage for each region in the BED file
	bedtools coverage -a allExons.bed -b ROI_bams/${1}_regionofinterest.bam -mean >> ${1}_bedtools_exomCoverage.txt
	awk '{sum+=$4} END { print  "'$1' Average = ",sum/NR}' ${1}_bedtools_exomCoverage.txt >> exomeCov_bedtools.txt
	echo "${1} done!"
}

# array in shell script
arr=("CHLA15_NoIndex_L002" "CHLA20_CTTGTA_L006" "CHP134_NoIndex_L006" "COGN415_NoIndex_L003" "COGN426_NoIndex_L004" "IMR5_NoIndex_L007" "Kelly_NoIndex_L008" "LAN5_CAGATC_L001" "NB1691_ACTTGA_L002" "NB1_GGCTAC_L005" "NB69_NoIndex_L008" "NBEBc1_GATCAG_L003" "NBLS_NoIndex_L007" "NBSD_TAGCTT_L004" "NGP_NoIndex_L008" "NLF_NoIndex_L001" "SKNAS_NoIndex_L002" "SKNBE1_NoIndex_L006" "SKNBE2C_NoIndex_L005" "SKNBE2_NoIndex_L003" "SKNDZ_NoIndex_L004" "SKNFI_NoIndex_L006" "SKNKAN_NoIndex_L008" "SKNKANR_NoIndex_L007" "SKNSH_NoIndex_L007" "XNB20_NoIndex_L005")

# @ means all elements in array
for i in ${arr[@]}; do
    # run back_ground_process function in background
    # pass element of array as argument
    # make log file
    back_ground_process $i > ~/KP/ExomeDepth/log_${i}.txt &
done


# wait until all child processes are done
wait

echo "All background processes are done!"
