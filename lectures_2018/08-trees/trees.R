library(ISLR)
install.packages("tree",dependencies=TRUE)
library(tree)
head(Hitters)
attach(Hitters)
Hitters <- na.omit(Hitters)
salary.log <- log(Salary)

##tree on all data
tree.hitters <- tree(salary.log ~ Years + Hits, data = Hitters)
summary(tree.hitters)
High <- ifelse(Salary <= 400, "No","Yes")
Hitters <- data.frame(Hitters,High)

#plotting tree without pruning
#did lab for classification tree
plot(tree.hitters)
text(tree.hitters, pretty=0)

set.seed(2)
train <- sample(1:nrow(Hitters),63)
hitters.test <- Hitters[-train,]
High.test <- High[-train]
##tree on training data
tree.hitters.train <- tree(High ~ Years + Hits, data = Hitters,subset=train)
tree.pred <- predict(tree.hitters.train, hitters.test, type="class")
#confusion matrix
table(tree.pred, High.test)
correct.pred = (30 + 20)/63
##why is it so low at 25 percent? 

?tree()

##does pruning the tree lead to improved results?

set.seed(3)
cv.hitters <- cv.tree(tree.hitters.train, FUN=prune.misclass)
names(cv.hitters)
cv.hitters

#we plot the error rate as a function of size and k
par(mfrow=c(1,2))
plot(cv.hitters$size, cv.hitters$dev, type = "b",xlab="size of tree", ylab = "CV error")
plot(cv.hitters$k, cv.hitters$dev, type = "b",xlab="penalty for size of tree", ylab = "CV error")

prune.hitters <- prune.misclass(tree.hitters.test,best=4)
plot(prune.hitters)
text(prune.hitters,pretty=0)
tree.pred <- predict(prune.hitters, hitters.test, type="class")
table(tree.pred, High.test)
correct.pred.prune = (29+20)/200
#The misclass rate goes up 

pdf("hitters_error_plot_classification.pdf")
plot(cv.hitters$size,cv.hitters$dev/nrow(Hitters[train,]),type="b",xlab="size of tree",ylab = "error", ylim=c(0,1),col=1)
train.error <- prune.misclass(tree.hitters.train,newdata=Hitters[train,])$dev/nrow(Hitters[train,])
test.error <- prune.misclass(tree.hitters.train,newdata=hitters.test)$dev/nrow(hitters.test)
points(cv.hitters$size,train.error,col=2,type="b")
points(cv.hitters$size,test.error,col=3,type="b")
legend("topright",legend=c("CV","training","test"),col=c(1,2,3),lty=rep(1,3))
dev.off()

##need trees for train and and evaluate on train and test and loop over each size of the tree
##figure out how to make a plot like in the book earlier. not sure how to make them for the other ones. need to write a function or loops.

#Now do the lab for the regression tree

set.seed(4)
train.regression <- sample(1:nrow(Hitters),nrow(Hitters)/2)
#first we need a training set, which we have already created
#now, create the regression tree
summary(tree.hitters.train)
plot()

tree(formula = High ~ Years + Hits, data = Hitters,subset=train)



