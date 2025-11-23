# **Identificación de genes de resistencia y virulencia en cepas de *Escherichia coli* aisladas de moluscos bivalvos.**

## **Introducción**

**La resistencia antimicrobiana (RAM)** es el mecanismo por el cual los microorganismos adquieren la capacidad de sobrevivir y propagarse en presencia de antimicrobianos, los cuales pueden ser naturales, semisintéticos o sintéticos. Este fenómeno constituye un problema de salud global, ya que se estima que para el año 2050 la principal causa de muerte serán las infecciones provocadas por bacterias resistentes a antimicrobianos. 
El uso inadecuado y excesivo de estos fármacos ha contribuido significativamente a la aparición y propagación de bacterias resistentes, no solo en entornos hospitalarios, sino también en otros ambientes como el agua, suelo y el aire. En este contexto, el medio marino se considera un gran reservorio de bacterias resistentes a los antimicrobianos, al funcionar como receptor final de los residuos terrestres provenientes de hospitales, industrias, ganadería, agricultura, entre otros. 

![2022-cde-infog-print-cycle-amr-sp_0-2-1536x1086](https://github.com/user-attachments/assets/611dd4c6-f827-4581-b671-8a6554e89abf)

Los organismos marinos pueden contaminarse con estas bacterias, siendo un ejemplo claro los moluscos bivalvos. Estos al ser organismos filtradores, obtienen sus nutrientes del entorno acuático mediante un proceso conocido como filtración, lo que también favorece la acumulación de contaminantes presentes en el medio, incluyendo bacterias resistentes como *Escherichia coli*.

![atmung-en](https://github.com/user-attachments/assets/b148e7b8-e888-40cd-aed2-7763bebb4585)

Esta especie es especialmente preocupante debido a su capacidad de adquirir y transferir genes de resistencia y virulencia mediante mecanismos de transferencia horizontal. Por ello, resulta de vital importancia estudiar la presencia de bacterias resistentes a los antibióticos mediante la identificación de genes de resistencia, así como de los genes que codifican factores de virulencia que permiten a las bacterias causar enfermedades en el ser humano. Todo esto con la finalidad de fortalecer la vigilancia de la RAM en moluscos bivalvos y contribuir con la seguridad alimentaria. 

## **Hipótesis**

Las cepas de *Escherichia coli* aisladas de especies de moluscos bivalvos contienen genes de resistencia y virulencia, lo que representaría un riesgo potencial para la salud humana.

## **Objetivos**

- Desarrollar un `workflow` bioinformático para procesar datos crudos de secuenciamiento por medio de la tecnología **Oxford Nanopore Technologies (ONT)**, que permita realizar la evaluación de la calidad de las lecturas hasta la identificación de genes de resistencia y virulencia.
- Desarrollar un `workflow` para el análisis filogenético de los genomas pertenecientes a las cepas de *Escherichia coli.*

## **Metodología**

Para desarrollar este proyecto se utilizará data cruda obtenida mediante el secuenciamiento del genoma completo de cepas de *Escherichia coli* aisladas a partir de diferentes especies de moluscos bivalvos. 
El desarrollo del `workflow` se realizará utilizando lenguaje `bash`.

### ***`Workflow` para el procesamiento de datos:***

**1. Evaluación de la calidad utilizando `Nanoplot`.**  

**2. Eliminación de adaptadores con la herramienta `Porechop`.**

**3. Ensamblaje del genoma utilizando `Flye`.**

**4. Evaluación de la calidad del ensamblado con `QUAST`.**

**5. Polishing del ensamblado con `Medaka`.**

**6. Anotación del genoma utilizando `Prokka`.**

**7. Búsqueda de genes de resistencia con la herramienta `AMRFinderPlus`.**

**8. Búsqueda de genes de virulencia con la herramienta `VirulenceFinder`.**


### ***`Workflow` para el análisis filogenético:***

**1. Identificación de variantes utilizando `Snippy`.**

**2. Creación del core genome utilizando `Snippy`.**

**3. Eliminación de regiones recombinantes con `Gubbins`.**

**4. Construcción del árbol filogenético con `IQ-TREE`.**







