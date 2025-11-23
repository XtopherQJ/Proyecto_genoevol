#!/bin/bash

#Pipeline para identificación de genes de resistencia

# === Paso 1: Descomprimir archivos .gz ===
#El primer argumento debe ser el directorio que contiene los archivos .gz

DIRECTORIO="$1"

#Descomprimir archivos .gz en el directorio especificado
for archivo in  "$DIRECTORIO"/*.gz; do
  if [ -f "$archivo" ]; then
    echo "Descomprimiendo: $archivo"
    gunzip "$archivo"
  fi
done

# Mensaje de finalización
echo "Todos los archivos .gz han sido descomprimidos."

# === Paso 2: Concatenar archivos fastq ===
NOMBRE_DIRECTORIO=$(basename "$DIRECTORIO")
NOMBRE_SALIDA="${NOMBRE_DIRECTORIO}_all.fastq"

#Concatenar todos los archivos .fastq en uno solo
cat "$DIRECTORIO"/*.fastq  > "$DIRECTORIO/$NOMBRE_SALIDA"

#Mensaje de finalización
echo "Todos los archivos .fastq han sido concatenados en $NOMBRE_SALIDA"

#Eliminar todos los archivos que empiecen con fastq y quedarme solo con el concatenado
rm -f "$DIRECTORIO"/fastq*

#Mensaje de eliminación
echo "Todos los archivos .fastq individuales han sido eliminados"

# === Paso 3: Eliminar adaptadores con Porechop ===

for archivo in  "$DIRECTORIO"/$NOMBRE_SALIDA; do
    porechop -i "$archivo" -o "$DIRECTORIO/${NOMBRE_SALIDA/_all.fastq/_sinadap.fastq}"
done
echo "Los adaptadores han sido eliminados."

# === Paso 4: Ejecutar NanoPlot ===
echo "Ejecutando NanoPlot..."
for archivo in "$DIRECTORIO"/*_sinadap.fastq; do
    NanoPlot --fastq "$archivo" --outdir "$DIRECTORIO/nanoplot_output"
done
echo "NanoPlot finalizado."

# === Paso 5: Ensamblar con Flye ===
echo "Ejecutando Flye..."
for archivo in "$DIRECTORIO"/*_sinadap.fastq; do
    flye --nano-hq "$archivo" --out-dir "$DIRECTORIO/emsamblado_output" \ 
         --genome-size 5m --threads 16
done
echo "Ensamblaje finalizado."

# === Paso 6: Polishing o correción del ensamblaje con Medaka ===
echo "Ejecutando Medaka..."
for archivo in "$DIRECTORIO/emsamblado_output/assembly.fasta"; do
    medaka_consensus -i "$archivo" -d "$DIRECTORIO/emsamblado_output/assembly.fasta" \
                     -o "$DIRECTORIO/medaka_output" -t 16 \ 
                     -m r1041_e82_400bps_sup_variant_g615
done
echo "Correción del ensamblaje finalizada."

# === Paso7: Evaluar el ensamblaje con Quast ===
echo "Ejecutando Quast..."
for archivo in "$DIRECTORIO/medaka_output/consensus.fasta"; do
    quast "$archivo" -o "$DIRECTORIO/quast_output"
done
echo "Evaluación del ensamblaje finalizada."

# === Paso8: Anotación del genoma con Prokka ===
echo "Ejecutando Prokka..."
for archivo in "$DIRECTORIO/medaka_output/consensus.fasta"; do
    prokka "$archivo" --outdir "$DIRECTORIO/anotacion_output" \ 
                      --prefix "genome$NOMBRE_DIRECTORIO" --cpu 16
done
echo "Anotación del genoma finalizada."

# === Paso9: Identificación de genes de resistencia con amrfinderplus ===
echo "Ejecutando amrfinderplus..."
for archivo in "$DIRECTORIO/anotacion_output/genome$NOMBRE_DIRECTORIO.fna"; do
    amrfinder -n "$archivo" -o "$DIRECTORIO/amrfinder_output.tsv" \ 
              --organism "Escherichia" -- threads 16
done
echo "Identificación de genes de resistencia finalizada."
