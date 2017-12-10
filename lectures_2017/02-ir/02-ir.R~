library(tm)
load(file="docs.Rdata")

corp = VCorpus(VectorSource(docs))
dtm = DocumentTermMatrix(corp, control=list(tolower=TRUE,removePunctuation=TRUE,removeNumbers=TRUE))

mydtm = as.matrix(dtm)
mydtm[,100:110]

# Compute unnormalized distance
q = c("but","cool","dude","party","michelangelo","raphael","rude")
dist = sqrt(rowSums((scale(mydtm,center=mydtm[9,],scale=F)^2)))
mat = cbind(mydtm[,q],dist)
colnames(mat) = c(q,"dist")

# Document length normalization
mydtm.dl = mydtm/rowSums(mydtm)
dist.dl = sqrt(rowSums((scale(mydtm.dl,center=mydtm.dl[9,],scale=F)^2)))
mat.dl = cbind(mydtm.dl[,q],dist.dl)
colnames(mat.dl) = c(q,"dist.dl")

# l2 length normalization
mydtm.l2 = mydtm/sqrt(rowSums(mydtm^2))
dist.l2 = sqrt(rowSums((scale(mydtm.l2,center=mydtm.l2[9,],scale=F)^2)))
mat.l2 = cbind(mydtm.l2[,q],dist.l2)
colnames(mat.l2) = c(q,"dist.l2")

# Compare two normalization schemes
a = cbind(mat.dl[,8],mat.l2[,8])
colnames(a) = c("dist/doclen","dist/l2len")
rownames(a) = paste(rownames(a),
c("(tmnt leo)","(tmnt rap)","(tmnt mic)","(tmnt don)",
"(real leo)","(real rap)","(real mic)","(real don)"))
