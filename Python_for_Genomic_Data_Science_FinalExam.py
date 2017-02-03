



def parseFastaFile (file):
    try:
        fh = open(file, "r")
    except IOError:
        print("File %s doesn't exists!" % file)
    seq = {}
    for line in fh:
        line = line.rstrip()
        if line[0] == ">":
            words = line.split()
            name = words[0][1:]
            seq[name] = ""
        else:
            seq[name] = seq[name] + line
            
    return seq

def fileRecords (file):
    seqDic = parseFastaFile(file)
    return len(seqDic)
    
    
def longestSeq (file):
    seqDic = parseFastaFile(file)
    maxLens = 0
    maxLensID = ''
    for k, v in seqDic.items():
        if(len(v) > maxLens):
            maxLens = len(v)
            maxLensID = k
    return maxLens, maxLensID
    
def shortestSeq (file):
    seqDic = parseFastaFile(file)
    minLens = len(list(seqDic.values())[1])
    minLensID = ''
    for k, v in seqDic.items():
        if(len(v) < minLens):
            minLens = len(v)
            minLensID = k
    return minLens, minLensID
    
    
def findSeqORF (file, orf):
    seqDic = parseFastaFile(file)
    seqORF = {}
    for k,v in seqDic.items():
        startID = orf - 1
        for i in range(startID, len(v), 3):
            if v[i:i+3] == "ATG":
                for j in range(i+3, len(v), 3):
                    if v[j:j+3] == "TAG" or v[j:j+3] == "TGA" or v[j:j+3] == "TAA":
                        if k in seqORF:
                            if j-i+3 > seqORF[k][2]:
                                seqORF[k] = [i+1, j+3, j-i+3]
                        else:
                            seqORF[k] = [i+1, j+3, j-i+3]
                            
                        i = j + 3
                        break
    return seqORF
                

def countOccurrence (string, sub):
    count = start = 0
    while True:
        start = string.find(sub, start) + 1
        if start > 0:
            count += 1
        else:
            return count
            
def findKmerOccurance (file, kmer):
    kmerCount = {}
    seqDic = parseFastaFile(file)
    for seq in seqDic.values():
        for i in range(0, len(seq), 1):
            j = i+kmer
            kmer = seq[i : i+kmer]
            if(kmer not in kmerCount):
                counts = 0
                for s in seqDic.values():
                    counts += countOccurrence(s, kmer)
                kmerCount[kmer] = counts
    return kmerCount
                
            

        

