#!/bin/bash
#Run these codes in the current SERVER directory
#the file $test has two columns, link and name, only one space allowed

#usage: ./STARCodeGenerator.sh testFolderPath mm9 30 PE
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

STARdate=$(date +"%y%m%d")

echo '' > STAR$STARdate.condor
printf '''
universe=vanilla
log=align-star-$(Process).log
output=align-star-$(Process).out
error=align-star-$(Process).err

STAR_DIR=/woldlab/castor/proj/programs/STAR-2.5.2a/bin/Linux_x86_64/

request_cpus = 8
request_memory = 30G
request_disk = 60G

executable=$(STAR_DIR)STAR
transfer_executable=false
should_transfer_files=IF_NEEDED

''' >> STAR$STARdate.condor

while read path
    do
        if [[ "$4" == "PE" ]]
            then
                READ1=$(echo $path"R1allfastq"$3)
                READ2=$(echo $path"R2allfastq"$3)
                EXTRA_ARGS=""
        elif [[ "$4" == "SE" ]]
            then
                READ1=$(echo $path"allfastq"$3)
                READ2=""
                EXTRA_ARGS="--outSAMstrandField intronMotif"
        fi
        echo -e 'arguments="--genomeDir' $STARDir \
            '--readFilesIn' $READ1 $READ2 \
            '--runThreadN' 8 \
            '--genomeLoad NoSharedMemory' \
            '--outFilterMultimapNmax 20' \
            '--alignSJoverhangMin 8' \
            '--alignSJDBoverhangMin 1' \
            '--outFilterMismatchNmax 999' \
            '--outFilterMismatchNoverReadLmax 0.04' \
            '--alignIntronMin 20' \
            '--alignIntronMax 1000000' \
            '--alignMatesGapMax 1000000' \
            '--outSAMheaderCommentFile COfile.txt' \
            '--outSAMheaderHD @HD VN:1.4 SO:coordinate' \
            '--outSAMunmapped Within' \
            '--outFilterType BySJout' \
            '--outSAMattributes NH HI AS NM MD' \
            '--outSAMtype BAM SortedByCoordinate' \
            '--quantMode TranscriptomeSAM GeneCounts' \
            '--sjdbScore 1' \
            '--limitBAMsortRAM 30000000000' \
            "--outFileNamePrefix "$path"."$2"."$3"mer" \
            $EXTRA_ARGS \
            '"\nqueue\n' >> STAR$STARdate.condor
    done <$1