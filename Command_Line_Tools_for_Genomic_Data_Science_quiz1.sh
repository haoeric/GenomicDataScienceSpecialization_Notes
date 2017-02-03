## 1. count the number of chromosomes in the genome
grep ">" apple.genome | wc -l    

or 

grep -c ">" apple.genome



## 2. count the number of unique genes 

cut -f1 apple.genes | uniq | wc -l

or 

cut -f1 apple.genes | sort -u | wc -l



## 3. count the number of trancript variants

cut -f2 apple.genes | wc -l



## 4. how many genes have a single splice variant
cut -f1 apple.genes | uniq -c | grep " 1 " | wc -l



## 5. How may genes have 2 or more splice variants
cut -f1 apple.genes | uniq -c | grep -v " 1 " | wc -l



## 6. How many genes are there on the ‘+’ strand
cut -f1,4 apple.genes | uniq | grep "+" | wc -l



## 7. How many genes are there on the ‘-’ strand
cut -f1,4 apple.genes | uniq | grep "-" | wc -l



## 8. How many genes are there on chromosome chr1
cut -f1,3 apple.genes | uniq | grep "chr1" | wc -l



## 9. How many genes are there on chromosome chr2
cut -f1,3 apple.genes | uniq | grep "chr2" | wc -l



## 10. How many genes are there on chromosome chr3
cut -f1,3 apple.genes | uniq | grep "chr3" | wc -l



## 11. How many transcripts are there on chr1
cut -f2,3 apple.genes | grep "chr1" | wc -l



## 12. How many transcripts are there on chr2
cut -f2,3 apple.genes | grep "chr2" | wc -l



## 13. How many transcripts are there on chr3
cut -f2,3 apple.genes | grep "chr3" | wc -l



## 14. How many genes are in common between condition A and condition B
cut -f1 apple.conditionA | sort -u > condAgenes
cut -f1 apple.conditionB | sort -u > condBgenes
cut -f1 apple.conditionC | sort -u > condCgenes
comm -1 -2 condAgenes condBgenes | wc -l

or 

cat condAgenes condBgenes | sort | uniq -c | grep " 2 " | wc -l



## 15. How many genes are specific to condition A
comm -2 -3 condAgenes condBgenes | wc -l



## 16. How many genes are specific to condition B
comm -1 -3 condAgenes condBgenes | wc -l



## 17. How many genes are in common to all three conditions
comm -1 -2 condAgenes condBgenes > condABgenes
comm -1 -2 condABgenes condCgenes | wc -l

