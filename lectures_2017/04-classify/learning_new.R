##Stat Learning Presentation
iris
attach(iris)
##section 4.2
print(iris,row.names=F)

y1 = I(Species == "setosa")
y2 = I(Species == "versicolor")
y3 = I(Species == "virginica")

mod1 = lm(y1 ~ Petal.Width + Petal.Length)
mod2 =lm(y2 ~ Petal.Width + Petal.Length)
mod3 =lm(y3 ~ Petal.Width + Petal.Length)

y1_hat = function(x1, x2){
	mod1$coeff%*%c(1,x1,x2)
	}
	
y2_hat = function(x1, x2){
	mod2$coeff%*%c(1,x1,x2)
	}

y3_hat = function(x1, x2){
	mod3$coeff%*%c(1,x1,x2)
	}
	
check = function(x1, x2){
	t = c(y1_hat(x1,x2),y2_hat(x1,x2),y3_hat(x1,x2))
	max1 = max(t)
	max2 = t[order(t)][2]
	max1 - max2
	}
	
contourplot(check)

b1 = mod1$coef
b2 = mod2$coef
b3 = mod3$coef


# boundary between 1 and 2
boundary12 = function(x1){
	((b2[1]-b1[1])+(b2[2]-b1[2])*x1)/(b1[3]-b2[3])
	}

# b1[1]+b1[2]*x1+b1[3]*x2 = b2[1]+b2[2]*x1+b2[3]*x2
# => (b1[3]-b2[3])*x2 = (b2[1]-b1[1])+(b2[2]-b1[2])*x1
# => x2 = ((b2[1]-b1[1])+(b2[2]-b1[2])*x1)/(b1[3]-b2[3])

# boundary between 1 and 3
boundary13 = function(x1){
	((b3[1]-b1[1])+(b3[2]-b1[2])*x1)/(b1[3]-b3[3])
	}
	
# boundary between 2 and 3
boundary23 = function(x1){
	((b3[1]-b2[1])+(b3[2]-b2[2])*x1)/(b2[3]-b3[3])
	}

pdf(file = "linear.pdf", width = 6, height = 5)
plot(Petal.Width, Petal.Length, col = as.numeric(Species), xlab = "Petal Width", ylab = " Petal Length")
legend("bottomright", c('Setosa', 'Versicolor', 'Virginica'), pch = c(1,1,1), col=c(1,2,3), bty='n', cex=1)
#plot(boundary12,add=T,xlim=c(0,3))
plot(boundary13,add=T,xlim=c(0,3)) ##this is the one we want
#plot(boundary23,add=T,xlim=c(0,3))
dev.off()


##LDA
library(MASS)
iris_lda = lda(Species ~ Petal.Width + Petal.Length)
plot(iris_lda)
predict(iris_lda, newdata = list(Petal.Width = 1, Petal.Length = 1))

nr = 100
nc = 100
x1seq = seq(min(Petal.Width),max(Petal.Width),length=nc)
x2seq = seq(min(Petal.Length),max(Petal.Length),length=nr)

	
## first function (1,2)
bound12 = matrix(0,nrow=nr,ncol=nc)
bound13 = matrix(0,nrow=nr,ncol=nc)
bound23 = matrix(0,nrow=nr,ncol=nc)
for( i in 1:nr){ 
	for( j in 1:nc){
		
		x1 = x1seq[j]
		x2 = x2seq[i]
		temp = predict(iris_lda, newdata=list(Petal.Width=x1, Petal.Length=x2))$post
		bound12[i,j] = temp[1] - temp[2]
		bound13[i,j] = temp[1] - temp[3]
		bound23[i,j] = temp[2] - temp[3]
		
		if(temp[3] > max(temp[1],temp[2])) {bound12[i,j] = bound12[i,j] + 10}
		
		if(temp[2] > max(temp[1],temp[3])) {bound13[i,j] = bound13[i,j] + 10}
		
		if(temp[1] > max(temp[2],temp[3])) {bound23[i,j] = bound23[i,j] + 10}
		
		}
	}
	bound = bound12*bound13*bound23
	
pdf(file = "lda.pdf", width = 6, height = 5)
plot(Petal.Width, Petal.Length, col = as.numeric(Species), xlab = "Petal Width", ylab = " Petal Length")
contour(bound,x=x1seq,y=x2seq,levels=c(0),add=T, drawlabels = F)
legend("bottomright", c('Setosa', 'Versicolor', 'Virginica'), pch = c(1,1,1), col=c(1,2,3), bty='n', cex=1)
dev.off()


## QDA

iris_qda = qda(Species ~ Petal.Width + Petal.Length)
plot(iris_qda)
predict(iris_qda, newdata = list(Petal.Width = 1, Petal.Length = 1))

nr = 100
nc = 100
x1seq = seq(min(Petal.Width),max(Petal.Width),length=nc)
x2seq = seq(min(Petal.Length),max(Petal.Length),length=nr)
	
boundq12 = matrix(0,nrow=nr,ncol=nc)
boundq13 = matrix(0,nrow=nr,ncol=nc)
boundq23 = matrix(0,nrow=nr,ncol=nc)
for( i in 1:nr){ 
	for( j in 1:nc){
		
		x1 = x1seq[j]
		x2 = x2seq[i]
		tempq = predict(iris_qda, newdata=list(Petal.Width=x1, Petal.Length=x2))$post
		boundq12[i,j] = tempq[1] - tempq[2]
		boundq13[i,j] = tempq[1] - tempq[3]
		boundq23[i,j] = tempq[2] - tempq[3]
		
		if(tempq[3] > max(tempq[1],tempq[2])) {boundq12[i,j] = boundq12[i,j] + 10}
		
		if(tempq[2] > max(tempq[1],tempq[3])) {boundq13[i,j] = boundq13[i,j] + 10}
		
		if(tempq[1] > max(tempq[2],tempq[3])) {boundq23[i,j] = boundq23[i,j] + 10}
		
		}
	}
	boundq = boundq12*boundq13*boundq23


pdf(file = "qda.pdf", width = 6, height = 5)
plot(Petal.Width, Petal.Length, col = as.numeric(Species), xlab = "Petal Width", ylab = " Petal Length")
contour(boundq,x=x1seq,y=x2seq,levels=c(0),add=T, drawlabels = F)
legend("bottomright", c('Setosa', 'Versicolor', 'Virginica'), pch = c(1,1,1), col=c(1,2,3), bty='n', cex=1)
dev.off()

## Fisher's example LDA
set.seed(4)
grp1h = rnorm(30, 1,2)
grp1v = grp1h + rnorm(20,0,2)
grp2h = rnorm(30, 6,2)
grp2v = grp2h+ rnorm(20, -5,2)
pdf(file = "fisher.pdf", width = 5, height = 5)
par(pty = "s")
plot(grp1h,grp1v, col = "blue", xlim = c(-6,12), ylim = c(-6,12),xlab = expression(x[1]), ylab = expression(x[2]))
points(grp2h,grp2v, col = "red")
dev.off()

ah1= mean(grp1h)
av1 = mean(grp1v)
ah2 = mean(grp2h)
av2 = mean(grp2v)
cov1 = cov(cbind(grp1h,grp1v))
cov2 = cov(cbind(grp2h,grp2v))
cov.pool = (cov1+cov2)/2
cov.pool.eig = eigen(cov.pool)
cov.pool.sqrt = cov.pool.eig$vectors %*% diag(sqrt(1/cov.pool.eig$values)) %*% solve(cov.pool.eig$vectors)
x1 = cbind(grp1h,grp1v)
x2 = cbind(grp2h,grp2v)
x1s = x1 %*% cov.pool.sqrt
x2s = x2 %*% cov.pool.sqrt
pdf(file = "fisher_trans.pdf", width = 5, height = 5)
par(pty = "s")
plot(x1s, col= "blue", xlim = c(-1,8), ylim = c(-5,4), xlab = expression("x'"[1]), ylab = expression("x'"[2]))
points(x2s, col = "red")
m = (mean(x2s[,2]) - mean(x1s[,2]))/(mean(x2s[,1])-mean(x1s[,1]))
abline(mean(x1s[,2]) - m*mean(x1s[,1]),m)
text(-0.5,1.5,expression("x''"[1]))

##perp line
abline(-7.5,-1/m)
text(4.5,4,expression("x''"[2]))
dev.off()






