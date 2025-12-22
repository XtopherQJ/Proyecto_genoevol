#!/bin/bash

# === Pipeline for identification of resistance genes ===

# === Step 0: Setup ===
RAW_DIR="fastq_files"
NANOPLOT_DIR="nanoplot_output"
ATNANOPLOT_DIR="at_nanoplot_output"
PORECHOP_DIR="porechop_output"
TRIMMED_DIR="trimmed_reads"
ASSEMBLY_DIR="flye_output"
DRAFT_DIR="draft_assemblies"
MEDAKA_DIR="medaka_output"
ANNOT_DIR="annotation_output"
THREADS=32

mkdir -p "$NANOPLOT_DIR" "$ATNANOPLOT_DIR" "$PORECHOP_DIR" "$TRIMMED_DIR" "$ASSEMBLY_DIR" "$DRAFT_DIR" "$MEDAKA_DIR" "$ANNOT_DIR"

# === Step 1: Quality Control with NanoPlot ===
echo "🚀 Running RAM pipeline..."
echo "🔍 Starting Quality Analysis..."
for file in "$RAW_DIR"/*.fastq.gz; do
    NanoPlot --fastq "${file}" --outdir "${NANOPLOT_DIR}/$(basename "$file" .fastq.gz)" --threads "$THREADS"
done 
echo "Quality Control completed."

# === Step 2: Adapters Removal with Porechop ===
echo "✂️ Removing adapters..."
for file in "$RAW_DIR"/*.fastq.gz; do
    sample="$(basename "$file" .fastq.gz)"
    porechop -i "${file}" -o "${PORECHOP_DIR}/${sample}.fastq.gz" --threads "$THREADS"
done
echo "Adapter removal completed."

# === Step 3: Trimming with Filtlong ===
echo "🗑️ Trimming reads..."
for file in "$PORECHOP_DIR"/*.fastq.gz; do
    sample="$(basename "$file" .fastq.gz)"
    filtlong --min_length 1000 --keep_percent 90 --mean_q_weight 9 "${file}" | gzip > "${TRIMMED_DIR}/${sample}_trimmed.fastq.gz"
done
echo "Trimming completed."

# === Step 4: New Quality Control ===
echo "🔍 Starting Post-trimming Quality Analysis..."
for file in "$TRIMMED_DIR"/*_trimmed.fastq.gz; do
    NanoPlot --fastq "${file}" --outdir "${ATNANOPLOT_DIR}/$(basename "$file" _trimmed.fastq.gz)" --threads "$THREADS"
done
echo "Post-trimming Quality Analysis completed."

# === Step 5: Genome Assembly with Flye ===
echo "🏗️ Assembling genomes..."
for file in "$TRIMMED_DIR"/*_trimmed.fastq.gz; do
    sample="$(basename "$file" _trimmed.fastq.gz)"
    flye --nano-raw "${file}" -i 2 --out-dir "${ASSEMBLY_DIR}/${sample}_flye" --threads "$THREADS"
    cp "${ASSEMBLY_DIR}/${sample}_flye/assembly.fasta" "${DRAFT_DIR}/${sample}.fasta"
done
echo "Assembly completed."

# === Step 6: Polishing with Medaka ===
echo "🖌️ Polishing assemblies with Medaka..."
for draft in "$DRAFT_DIR"/*.fasta; do
    sample="$(basename "$draft" .fasta)"
    R="${TRIMMED_DIR}/${sample}_trimmed.fastq.gz"
    medaka_consensus -i "${R}" -d "${draft}" -o "${MEDAKA_DIR}/${sample}_medaka" -t "$THREADS"
done
echo "Polishing with Medaka completed."

# === Step 7: Quality Assessment with Quast ===
echo "📏 Assessing assembly quality with Quast..."
for draft in "$DRAFT_DIR"/*.fasta; do
    genome="$(basename "$draft" .fasta)"
    quast.py "$draft" "$MEDAKA_DIR"/"${genome}_medaka/consensus.fasta" \ 
    -o "${QUAST_DIR}/${genome}_quast" -t "$THREADS" -r "$REFERENCE" || true
done
echo "Quality assessment completed."

