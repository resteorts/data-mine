# Hierarchical agglomerative clustering example
set.seed(0)
x = matrix(runif(7*2),ncol=2)

pdf(file="agclustex.pdf",width=4,height=4)
par(mar=c(4.5,4.5,0.5,0.5))
plot(x,xlab="Dimension 1",ylab="Dimension 2",main="")
d = 0.04
text(x[,1]+d-2*d*(x[,1]>0.5),x[,2],labels=1:7)
graphics.off()

hc = hclust(dist(x),method="average")

pdf(file="agclustex2.pdf",width=10,height=5)
par(mfrow=c(1,2))
par(mar=c(4.5,4.5,0.5,2.5))
plot(x,xlab="Dimension 1",ylab="Dimension 2",main="")
d = 0.04
text(x[,1]+d-2*d*(x[,1]>0.5),x[,2],labels=1:7)
par(mar=c(2,4.5,0.5,0.5))
plot(hc,main="",hang=-1e-10)
graphics.off()

pdf(file="noinv.pdf",width=5,height=5) 
par(mar=c(0.5,4.5,0.5,0.5))
plot(hc,main="",hang=-1e-10)
abline(h=hc$height,lty=2)
text(rep(1,6)+0.2,hc$height+0.02,
as.character(round(hc$height,2)))
graphics.off()

# Linkages
set.seed(0)
x = rbind(matrix(rnorm(2*50,mean=1,sd=0.7),ncol=2),
matrix(rnorm(2*50,mean=-1,sd=0.8),ncol=2))

dmin = Inf
dmax = 0
imin = 0; jmin = 0
imax = 0; jmax = 0
for (i in 1:50) {
for (j in 51:100) {
a = sqrt(sum((x[i,]-x[j,])^2))
if (a<dmin) {
dmin=a
imin=i; jmin=j
}
if (a>dmax) {
dmax=a
imax=i; jmax=j
}
}}

pdf(file="single.pdf",width=5,height=5)
par(mar=c(3.5,3.5,0.5,0.5))
plot(x,xlab="",ylab="",
col=c(rep("red",50),rep("blue",50)))
segments(x[imin,1],x[imin,2],x[jmin,1],x[jmin,2])
graphics.off()

pdf(file="complete.pdf",width=5,height=5)
par(mar=c(3.5,3.5,0.5,0.5))
plot(x,xlab="",ylab="",
col=c(rep("red",50),rep("blue",50)))
segments(x[imax,1],x[imax,2],x[jmax,1],x[jmax,2])
graphics.off()

pdf(file="average.pdf",width=5,height=5)
par(mar=c(3.5,3.5,0.5,0.5))
plot(x,xlab="",ylab="",
col=c(rep("red",50),rep("blue",50)))
for (i in imin:imin) {
for (j in 51:100) {
segments(x[i,1],x[i,2],x[j,1],x[j,2])
}
}
graphics.off()


cols = c(2,4,3)

## Examples
set.seed(0)
x = rbind(matrix(rnorm(2*20,mean=-1),ncol=2),
matrix(rnorm(2*30,mean=1),ncol=2))
x = rbind(x,matrix(runif(2*10,min(x),max(x)),ncol=2))
d = dist(x)

hcsing = hclust(d,method="single")
labssing = cutree(hcsing,h=0.9)

pdf(file="exsing.pdf",width=10,height=5)
par(mfrow=c(1,2))
par(mar=c(3.5,3.5,0.5,2.5))
plot(x,xlab="",ylab="",col=cols[labssing])
par(mar=c(2,4.5,0.5,0.5))
plot(hcsing,main="",labels=FALSE,hang=-1e-10)
abline(h=0.9,lty=2)
graphics.off()

hccomp = hclust(d,method="complete")
labscomp = cutree(hccomp,h=5)

pdf(file="excomp.pdf",width=10,height=5)
par(mfrow=c(1,2))
par(mar=c(3.5,3.5,0.5,2.5))
plot(x,xlab="",ylab="",col=cols[labscomp])
par(mar=c(2,4.5,0.5,0.5))
plot(hccomp,main="",labels=FALSE,hang=-1e-10)
abline(h=5,lty=2)
graphics.off()

hcavg = hclust(d,method="average")
labsavg = cutree(hcavg,h=2.5)

pdf(file="exavg.pdf",width=10,height=5)
par(mfrow=c(1,2))
par(mar=c(3.5,3.5,0.5,2.5))
plot(x,xlab="",ylab="",col=cols[labsavg])
par(mar=c(2,4.5,0.5,0.5))
plot(hcavg,main="",labels=FALSE,hang=-1e-10)
abline(h=2.5,lty=2)
graphics.off()

pdf(file="props1.pdf",width=4.5,height=4.5)
par(mar=c(3.5,3.5,3.5,3.5))
plot(x,main="Single",xlab="",ylab="",col=cols[labssing])
graphics.off()

pdf(file="props2.pdf",width=4.5,height=4.5)
par(mar=c(3.5,3.5,3.5,3.5))
plot(x,main="Complete",xlab="",ylab="",col=cols[labscomp])
graphics.off()

pdf(file="props3.pdf",width=4.5,height=4.5)
par(mar=c(3.5,3.5,3.5,3.5))
plot(x,main="Average",xlab="",ylab="",col=cols[labsavg])
graphics.off()

hcavg2 = hclust(d^2,method="average")
labsavg2 = cutree(hcavg2,h=8)

pdf(file="mono1.pdf",width=4.5,height=4.5)
par(mar=c(3.5,3.5,3.5,3.5))
plot(x,main="Avg linkage: distance",xlab="",
ylab="",col=cols[labsavg])
graphics.off()

pdf(file="mono2.pdf",width=4.5,height=4.5)
par(mar=c(3.5,3.5,3.5,3.5))
plot(x,main="Avg linkage: distance^2",xlab="",
ylab="",col=cols[c(2,1,3)][labsavg2])
graphics.off()


# Choosing the number of clusters example
set.seed(0)
x = rbind(matrix(rnorm(50*2,sd=0.2),ncol=2),
scale(matrix(rnorm(50*2,sd=0.2),ncol=2),cent=-c(1,0),scale=F),
scale(matrix(rnorm(50*2,sd=0.2),ncol=2),cent=-c(1,1),scale=F),
scale(matrix(rnorm(50*2,sd=0.2),ncol=2),cent=-c(1,1),scale=F),
scale(matrix(rnorm(50*2,sd=0.2),ncol=2),cent=-c(0.2,0.6),scale=F))

c3 = kmeans(x,3,algorithm="Lloyd",nstart=10,iter.max=100)
c4 = kmeans(x,4,algorithm="Lloyd",nstart=10,iter.max=100)
c5 = kmeans(x,5,algorithm="Lloyd",nstart=10,iter.max=100)

pdf(file="choosek.pdf",height=8,width=8)
par(mfrow=c(2,2))
par(mar=c(3.5,3.5,3,0.5))
plot(x,xlab="",ylab="",main="K = 3",col=c3$cluster+1)
points(c3$centers,col=2:4,pch=19,cex=2)
points(c3$centers,cex=2)

plot(x,xlab="",ylab="",main="K = 4",col=c4$cluster+1)
points(c4$centers,col=2:5,pch=19,cex=2)
points(c4$centers,cex=2)

plot(x,xlab="",ylab="",main="K = 5",col=c5$cluster+1)
points(c5$centers,col=2:6,pch=19,cex=2)
points(c5$centers,cex=2)

plot(3:5,c(c3$tot.withinss,c4$tot.withinss,c5$tot.withinss),
xlab="",ylab="",main="Within-cluster variation",type="b")
graphics.off()
