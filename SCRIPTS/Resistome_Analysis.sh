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
done
echo "🎯 AMRFinder analysis completed for all samples."

# === Step 2: Multilocus Sequence Typing (MLST) ===
echo "🔧 Step 2: Performing MLST analysis"
for fasta in "$INPUT_DIR"/*.fasta; do
    sample="$(basename "$fasta" .fasta)"
    mlst "${fasta}" > "${OUTPUT_DIR}/${sample}_mlst.tsv"
done
echo "🎯 MLST analysis completed for all samples."

# === Step 3: Phylogroup Determination ===
echo "🔧 Step 3: Determining phylogroups using ClermonTyping"
for fasta in "$INPUT_DIR"/*.fasta; do
    sample="$(basename "$fasta" .fasta)"
    "$PHYLOGROUP"/clermonTyping.sh --fasta "${fasta}" > "${OUTPUT_DIR}/${sample}_phylogroup.txt"
done
echo "🎯 ClermonTyping analysis completed for all samples."

# === Step 4: Serotype Prediction ===
echo "🔧 Predicting serotypes using SerotypeFinder"
for fasta in "$INPUT_DIR"/*.fasta; do
sample="$(basename "$fasta" .fasta)"
ectyper -i "${fasta}" -c "$THREADS" --verify --pathotype -o "${OUTPUT_DIR}/${sample}_serotype"
done
echo "🎯 Serotype prediction completed for all samples."
