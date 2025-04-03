# CellRanger-Pipeline
This script automates the process of downloading SRA files, converting them to FASTQ format, and running the Cell Ranger count pipeline for RNA-seq analysis. It processes multiple samples concurrently using SLURM job scheduling. The results, including BAM files and gene expression matrices, are stored in a specified output directory.
