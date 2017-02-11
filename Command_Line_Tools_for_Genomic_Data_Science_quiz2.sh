# install samtools

git clone https://github.com/samtools/htslib
cd htslib
autoheader     # If using configure, generate the header template...
autoconf       # ...and configure script (or use autoreconf to do both)
./configure    # Optional, needed for choosing optional functionality
make
make install

cd ..

git clone https://github.com/samtools/samtools
cd samtools
./configure
make
make install


# install bedtools
git clone https://github.com/arq5x/bedtools2
make make install


# setting PATH for sratools
export PATH="/Users/chenhao/Lucence/tools/sratoolkit.2.8.0-mac64/bin:$PATH"

# download sequence data from NCBI SRA
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR110/SRR1107997/SRR1107997.sra

## view the sra data
nohup fastp-dump SRR1107997.sra &



## usage of samtools to process bam file

samtools

samtools flagstat example.bam
samtools sort example.bam example.sorted
samtools index exmaple.sorted.bam
samtools merge f1.bam f2.bam

# convert bam file to sanm format
samtools view -h example.bam > example.sam


## usage of bedtools








##------------------------ Exam 2 ---------------------------##

# download data from  https://d396qusza40orc.cloudfront.net/gencommand/gencommand_proj2_data.tar.gz
tar -zxvf gencommand_proj3_data.tar.gz


## 1. How many alignments does the set contain?
samtools flagstat athal_wu_0_A.bam



# 2. How many alignments show the read’s mate unmapped

nohup samtools sort athal_wu_0_A.bam -o athal_wu_0_A.sorted.bam &

samtools view athal_wu_0_A.sorted.bam | cut -f 7 | grep '*' | wc -l



# 3. How many alignments contain a deletion (D)?
samtools view athal_wu_0_A.sorted.bam | cut -f 6 | grep 'D' | wc -l



# 4. How many alignments show the read’s mate mapped to the same chromosome?
samtools view athal_wu_0_A.sorted.bam | cut -f 7 | grep '=' | wc -l



# 5. How many alignments are spliced?
samtools view athal_wu_0_A.sorted.bam | cut -f 6 | grep 'N' | wc -l


# 6-10 Extract only the alignments in the range “Chr3:11,777,000-11,794,000”, corresponding to a locus of interest. For this alignment set:
samtools view -b -h athal_wu_0_A.sorted.bam "Chr3:11777000-11794000" > athal_wu_0_A.sorted.chr3seg.bam

# 6. How many alignments are spliced?


samtools flagstat athal_wu_0_A.sorted.chr3seg.bam



# 7. How many alignments show the read’s mate unmapped
samtools view athal_wu_0_A.sorted.chr3seg.bam | cut -f 7 | grep '*' | wc -l



# 8. How many alignments contain a deletion (D)?
samtools view athal_wu_0_A.sorted.chr3seg.bam | cut -f 6 | grep 'D' | wc -l



# 9. How many alignments show the read’s mate mapped to the same chromosome?
samtools view athal_wu_0_A.sorted.chr3seg.bam | cut -f 7 | grep '=' | wc -l



# 10. How many alignments are spliced?
samtools view athal_wu_0_A.sorted.chr3seg.bam | cut -f 6 | grep 'N' | wc -l



# 11-15 Determine general information about the alignment process from the original BAM file.
samtools view -h athal_wu_0_A.bam | head  -15



# 16-20 Using BEDtools, examine how many of the alignments at point 2 overlap exons at the locus of interest. Use the BEDtools ‘-wo’ option to only report non-zero overlaps. The list of exons is given in the included ‘athal_wu_0_A_annot.gtf’ GTF file.

bedtools bamtobed -i athal_wu_0_A.sorted.chr3seg.bam > athal_wu_0_A_chr3seg.bed

# 16 How many overlaps (each overlap is reported on one line) are reported?
bedtools intersect -wo -a athal_wu_0_A_chr3seg.bed -b athal_wu_0_A_annot.gtf | wc -l



# 17 How many of these are 10 bases or longer?
bedtools intersect -wo -a athal_wu_0_A_chr3seg.bed -b athal_wu_0_A_annot.gtf | cut -f 16 | awk '$1>=10{print}' | wc -l

bedtools intersect -wo -a athal_wu_0_A_chr3seg.bed -b athal_wu_0_A_annot.gtf | cut -f 16 | sort -nr | cat > count.txt


# 18 How many alignments overlap the annotations?
bedtools intersect -wo -a athal_wu_0_A_chr3seg.bed -b athal_wu_0_A_annot.gtf | cut -f4 | uniq | wc -l



# 19 Conversely, how many exons have reads mapped to them?
bedtools intersect -wo -a athal_wu_0_A_chr3seg.bed -b athal_wu_0_A_annot.gtf | cut -f 9-11 | uniq | wc -l



# 20 If you were to convert the transcript annotations in the file “athal_wu_0_A_annot.gtf” into BED format, how many BED records would be generated?
cut -f 9 athal_wu_0_A_annot.gtf | cut -d ";" -f 1 | uniq | wc -l
