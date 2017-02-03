from Bio.Blast import NCBIWWW
fasta_string = open("/Users/chenhao/Desktop/querySeq.fa").read()
res = NCBIWWW.qblast("blastn", "nt", fasta_string)

from Bio.Blast import NCBIXML
record = NCBIXML.read(res)

len(record.alignments)
E_VALUE_THRESH = 0.01
for alignment in record.alignments:
    for hsp in alignment.hsps:
        if hsp.expect < E_VALUE_THRESH:
            print ("------alignment------")
            print (alignment.title)
            print (alignment.length)
            print (hsp.expect)
            print (hsp.query)
            print (hsp.match)
            print (hsp.sbjct)




from Bio.Seq import Seq

t = Seq("TGGGCCTCATATTTATCCTATATACCATGTTCGTATGGTGGCGCGATGTTCTACGTGAATCCACGTTCGAAGGACATCATACCAAAGTCGTACAATTAGGACCTCGATATGGTTTTATTCTGTTTATCGTATCGGAGGTTATGTTCTTTTTTGCTCTTTTTCGGGCTTCTTCTCATTCTTCTTTGGCACCTACGGTAGAG")
t.translate()




