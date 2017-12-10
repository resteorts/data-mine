install.packages("ISLR",dependencies=TRUE)
library(ISLR)
attach(Default)
head(Default)
names(Default)
##Try and reproduce the figures 4.1 and 4.2
##red == default
##blue == did not default

##need to separate out the yes and no's below
##need to remember how to do a logistic plot

pdf(file = "scatter-default.pdf")
plot(balance,income, pch = ifelse(default=="Yes",3,1), col = ifelse(default=="Yes","red","blue") ,cex = 0.5, xlab= "balance" , ylab = "income")
dev.off()

pdf(file = "boxplox_balance-and-income.pdf")
par(mfrow=c(1,2))
boxplot(balance ~ default,col = c("blue", "red"),xlab ="default",ylab="balance")
boxplot(income ~ default,col = c("blue", "red"),xlab ="default",ylab="income")
dev.off()


default.01 <- ifelse(default== "Yes",1,0)
##not sure what's wrong with the code below
lm.default <- lm(default.01~student+balance+income,data=Default)



pdf(file = "lm-and-glm_default.pdf", width=7,height=5)
par(mfrow=c(1,2))
curve(predict(lm.default,data.frame(student="Yes",balance=x,income=40000),type="resp"),from=0,to=2700,ylim=c(-.1,1), xlab= "balance" , ylab = "income")
points(balance,ifelse(default=="Yes",1,0), col = ifelse(default=="Yes","red","blue"), pch=20 , cex=0.5)


#plot(glm_default.pdf)
glm.default <- glm(default~student+balance+income,family="binomial",data=Default)
curve(predict(glm.default,data.frame(student="Yes",balance=x,income=40000),type="resp"),from=0,to=2700, xlab= "balance" , ylab = "income")
# draws a curve based on prediction from logistic regression model

##giving whether they actually defaulted or not
points(balance,ifelse(default=="Yes",1,0), col = ifelse(default=="Yes","red","blue"), pch=20 , cex=0.5)
dev.off()


