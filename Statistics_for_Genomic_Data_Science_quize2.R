par(pch = 19)
library(broom)

## Load the Montgomery and Pickrell eSet
con =url("http://bowtie-bio.sourceforge.net/recount/ExpressionSets/montpick_eset.RData")
load(file=con)
close(con)
mp = montpick.eset
pdata=pData(mp)
edata=as.data.frame(exprs(mp))
fdata = fData(mp)


svd1 = svd(edata)
plot(svd1$d,ylab="Singular value",col=2)
plot(svd1$u[,1], svd1$u[,2])
head(svd1$d^2/sum(svd1$d^2))

edata_log <- log2(edata + 1)
svd2 = svd(edata_log)
head(svd2$d^2/sum(svd2$d^2))

edata_norm <- edata_log - rowMeans(edata_log)
svd3 = svd(edata_norm)
head(svd3$d^2/sum(svd3$d^2))
plot(svd3$u[,1], svd3$u[,2])

pca <- prcomp(edata_log, center = TRUE)
plot(pca$x[,1:2])


set.seed(333)
kc <- kmeans(t(edata_norm), centers = 2)
cor(svd3$v[,1], kc$cluster, method = "spearman")


md1 <- model.matrix( ~ pdata$population)
fit1 = lm.fit(md1, t(edata_log))



## Load the Bodymap data
con =url("http://bowtie-bio.sourceforge.net/recount/ExpressionSets/bodymap_eset.RData")
load(file=con)
close(con)
bm = bodymap.eset
edata = exprs(bm)
pdata_bm=pData(bm)


lm1 <- lm(edata[1,] ~ factor(pdata_bm$num.tech.reps))
tidy(lm1)


lm2 <- lm(edata[1,] ~ pdata_bm$age + pdata_bm$gender)
tidy(lm2)


library(limma)
age_miss <- is.na(pdata_bm$age)
md2 <- model.matrix(~pdata_bm$age[!age_miss])
fit_limma = lmFit(edata[, !age_miss], md2)
fit_limma$coefficients[1000, ]

plot(pdata_bm$age[!age_miss], edata[1000, !age_miss])
abline(fit_limma$coefficients[1000, ][1], fit_limma$coefficients[1000, ][2])



md3 <- model.matrix(~pdata_bm$age[!age_miss] + pdata_bm$tissue.type[!age_miss])
fit_limma2 = lmFit(edata[, !age_miss], md2)

fit_limma$coefficients[1000, ]


library(sva)

edata_log <- log2(edata + 1)
data <- edata_log[rowMeans(edata_log) >= 1, !age_miss]
age <- pdata_bm$age[!age_miss]
pda <- pdata_bm[!age_miss, ]

set.seed(33353)
md4 = model.matrix( ~ age, data = pda)
md0 = model.matrix( ~ 1, data=pda)
sva1 = sva(data, md4, md0, n.sv=1)
cor(sva1$sv,  pda$age)

plot(pda$race, sva1$sv)
plot(pda$gender, sva1$sv)





