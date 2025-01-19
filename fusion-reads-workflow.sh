#!/bin/bash

# Vector-Genome Fusion Reads Analysis Pipeline
# This script automates the three rounds of mapping to identify vector-genome fusion reads

# Exit on error
set -e

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is required but not installed."
        exit 1
    fi
}

# Define paths
BOWTIE="/woldlab/castor/proj/genome/programs/bowtie-1.0.1+hamrhein_nh_patch/bowtie"
SAMTOOLS="/woldlab/castor/proj/programs/samtools-0.1.16/bin/samtools"

# Check if executables exist at specified paths
if [ ! -x "$BOWTIE" ]; then
    echo "Error: bowtie not found at $BOWTIE or not executable"
    exit 1
fi

if [ ! -x "$SAMTOOLS" ]; then
    echo "Error: samtools not found at $SAMTOOLS or not executable"
    exit 1
fi

# Check required commands
check_command "python2"

# Input validation
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <input_fastq> <vector_index> <genome_index> <output_prefix>"
    echo "Example: $0 input.fastq Original_vector dm6 output"
    exit 1
fi

# Input parameters
INPUT_FASTQ=$1
VECTOR_INDEX=$2
GENOME_INDEX=$3
OUTPUT_PREFIX=$4

# Create output directory
mkdir -p "${OUTPUT_PREFIX}_output"
cd "${OUTPUT_PREFIX}_output"

echo "=== Starting Vector-Genome Fusion Reads Analysis ==="

# Round 1: Get reads containing vector sequences
echo "Round 1: Identifying reads with vector sequences..."

# Extract 20bp from 5' end
echo "Extracting 20bp from 5' end..."
python2 /woldlab/castor/home/georgi/code/trimfastq.py ../"$INPUT_FASTQ" 20 > 20fiveprime.fastq

# Map to vector and extract mapped reads
echo "Mapping to vector..."
"$BOWTIE" "$VECTOR_INDEX" -p 8 -v 2 -k 1 -t --sam-nh -y -q \
    --al alltrimmedVectorfastq 20fiveprime.fastq

# Retrieve original full length reads
echo "Retrieving full length reads..."
grep -f <(cat alltrimmedVectorfastq | paste - - - - | cut -f 1) \
    <(cat ../"$INPUT_FASTQ" | sed 's/ /_/g' | paste - - - - ) | \
    tr "\t" "\n" > alltrimmedVectorFullLengthfastq

# Round 2: Filter out pure vector reads
echo "Round 2: Filtering pure vector reads..."
"$BOWTIE" "$VECTOR_INDEX" -p 8 -v 2 -k 1 -t --sam-nh -y -q \
    --un alltrimmedVectorUnmapfastq alltrimmedVectorFullLengthfastq

# Round 3: Identify genome sequences
echo "Round 3: Identifying genome sequences..."

# Extract 20bp from 3' end
echo "Extracting 20bp from 3' end..."
paste <(cat alltrimmedVectorUnmapfastq | paste - - | cut -f1 | tr "\t" "\n") \
    <(cat alltrimmedVectorUnmapfastq | paste - - | cut -f2 | tr "\t" "\n" | \
    grep -o '.\{20\}$' ) | tr "\t" "\n" > 20threeprime.fastq

# Map to genome and create sorted BAM
echo "Mapping to genome and creating BAM file..."
"$BOWTIE" "$GENOME_INDEX" -p 8 -v 0 -k 1 -m 1 -t --sam-nh --best --strata -y -q \
    --sam 20threeprime.fastq | \
    "$SAMTOOLS" view -bT "$GENOME_INDEX.fa" - | \
    "$SAMTOOLS" sort - "${OUTPUT_PREFIX}.20threeprime.dm6"

# Index BAM file
echo "Indexing BAM file..."
"$SAMTOOLS" index "${OUTPUT_PREFIX}.20threeprime.dm6.bam"

# Generate summary statistics
echo "Generating summary statistics..."
echo "Initial reads: $(expr $(cat "$INPUT_FASTQ" | wc -l) / 4)" > "${OUTPUT_PREFIX}_statistics.txt"
echo "Reads with vector (5'): $(expr $(cat alltrimmedVectorfastq | wc -l) / 4)" >> "${OUTPUT_PREFIX}_statistics.txt"
echo "Reads after vector filtering: $(expr $(cat alltrimmedVectorUnmapfastq | wc -l) / 4)" >> "${OUTPUT_PREFIX}_statistics.txt"
echo "Final fusion reads: $("$SAMTOOLS" view -c "${OUTPUT_PREFIX}.20threeprime.dm6.bam")" >> "${OUTPUT_PREFIX}_statistics.txt"

echo "=== Analysis Complete ==="
echo "Results can be found in ${OUTPUT_PREFIX}_output directory"
echo "BAM file: ${OUTPUT_PREFIX}.20threeprime.dm6.bam"
echo "Statistics file: ${OUTPUT_PREFIX}_statistics.txt"
