
## calculate edit distance between string

## using recursive programming (very slow)
def editDistRecursive(x, y):
    if len(x) == 0:
        return len(y)
    elif len(y) == 0:
        return len(x)
    else:
        distHor = editDistRecursive(x[:-1], y) + 1
        distVer = editDistRecursive(x, y[:-1]) + 1
        if x[-1] == y[-1]:
            distDiag = editDistRecursive(x[:-1], y[:-1])
        else:
            distDiag = editDistRecursive(x[:-1], y[:-1]) + 1
            
    return min(distHor, distVer, distDiag)



## using dynamic programming (much faster)
def editDistance(x, y):
    # initialize distance matrix
    D = []
    for i in range(len(x)+1):
        D.append([0]*(len(y)+1))
    for i in range(len(x)+1):
        D[i][0] = i
    for i in range(len(y)+1):
        D[0][i] = i
    
    for i in range(1, len(x)+1):
        for j in range(1, len(y)+1):
            distHor = D[i][j-1] + 1
            distVer = D[i-1][j] + 1
            if x[i-1] == y[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + 1
            D[i][j] = min(distHor, distVer, distDiag)
    return D[-1][-1]
    
    

## global alignment with specified penality matrix
alphabet = ['A', 'C', 'G', 'T']
score = [[0,4,2,4,8], \
         [4,0,4,2,8], \
         [2,4,0,4,8], \
         [8,8,8,8,8]]
         
         
def globalAlignment(x, y):
    # initialize distance matrix
    D = []
    for i in range(len(x)+1):
        D.append([0]*(len(y)+1))
    for i in range(1, len(x)+1):
        D[i][0] = D[i-1][0] + score[alphabet.index(x[i-1])][-1]
    for i in range(1, len(y)+1):
        D[0][i] = D[0][i-1] + score[-1][alphabet.index(y[i-1])]
    
    for i in range(1, len(x)+1):
        for j in range(1, len(y)+1):
            distHor = D[i][j-1] + score[-1][alphabet.index(y[j-1])]
            distVer = D[i-1][j] + score[alphabet.index(x[i-1])][-1]
            if x[i-1] == y[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + score[alphabet.index(x[i-1])][alphabet.index(y[j-1])]
            D[i][j] = min(distHor, distVer, distDiag)
    return D[-1][-1]



x = 'TACCAGATTCGA'
y = 'TACCAATTCGA'
globalAlignment(x,y)





## find the overlap between two string
def overlap(a, b, min_length=3):
    """ Return length of longest suffix of 'a' matching
        a prefix of 'b' that is at least 'min_length'
        characters long.  If no such overlap exists,
        return 0. """
    start = 0  # start all the way at the left
    while True:
        start = a.find(b[:min_length], start)  # look for b's prefix in a
        if start == -1:  # no more occurrences to right
            return 0
        # found occurrence; check for full suffix/prefix match
        if b.startswith(a[start:]):
            return len(a)-start
        start += 1  # move just past previous match
        
        
 
def overlap_all_pairs(reads, k):
    pairs = []
    for i in range(len(reads)):
        for j in range(len(reads)):
            if not i == j:
                m = overlap(reads[i], reads[j], k)
                if not m == 0:
                    pairs.append([reads[i], reads[j]])
    return pairs
    
    
reads = ['ABCDEFG', 'EFGHIJ', 'HIJABC']                    
overlap_all_pairs(reads, 4)

reads = ['CGTACG', 'TACGTA', 'GTACGT', 'ACGTAC', 'GTACGA', 'TACGAT']
t = overlap_all_pairs(reads, 4)
overlap_all_pairs(reads, 5)


def readFastq (file):
    sequences = []
    #qualities = []
    with open (file) as f:
        while True:
            f.readline()
            seq = f.readline().rstrip()
            f.readline()
            qua = f.readline().rstrip()
            if len(seq) == 0:
                break
            sequences.append(seq)
            #qualities.append(qua)
    return sequences
    
    
reads = readFastq("/Users/chenhao/Downloads/ERR266411_1.for_asm.fastq")
r = overlap_all_pairs(reads, 30)

nodes = []
for i in range(len(r)):
    nodes.append(r[i][0])
len(set(nodes))


from itertools import permutations

list(permutations([1,2,3], 3))

def naive_overlap_map(reads, k):
    olaps = {}
    for a,b in permutations(reads, 2):
        olen = overlap(a, b, min_length=k)
        if olen > 0:
            olaps[(a,b)] = olen
    return olaps
    
    
    
    
    
    
    
    
def readGenome(filename):
    genome = ''
    with open(filename, "r") as f:
        for line in f:
            if not line[0] == ">":
                genome += line.rstrip()
    return genome




def editDistance2(x, y):
    """ this is like the local alignment function but did not allow substring of x """
    
    # initialize distance matrix
    D = []
    for i in range(len(x)+1):
        D.append([0]*(len(y)+1))
    for i in range(len(x)+1):
        D[i][0] = i
    for i in range(len(y)+1):
        ## here is the only difference from 'editDistance' function above
        D[0][i] = 0  # allow start in any place of y with no penality before that position
    
    for i in range(1, len(x)+1):
        for j in range(1, len(y)+1):
            distHor = D[i][j-1] + 1
            distVer = D[i-1][j] + 1
            if x[i-1] == y[j-1]:
                distDiag = D[i-1][j-1]
            else:
                distDiag = D[i-1][j-1] + 1
            D[i][j] = min(distHor, distVer, distDiag)
    return min(D[-1])
    
  
P = "GCGTATGC"
T = "TATTGGCTATACGGTT"
editDistance2(P, T)

g = readGenome("/Users/chenhao/Downloads/chr1.GRCh38.excerpt.fasta")

x = "GCTGATCGATCGTACG"
editDistance2(x, g)

x = "GATTTACCAGATTGAG"
editDistance2(x, g)


