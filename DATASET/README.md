## RAW READS
Las dos lecturas crudas o raw reads que se utilizarán como ejemplos para evaluar los scripts e identificar genes de resistencia pertenecen al Bioproject **PRJEB85647** - *Study: Whole Genome Sequencing of E. coli for antimicrobial resistance surveillance*

Puede descargar los raw reads usando los siguientes enlaces:
* [ERR14317609](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=ERR14317609&display=metadata)
* [ERR14314289](https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=ERR14314289&display=metadata)



#### SRA-TOOLS
Utilizaremos **sra-tools** para descargar varios archivos raw reads creando un `sra_list.txt` que contenga los códigos de accesión.
```bash
nano sra_list.txt
```
Dentro de la sra_list.txt se colocan los códigos de accesión de los raw reads.
```bash
ERR14317609
ERR14314289
```
Instalamos **sra-tools**
```bash
conda install bioconda::sra-tools
prefetch --version
```
Descargamos todos los raw reads de `sra_list.txt`
```bash
prefetch --option-file sra_list.txt
```
Convertimos los **sra** a **fastq**
```bash
mkdir fastq_files
for sra in $(cat sra_list.txt); do
    fasterq-dump $sra -O fastq/ --threads 8
done

gzip fastq/*.fastq
```


El **reference.fna** utilizado para la anotación de los genomas pertenece a la cepa ***Escherichia coli* str. K-12 substr. MG1655** con código de accesión 
**GCA_000005845.2**
