#!/usr/bin/bash
#$ -j y
#$ -V
#$ -t 1-4
#$ -l m_mem_free=8G,h_vmem=8G
#$ -pe smp 4
#$ -cwd




input=("bill" "ted" "lisa" "42")

function echoMe {
    echo "Hello $1 from job $SGE_TASK_ID" # $SGE_TASK_ID = index value & $1 takes array value
    sleep 30
    exit 0
}

echoMe ${input[$SGE_TASK_ID-1]} # as $SGE_TASK_ID starts from 1 and bash array index starts from 0
