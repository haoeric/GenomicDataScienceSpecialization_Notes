# read fastq file
def readFastq (file):
    sequences = []
    qualities = []
    with open (file) as f:
        while True:
            f.readline()
            seq = f.readline().rstrip()
            f.readline()
            qua = f.readline().rstrip()
            if len(seq) == 0:
                break
            sequences.append(seq)
            qualities.append(qua)
    return sequences, qualities
    

def phred33ToQ(qual):
    return ord(qual) - 33
    

def cycleQuality(values, lens=100):
    hist =[0]*lens
    for val in values:
        for i in range(len(val)):
            q = phred33ToQ(val[i])
            hist[i] += q
    return hist
    
    
def createHist(values, lens=50):
    hist =[0]*lens
    for val in values:
        for phred in val:
            q = phred33ToQ(phred)
            hist[q] += 1
    return hist

import matplotlib.pyplot as plt
h = cycleQuality(values = q, lens = 100)
for i in range(len(h)):
    if(h[i] == 4526):
        print(i)




def findGCbyPos(sequences, seqLens):
    gc = [0] * seqLens
    total = [0] * seqLens
    
    for read in sequences:
        for base in range(len(read)):
            if base == "G" or base = "C":
                gc[i] += 1
                total[i] += 1
                
    for i in range(len(gc)):
        if(total[i] > 0):
            gc[i] /= float(total[i])
            
    return gc
    

import collections 
count = collections.Counter()
for seq in seqs:
    count.update(seq)
print count










def readGenome(filename):
    genome = ''
    with open(filename, "r") as f:
        for line in f:
            if not line[0] == ">":
                genome += line.rstrip()
    return genome
    

def reverseComplement(s):
    s = s.upper();
    complements = {"A":"T", "T":"A", "C":"G", "G":"C", "N":"N"}
    rs = ''
    for base in s:
        rs = complements[base] + rs
    return rs



import random
def generateReads(genome, numReads, readLen):
    '''generate random reads from given genome with certain length'''
    reads = []
    for _ in range(numReads):
        startID = random.randint(0, len(genome)-readLen)
        reads.append(genome[startID:startID+readLen])
    return reads
    
    
def naiveAlignmenter(sequence, reference):
    occurrences = []
    for i in range(len(reference)-len(sequence)+1):
        match = True
        for j in range(len(sequence)):
            if not sequence[j] == reference[i+j]:
                match = False
                break
        if match:
                occurrences.append(i)
            
    return occurrences
    
    
def naiveAlignmenter_kmm(sequence, reference, k):
    occurrences = []
    for i in range(len(reference)-len(sequence)+1):
        match = True
        mismatches = 0
        for j in range(len(sequence)):
            if not sequence[j] == reference[i+j]:
                mismatches += 1
                if(mismatches > k):
                    match = False
                    break
        if match:
                occurrences.append(i)
            
    return occurrences
    


    