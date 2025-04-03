# CellRanger-Pipeline
This script automates the process of downloading SRA (Sequence Read Archive) files, converting them to FASTQ format, and running the Cell Ranger count pipeline for scRNA-seq analysis. It processes multiple samples concurrently using SLURM job scheduling. The results, including BAM files and gene expression matrices, are stored in a specified output directory.

**Requirements**
Cell Ranger: v7.1.0 or higher
SRA Toolkit: v3.0.10 or higher

**SLURM:** 
For managing job execution on a high-performance cluster

Linux environment: With SLURM and necessary software installed
Input data: List of SRA IDs (sra_ids.txt) containing one SRA ID per line

**Script Explanation
SLURM Directives**
The following SLURM directives define the job's resources:

--job-name="Project_Name": Name of the job.
--mem=180G: Memory allocation for the job.
--mincpus=24: Minimum number of CPU cores required.
--time=78:00:00: Maximum time limit for the job.
--mail-user=email_id: Email address for job notifications.
--mail-type=BEGIN,END,FAIL: Notifications for job start, end, and failure.
--output="std-%j-%N.out" and --error="std-%j-%N.err": Output and error log files.


**Modules**
The script loads two essential modules:
cellranger/7.1.0: Cell Ranger version 7.1.0 is required to perform RNA-seq analysis.
sratoolkit/3.0.10: The SRA Toolkit is used to download and convert SRA files into FASTQ format.



**Variables**
SRA_ID_LIST="sra_ids.txt": Path to a text file containing the list of SRA IDs (one per line).
OUTPUT_DIR="cellranger_output": Directory to store output files.
CELLRANGER_REF="/path/to/refdata-gex-GRCh38-2020-A": Path to the reference genome used by Cell Ranger for alignment.
THREADS=24: Number of CPU threads to use during the processing of the data.



**Script Execution**
The script processes each SRA file as follows:
Download SRA file: The prefetch command is used to download the SRA files based on IDs in sra_ids.txt.
Convert SRA to FASTQ: The fasterq-dump command is used to convert the downloaded SRA files into FASTQ format. The FASTQ files are split into separate files for paired-end reads and stored in the specified output directory.



**Run Cell Ranger Count**
The cellranger count command is executed to perform scRNA-seq analysis. The following options are used:

--id="$SRA_ID": Unique identifier for the sample.
--transcriptome="$CELLRANGER_REF": Path to the reference genome.
--fastqs="$FASTQ_DIR": Directory containing the FASTQ files.
--sample="$SRA_ID": Sample name for the Cell Ranger run.
--create-bam=true: Generates BAM files in addition to other output files.
--localcores="$THREADS": Number of CPU cores to use.
--output-dir="$OUTPUT_DIR/$SRA_ID": Directory for storing results specific to each sample.



**Move Results** 
After processing, the sample directory containing the output files is moved into the OUTPUT_DIR.



**Output**
The results for each sample will be stored in the cellranger_output directory. 

