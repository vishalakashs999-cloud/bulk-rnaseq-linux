# Bulk RNA-seq Analysis Using Linux

## Project Overview

This repository documents a command-line RNA-seq analysis workflow performed in a Linux environment using publicly available sequencing data.

The documented sample is **SRR032238**. Its relationship to GEO accession GSE29158 requires confirmation before the analysis can be attributed to that study.

## Bioinformatics Tools

- SRA Toolkit — sequencing data retrieval
- FastQC — sequencing quality assessment
- Trim Galore — adapter and quality trimming
- HISAT2 v2.2.1 — read alignment
- SAMtools v1.19.2 — alignment file processing
- featureCounts v2.0.6 — gene-level read quantification

## Analysis Workflow

1. Retrieved sequencing reads using SRA Toolkit.
2. Evaluated raw read quality with FastQC.
3. Performed quality trimming using Trim Galore with a Phred quality threshold of 30 and minimum read length of 20 bases.
4. Assessed trimmed reads using FastQC.
5. Aligned trimmed reads using HISAT2 with a human reference index.
6. Converted SAM to BAM and sorted the alignment file using SAMtools.
7. Quantified exon-overlapping reads at the gene level using featureCounts with GRCh38.p14 gene annotation.

## Alignment Results

| Metric | Result |
| Total alignment records | 35,887,970 |
| Primary alignment records | 21,608,989 |
| Primary mapped records | 20,234,890 |
| Primary mapping rate | 93.64% |
| Secondary alignment records | 14,278,981 |
| Overall mapped alignment records | 34,513,871 |

The alignment statistics were obtained using `samtools flagstat` on `RNA_correctsorted.bam`. Secondary alignments are included in the total alignment-record count.

## Repository Outputs

- `SRR032238_fastqc.html` — raw sequencing QC report
- `SRR032238_trimmed_fastqc.html` — post-trimming QC report
- `correctedgenecount.txt.summary` — featureCounts assignment statistics

## Technical Skills Demonstrated

Linux command-line analysis, sequencing quality control, read trimming, reference-based alignment, BAM processing, and gene-level RNA-seq quantification.

## Reproducibility Notes

This repository documents commands and outputs from an existing analysis. The original HISAT2 index construction and accession-to-study relationship have not yet been independently verified. Large FASTQ and BAM files are not included in the repository.
