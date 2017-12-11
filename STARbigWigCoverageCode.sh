#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./STARCodeGenerator.sh testFolderPath mm9 30
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

STARdate=$(date +"%y%m%d")

echo '' > bedgraph$STARdate.condor
printf '''
universe=vanilla
log=bedgraph-star-$(Process).log
output=bedgraph-star-$(Process).out
error=bedgraph-star-$(Process).err

STAR_DIR=/woldlab/castor/proj/programs/STAR-2.5.2a/bin/Linux_x86_64/

request_cpus = 1
request_memory = 4G

executable=$(STAR_DIR)STAR
transfer_executable=false
should_transfer_files=IF_NEEDED

#should_transfer_files=Always
#when_to_transfer_output=ON_EXIT
#transfer_input_files=/woldlab/castor/home/phe/programs/SamtoolsSort.sh

''' >> bedgraph$STARdate.condor

while read path
    do
        echo -e 'arguments="--runMode inputAlignmentsFromBAM' \
        '--inputBAMfile '$path'.'$2'.'$3'merAligned.sortedByCoord.out.bam ' \
        '--outWigType bedGraph' \
        '--outWigStrand Unstranded' \
        '--outWigReferencesPrefix chr' \
        '"\nqueue\n' >> bedgraph$STARdate.condor
#echo -e '+PostCmd="SamtoolsSort.sh"\n+PostArguments="'$path'.'$2'.'$3'merAligned.toTranscriptome.out.bam"\nqueue\n'>> bedgraph$STARdate.condor
    done <$1