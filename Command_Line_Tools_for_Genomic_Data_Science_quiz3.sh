
## ---------------------------------course notes---------------------------------------
## install bcftools
git clone git://github.com/samtools/bcftools.git
cd bcftools; make


## bowtie build index of reference genome
mkdir hpv
cd hpv
bowtie2-build HPV_all.fasta

## bowtie alignment 
bowtie2 -p 4 -x /hpv/hg38c.fa -S example.sam


## BWA build index
bwa index HPV_all.fasta
 
## bwa mem alignment
bwa men -t 4 /data1/genomes/hg38c.fa exome.fastq > exome.bwa.sam

## tramsform to bam format
samtools view -bT /data1/genomes/hg38c.fa exome.bwa.sam > exome.bwa.bam


## mpileup
samtools index sample.bam
samtools mpileup -f /data1/genomes/hg38c.fa sample.bam > sample.mpileup

samtools mpileup -v -u -f /data1/genomes/hg38c.fa sample.bam > sample.vcf

samtools mpileup -g -f /data1/genomes/hg38c.fa sample.bam > sample.bcf


## vairant calling
bcftools view example.bcf

bcftools call 







##---------------------------------course examination---------------------------------------

## 1. How many sequences were in the genome
grep ">" wu_0.v7.fas | wc -l


## 2. What was the name of the third sequence in the genome file? Give the name only, without the “>” sign.
grep ">" wu_0.v7.fas | head 


## 3. What was the name of the last sequence in the genome file? Give the name only, without the “>” sign.
grep ">" wu_0.v7.fas | tail


# 4.5 Generate a bowtie2 index of the wu_0_A genome using bowtie2-build, with the prefix 'wu_0'.
bowtie2-build wu_0.v7.fas wu/wu_0


# 6. How many reads were in the original fastq file?
grep ^@ wu_0_A_wgs.fastq | wc -l


# Run bowtie2 to align the reads to the genome, under two scenarios: first, to report only full-length matches of the reads; and second, to allow partial (local) matches. All other parameters are as set by default.
bowtie2 -p 4 -x wu/wu_0 -q wu_0_A_wgs.fastq -S wu_0.sam
samtools view -bT wu_0.v7.fas wu_0.sam > wu_0.bam

# 7. How many matches (alignments) were reported for the original (full-match) setting? Exclude lines in the file containing unmapped reads.
samtools view wu_0.bam | cut -f6 | grep M | wc -l


# 8. How many matches (alignments) were reported with the local-match setting? Exclude lines in the file containing unmapped reads.
bowtie2 -p 4 --local -x wu/wu_0 -q wu_0_A_wgs.fastq -S wu_0_local.sam
samtools view -bT wu_0.v7.fas wu_0_local.sam > wu_0_local.bam
samtools view wu_0_local.bam | cut -f6 | grep M | wc -l


# 9. How many reads were mapped in the scenario in Question 7?
samtools view wu_0.bam | wc -l


# 10. How many reads were mapped in the scenario in Question 8?
samtools view wu_0_local.bam | wc -l


# 13. How many alignments contained insertions and/or deletions, in the scenario in Question 7?
samtools view wu_0.bam | cut -f6 | grep [ID] | wc -l


## 14. How many alignments contained insertions and/or deletions, in the scenario in Question 8?
samtools view wu_0_local.bam | cut -f6 | grep [ID] | wc -l



# Compile candidate sites of variation using SAMtools mpileup for further evaluation with BCFtools. Provide the reference fasta genome and use the option “-uv” to generate the output in uncompressed VCF format for easy examination.
samtools sort wu_0.bam -o wu_0_sorted
samtools index wu_0_sorted
samtools mpileup -v -u -f wu_0.v7.fas wu_0_sorted > wu_0.vcf


# 15. How many entries were reported for Chr3?
bcftools view wu_0.vcf | grep ^Chr3 | wc -l


# 16. How many entries have ‘A’ as the corresponding genome letter?
bcftools view -H wu_0.vcf | cut -f4 | grep A | wc -l


# 17. How many entries have exactly 20 supporting reads (read depth)?
bcftools view -H wu_0.vcf | cut -f8 | cut -d ";" -f1 | grep =20$ | wc -l


# 18. How many entries represent indels?



# 19. How many entries are reported for position 175672 on Chr1?
bcftools view -H wu_0.vcf | grep ^Chr1 | cut -f2 | grep ^175672$ | wc -l



# Call variants using ‘BCFtools call’ with the multiallelic-caller model. For this, you will need to first re-run SAMtools mpileup with the BCF output format option (‘-g’) to generate the set of candidate sites to be evaluated by BCFtools. In the output to BCFtools, select to show only the variant sites, in uncompressed VCF format for easy examination.

samtools mpileup -g -f wu_0.v7.fas wu_0_sorted > wu_0.bcf
bcftools call -v -m -O z -o wu_0.vcf.gz wu_0.bcf


# 20. How many variants are called on Chr3?
bcftools view -H wu_0_2.vcf | grep ^Chr3 | wc -l


# 21. How many variants represent an A->T SNP? If useful, you can use ‘grep –P’ to allow tabular spaces in the search term.
bcftools view -H wu_0_2.vcf | cut -f4,5 | tr '\t' - | grep ^A-T$ | wc -l


# 22. How many entries are indels?




# 23. How many entries have precisely 20 supporting reads (read depth)?
bcftools view -H wu_0_2.vcf | cut -f8 | cut -d ";" -f1 | grep =20$ | wc -l


# 24. What type of variant (i.e., SNP or INDEL) is called at position 11937923 on Chr3?
bcftools view -H wu_0.vcf | cut -f 1,2 | tr '\t' - | grep -n ^Chr3-11937923$
bcftools view -H wu_0.vcf > a.txt
awk 'NR==3342560' a.txt



samtools tview -p













