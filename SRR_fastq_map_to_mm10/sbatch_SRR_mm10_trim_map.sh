#!/bin/bash
#SBATCH -c 6                               # Request one core
#SBATCH -t 2-00:00                         # Runtime in D-HH:MM format
#SBATCH -p medium                          # Partition to run in
#SBATCH --mem=16G                         # Memory total in MiB (for all cores)
#SBATCH -o hostname_%j.out                 # File to which STDOUT will be written, including job ID (%j)
#SBATCH -e hostname_%j.err                 # File to which STDERR will be written, including job ID (%j)


set -e

SRR=$1 Output=$2

export PATH=$PATH:/n/data1/hms/bcmp/hur/lab/Dylan/sratoolkit/bin
prefetch ${SRR} --max-size u
fasterq-dump ${SRR}

FASTQ1="${SRR}.fastq"

module load java/jdk-1.8u112 
module load trimmomatic/0.36

java -jar $TRIMMOMATIC/trimmomatic-0.36.jar SE -threads 6 -phred33 ${FASTQ1} ${FASTQ1}_trimmed.fastq ILLUMINACLIP:$TRIMMOMATIC/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 MINLEN:15

module load fastqc/0.11.9

#fastqc ${FASTQ1}_paired.fq

module load gcc/6.2.0 bowtie2/2.3.4.3

bowtie2 -p 6 --local -x /n/groups/shared_databases/igenome/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome -U ${FASTQ1}_trimmed.fastq -S ${Output}.sam

module load gcc/6.2.0   samtools/1.9
samtools view -bS  ${Output}.sam >  ${Output}.bam
samtools sort ${Output}.bam -o ${Output}_sorted.bam
samtools view -b -F 4 ${Output}_sorted.bam > ${Output}_mm10.bam
samtools index ${Output}_mm10.bam

rm ${Output}.sam ${Output}.bam ${Output}_sorted.bam ${FASTQ1}_trimmed.fastq
