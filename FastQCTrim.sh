#!/bin/bash
#this script is part of the refolder scripts which trims reads and runs fastQC
#FastQCTrim.sh PE $path 30
#FastQCTrim.sh PE $path 0
#FastQCTrim.sh PE $path 0 23 29
if [[ "$1" == "PE" ]]
    then
        printf "cat "$2"*R1.fastq > "$2"R1all.fastq && " >> testcode
        printf "cat "$2"*R2.fastq > "$2"R2all.fastq && " >> testcode
        printf "mkdir -p "$2"FastQCk6R1 && " >> testcode
        printf "mkdir -p "$2"FastQCk6R2 && " >> testcode
        printf "mkdir -p "$2"FastQCk6 && " >> testcode
        printf "mkdir -p "$2"FastQCk6/Unique && " >> testcode
        printf "mkdir -p "$2"FastQCk6/Multi && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1all.fastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2all.fastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R1all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - | ~/.local/bin/cutadapt -a GAAGAGCACACGTCTGAACTCC - > "$2"R1trimmedfastq && " >> testcode
        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R2all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - > "$2"R2trimmedfastq && " >> testcode
#        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R1all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - | ~/.local/bin/cutadapt -a GAAGAGCACACGTCTGAACTCC - > "$2"R1allpairedfastq && " >> testcode
#        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"R2all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - > "$2"R2allpairedfastq && " >> testcode
        printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar PE -threads 4 -trimlog "$2"trimmomatic.log "$2"R1trimmedfastq "$2"R2trimmedfastq "$2"R1allpairedfastq "$2"R1allunpairedfastq "$2"R2allpairedfastq "$2"R2allunpairedfastq ILLUMINACLIP:/woldlab/castor/home/phe/genomes/AllAdaptors.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:"$(($3==0?20:$3))" && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allpairedfastq -o "$2"FastQCk6R1 -k 6 && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allpairedfastq -o "$2"FastQCk6R2 -k 6 && " >> testcode
        if [[ "$3" == "0" ]]
            then
                if [ -z "$4" ]
                    then
                        printf "mv "$2"R1allpairedfastq "$2"R1allfastq"$3" && " >> testcode
                        printf "mv "$2"R2allpairedfastq "$2"R2allfastq"$3" && " >> testcode
                else
                    printf "cat "$2"R1allpairedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= "$4" && length(\$2) <= "$5"' | sed 's/\\\t/\\\n/g' > "$2"R1allfastq"$4"_"$5" && " >> testcode
                    printf "cat "$2"R2allpairedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= "$4" && length(\$2) <= "$5"' | sed 's/\\\t/\\\n/g' > "$2"R2allfastq"$4"_"$5" && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allfastq"$4"_"$5" -o "$2"FastQCk6R1 -k 6 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allfastq"$4"_"$5" -o "$2"FastQCk6R2 -k 6 && " >> testcode
                    printf "cat "$2"R1allpairedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= 21 && length(\$2) <= 21' | sed 's/\\\t/\\\n/g' > "$2"R1allfastq21_21 && " >> testcode
                    printf "cat "$2"R2allpairedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= "$4" && length(\$2) <= 21' | sed 's/\\\t/\\\n/g' > "$2"R2allfastq21_21 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R1allfastq21_21 -o "$2"FastQCk6R1 -k 6 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"R2allfastq21_21 -o "$2"FastQCk6R2 -k 6 && " >> testcode
                fi
        else
 #          printf "python2 /woldlab/castor/home/georgi/code/trimfastq.py "$2"R1allpairedfastq "$3" -stdout > "$2"R1allfastq"$3" && " >> testcode
 #          printf "python2 /woldlab/castor/home/georgi/code/trimfastq.py "$2"R2allpairedfastq "$3" -stdout > "$2"R2allfastq"$3" && " >> testcode
            printf "mv "$2"R1allpairedfastq "$2"R1allfastq"$3" && " >> testcode
            printf "mv "$2"R2allpairedfastq "$2"R2allfastq"$3" && " >> testcode
        fi
elif [[ "$1" == "SE" ]]
    then
        printf "cat "$2"*.fastq > "$2"all.fastq && " >> testcode
        printf "mkdir -p "$2"FastQCk6 && " >> testcode
        printf "mkdir -p "$2"FastQCk6/Unique && " >> testcode
        printf "mkdir -p "$2"FastQCk6/Multi && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"all.fastq -o "$2"FastQCk6 -k 6 && " >> testcode
        printf "~/.local/bin/cutadapt -a CTGTCTCTTATACAC "$2"all.fastq | ~/.local/bin/cutadapt -a CGTATGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g TGCCGTCTTCTGCTTG - | ~/.local/bin/cutadapt -g GGTAACTTTGTGTTT - | ~/.local/bin/cutadapt -g CTTTGTGTTTGA - | ~/.local/bin/cutadapt -a CACTCGTCGGCAGCGTTAGATGTGTATAAG - > "$2"alltrimmedfastq && " >> testcode
#        printf "java -jar /woldlab/castor/proj/programs/Trimmomatic-0.33/trimmomatic-0.33.jar SE -threads 4 -trimlog "$2"trimmomatic.log "$2"trimmedfastq "$2"alltrimmedfastq ILLUMINACLIP:/woldlab/castor/home/phe/genomes/AllAdaptors.fa:2:30:10 MAXINFO:35:0.9 MINLEN:"$(($3==0?20:$3))" && " >> testcode
        printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"alltrimmedfastq -o "$2"FastQCk6 -k 6 && " >> testcode
        if [[ "$3" == "0" ]]
            then
                if [ -z "$4" ]
                    then
                        printf "mv "$2"alltrimmedfastq "$2"allfastq"$3" && " >> testcode
                else
                    printf "cat "$2"alltrimmedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= "$4" && length(\$2) <= "$5"' | sed 's/\\\t/\\\n/g' > "$2"allfastq"$4"_"$5" && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"allfastq"$4"_"$5" -o "$2"FastQCk6 -k 6 && " >> testcode
                    printf "cat "$2"alltrimmedfastq | paste - - - - | awk -F\"\\\t\" 'length(\$2) >= 21 && length(\$2) <= 22' | sed 's/\\\t/\\\n/g' > "$2"allfastq21_22 && " >> testcode
                    printf "/woldlab/castor/proj/programs/FastQC-0.11.3/fastqc "$2"allfastq21_22 -o "$2"FastQCk6 -k 6 && " >> testcode
                fi
        else
            printf "python2 /woldlab/castor/home/georgi/code/trimfastq.py "$2"alltrimmedfastq "$3" -stdout > "$2"allfastq"$3" && " >> testcode
        fi
else
    echo $4
    printf "single end(SE) or paired end(PE)?"
    exit 1
fi
printf "rm "$2"*fastq & \n" >> testcode

