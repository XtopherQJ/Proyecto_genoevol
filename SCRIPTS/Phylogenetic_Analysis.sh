#!/bin/bash

#  ----Utilizando Snippy para crear el core genome ----
# Primero vamos a ubicar todos los genomas en un directorio llamado all_fastas
# Recordar que la mejor opción es utilizar el archivo ensamblado luego del polishing. 


echo "🚀 Iniciando el análisis con Snippy..."

mkdir -p snippy_results all_fastas
cp ensamblados/*.fasta all_fastas/

# Utilizamos un loop para correr Snippy en cada genoma

for genome_fasta in all_fastas/*.fasta; do
    nombre_base=$(basename "$genome_fasta" .fasta) 
    snippy --ref genomic.gbff --ctgs "$genome_fasta" \
    --outdir "snippy_results/$nombre_base" \
    --force --cpus 8;
done

# Ahora que tenemos los resultados de Snippy para cada genoma, vamos a crear el core genome

echo "🔨 Construyendo el core genome con Snippy-core..."
snippy-core --prefix core_analisis --ref genomic.gbff snippy_results/*/

# Finalmente, utilizamos Gubbins para detectar regiones recombinantes en el core genome

echo "🗑️ Eliminando las regiones recombinantes con Gubbins"
run_gubbins.py --prefix gubbins_resultado core_analisis/core_analisis.full.aln

# Construiremos el árbol filogenético utilizando IQ-TREE

echo "🌳 Construyendo el árbol filogenético con IQ-TREE..."
iqtree -s gubbins_resultado.filtered_polymorphic_sites.fasta -m TEST -B 1000 -nt AUTO

echo "✅ Análisis completado"
