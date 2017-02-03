rm(list = ls())
tropical = c("darkorange", "dodgerblue", "hotpink", "limegreen", "yellow")
palette(tropical)

par(pch = 19)


suppressPackageStartupMessages({
    library(gplots)
    library(devtools)
    library(Biobase)
    library(RSkittleBrewer)
    library(org.Hs.eg.db)
    library(AnnotationDbi)
})


library(Biobase)
library(GenomicRanges)
library(SummarizedExperiment)
data(sample.ExpressionSet, package = "Biobase")
se = makeSummarizedExperimentFromExpressionSet(sample.ExpressionSet)



con =url("http://bowtie-bio.sourceforge.net/recount/ExpressionSets/bottomly_eset.RData")
load(file=con)
close(con)
bot = bottomly.eset
pdata_bot=pData(bot)



con =url("http://bowtie-bio.sourceforge.net/recount/ExpressionSets/bodymap_eset.RData")
load(file=con)
close(con)
bm = bodymap.eset
pdata_bm=pData(bm)
pdata = pData(bm)
edata = exprs(bm)

s1 = edata[,1]
s2 = edata[,2]

## MA-plot with different transformation
plot( (log2(s1+1)+log2(s2+1))/2, log2(s1+1)-log2(s2+1) )


rlog_edata <- rlog(edata)
rs1 = rlog_edata[,1]
rs2 = rlog_edata[,2]
plot( (rs1 + rs2)/2, rs1-rs2 )



## clustering
con =url("http://bowtie-bio.sourceforge.net/recount/ExpressionSets/montpick_eset.RData")
load(file=con)
close(con)
mp = montpick.eset
pdata=pData(mp)
edata=as.data.frame(exprs(mp))
fdata = fData(mp)

library(rafalib)
myplclust



# 1. With no changes to the data
edist = dist(t(edata))
hc = hclust(edist)
myplclust(hc, labels = hc$labels, lab.col = as.numeric(pdata$study), cex = 0.6)

# 2. After filtering all genes with 𝚛𝚘𝚠𝙼𝚎𝚊𝚗𝚜 less than 100
edist2 <- dist(t(edata[rowMeans(edata) >= 100, ]))
hc2 = hclust(edist2)
myplclust(hc2, labels = hc2$labels, lab.col = as.numeric(pdata$study), cex = 0.6)

# 3. After taking the 𝚕𝚘𝚐𝟸 transform of the data without filtering
edist3 <- dist(t(log2(edata+1)))
hc3 = hclust(edist3)
myplclust(hc3, labels = hc3$labels, lab.col = as.numeric(pdata$study), cex = 0.6)



## k-means clustering
set.seed(1235)
loge <- log2(edata+1)
kc <- kmeans(t(loge), 2)

kcc <- kc$cluster
table(kcc)
hcc <- cutree(hc3,k = 2)
table(hcc)
t <- as.numeric(pdata$study)
table(t)
sum(abs(t - kcc))
sum(abs(t - hcc))
sum(t == hcc)










