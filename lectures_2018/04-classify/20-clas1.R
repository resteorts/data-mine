library(classifly)
data(olives)

y = as.numeric(olives[,1])
x = as.matrix(olives[,3:10])

n = nrow(x)
p = ncol(x)

pi = numeric(3)
mu = matrix(0,3,8)

for (j in 1:3) {
  pi[j] = sum(y==j)/n
  mu[j,] = colMeans(x[y==j,])
}

Sigma = matrix(0,p,p)
for (j in 1:3) {
  A = scale(x[y==j,],center=T,scale=F)
  Sigma = Sigma + t(A)%*%A
}
Sigma = Sigma/(n-3)
Sigmainv = solve(Sigma)

lda.classify = function(x0, pi, mu, Sigmainv) {
  K = length(pi)
  delta = numeric(K)
  for (j in 1:K) {
    delta[j] = t(x0) %*% Sigmainv %*% mu[j,] -
      0.5 * t(mu[j,]) %*% Sigmainv %*% mu[j,] + log(pi[j])
  }
  return(which.max(delta))
}

yhat = numeric(n)
for (i in 1:n) {
  yhat[i] = lda.classify(x[i,],pi,mu,Sigmainv)
}

# Training errors
sum(yhat!=y)

# Still left with some questions ...

# How would we visualize the LDA classification rule,
# i.e., the decision boundaries here, since p=8?

library(MASS)
a = lda(x,y)
cols = c("red","darkgreen","blue")
z = x %*% a$scaling # What are these "scalings"?
plot(z,col=cols[y]) # What is this showing?
