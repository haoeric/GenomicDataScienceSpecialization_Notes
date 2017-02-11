## find shorted common supersequence through brute-force approach
def overlap(a, b, min_length=3):
    """ Return length of longest suffix of 'a' matching
        a prefix of 'b' that is at least 'min_length'
        characters long.  If no such overlap exists,
        return 0. """
    start = 0  # start all the way at the left
    while True:
        start = a.find(b[:min_length], start)  # look for b's suffx in a
        if start == -1:  # no more occurrences to right
            return 0
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            return len(a)-start
        start += 1  # move just past previous match

import itertools

def scs(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = None
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        if shortest_sup is None or len(sup) < len(shortest_sup):
            shortest_sup = sup  # found shorter superstring
    return shortest_sup  # return shortest
    
    
## find all SCS strings
def scs2(ss):
    """ Returns shortest common superstring of given
        strings, which must be the same length """
    shortest_sup = tuple()
    for ssperm in itertools.permutations(ss):
        sup = ssperm[0]  # superstring starts as first string
        for i in range(len(ss)-1):
            # overlap adjacent strings A and B in the permutation
            olen = overlap(ssperm[i], ssperm[i+1], min_length=1)
            # add non-overlapping portion of B to superstring
            sup += ssperm[i+1][olen:]
        if len(shortest_sup) == 0:
            shortest_sup = (sup,)
        elif len(sup) <= len(shortest_sup[-1]):
            if len(sup) < len(shortest_sup[-1]):
                shortest_sup = (sup,)
            else:
                shortest_sup = shortest_sup + (sup,)  
    return shortest_sup  # return shortest
            


## find shorted common supersequence through greedy algorithm
    
def pick_maximal_overlap(reads, k):
    reada, readb, = None, None
    best_olen = 0
    for a,b in itertools.permutations(reads, 2):
        olen = overlap(a, b, min_length=k)
        if olen > best_olen:
            reada, readb = a, b
            best_olen = olen
    return reada, readb, best_olen
    

def greedy_scs(reads, k):
    reada, readb, olen = pick_maximal_overlap(reads, k)
    while olen > 0 :
        reads.remove(reada)
        reads.remove(readb)
        reads.append(reada + readb[olen:])
        reada, readb, olen = pick_maximal_overlap(reads, k)
        print(len(reads))
    return ''.join(reads)
    
    


# read fastq file
def readFastq (file):
    sequences = []
    # qualities = []
    with open (file) as f:
        while True:
            f.readline()
            seq = f.readline().rstrip()
            f.readline()
            qua = f.readline().rstrip()
            if len(seq) == 0:
                break
            sequences.append(seq)
            # qualities.append(qua)
    return sequences
    


s = readFastq("/Users/chenhao/GitProject/GenomicDataScienceSpecialization_Notes/data/ads1_week4_reads.fq")   
t = greedy_scs(s, 1)
t.count('A')
t.count('T')
