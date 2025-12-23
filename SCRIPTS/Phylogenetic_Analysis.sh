#!/bin/bash

# === Phylogenetic Analysis Pipeline ===

echo "🚀 Starting Phylogenetic Analysis Pipeline"

# === Step 0: Setup ===
INPUT_DIR="all_fastas"
OUTPUT_DIR="phylo_results"
REFERENCE="genomic.gbff"
SNIPPY="snippy_results"
THREADS=32

mkdir -p "$OUTPUT_DIR" "$SNIPPY"

# === Step 1: Finding SNPs with Snippy ===
echo "🔍 Finding SNPs with Snippy..."
for genome in "$INPUT_DIR"/*.fasta; do
    sample="$(basename "$genome" .fasta)" 
    snippy --ref "${REFERENCE}" --ctgs "${genome}" --outdir "${OUTPUT_DIR}/$sample" --force --cpus "${THREADS}"
done
echo "✅ SNP calling completed."

# === Step 2: Core SNP Alignment with Snippy-core ===
echo "🔨 Constructing the core genome with Snippy-core..."
snippy-core --prefix core_snps --ref "${REFERENCE}" "${OUTPUT_DIR}"/*/
mv core_snps* "${SNIPPY}/"
echo "✅ Core genome alignment completed."

# === Step 3: Removing Recombinant Regions with Gubbins ===
echo "🧹 Removing recombinant regions with Gubbins..."
run_gubbins.py --prefix gubbins_results --threads "${THREADS}" "${SNIPPY}/core_snps.full.aln"
mv gubbins_results* "${SNIPPY}/"
echo "✅ Recombinant regions removed."

# === Step 4: Phylogenetic Tree Construction with iQ-TREE ===
echo "🌳 Constructing phylogenetic tree with iQ-TREE..."
iqtree -s "${SNIPPY}/gubbins_results.filtered_polymorphic_sites.fasta" -m TEST -B 1000 -nt AUTO
echo "✅ Phylogenetic tree construction completed."

echo "🎉 Phylogenetic Analysis Pipeline completed successfully!"
