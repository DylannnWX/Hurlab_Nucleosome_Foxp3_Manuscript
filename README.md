Welcome to the Github repo of our Foxp3 Nucleosome manuscript! Here you will find the custom python and linux scripts used in our manuscript. They are:

1. ATGC_colors:

This straightforward python script give any sequence custom colors by A, T, C and G nucleotide. We used this for visualizing TnG sequences in our supplementary figures.

2. SRR_fastq_map_to_mm10

This shell script utilizes Harvard Medical School's O2 cloud computing platform and NCBI's SRAToolkit, and process the sample via the below steps:
 ** A. **Fetch SRR#, convert to fastq with fasterq-dump in SRAToolkit
  **B.** Trimms fastq with Trimmomatic
  **C.** Aligns fastq with bowtie2 on mm10 genome
  **D.** Uses samtools to get aligned reads, and sort by aligned position

3. TnG_Fimo_to_bed

This python script takes the FIMO tsv result as input, reads it into a python pandas database, and filters the FIMO regions with the below criteria: [no 12A, 12G, 12T, 12C, 6AG, 6AT, 6AC, 6GT, 6GC, or 6TCs], and [p-value < 8e-5]. The result FIMO regions were exported into a .bed file that is tab-delimited, with the first three columns being "Chromosome", "Start", and "End". This .bed file can be used directly as any other peak files, and you can use it for overlapping, merging, IGV or other purposes.
