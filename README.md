# Code generator instructions
* This is a set of scripts to generate command-line scripts to handle sequencing data (the codes to write [codes](https://github.com/brianpenghe/Luo_2021_piRNA))
* It generates codes to download data from Igor's website and codes for sequencing analysis

## [smallRNA-seq for Luo et al.](smallRNA-seq.md)
* downloading, trimming, genome mapping, vector mapping, bin calculation, ping-pong analyses etc.
* more information about the generated code can be found [here](piRNA-seq.md)
## [totalRNA-seq/RIP-seq for Luo et al.](totalRNA-seq__OR__RIP.md)
* downloading, trimming, rRNA removal, transcriptome mapping, vector mapping, bin calculation, phasing etc.
## [polyA-RNA-seq]()
* downloading, trimming, transcriptome mapping, FPKM/TPM calculation, track generation etc.
## [ATAC-seq]()
* downloading, trimming, genome mapping, normalization, peak calling, track generation etc. 
## [4C-seq]()

## [ChIP-seq for Luo et al.](ChIP-seq.md)


# Pipeline modification instructions

<details>
  <summary><b>&nbsp&nbsp1. Construct bowtie indices</b></summary>
  
### 1.1 Open the sequence files using snapgene etc. and save as .fasta (.fa) files
### 1.2 Copy the .fasta files to `~phe/genomes/YichengVector/`
### 1.3 Run `/woldlab/castor/proj/genome/programs/bowtie-0.12.7/bowtie-build -f 2kbCirceSDGFPalldel.fa 2kbCirceSDGFPalldel`
</details>

<details>
  <summary><b>&nbsp&nbsp2. Add the vectors in the</b></summary>
  
###  [RNA bowtie code](BowtieYichengCodeGeneratorRNA.sh) or [smallRNA bowtie code](BowtieYichengCodeGeneratorsmallRNA.sh)
</details>
