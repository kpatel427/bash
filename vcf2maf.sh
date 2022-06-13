#!/usr/bin/bash

# change dir
echo "Changing directory"
cd ~/KP/mutations

# activate envir
echo "activating envir"
source activate vep


# read into an array
IFS=$'\n' read -d '' -r -a arr < ~/KP/mutations/vcfs/vcf_list.txt


# execute command to convert to maf
for i in ${arr[@]}; 
do
	name=$(basename ${i})
	filename="${name%.*}"

	echo "Processing $i..."

	perl mskcc-vcf2maf-bbe39fe/vcf2maf.pl \
	--input-vcf vcfs/$i \
	--output-maf mafs/$i.maf \
	--tumor-id ${filename} \
	--ref-fasta ~/.vep/homo_sapiens/95_GRCh37/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa \
	--vep-path ~/miniconda3/envs/vep/bin/
done
