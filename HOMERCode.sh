#!/bin/bash
#Run these codes in the current SERVER directory
#the testFolderPath file contains the paths
#usage: ~/programs/eRangeCode.sh testFolderPath mm9 36mer

echo '' >> testcodeHOMER
CurrentLo=$(pwd)
source ~/programs/GenomeDefinitions.sh $2

echo "#!/bin/bash" >> testcodeHOMER
echo "#HOMER prepare reads, Peak calling and convert to bed(no score) codes:" >> testcodeHOMER
echo "#*****************" >> testcodeHOMER

echo "export PATH=/woldlab/castor/home/phe/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/woldlab/castor/proj/programs/weblogo:/woldlab/castor/proj/programs/x86_64/blat/:/woldlab/castor/proj/programs/homer-4.7/bin" >> testcodeHOMER

while read line
    do
        printf "condor_run -a request_memory=20000 \" /woldlab/castor/proj/programs/homer-4.7/bin/makeTagDirectory "$line"."$2"."$3"HomerTags "$line"."$2"."$3".unique.nochrM.bam \" && " >> testcodeHOMER
        printf "condor_run -a request_memory=20000 \"/woldlab/castor/proj/programs/homer-4.7/bin/findPeaks "$line"."$2"."$3"HomerTags -localSize 50000 -minDist 50 -size 150 -fragLength 0 -o "$line"."$2"."$3"lS50000mD50s150fL0 2> "$line"."$2"."$3"lS50000mD50s150fL0.err \" && " >> testcodeHOMER
        printf "grep 000 "$line"."$2"."$3"lS50000mD50s150fL0 | grep chr - | grep -v = | awk '{print \$2\"\\\t\"\$3\"\\\t\"\$4\"\\\t\"\$1\"\\\t225\\\t\"\$5}' - | sort -k 1d,1 -k 2n,2 > "$line"."$2"."$3"lS50000mD50s150fL0.whole.bed && " >> testcodeHOMER
        printf "intersectBed -a "$line"."$2"."$3"lS50000mD50s150fL0.whole.bed -b "$mitoblack" -v | intersectBed -a - -b "$blacklist" -v > "$line"."$2"."$3"lS50000mD50s150fL0.bed && " >> testcodeHOMER
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0.bigBed && " >> testcodeHOMER
        printf "/woldlab/castor/proj/programs/x86_64/bedToBigBed "$line"."$2"."$3"lS50000mD50s150fL0.whole.bed "$chromsizes" "$line"."$2"."$3"lS50000mD50s150fL0.whole.bigBed && " >> testcodeHOMER
        printf "echo 'RiP:' \$(intersectBed -abam $line."$2"."$3".unique.dup.bam -b $line."$2"."$3"lS50000mD50s150fL0.bed | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c - ) > "$line"."$2"."$3".lS50000mD50s150fL0.stats && " >> testcodeHOMER
        printf "echo 'RiPwhole:' \$(intersectBed -abam $line."$2"."$3".unique.dup.bam -b $line."$2"."$3"lS50000mD50s150fL0.whole.bed | /woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c - ) >> "$line"."$2"."$3".lS50000mD50s150fL0.stats && " >> testcodeHOMER
        printf "echo 'RiChrM:' \$(/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c $line."$2"."$3".unique.dup.bam chrM ) >> "$line"."$2"."$3".lS50000mD50s150fL0.stats && " >> testcodeHOMER
        printf "echo 'Rtotal:' \$(/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools view -c $line."$2"."$3".unique.dup.bam ) >> "$line"."$2"."$3".lS50000mD50s150fL0.stats & \n" >> testcodeHOMER
    done <$1

chmod a+x testcodeHOMER




