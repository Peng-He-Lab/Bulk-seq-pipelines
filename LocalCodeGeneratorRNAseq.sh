#!/bin/bash
#Run these codes in the current SERVER directory
#the files must be fastq files, no compressed forms allowed
#the file $test has two columns, Full Location Path and name, only one space allowed
#each experiment folder contains a set of fastq files belonging to the same library
# for example: /woldlab/castor/home/phe/ChIPseq   test1
#delete the testFolderPath file
#it generates three files: bowtieXXXXXX testcode & testFolderPath
#usage: ~/programs/GECCodeGeneratorATAC.sh test mm9 36

echo '' > testcode
CurrentLo=$(pwd)
source /woldlab/castor/home/phe/programs/GenomeDefinitions.sh $2

source /woldlab/castor/home/phe/programs/Localrefolder.sh

/woldlab/castor/home/phe/programs/TophatCodeGenerator.sh testFolderPath $2 $3

/woldlab/castor/home/phe/programs/RNAseQC.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TophatbigWigCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/CufflinksCode.sh testFolderPath $2 $3"mer"

/woldlab/castor/home/phe/programs/TrackSummary.sh bigWig

/woldlab/castor/home/phe/programs/TophatCufflinksStats.sh testFolderPath $2 $3

