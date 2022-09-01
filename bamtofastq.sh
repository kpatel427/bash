#!/usr/bin/bash
#SBATCH --job-name=WGSbamtofastq
#SBATCH --cpus-per-task=2
#SBATCH -a 1-19
#SBATCH --mem=256G
#SBATCH -t 96:00:00

function bamtofastq () {

  args=("$@")

  echo Number of arguments: $#
  echo 1st argument: ${args[0]}
  echo 2nd argument: ${args[1]}

  name=$(basename ${1})
  filename="${name%.*}"


    echo "Processing filename = $filename..."
    echo ""

    echo "Sorting BAMs by name..."
    samtools sort -n /path/to/bam/${args[0]} -o /path/to/bam/${args[0]}.sortedbyName.bam    

    echo "Getting fastqs from sorted BAMs..."
    bedtools bamtofastq -i /path/to/bam/${args[0]}.sortedbyName.bam  \
                      -fq /path/to/output/folder/${args[1]}_R1.fastq \
                      -fq2 /path/to/output/folder/${args[1]}_R2.fastq


    echo "Removing sorted file to save space..."
    rm /path/to/bam/${args[0]}.sortedbyName.bam

    echo "gzip fastqs..."
    gzip /path/to/output/folder/${args[1]}_R1.fastq
    gzip /path/to/output/folder/${args[1]}_R2.fastq


}


IFS=$'\n' read -d '' -r -a arr < ~/projectfolder/normal_sample_ID_name.mapping.txt
bamtofastq ${arr[$SLURM_ARRAY_TASK_ID-1]}
echo "Done!"

