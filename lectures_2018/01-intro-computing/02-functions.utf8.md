
---
title: "Introduction to Functions"
author: "Rebecca C. Steorts, Duke University "
date: STA 325, Supplemental Material
output: 
     beamer_presentation:
      includes: 
          in_header: custom2.tex
font-size: 8px
---

Agenda
===
- Defining functions: Tying related commands into bundles

Why Functions?
===

- Data structures tie related values into one object

- Functions tie related commands into one object

- Both data structures and functions are easier to work with

Defining a function
===

```
function.name <- function(arguments){
  # computations on the arguments
  # some other code
  # return desired output
}
```

What should be a function?
===

- Things you're going to re-run, especially if they will be re-run with changes
- Chunks of code you keep highlighting and hitting return on
- Chunks of code that are small parts of bigger analyses
- Chunks that are very similar to other chunks

Trivial Example
===

Suppose we'd like to write a function to take the square of a number (or vector of numbers). 

Squaring a number
===


```r
# Input: a number (scalar, vector, matrix)
# Output: the number squared
squared <- function(number) {
     return(number^2)
}
```

Squaring a number
===
Let's test our function


```r
squared(8)
```

```
## [1] 64
```

```r
squared(c(1,2,3,4))
```

```
## [1]  1  4  9 16
```

```r
squared(matrix(c(1,2,3,4),nrow=2))
```

```
##      [,1] [,2]
## [1,]    1    9
## [2,]    4   16
```

Example: Fitting a Model
===

Fact: bigger cities tend to produce more economically per capita

A proposed statistical model (Geoffrey West et al.):

\[
Y = y_0 N^{a} + \mathrm{noise}
\]

where we have the following notation:

- $Y$ is the per-capita "gross metropolitan product" of a city, 
- $N$ is its population, 
- and $y_0$ and $a$ are fixed (known) parameters



Example: Fitting a Model
===
\footnotesize

```r
gmp <- read.table("gmp.dat")
head(gmp)
```

```
##                           MSA        gmp pcgmp
## 1                 Abilene, TX 3.8870e+09 24490
## 2                   Akron, OH 2.2998e+10 32889
## 3                  Albany, GA 3.9550e+09 24269
## 4 Albany-Schenectady-Troy, NY 3.1321e+10 36836
## 5             Albuquerque, NM 3.0727e+10 37657
## 6              Alexandria, LA 3.8790e+09 25494
```

```r
(gmp$pop <- gmp$gmp/gmp$pcgmp)
```

```
##   [1]   158717.84   699261.15   162965.10   850282.33   815970.47
##   [6]   152153.45   794430.63   125518.36   239816.08    83516.05
##  [11]   358813.79   130999.87   176947.56   346177.74   112581.81
##  [16]   216132.40   396976.90   182713.02  5113957.70   269322.28
##  [21]   127938.40   522080.40  1527046.73   770226.28  2658030.83
##  [26]   147825.50   223314.74   763582.68   137179.36   107909.58
##  [31]   373829.25   188300.89   148825.14   147666.53   246426.53
##  [36]  1100296.33   101148.18   155789.02   181538.09   161638.93
##  [41]   566392.18  4467211.94   285047.26   113890.96   678839.01
##  [46]   239767.35   890510.01   378190.41    99824.16  1132002.50
##  [51]   141495.84   206244.26   407364.62   568287.45    92633.32
##  [56]    54978.79    70215.84   249383.33   221247.23   303595.90
##  [61]   616638.65  1580061.13   190189.08   509183.49    85902.37
##  [66]  9439746.58   217116.40  2119967.63   252444.48   109333.91
##  [71]  2103841.64   130543.90   200058.82   601423.82   159413.67
##  [76]   702914.47   289981.77    73891.84  1732484.81   412668.30
##  [81]    80104.99    99099.10  5995545.30   131919.91    81647.68
##  [86]   106140.12   373912.55   840961.42   147776.43   109085.68
##  [91]   495022.41  2403111.52   534666.64  4486566.72   137467.65
##  [96]   147532.42    91403.25   273661.25   467130.77   156020.00
## [101]   156979.36   110605.78   196340.91    88084.32   722454.93
## [106]   279640.83   339425.68   348594.83    94815.69   188947.65
## [111]   121613.16   348061.00   422435.23   125982.82   437428.90
## [116]   197602.76   142365.89    98653.29   280938.33   285899.28
## [121]   182839.10   405699.08   882174.76   102751.59   252903.48
## [126]   171449.21   128009.40   112614.63    97708.04   133872.45
## [131]   771267.49    81844.90   234696.52   298315.61   684548.32
## [136]   168422.21   599501.32   227196.37   255861.29   145721.59
## [141]   524103.19   116064.40  1183276.94   135066.96   356224.90
## [146]    71470.05   256515.61   904134.47    95141.16   200810.56
## [151]  5485516.33   284240.45   377736.28   115265.55  1668228.16
## [156]   144283.12   100078.13   162888.46   530520.23   112000.70
## [161]  1276500.41   160900.11   158046.57   144490.58   191239.81
## [166]   145920.13   114465.74   168337.12   321434.40   109923.94
## [171]  1958304.97   222854.07   357877.92   301371.93   181670.08
## [176]   669520.78    99916.38   129798.23   188300.10   254371.03
## [181]   190897.87   192543.89   556773.53   493328.32   455452.70
## [186]   226435.71   193456.05  1770683.78   112545.68   112254.68
## [191]   126400.72    59557.01   106911.21   439867.80   105188.38
## [196]   287767.72   656597.73   118406.09   201328.58    98687.45
## [201] 12796910.62  1218982.82   265893.73   240056.48   228790.04
## [206]   143309.66   546482.67   400000.00   116944.27    90767.56
## [211]   126290.35   686016.89   196487.83  1270272.21   241260.34
## [216]  5402390.73   109171.70   123444.23  1538709.96  3164192.52
## [221]   103959.40   401642.11   505224.54   172422.64   153150.40
## [226]   362455.80   116773.02   131921.82   114129.71   115510.20
## [231]   174022.64   239489.83   130854.24   311588.64  1485712.99
## [236]   841882.52   991905.02 18848354.21   159349.20   267884.62
## [241]   313754.47    97535.75   126460.27   503208.49  1173280.42
## [246]   232858.49   819055.46  1993952.22   160248.97   111289.55
## [251]   791249.31   530975.27    82286.47   163922.46   160942.98
## [256]   149466.64   450715.26   368644.29  5805310.30  4035182.75
## [261]   102745.13  2360741.67   130351.36    87053.57   511183.91
## [266]  2126476.75   387640.00   665552.09   206288.82  1603651.01
## [271]   491167.38   151705.52   152784.65   198091.90   997122.94
## [276]   118940.53   398339.84   178253.89   401133.13  1193879.26
## [281]  3982476.14   294173.54   178363.12  1032854.92   344644.09
## [286]   144368.46    95021.96  2055976.39   204858.35   183258.40
## [291]   127093.42   124291.03  2790752.54   378588.05   403921.15
## [296]   117885.15  1074269.57   107525.18  1931993.57  2937011.58
## [301]    77409.62  4177580.70  1762251.16   259658.55   400391.56
## [306]   249628.79   140644.58   460954.01   321193.68   548038.36
## [311]  3253974.78   129293.07   113888.45   116835.44   386903.69
## [316]   141653.01   221462.76   315824.53   269551.78   446928.26
## [321]   205662.10   686690.99   410118.44   140977.36   143783.11
## [326]   662407.53   104082.66   644858.71   347327.61  2687132.85
## [331]   169953.05   133828.70   651761.13   227295.58   363257.44
## [336]   974133.10   891186.91   202385.81   194294.22   294041.93
## [341]   128271.16   407067.28   112501.47   153913.57  1661636.86
## [346]   412052.87   225700.82   127982.36  5259826.70   162819.41
## [351]   128792.84   123832.54   104960.56   146684.22   588026.19
## [356]   149302.86   117249.80   328591.53   118654.71   453707.36
## [361]   780639.20   230143.94   413969.74   576247.07   159817.99
## [366]   185088.58
```

Example: Fitting a Model
===
![](02-functions_files/figure-beamer/unnamed-chunk-4-1.pdf)<!-- --> 

Example: Fitting a Model
===

We want to fit the model
$$
Y = y_0 N^{a} + \mathrm{noise}
$$

Take $y_0=6611$  for today

Suppose we want to fit the above model, calculate its mean squared error,
and then we stop fitting the model when the derivative of the MSE "stops changing"
by some small amount. Our goal will be to write this into a function. 

Mean squared error (MSE) and its derivative 
===

Approximate the derivative of error w.r.t $a$ using the following: 

$$
\begin{aligned}
MSE(a) & \equiv & \frac{1}{n}\sum_{i=1}^{n}{(Y_i - y_0 N_i^a)^2}\\
MSE^{\prime}(a) & \approx & \frac{MSE(a+h) - MSE(a)}{h}\\
a_{t+1} - a_{t} & \propto & -MSE^{\prime}(a)
\end{aligned}
$$

The Quick Approach (No Function) 
===
\tiny

```r
maximum.iterations <- 100
deriv.step <- 1/1000
step.scale <- 1e-12
stopping.deriv <- 1/100
iteration <- 0
deriv <- Inf
a <- 0.15
while ((iteration < maximum.iterations) && (deriv > stopping.deriv)) {
  iteration <- iteration + 1
  mse.1 <- mean((gmp$pcgmp - 6611*gmp$pop^a)^2)
  mse.2 <- mean((gmp$pcgmp - 6611*gmp$pop^(a+deriv.step))^2)
  deriv <- (mse.2 - mse.1)/deriv.step
  a <- a - step.scale*deriv
}
list(a=a,iterations=iteration,converged=(iteration < maximum.iterations))
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

What's wrong with this?
===

-  Not _encapsulated_: Re-run by cutting and pasting code --- but how
  much of it? Also, hard to make part of something larger
-  _Inflexible_: To change initial guess at $a$, have to edit, cut,
  paste, and re-run
-  _Error-prone_: To change the data set, have to edit, cut, paste,
  re-run, and hope that all the edits are consistent
-  _Hard to fix_: should stop when _absolute value_ of derivative is
  small, but this stops when large and negative.  Imagine having five copies of
  this and needing to fix same bug on each.

Let's turn this into a function and try to gain improvements! 

First Attempt
===
\tiny

```r
estimate.scaling.exponent.1 <- function(a) {
  maximum.iterations <- 100
  deriv.step <- 1/1000
  step.scale <- 1e-12
  stopping.deriv <- 1/100
  iteration <- 0
  deriv <- Inf
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    mse.1 <- mean((gmp$pcgmp - 6611*gmp$pop^a)^2)
    mse.2 <- mean((gmp$pcgmp - 6611*gmp$pop^(a+deriv.step))^2)
    deriv <- (mse.2 - mse.1)/deriv.step
    a <- a - step.scale*deriv
  }
  fit <- list(a=a,iterations=iteration, converged=(iteration < maximum.iterations))
  return(fit)
}
estimate.scaling.exponent.1(a=0.15)
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

But why do we have many fixed constants running around? 

Fixing the fixed constants
===
\tiny

```r
estimate.scaling.exponent.2 <- function(a, y0=6611,
  maximum.iterations=100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    mse.1 <- mean((gmp$pcgmp - y0*gmp$pop^a)^2)
    mse.2 <- mean((gmp$pcgmp - y0*gmp$pop^(a+deriv.step))^2)
    deriv <- (mse.2 - mse.1)/deriv.step
    a <- a - step.scale*deriv
  }
  fit <- list(a=a,iterations=iteration,
    converged=(iteration < maximum.iterations))
  return(fit)
}
estimate.scaling.exponent.2(a=0.15)
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

Why type out the same calculation of the MSE twice? 
Instead, let's create a function for this. 

Creating an MSE function
===
\tiny

```r
estimate.scaling.exponent.3 <- function(a, y0=6611,
  maximum.iterations=100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  mse <- function(a) { mean((gmp$pcgmp - y0*gmp$pop^a)^2) }
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    deriv <- (mse(a+deriv.step) - mse(a))/deriv.step
    a <- a - step.scale*deriv
  }
  fit <- list(a=a,iterations=iteration,
    converged=(iteration < maximum.iterations))
  return(fit)
}
estimate.scaling.exponent.3(a=0.15)
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

We're locked in to using specific columns of `gmp`; shouldn't have to re-write just to compare two data sets. Let's add more arguments for the response and preditor variables. 

More arguments (with defaults)
===
\tiny

```r
estimate.scaling.exponent.4 <- function(a, y0=6611,
  response=gmp$pcgmp, predictor = gmp$pop,
  maximum.iterations=100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  iteration <- 0
  deriv <- Inf
  mse <- function(a) { mean((response - y0*predictor^a)^2) }
  while ((iteration < maximum.iterations) && (abs(deriv) > stopping.deriv)) {
    iteration <- iteration + 1
    deriv <- (mse(a+deriv.step) - mse(a))/deriv.step
    a <- a - step.scale*deriv
  }
  fit <- list(a=a,iterations=iteration,
    converged=(iteration < maximum.iterations))
  return(fit)
}
estimate.scaling.exponent.4(a=0.15)
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

We could turn the `while()` loop into
a `for()` loop, and nothing outside the function would change.

Replacing `while()` loop with `for()` loop
===
\tiny

```r
estimate.scaling.exponent.5 <- function(a, y0=6611,
  response=gmp$pcgmp, predictor = gmp$pop,
  maximum.iterations=100, deriv.step = .001,
  step.scale = 1e-12, stopping.deriv = .01) {
  mse <- function(a) { mean((response - y0*predictor^a)^2) }
  for (iteration in 1:maximum.iterations) {
    deriv <- (mse(a+deriv.step) - mse(a))/deriv.step
    a <- a - step.scale*deriv
    if (abs(deriv) <= stopping.deriv) { break() }
  }
  fit <- list(a=a,iterations=iteration,
    converged=(iteration < maximum.iterations))
  return(fit)
}
estimate.scaling.exponent.5(a=0.15)
```

```
## $a
## [1] 0.1258166
## 
## $iterations
## [1] 58
## 
## $converged
## [1] TRUE
```

Final Code
===

The final code is shorter, clearer, more flexible, and more re-usable

_Exercise:_ Run the code with the default values to get
an estimate of $a$; plot the curve along with the data points

_Exercise:_ Randomly remove one data point --- how much does the estimate change?

_Exercise:_ Run the code from multiple starting points --- how different
are the estimates of $a$?

Summary
===

-  **Functions** bundle related commands together into objects.
- Using functions make code easier to re-run, easier to re-use, easier to combine, easier to modify, less risk of error, easier to conceptualize.
- We can write nice, clean programs by writing code that includes many functions. 


