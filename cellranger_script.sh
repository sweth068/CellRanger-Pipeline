#!/bin/bash

#SBATCH --job-name="Project_Name"

#SBATCH --mem=180G

#SBATCH --mincpus=24

#SBATCH --time=78:00:00

#SBATCH --mail-user=email_id

#SBATCH --mail-type=BEGIN

#SBATCH --mail-type=END

#SBATCH --mail-type=FAIL

#SBATCH --output="std-%j-%N.out"

#SBATCH --error="std-%j-%N.err"

#Load necessary modules

module load cellranger/7.1.0
module load sratoolkit/3.0.10


SRA_ID_LIST="sra_ids.txt"  #File containing list of SRA IDs, one per line

OUTPUT_DIR="cellranger_output"  #Output directory for Cell Ranger results

CELLRANGER_REF="/path/to/refdata-gex-GRCh38-2020-A"  #Path to Cell Ranger reference

THREADS=24  #Number of threads for processing



#Create necessary directories
mkdir -p "$OUTPUT_DIR"

#Download and process each SRA file
while read -r SRA_ID; do
    echo "Processing $SRA_ID..."
    
    #Download SRA file
    prefetch "$SRA_ID"
    
    #Convert SRA to FASTQ
    fasterq-dump "$SRA_ID" --split-files --outdir "$OUTPUT_DIR" --threads "$THREADS"
    
    #Define fastq paths
    FASTQ_DIR="$OUTPUT_DIR/$SRA_ID"
    mkdir -p "$FASTQ_DIR"

    #Move FASTQ files to the FASTQ directory
    if [[ -f "$OUTPUT_DIR/${SRA_ID}_1.fastq" ]]; then
        mv "$OUTPUT_DIR/${SRA_ID}_1.fastq" "$FASTQ_DIR"
    fi
    if [[ -f "$OUTPUT_DIR/${SRA_ID}_2.fastq" ]]; then
        mv "$OUTPUT_DIR/${SRA_ID}_2.fastq" "$FASTQ_DIR"
    fi
    
    
    #Run Cell Ranger
    cellranger count \
      --id="$SRA_ID" \
      --transcriptome="$CELLRANGER_REF" \
      --fastqs="$FASTQ_DIR" \
      --sample="$SRA_ID" \
      --create-bam=true \
      --localcores="$THREADS" \
      --output-dir="$OUTPUT_DIR/$SRA_ID"
    
    #Move results to output directory
    mv "$SRA_ID" "$OUTPUT_DIR"
    
    echo "Processing of $SRA_ID completed."
done < "$SRA_ID_LIST"

echo "All samples processed successfully!"