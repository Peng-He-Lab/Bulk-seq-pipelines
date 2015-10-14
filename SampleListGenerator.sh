#!/bin/bash
#SampleListGenerator.sh input output
echo '' > $2
while read line
    do
        if [$(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | wc -l) != 0 ]
            then
                echo -n $line' ' >> $2
                wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/library/$line/ -q -O - | grep 'libns:flowcell" resource="' | cut -d/ -f3 > Flowcell
                while read Flow
                    do
                        folder=$(grep $Flow index.html | grep -v $Flow"_temp" | cut -d"\"" -f8)
                        if [$(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox/$folder"Unaligned/" -q -O - | grep $line | wc -l) == 0 ]
                            then continue
                        else
                            project=$(wget --user=gec --password=gecilluminadata --no-check-certificate https://jumpgate.caltech.edu/runfolders/volvox/$folder"Unaligned/" -q -O - | grep $line | cut -d"\"" -f8)
                            echo https://jumpgate.caltech.edu/runfolders/volvox/$folder"Unaligned/"$project"Sample_"$line"/" >> $2
                        fi
                    done<Flowcell
        else
            printf $line" no Flowcells found\n"
        fi
    done <$1