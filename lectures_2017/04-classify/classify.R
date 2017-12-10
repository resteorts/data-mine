# Consider the Default data set in R
# Our goal is to predict the default (credit card) using balance 

library(ISLR)
library(plyr)
attach(Default)
names(Default)
#default <- revalue(default, c("Yes"="1", "No"="0"))
head(default)

sum(default)

# we must give the factor ordered labelings
# for a review of factors, see 
# https://www.youtube.com/watch?v=xkRBfy8_2MU
default_factor <- factor(default, ordered=TRUE, levels=c(0,1))

# linear regression 
lm.fit <- lm(as.numeric(default)~balance, data=Default)
plot(balance, default,xlab="balance", ylab= "default (1=No, 2=Yes)")
abline(lm.fit, col="red", lwd=3)


# logistic regression
glm.fit <- glm(default~balance, family="binomial", data=Default)
summary(glm.fit)
plot(balance,default, xlab="balance", ylab= "default (1=No, 2=Yes)")
fitted <- fitted(glm.fit) + 1
points(balance, fitted, types="l", col="red")

predict(glm.fit, 1000, type="response")

## now look at MLR

glm.fit.mlr <- glm(default~balance + income + student, family="binomial", data=Default)
glm.fit.mlr$coeff
summary(glm.fit.mlr)

plot(student, balance, col= c("blue","orange"))
glm.probs <- predict(glm.fit.mlr, student, type="response")
plot(balance, glm.probs, col=c("blue","orange"), xlab="Credit Card Balance", ylab="Default Rate")

glm.fit.mlr <- glm(default~balance, family="binomial", data=Default)
glm.probs <- predict(glm.fit.mlr, student, type="response")
plot(balance, glm.probs, col=c("blue","orange"))




library(ggplot2)
qplot(student, default, data=Default,
   xlab="Horsepower", ylab="Miles per Gallon") 


glm.probs <- predict(glm.fit.mlr, student, type="response")
par(mfrow=c(1,2))
par(mar=c(0.5, 4.5, 0.5, 0.5))
plot(student, balance, col= c("blue","orange"))
plot(balance, glm.probs, col=c("blue","orange"), xlab="Credit Card Balance", ylab="Default Rate")



