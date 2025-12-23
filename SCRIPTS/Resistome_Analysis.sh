#!/bin/bash

# === Resistome analysis pipeline ===

echo "🚀 Starting Resistome Analysis Pipeline"

# === Step 0: Setup ===
INPUT_DIR="pol_genomes"
OUTPUT_DIR="resistome_results"
THREADS=4

mkdir -p "$OUTPUT_DIR"

# === Step 1: AMRFinderPlus Analysis ===
echo "🔧 Step 1: Running AMRFinderPlus for resistance and virulence gene detection"
for fasta in "$INPUT_DIR"/*.fasta; do
    sample="$(basename "$fasta" .fasta)"
    echo "🔍 Analyzing resistance and virulence genes in: $sample"
    amrfinder -n "$fasta" --organism Escherichia --plus -o "${OUTPUT_DIR}/${sample}_amrfinder.tsv"
    echo "✅ Output saved to: ${OUTPUT_DIR}/${sample}_amrfinder.tsv"
done

echo "🎯 AMRFinder analysis completed for all samples."
