
#!/usr/bin/env bash

# Human RNA-seq analysis: SRR032238
# Historical workflow reconstructed from Linux command
# history, BAM metadata and featureCounts output.
#
# Documentation only: not a validated end-to-end script.
# Do not execute as a single automated pipeline.

# STEP 1: Download FASTQ data
prefetch SRR032238
fasterq-dump SRR032238 --threads 2 --progress

# STEP 2: Raw read quality control
fastqc SRR032238.fastq

# STEP 3: Quality trimming
trim_galore --quality 30 --length 20 --cores 2 \
  SRR032238.fastq

# STEP 4: Post-trimming quality control
fastqc SRR032238_trimmed.fq


# STEP 5: Bowtie2 reference-filtering experiment
# This was attempted during workflow development.
# The reference below is NOT rRNA-specific.
# Therefore, this is NOT validated rRNA depletion.
#
# The filtering output was not used as input to
# the documented final HISAT2 alignment.

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_rna_from_genomic.fna.gz

gunzip GCF_000001405.40_GRCh38.p14_rna_from_genomic.fna.gz

bowtie2-build \
  GCF_000001405.40_GRCh38.p14_rna_from_genomic.fna \
  rRNA_index

# A Bowtie2 filtering command was previously attempted
# using a different RNA reference.
# It is retained here as historical documentation:
#
# bowtie2 -x rRNA_index \
#   -U SRR032238_trimmed.fq \
#   --un rRNA_filtered.fastq \
#   -S discarded_rRNA.sam


# STEP 6: HISAT2 alignment
# Requires pre-built human_index.
# Original index-building command not recovered.

hisat2 -p 2 --dta \
  -x human_index \
  -S RNAseq_corrected.sam \
  -U SRR032238_trimmed.fq


# STEP 7: Convert SAM to BAM
samtools view -S -b \
  RNAseq_corrected.sam > RNA_correctedseqal.bam


# STEP 8: Sort BAM
samtools sort \
  -o RNA_correctsorted.bam \
  RNA_correctedseqal.bam


# STEP 9: Gene-level quantification
# Requires the GRCh38.p14 genomic GTF annotation.

featureCounts -T 2 \
  -a GCF_000001405.40_GRCh38.p14_genomic.gtf \
  -o correctedgenecount.txt \
  -t exon \
  -g gene_id \
  RNA_correctsorted.bam


# STEP 10: Alignment statistics
samtools flagstat RNA_correctsorted.bam
