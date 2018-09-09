# This is a script that contains minimal functions to run Tukey's outlier method
# Created: 2018-09-08, Rebecca C. Steorts
# Last modified: 2018-09-08

# Re-defining test.tukey.outlier to incorporate a new test case
  # Return FALSE when faced with an NA value, i.e., missing is
  # not an outlier
test.tukey.outlier <- function() {
  x <- c(2.2, 7.8, -4.4, 0.0, -1.2, 3.9, 4.9, 2.0, -5.7, -7.9, -4.9,  28.7,  4.9)
  x.pattern <- rep(FALSE,length(x))
  x.pattern[12] <- TRUE
  stopifnot(all(tukey.outlier(x) == x.pattern))
  stopifnot(all(tukey.outlier(-x) == tukey.outlier(x)))
  stopifnot(all(tukey.outlier(100*x) == tukey.outlier(x)))
  x.with.nas <- x
  x.with.nas[7] <- NA
  stopifnot(all(tukey.outlier(x.with.nas)==x.pattern))
  return(TRUE)
}

# Redefine quartile to handle NAs
quartiles <- function(x) {
  q1<-quantile(x,0.25,na.rm=TRUE,names=FALSE)
  q3<-quantile(x,0.75,na.rm=TRUE,names=FALSE)
  quartiles <- c(first=q1,third=q3,iqr=q3-q1)
  return(quartiles)
}

# Redefine tukey.outlier to output FALSE where the input value
# is NA i.e., missing values are never outliers
tukey.outlier <- function(x) {
  quartiles <- quartiles(x)
  lower.limit <- quartiles[1]-1.5*quartiles[3]
  upper.limit <- quartiles[2]+1.5*quartiles[3]
  # Here, we still have NA's that need to be removed 
  outliers <- ((x < lower.limit) | (x > upper.limit))
  # Replace all NA values to FALSE 
  # We are treating them as not being outliers
  outliers[is.na(outliers)] <- FALSE
  return(outliers)
}