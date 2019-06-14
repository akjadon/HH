Car Price Prediction Model
================

Load Libraries----
------------------

``` r
    library(caret)
    library(tidyr)
    library(MASS)
    library(car)
```

### Load Car Price data ----

``` r
    carprice <- read.csv("CarPrice_Assignment.csv")
```

|     car\_ID|     symboling| CarName                  | fueltype | aspiration | doornumber | carbody     | drivewheel | enginelocation |  wheelbase|  carlength|  carwidth|  carheight|  curbweight| enginetype | cylindernumber |  enginesize| fuelsystem |  boreratio|  stroke|  compressionratio|  horsepower|  peakrpm|  citympg|  highwaympg|     price|
|-----------:|-------------:|:-------------------------|:---------|:-----------|:-----------|:------------|:-----------|:---------------|----------:|----------:|---------:|----------:|-----------:|:-----------|:---------------|-----------:|:-----------|----------:|-------:|-----------------:|-----------:|--------:|--------:|-----------:|---------:|
|           1|             3| alfa-romero giulia       | gas      | std        | two        | convertible | rwd        | front          |       88.6|      168.8|      64.1|       48.8|        2548| dohc       | four           |         130| mpfi       |       3.47|    2.68|               9.0|         111|     5000|       21|          27|  13495.00|
|           2|             3| alfa-romero stelvio      | gas      | std        | two        | convertible | rwd        | front          |       88.6|      168.8|      64.1|       48.8|        2548| dohc       | four           |         130| mpfi       |       3.47|    2.68|               9.0|         111|     5000|       21|          27|  16500.00|
|           3|             1| alfa-romero Quadrifoglio | gas      | std        | two        | hatchback   | rwd        | front          |       94.5|      171.2|      65.5|       52.4|        2823| ohcv       | six            |         152| mpfi       |       2.68|    3.47|               9.0|         154|     5000|       19|          26|  16500.00|
|           4|             2| audi 100 ls              | gas      | std        | four       | sedan       | fwd        | front          |       99.8|      176.6|      66.2|       54.3|        2337| ohc        | four           |         109| mpfi       |       3.19|    3.40|              10.0|         102|     5500|       24|          30|  13950.00|
|           5|             2| audi 100ls               | gas      | std        | four       | sedan       | 4wd        | front          |       99.4|      176.6|      66.4|       54.3|        2824| ohc        | five           |         136| mpfi       |       3.19|    3.40|               8.0|         115|     5500|       18|          22|  17450.00|
|           6|             2| audi fox                 | gas      | std        | two        | sedan       | fwd        | front          |       99.8|      177.3|      66.3|       53.1|        2507| ohc        | five           |         136| mpfi       |       3.19|    3.40|               8.5|         110|     5500|       19|          25|  15250.00|
|           7|             1| audi 100ls               | gas      | std        | four       | sedan       | fwd        | front          |      105.8|      192.7|      71.4|       55.7|        2844| ohc        | five           |         136| mpfi       |       3.19|    3.40|               8.5|         110|     5500|       19|          25|  17710.00|
|           8|             1| audi 5000                | gas      | std        | four       | wagon       | fwd        | front          |      105.8|      192.7|      71.4|       55.7|        2954| ohc        | five           |         136| mpfi       |       3.19|    3.40|               8.5|         110|     5500|       19|          25|  18920.00|
|           9|             1| audi 4000                | gas      | turbo      | four       | sedan       | fwd        | front          |      105.8|      192.7|      71.4|       55.9|        3086| ohc        | five           |         131| mpfi       |       3.13|    3.40|               8.3|         140|     5500|       17|          20|  23875.00|
|          10|             0| audi 5000s (diesel)      | gas      | turbo      | two        | hatchback   | 4wd        | front          |       99.5|      178.2|      67.9|       52.0|        3053| ohc        | five           |         131| mpfi       |       3.13|    3.40|               7.0|         160|     5500|       16|          22|  17859.17|
|  \#Let us e|  xamine the s| tructure of the dataset  |          |            |            |             |            |                |           |           |          |           |            |            |                |            |            |           |        |                  |            |         |         |            |          |

``` r
    str(carprice)
```

    ## 'data.frame':    205 obs. of  26 variables:
    ##  $ car_ID          : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ symboling       : int  3 3 1 2 2 2 1 1 1 0 ...
    ##  $ CarName         : Factor w/ 147 levels "alfa-romero giulia",..: 1 3 2 4 5 9 5 7 6 8 ...
    ##  $ fueltype        : Factor w/ 2 levels "diesel","gas": 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ aspiration      : Factor w/ 2 levels "std","turbo": 1 1 1 1 1 1 1 1 2 2 ...
    ##  $ doornumber      : Factor w/ 2 levels "four","two": 2 2 2 1 1 2 1 1 1 2 ...
    ##  $ carbody         : Factor w/ 5 levels "convertible",..: 1 1 3 4 4 4 4 5 4 3 ...
    ##  $ drivewheel      : Factor w/ 3 levels "4wd","fwd","rwd": 3 3 3 2 1 2 2 2 2 1 ...
    ##  $ enginelocation  : Factor w/ 2 levels "front","rear": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ wheelbase       : num  88.6 88.6 94.5 99.8 99.4 ...
    ##  $ carlength       : num  169 169 171 177 177 ...
    ##  $ carwidth        : num  64.1 64.1 65.5 66.2 66.4 66.3 71.4 71.4 71.4 67.9 ...
    ##  $ carheight       : num  48.8 48.8 52.4 54.3 54.3 53.1 55.7 55.7 55.9 52 ...
    ##  $ curbweight      : int  2548 2548 2823 2337 2824 2507 2844 2954 3086 3053 ...
    ##  $ enginetype      : Factor w/ 7 levels "dohc","dohcv",..: 1 1 6 4 4 4 4 4 4 4 ...
    ##  $ cylindernumber  : Factor w/ 7 levels "eight","five",..: 3 3 4 3 2 2 2 2 2 2 ...
    ##  $ enginesize      : int  130 130 152 109 136 136 136 136 131 131 ...
    ##  $ fuelsystem      : Factor w/ 8 levels "1bbl","2bbl",..: 6 6 6 6 6 6 6 6 6 6 ...
    ##  $ boreratio       : num  3.47 3.47 2.68 3.19 3.19 3.19 3.19 3.19 3.13 3.13 ...
    ##  $ stroke          : num  2.68 2.68 3.47 3.4 3.4 3.4 3.4 3.4 3.4 3.4 ...
    ##  $ compressionratio: num  9 9 9 10 8 8.5 8.5 8.5 8.3 7 ...
    ##  $ horsepower      : int  111 111 154 102 115 110 110 110 140 160 ...
    ##  $ peakrpm         : int  5000 5000 5000 5500 5500 5500 5500 5500 5500 5500 ...
    ##  $ citympg         : int  21 21 19 24 18 19 19 19 17 16 ...
    ##  $ highwaympg      : int  27 27 26 30 22 25 25 25 20 22 ...
    ##  $ price           : num  13495 16500 16500 13950 17450 ...

Data Cleaning----
=================

-   ### Dervide CompanyName from the CarName variable

``` r
      carprice <- separate(carprice,CarName, "CompanyName", sep = " ")
```

-   CompanyName to lowercase

``` r
      carprice$CompanyName <- tolower(carprice$CompanyName)
```

-   Correcting car Comapny Name, treatinf misspelled values as one

``` r
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="porcshce","porsche")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="maxda","mazda")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="toyouta","toyota")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="vokswagen" | carprice$CompanyName=="vw","volkswagen")
```

-   CompanyName to factor

``` r
      carprice$CompanyName <- as.factor(carprice$CompanyName)
```

Dummy Variable Creation----
===========================

``` r
  # Variable with 2 Levels  
    
    # convert fueltype variable to numeric is to replace the levels
      levels(carprice$fueltype)<-c(1,0)
      carprice$fueltype <- as.numeric(levels(carprice$fueltype))[carprice$fueltype]
    
    # convert aspiration variable to numeric is to replace the levels
      levels(carprice$aspiration)<-c(1,0)
      carprice$aspiration <- as.numeric(levels(carprice$aspiration))[carprice$aspiration]
    
    # convert doornumber variable to numeric is to replace the levels
      levels(carprice$doornumber)<-c(1,0)
      carprice$doornumber <- as.numeric(levels(carprice$doornumber))[carprice$doornumber]
    
    # convert enginelocation variable to numeric is to replace the levels
      levels(carprice$enginelocation)<-c(1,0)
      carprice$enginelocation <- as.numeric(levels(carprice$enginelocation))[carprice$enginelocation]
```

``` r
# Variable with more thatn 3 Levels
    
      dmy <- dummyVars("~ CompanyName + carbody + drivewheel + enginetype + cylindernumber + fuelsystem", data = carprice, fullRank = T)
      dummy_1 <- data.frame(predict(dmy,newdata = carprice))
      
    # Removing orignal columns as dummy variables are generated for those
      carprice_1 <- carprice[,-3]
      carprice_1 <- carprice_1[,-c(6:7)]
      carprice_1 <- carprice_1[,-c(12:13)]
    
    # Combine the dummy variables to the main data set, after removing the original categorical columns
      carprice_1 <- cbind(carprice_1[,-13], dummy_1)
      View(carprice_1)
      str(carprice_1)
```

    ## 'data.frame':    205 obs. of  66 variables:
    ##  $ car_ID                : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ symboling             : int  3 3 1 2 2 2 1 1 1 0 ...
    ##  $ fueltype              : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ aspiration            : num  1 1 1 1 1 1 1 1 0 0 ...
    ##  $ doornumber            : num  0 0 0 1 1 0 1 1 1 0 ...
    ##  $ enginelocation        : num  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ wheelbase             : num  88.6 88.6 94.5 99.8 99.4 ...
    ##  $ carlength             : num  169 169 171 177 177 ...
    ##  $ carwidth              : num  64.1 64.1 65.5 66.2 66.4 66.3 71.4 71.4 71.4 67.9 ...
    ##  $ carheight             : num  48.8 48.8 52.4 54.3 54.3 53.1 55.7 55.7 55.9 52 ...
    ##  $ curbweight            : int  2548 2548 2823 2337 2824 2507 2844 2954 3086 3053 ...
    ##  $ enginesize            : int  130 130 152 109 136 136 136 136 131 131 ...
    ##  $ boreratio             : num  3.47 3.47 2.68 3.19 3.19 3.19 3.19 3.19 3.13 3.13 ...
    ##  $ stroke                : num  2.68 2.68 3.47 3.4 3.4 3.4 3.4 3.4 3.4 3.4 ...
    ##  $ compressionratio      : num  9 9 9 10 8 8.5 8.5 8.5 8.3 7 ...
    ##  $ horsepower            : int  111 111 154 102 115 110 110 110 140 160 ...
    ##  $ peakrpm               : int  5000 5000 5000 5500 5500 5500 5500 5500 5500 5500 ...
    ##  $ citympg               : int  21 21 19 24 18 19 19 19 17 16 ...
    ##  $ highwaympg            : int  27 27 26 30 22 25 25 25 20 22 ...
    ##  $ price                 : num  13495 16500 16500 13950 17450 ...
    ##  $ CompanyName.audi      : num  0 0 0 1 1 1 1 1 1 1 ...
    ##  $ CompanyName.bmw       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.buick     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.chevrolet : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.dodge     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.honda     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.isuzu     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.jaguar    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.mazda     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.mercury   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.mitsubishi: num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.nissan    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.peugeot   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.plymouth  : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.porsche   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.renault   : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.saab      : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.subaru    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.toyota    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.volkswagen: num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ CompanyName.volvo     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ carbody.hardtop       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ carbody.hatchback     : num  0 0 1 0 0 0 0 0 0 1 ...
    ##  $ carbody.sedan         : num  0 0 0 1 1 1 1 0 1 0 ...
    ##  $ carbody.wagon         : num  0 0 0 0 0 0 0 1 0 0 ...
    ##  $ drivewheel.fwd        : num  0 0 0 1 0 1 1 1 1 0 ...
    ##  $ drivewheel.rwd        : num  1 1 1 0 0 0 0 0 0 0 ...
    ##  $ enginetype.dohcv      : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ enginetype.l          : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ enginetype.ohc        : num  0 0 0 1 1 1 1 1 1 1 ...
    ##  $ enginetype.ohcf       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ enginetype.ohcv       : num  0 0 1 0 0 0 0 0 0 0 ...
    ##  $ enginetype.rotor      : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ cylindernumber.five   : num  0 0 0 0 1 1 1 1 1 1 ...
    ##  $ cylindernumber.four   : num  1 1 0 1 0 0 0 0 0 0 ...
    ##  $ cylindernumber.six    : num  0 0 1 0 0 0 0 0 0 0 ...
    ##  $ cylindernumber.three  : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ cylindernumber.twelve : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ cylindernumber.two    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.2bbl       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.4bbl       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.idi        : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.mfi        : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.mpfi       : num  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ fuelsystem.spdi       : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ fuelsystem.spfi       : num  0 0 0 0 0 0 0 0 0 0 ...

``` r
# Divide the data into training and test data set----
    
    #set the seed to 100
      set.seed(100)
    
    # randomly generate row indices for train dataset
      trainindices= sample(1:nrow(carprice_1), 0.7*nrow(carprice_1))
    # generate the train data set
      train = carprice_1[trainindices,]
    
    #Store the rest of the observations into an object "test".
      test = carprice_1[-trainindices,]
      View(test)
```

``` r
# Model Building----
    # Build model 1 containing all variables
      model_1 <-lm(price~.,data=train)
      summary(model_1)
```

    ## 
    ## Call:
    ## lm(formula = price ~ ., data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2678.9  -647.9    47.0   570.6  3621.4 
    ## 
    ## Coefficients: (9 not defined because of singularities)
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -3.276e+04  1.544e+04  -2.121 0.036793 *  
    ## car_ID                  9.708e+01  5.742e+01   1.691 0.094477 .  
    ## symboling               1.047e+02  2.764e+02   0.379 0.705695    
    ## fueltype                8.139e+03  7.131e+03   1.141 0.256867    
    ## aspiration             -3.238e+03  8.749e+02  -3.701 0.000379 ***
    ## doornumber             -4.857e+01  5.233e+02  -0.093 0.926265    
    ## enginelocation         -6.608e+03  4.476e+03  -1.476 0.143565    
    ## wheelbase              -2.309e+01  1.099e+02  -0.210 0.834034    
    ## carlength               1.472e+01  5.566e+01   0.264 0.792035    
    ## carwidth                5.655e+02  2.373e+02   2.383 0.019378 *  
    ## carheight               6.103e+01  1.585e+02   0.385 0.701063    
    ## curbweight              3.334e+00  1.680e+00   1.985 0.050324 .  
    ## enginesize              9.952e+01  2.625e+01   3.791 0.000278 ***
    ## boreratio              -5.496e+02  1.861e+03  -0.295 0.768392    
    ## stroke                 -2.289e+03  1.080e+03  -2.120 0.036903 *  
    ## compressionratio       -5.900e+02  5.294e+02  -1.115 0.268121    
    ## horsepower             -2.320e+01  2.384e+01  -0.973 0.333142    
    ## peakrpm                 2.204e+00  7.646e-01   2.883 0.004975 ** 
    ## citympg                 9.592e+01  1.372e+02   0.699 0.486309    
    ## highwaympg              3.683e+01  1.206e+02   0.305 0.760768    
    ## CompanyName.audi       -1.636e+03  2.235e+03  -0.732 0.466092    
    ## CompanyName.bmw         4.528e+03  2.632e+03   1.720 0.088942 .  
    ## CompanyName.buick      -1.761e+03  4.104e+03  -0.429 0.668852    
    ## CompanyName.chevrolet  -6.260e+03  5.202e+03  -1.204 0.232083    
    ## CompanyName.dodge      -9.603e+03  2.908e+03  -3.302 0.001400 ** 
    ## CompanyName.honda      -7.393e+03  3.520e+03  -2.100 0.038621 *  
    ## CompanyName.isuzu      -8.009e+03  3.720e+03  -2.153 0.034138 *  
    ## CompanyName.jaguar     -8.025e+02  3.157e+03  -0.254 0.799936    
    ## CompanyName.mazda      -1.151e+04  4.321e+03  -2.664 0.009213 ** 
    ## CompanyName.mercury    -1.043e+04  5.221e+03  -1.998 0.048845 *  
    ## CompanyName.mitsubishi -1.564e+04  5.746e+03  -2.722 0.007858 ** 
    ## CompanyName.nissan     -1.486e+04  6.493e+03  -2.288 0.024562 *  
    ## CompanyName.peugeot    -1.563e+04  6.260e+03  -2.497 0.014424 *  
    ## CompanyName.plymouth   -1.845e+04  7.883e+03  -2.340 0.021594 *  
    ## CompanyName.porsche    -6.479e+03  8.728e+03  -0.742 0.459955    
    ## CompanyName.renault    -1.927e+04  8.114e+03  -2.375 0.019780 *  
    ## CompanyName.saab       -1.649e+04  8.441e+03  -1.954 0.053947 .  
    ## CompanyName.subaru     -2.152e+04  8.977e+03  -2.398 0.018665 *  
    ## CompanyName.toyota     -2.066e+04  9.945e+03  -2.077 0.040739 *  
    ## CompanyName.volkswagen -2.299e+04  1.139e+04  -2.018 0.046672 *  
    ## CompanyName.volvo      -2.092e+04  1.150e+04  -1.819 0.072398 .  
    ## carbody.hardtop        -1.195e+03  1.199e+03  -0.997 0.321789    
    ## carbody.hatchback      -1.446e+03  1.233e+03  -1.173 0.243869    
    ## carbody.sedan          -1.435e+03  1.293e+03  -1.109 0.270355    
    ## carbody.wagon          -1.834e+03  1.442e+03  -1.271 0.207028    
    ## drivewheel.fwd          2.531e+02  1.013e+03   0.250 0.803400    
    ## drivewheel.rwd         -1.806e+03  1.363e+03  -1.325 0.188596    
    ## enginetype.dohcv               NA         NA      NA       NA    
    ## enginetype.l                   NA         NA      NA       NA    
    ## enginetype.ohc         -4.247e+02  1.273e+03  -0.334 0.739561    
    ## enginetype.ohcf                NA         NA      NA       NA    
    ## enginetype.ohcv        -7.639e+01  1.309e+03  -0.058 0.953599    
    ## enginetype.rotor        9.756e+03  4.879e+03   2.000 0.048701 *  
    ## cylindernumber.five    -2.344e+03  3.192e+03  -0.734 0.464822    
    ## cylindernumber.four    -7.522e+02  3.764e+03  -0.200 0.842078    
    ## cylindernumber.six     -2.936e+02  2.795e+03  -0.105 0.916585    
    ## cylindernumber.three           NA         NA      NA       NA    
    ## cylindernumber.twelve          NA         NA      NA       NA    
    ## cylindernumber.two             NA         NA      NA       NA    
    ## fuelsystem.2bbl         2.291e+03  1.272e+03   1.802 0.075057 .  
    ## fuelsystem.4bbl                NA         NA      NA       NA    
    ## fuelsystem.idi                 NA         NA      NA       NA    
    ## fuelsystem.mfi         -4.020e+01  2.419e+03  -0.017 0.986778    
    ## fuelsystem.mpfi         1.831e+03  1.366e+03   1.340 0.183658    
    ## fuelsystem.spdi         1.226e+03  1.635e+03   0.750 0.455242    
    ## fuelsystem.spfi                NA         NA      NA       NA    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1414 on 86 degrees of freedom
    ## Multiple R-squared:  0.9819, Adjusted R-squared:   0.97 
    ## F-statistic:  83.1 on 56 and 86 DF,  p-value: < 2.2e-16

``` r
    # Using stepAIC for removing the insignificant variables
      step <- stepAIC(model_1, direction="both")
```

    ## Start:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     cylindernumber.twelve + cylindernumber.two + fuelsystem.2bbl + 
    ##     fuelsystem.4bbl + fuelsystem.idi + fuelsystem.mfi + fuelsystem.mpfi + 
    ##     fuelsystem.spdi + fuelsystem.spfi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     cylindernumber.twelve + cylindernumber.two + fuelsystem.2bbl + 
    ##     fuelsystem.4bbl + fuelsystem.idi + fuelsystem.mfi + fuelsystem.mpfi + 
    ##     fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     cylindernumber.twelve + cylindernumber.two + fuelsystem.2bbl + 
    ##     fuelsystem.4bbl + fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     cylindernumber.twelve + cylindernumber.two + fuelsystem.2bbl + 
    ##     fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     cylindernumber.twelve + fuelsystem.2bbl + fuelsystem.mfi + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + cylindernumber.three + 
    ##     fuelsystem.2bbl + fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcf + enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + fuelsystem.2bbl + 
    ##     fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.l + enginetype.ohc + 
    ##     enginetype.ohcv + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + fuelsystem.2bbl + 
    ##     fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.dohcv + enginetype.ohc + enginetype.ohcv + 
    ##     enginetype.rotor + cylindernumber.five + cylindernumber.four + 
    ##     cylindernumber.six + fuelsystem.2bbl + fuelsystem.mfi + fuelsystem.mpfi + 
    ##     fuelsystem.spdi
    ## 
    ## 
    ## Step:  AIC=2116
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.ohcv + enginetype.rotor + 
    ##     cylindernumber.five + cylindernumber.four + cylindernumber.six + 
    ##     fuelsystem.2bbl + fuelsystem.mfi + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - fuelsystem.mfi          1       552 171969207 2114.0
    ## - enginetype.ohcv         1      6810 171975465 2114.0
    ## - doornumber              1     17227 171985881 2114.0
    ## - cylindernumber.six      1     22065 171990719 2114.0
    ## - cylindernumber.four     1     79857 172048511 2114.1
    ## - wheelbase               1     88324 172056979 2114.1
    ## - drivewheel.fwd          1    124696 172093351 2114.1
    ## - CompanyName.jaguar      1    129227 172097881 2114.1
    ## - carlength               1    139885 172108539 2114.1
    ## - boreratio               1    174504 172143159 2114.1
    ## - highwaympg              1    186555 172155209 2114.2
    ## - enginetype.ohc          1    222418 172191073 2114.2
    ## - symboling               1    287080 172255734 2114.2
    ## - carheight               1    296656 172265311 2114.2
    ## - CompanyName.buick       1    368355 172337010 2114.3
    ## - citympg                 1    977605 172946260 2114.8
    ## - CompanyName.audi        1   1071777 173040431 2114.9
    ## - cylindernumber.five     1   1077912 173046567 2114.9
    ## - CompanyName.porsche     1   1101688 173070343 2114.9
    ## - fuelsystem.spdi         1   1125093 173093747 2114.9
    ## - horsepower              1   1894215 173862869 2115.6
    ## - carbody.hardtop         1   1985778 173954432 2115.6
    ## <none>                                171968655 2116.0
    ## - carbody.sedan           1   2461037 174429692 2116.0
    ## - compressionratio        1   2484282 174452936 2116.1
    ## - fueltype                1   2605164 174573819 2116.2
    ## - carbody.hatchback       1   2753304 174721959 2116.3
    ## - CompanyName.chevrolet   1   2896323 174864977 2116.4
    ## - carbody.wagon           1   3232130 175200785 2116.7
    ## - drivewheel.rwd          1   3511966 175480621 2116.9
    ## - fuelsystem.mpfi         1   3592492 175561147 2116.9
    ## - enginelocation          1   4357039 176325694 2117.6
    ## - car_ID                  1   5717244 177685899 2118.7
    ## - CompanyName.bmw         1   5919002 177887656 2118.8
    ## - fuelsystem.2bbl         1   6492880 178461535 2119.3
    ## - CompanyName.volvo       1   6616006 178584660 2119.4
    ## - CompanyName.saab        1   7635079 179603734 2120.2
    ## - curbweight              1   7879574 179848228 2120.4
    ## - CompanyName.mercury     1   7984804 179953459 2120.5
    ## - enginetype.rotor        1   7995256 179963911 2120.5
    ## - CompanyName.volkswagen  1   8145934 180114589 2120.6
    ## - CompanyName.toyota      1   8630342 180598997 2121.0
    ## - CompanyName.honda       1   8821839 180790494 2121.2
    ## - stroke                  1   8985587 180954241 2121.3
    ## - CompanyName.isuzu       1   9267076 181235731 2121.5
    ## - CompanyName.nissan      1  10472263 182440917 2122.4
    ## - CompanyName.plymouth    1  10950199 182918853 2122.8
    ## - CompanyName.renault     1  11277811 183246466 2123.1
    ## - carwidth                1  11354716 183323370 2123.1
    ## - CompanyName.subaru      1  11495238 183463893 2123.2
    ## - CompanyName.peugeot     1  12469652 184438307 2124.0
    ## - CompanyName.mazda       1  14193766 186162420 2125.3
    ## - CompanyName.mitsubishi  1  14814110 186782764 2125.8
    ## - peakrpm                 1  16620204 188588859 2127.2
    ## - CompanyName.dodge       1  21802329 193770983 2131.1
    ## - aspiration              1  27385125 199353780 2135.1
    ## - enginesize              1  28731082 200699737 2136.1
    ## 
    ## Step:  AIC=2114
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.ohcv + enginetype.rotor + 
    ##     cylindernumber.five + cylindernumber.four + cylindernumber.six + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - enginetype.ohcv         1      7038 171976245 2112.0
    ## - doornumber              1     16765 171985972 2112.0
    ## - cylindernumber.six      1     22821 171992028 2112.0
    ## - cylindernumber.four     1     83001 172052208 2112.1
    ## - wheelbase               1     87850 172057058 2112.1
    ## - drivewheel.fwd          1    124270 172093477 2112.1
    ## - CompanyName.jaguar      1    128674 172097881 2112.1
    ## - carlength               1    139467 172108674 2112.1
    ## - boreratio               1    173969 172143176 2112.1
    ## - highwaympg              1    190303 172159510 2112.2
    ## - enginetype.ohc          1    222069 172191276 2112.2
    ## - symboling               1    295960 172265167 2112.2
    ## - carheight               1    309159 172278366 2112.2
    ## - CompanyName.buick       1    368904 172338111 2112.3
    ## - citympg                 1    977053 172946260 2112.8
    ## - CompanyName.audi        1   1076911 173046119 2112.9
    ## - cylindernumber.five     1   1097209 173066416 2112.9
    ## - CompanyName.porsche     1   1102020 173071227 2112.9
    ## - fuelsystem.spdi         1   1665840 173635047 2113.4
    ## - horsepower              1   1913347 173882554 2113.6
    ## - carbody.hardtop         1   1994769 173963976 2113.7
    ## <none>                                171969207 2114.0
    ## - compressionratio        1   2483885 174453092 2114.1
    ## - carbody.sedan           1   2528464 174497672 2114.1
    ## - fueltype                1   2627581 174596788 2114.2
    ## - carbody.hatchback       1   2774885 174744092 2114.3
    ## - CompanyName.chevrolet   1   2955137 174924344 2114.4
    ## - carbody.wagon           1   3305354 175274561 2114.7
    ## - drivewheel.rwd          1   3631334 175600541 2115.0
    ## - enginelocation          1   4363225 176332432 2115.6
    ## + fuelsystem.mfi          1       552 171968655 2116.0
    ## - fuelsystem.mpfi         1   5669058 177638265 2116.6
    ## - car_ID                  1   5717509 177686716 2116.7
    ## - CompanyName.bmw         1   5959162 177928369 2116.9
    ## - CompanyName.volvo       1   6615908 178585115 2117.4
    ## - CompanyName.saab        1   7649780 179618987 2118.2
    ## - curbweight              1   7913550 179882757 2118.4
    ## - CompanyName.mercury     1   7984453 179953660 2118.5
    ## - enginetype.rotor        1   8048208 180017415 2118.5
    ## - CompanyName.volkswagen  1   8148444 180117651 2118.6
    ## - CompanyName.toyota      1   8630131 180599338 2119.0
    ## - stroke                  1   9062258 181031465 2119.3
    ## - CompanyName.honda       1   9182601 181151808 2119.4
    ## - CompanyName.isuzu       1   9274442 181243649 2119.5
    ## - fuelsystem.2bbl         1   9877441 181846648 2120.0
    ## - CompanyName.nissan      1  10476905 182446112 2120.4
    ## - CompanyName.plymouth    1  10952782 182921989 2120.8
    ## - CompanyName.renault     1  11294590 183263797 2121.1
    ## - carwidth                1  11361354 183330561 2121.2
    ## - CompanyName.subaru      1  11497161 183466368 2121.2
    ## - CompanyName.peugeot     1  12469475 184438682 2122.0
    ## - CompanyName.mazda       1  14199361 186168568 2123.3
    ## - CompanyName.mitsubishi  1  14848385 186817592 2123.8
    ## - peakrpm                 1  16643038 188612245 2125.2
    ## - CompanyName.dodge       1  21951102 193920309 2129.2
    ## - aspiration              1  27516139 199485346 2133.2
    ## - enginesize              1  28730907 200700114 2134.1
    ## 
    ## Step:  AIC=2112
    ## price ~ car_ID + symboling + fueltype + aspiration + doornumber + 
    ##     enginelocation + wheelbase + carlength + carwidth + carheight + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + highwaympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.fwd + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - doornumber              1     18285 171994530 2110.0
    ## - cylindernumber.six      1     19545 171995790 2110.0
    ## - cylindernumber.four     1     76295 172052540 2110.1
    ## - wheelbase               1     82508 172058753 2110.1
    ## - drivewheel.fwd          1    122335 172098580 2110.1
    ## - CompanyName.jaguar      1    122799 172099044 2110.1
    ## - carlength               1    152491 172128736 2110.1
    ## - boreratio               1    176876 172153121 2110.2
    ## - highwaympg              1    189892 172166137 2110.2
    ## - enginetype.ohc          1    215097 172191342 2110.2
    ## - carheight               1    313933 172290178 2110.3
    ## - symboling               1    338349 172314594 2110.3
    ## - CompanyName.buick       1    393401 172369646 2110.3
    ## - citympg                 1   1015883 172992128 2110.8
    ## - CompanyName.audi        1   1089153 173065398 2110.9
    ## - CompanyName.porsche     1   1122539 173098784 2110.9
    ## - cylindernumber.five     1   1183862 173160107 2111.0
    ## - fuelsystem.spdi         1   1684639 173660884 2111.4
    ## - horsepower              1   1981005 173957250 2111.6
    ## - carbody.hardtop         1   2170026 174146271 2111.8
    ## <none>                                171976245 2112.0
    ## - compressionratio        1   2495474 174471719 2112.1
    ## - fueltype                1   2644945 174621190 2112.2
    ## - carbody.sedan           1   2676322 174652567 2112.2
    ## - CompanyName.chevrolet   1   2957700 174933945 2112.4
    ## - carbody.hatchback       1   2999630 174975875 2112.5
    ## - carbody.wagon           1   3431969 175408214 2112.8
    ## - drivewheel.rwd          1   3774299 175750544 2113.1
    ## - enginelocation          1   4377046 176353291 2113.6
    ## + enginetype.ohcv         1      7038 171969207 2114.0
    ## + fuelsystem.mfi          1       780 171975465 2114.0
    ## - fuelsystem.mpfi         1   5702572 177678817 2114.7
    ## - car_ID                  1   6196575 178172820 2115.1
    ## - CompanyName.bmw         1   6227680 178203925 2115.1
    ## - CompanyName.volvo       1   7052026 179028271 2115.8
    ## - curbweight              1   7914250 179890495 2116.4
    ## - CompanyName.saab        1   8152249 180128494 2116.6
    ## - CompanyName.mercury     1   8246384 180222629 2116.7
    ## - enginetype.rotor        1   8587056 180563301 2117.0
    ## - CompanyName.volkswagen  1   8742532 180718777 2117.1
    ## - CompanyName.toyota      1   9116638 181092883 2117.4
    ## - stroke                  1   9120840 181097085 2117.4
    ## - CompanyName.isuzu       1   9399480 181375725 2117.6
    ## - CompanyName.honda       1   9486270 181462515 2117.7
    ## - fuelsystem.2bbl         1   9877418 181853663 2118.0
    ## - CompanyName.nissan      1  11168801 183145046 2119.0
    ## - CompanyName.plymouth    1  11600870 183577115 2119.3
    ## - CompanyName.renault     1  11843920 183820165 2119.5
    ## - CompanyName.subaru      1  11947945 183924190 2119.6
    ## - carwidth                1  12169943 184146188 2119.8
    ## - CompanyName.peugeot     1  12795854 184772099 2120.3
    ## - CompanyName.mazda       1  14651983 186628228 2121.7
    ## - CompanyName.mitsubishi  1  15574851 187551096 2122.4
    ## - peakrpm                 1  16815745 188791990 2123.3
    ## - CompanyName.dodge       1  22241131 194217376 2127.4
    ## - aspiration              1  27509289 199485534 2131.2
    ## - enginesize              1  28904237 200880482 2132.2
    ## 
    ## Step:  AIC=2110.02
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     wheelbase + carlength + carwidth + carheight + curbweight + 
    ##     enginesize + boreratio + stroke + compressionratio + horsepower + 
    ##     peakrpm + citympg + highwaympg + CompanyName.audi + CompanyName.bmw + 
    ##     CompanyName.buick + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.jaguar + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.fwd + drivewheel.rwd + 
    ##     enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + cylindernumber.six + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - cylindernumber.six      1     22607 172017136 2108.0
    ## - wheelbase               1     70528 172065057 2108.1
    ## - cylindernumber.four     1     75985 172070515 2108.1
    ## - CompanyName.jaguar      1    121970 172116500 2108.1
    ## - drivewheel.fwd          1    124784 172119313 2108.1
    ## - carlength               1    140086 172134616 2108.1
    ## - highwaympg              1    179283 172173812 2108.2
    ## - boreratio               1    204175 172198705 2108.2
    ## - enginetype.ohc          1    234393 172228923 2108.2
    ## - carheight               1    304799 172299328 2108.3
    ## - CompanyName.buick       1    386259 172380789 2108.3
    ## - symboling               1    436783 172431312 2108.4
    ## - citympg                 1   1050702 173045231 2108.9
    ## - CompanyName.audi        1   1074725 173069254 2108.9
    ## - CompanyName.porsche     1   1104392 173098922 2108.9
    ## - cylindernumber.five     1   1176708 173171237 2109.0
    ## - fuelsystem.spdi         1   1727327 173721857 2109.4
    ## - horsepower              1   1988815 173983345 2109.7
    ## - carbody.hardtop         1   2155550 174150080 2109.8
    ## <none>                                171994530 2110.0
    ## - compressionratio        1   2618450 174612979 2110.2
    ## - fueltype                1   2802334 174796863 2110.3
    ## - carbody.sedan           1   2881253 174875782 2110.4
    ## - CompanyName.chevrolet   1   2943869 174938399 2110.4
    ## - carbody.hatchback       1   3025694 175020223 2110.5
    ## - carbody.wagon           1   3678598 175673127 2111.0
    ## - drivewheel.rwd          1   3926427 175920957 2111.2
    ## - enginelocation          1   4373894 176368424 2111.6
    ## + doornumber              1     18285 171976245 2112.0
    ## + enginetype.ohcv         1      8558 171985972 2112.0
    ## + fuelsystem.mfi          1       189 171994340 2112.0
    ## - fuelsystem.mpfi         1   5852904 177847434 2112.8
    ## - car_ID                  1   6200398 178194928 2113.1
    ## - CompanyName.bmw         1   6272826 178267356 2113.1
    ## - CompanyName.volvo       1   7068245 179062774 2113.8
    ## - curbweight              1   7941784 179936313 2114.5
    ## - CompanyName.saab        1   8203498 180198027 2114.7
    ## - CompanyName.mercury     1   8285656 180280186 2114.8
    ## - enginetype.rotor        1   8571865 180566395 2115.0
    ## - CompanyName.volkswagen  1   8774556 180769086 2115.1
    ## - stroke                  1   9136684 181131213 2115.4
    ## - CompanyName.toyota      1   9143994 181138524 2115.4
    ## - CompanyName.isuzu       1   9382138 181376668 2115.6
    ## - CompanyName.honda       1   9613209 181607738 2115.8
    ## - fuelsystem.2bbl         1  10179018 182173547 2116.2
    ## - CompanyName.nissan      1  11251510 183246039 2117.1
    ## - CompanyName.plymouth    1  11638414 183632943 2117.4
    ## - CompanyName.renault     1  11969309 183963838 2117.6
    ## - CompanyName.subaru      1  12030779 184025309 2117.7
    ## - carwidth                1  12182899 184177429 2117.8
    ## - CompanyName.peugeot     1  12779273 184773802 2118.3
    ## - CompanyName.mazda       1  14801997 186796527 2119.8
    ## - CompanyName.mitsubishi  1  15671462 187665991 2120.5
    ## - peakrpm                 1  16798594 188793124 2121.3
    ## - CompanyName.dodge       1  22526765 194521294 2125.6
    ## - aspiration              1  27518362 199512891 2129.2
    ## - enginesize              1  28886973 200881502 2130.2
    ## 
    ## Step:  AIC=2108.04
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     wheelbase + carlength + carwidth + carheight + curbweight + 
    ##     enginesize + boreratio + stroke + compressionratio + horsepower + 
    ##     peakrpm + citympg + highwaympg + CompanyName.audi + CompanyName.bmw + 
    ##     CompanyName.buick + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.jaguar + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.fwd + drivewheel.rwd + 
    ##     enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + fuelsystem.2bbl + fuelsystem.mpfi + 
    ##     fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - wheelbase               1     87073 172104209 2106.1
    ## - cylindernumber.four     1     87763 172104899 2106.1
    ## - drivewheel.fwd          1    115294 172132430 2106.1
    ## - carlength               1    146003 172163140 2106.2
    ## - CompanyName.jaguar      1    154668 172171804 2106.2
    ## - highwaympg              1    168651 172185787 2106.2
    ## - boreratio               1    254847 172271984 2106.2
    ## - enginetype.ohc          1    279000 172296136 2106.3
    ## - carheight               1    285972 172303108 2106.3
    ## - CompanyName.buick       1    365669 172382806 2106.3
    ## - symboling               1    415132 172432268 2106.4
    ## - citympg                 1   1118393 173135529 2107.0
    ## - CompanyName.audi        1   1118756 173135892 2107.0
    ## - CompanyName.porsche     1   1157469 173174606 2107.0
    ## - fuelsystem.spdi         1   1760886 173778022 2107.5
    ## - carbody.hardtop         1   2188198 174205334 2107.8
    ## - cylindernumber.five     1   2218452 174235589 2107.9
    ## - horsepower              1   2248213 174265349 2107.9
    ## <none>                                172017136 2108.0
    ## - compressionratio        1   2765372 174782508 2108.3
    ## - fueltype                1   2915098 174932234 2108.4
    ## - carbody.sedan           1   2926294 174943430 2108.4
    ## - carbody.hatchback       1   3091921 175109057 2108.6
    ## - carbody.wagon           1   3675725 175692861 2109.1
    ## - CompanyName.chevrolet   1   4292700 176309836 2109.6
    ## - drivewheel.rwd          1   4338913 176356049 2109.6
    ## + cylindernumber.six      1     22607 171994530 2110.0
    ## + doornumber              1     21346 171995790 2110.0
    ## + enginetype.ohcv         1      4759 172012378 2110.0
    ## + fuelsystem.mfi          1       582 172016554 2110.0
    ## - fuelsystem.mpfi         1   6026155 178043291 2111.0
    ## - car_ID                  1   6238477 178255613 2111.1
    ## - CompanyName.bmw         1   6570490 178587626 2111.4
    ## - CompanyName.volvo       1   7059172 179076308 2111.8
    ## - curbweight              1   7936833 179953969 2112.5
    ## - CompanyName.saab        1   8191938 180209075 2112.7
    ## - CompanyName.mercury     1   8312524 180329660 2112.8
    ## - CompanyName.volkswagen  1   8766259 180783395 2113.2
    ## - CompanyName.toyota      1   9150438 181167574 2113.4
    ## - stroke                  1   9288537 181305674 2113.6
    ## - CompanyName.isuzu       1   9359604 181376740 2113.6
    ## - CompanyName.honda       1   9592314 181609450 2113.8
    ## - fuelsystem.2bbl         1  10473383 182490519 2114.5
    ## - enginelocation          1  10481909 182499045 2114.5
    ## - CompanyName.nissan      1  11264905 183282041 2115.1
    ## - CompanyName.plymouth    1  11661064 183678201 2115.4
    ## - CompanyName.renault     1  12018865 184036002 2115.7
    ## - CompanyName.subaru      1  12077302 184094438 2115.7
    ## - carwidth                1  12160386 184177522 2115.8
    ## - CompanyName.peugeot     1  12758252 184775388 2116.3
    ## - CompanyName.mazda       1  14785346 186802482 2117.8
    ## - CompanyName.mitsubishi  1  15699895 187717032 2118.5
    ## - peakrpm                 1  17511813 189528949 2119.9
    ## - CompanyName.dodge       1  22515050 194532187 2123.6
    ## - aspiration              1  28008833 200025969 2127.6
    ## - enginetype.rotor        1  35272660 207289796 2132.7
    ## - enginesize              1  51552356 223569493 2143.5
    ## 
    ## Step:  AIC=2106.11
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carlength + carwidth + carheight + curbweight + enginesize + 
    ##     boreratio + stroke + compressionratio + horsepower + peakrpm + 
    ##     citympg + highwaympg + CompanyName.audi + CompanyName.bmw + 
    ##     CompanyName.buick + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.jaguar + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.fwd + drivewheel.rwd + 
    ##     enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     cylindernumber.four + fuelsystem.2bbl + fuelsystem.mpfi + 
    ##     fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - carlength               1     66061 172170271 2104.2
    ## - cylindernumber.four     1     67651 172171860 2104.2
    ## - drivewheel.fwd          1    111527 172215737 2104.2
    ## - carheight               1    199311 172303520 2104.3
    ## - highwaympg              1    211099 172315308 2104.3
    ## - CompanyName.jaguar      1    220699 172324908 2104.3
    ## - boreratio               1    296853 172401063 2104.4
    ## - enginetype.ohc          1    326370 172430580 2104.4
    ## - CompanyName.buick       1    336380 172440589 2104.4
    ## - symboling               1    497137 172601346 2104.5
    ## - citympg                 1   1068787 173172996 2105.0
    ## - CompanyName.porsche     1   1074514 173178724 2105.0
    ## - CompanyName.audi        1   1117719 173221929 2105.0
    ## - fuelsystem.spdi         1   1710785 173814994 2105.5
    ## - cylindernumber.five     1   2199558 174303768 2105.9
    ## - horsepower              1   2245800 174350009 2106.0
    ## - carbody.hardtop         1   2302814 174407023 2106.0
    ## <none>                                172104209 2106.1
    ## - carbody.sedan           1   2992640 175096849 2106.6
    ## - compressionratio        1   3174834 175279044 2106.7
    ## - fueltype                1   3319683 175423892 2106.8
    ## - carbody.hatchback       1   3489500 175593709 2107.0
    ## - carbody.wagon           1   3637260 175741470 2107.1
    ## - CompanyName.chevrolet   1   4231310 176335519 2107.6
    ## - drivewheel.rwd          1   4269044 176373253 2107.6
    ## + wheelbase               1     87073 172017136 2108.0
    ## + cylindernumber.six      1     39152 172065057 2108.1
    ## + doornumber              1      7630 172096579 2108.1
    ## + fuelsystem.mfi          1       270 172103939 2108.1
    ## + enginetype.ohcv         1       167 172104042 2108.1
    ## - fuelsystem.mpfi         1   6018108 178122317 2109.0
    ## - car_ID                  1   6222512 178326721 2109.2
    ## - CompanyName.bmw         1   6548187 178652396 2109.4
    ## - CompanyName.volvo       1   7021021 179125230 2109.8
    ## - CompanyName.mercury     1   8242003 180346213 2110.8
    ## - CompanyName.saab        1   8313555 180417765 2110.9
    ## - CompanyName.volkswagen  1   8804654 180908863 2111.2
    ## - CompanyName.toyota      1   9163841 181268050 2111.5
    ## - stroke                  1   9221076 181325286 2111.6
    ## - curbweight              1   9240672 181344881 2111.6
    ## - CompanyName.isuzu       1   9278964 181383173 2111.6
    ## - CompanyName.honda       1   9515839 181620048 2111.8
    ## - fuelsystem.2bbl         1  10566384 182670594 2112.6
    ## - enginelocation          1  11109345 183213554 2113.1
    ## - CompanyName.nissan      1  11339995 183444204 2113.2
    ## - CompanyName.plymouth    1  11650206 183754416 2113.5
    ## - CompanyName.subaru      1  12145145 184249354 2113.9
    ## - CompanyName.renault     1  12195568 184299777 2113.9
    ## - carwidth                1  12248339 184352548 2113.9
    ## - CompanyName.peugeot     1  12675048 184779257 2114.3
    ## - CompanyName.mazda       1  15007251 187111460 2116.1
    ## - CompanyName.mitsubishi  1  15687059 187791268 2116.6
    ## - peakrpm                 1  17438893 189543103 2117.9
    ## - CompanyName.dodge       1  22470789 194574998 2121.7
    ## - aspiration              1  27929731 200033940 2125.6
    ## - enginetype.rotor        1  35728700 207832909 2131.1
    ## - enginesize              1  51807611 223911820 2141.7
    ## 
    ## Step:  AIC=2104.16
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + carheight + curbweight + enginesize + boreratio + 
    ##     stroke + compressionratio + horsepower + peakrpm + citympg + 
    ##     highwaympg + CompanyName.audi + CompanyName.bmw + CompanyName.buick + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.jaguar + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.fwd + drivewheel.rwd + enginetype.ohc + enginetype.rotor + 
    ##     cylindernumber.five + cylindernumber.four + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - cylindernumber.four     1     37245 172207516 2102.2
    ## - drivewheel.fwd          1    135297 172305568 2102.3
    ## - carheight               1    199956 172370227 2102.3
    ## - highwaympg              1    222777 172393048 2102.3
    ## - boreratio               1    320319 172490589 2102.4
    ## - CompanyName.jaguar      1    322754 172493025 2102.4
    ## - enginetype.ohc          1    331121 172501392 2102.4
    ## - symboling               1    458896 172629166 2102.6
    ## - CompanyName.buick       1    483980 172654251 2102.6
    ## - citympg                 1   1030112 173200382 2103.0
    ## - CompanyName.audi        1   1119251 173289521 2103.1
    ## - CompanyName.porsche     1   1449519 173619790 2103.4
    ## - fuelsystem.spdi         1   1739696 173909966 2103.6
    ## - cylindernumber.five     1   2133502 174303773 2103.9
    ## - horsepower              1   2219555 174389826 2104.0
    ## - carbody.hardtop         1   2245532 174415803 2104.0
    ## <none>                                172170271 2104.2
    ## - carbody.sedan           1   3094389 175264659 2104.7
    ## - compressionratio        1   3136383 175306654 2104.8
    ## - fueltype                1   3287837 175458108 2104.9
    ## - carbody.hatchback       1   3449844 175620115 2105.0
    ## - carbody.wagon           1   3780406 175950676 2105.3
    ## - drivewheel.rwd          1   4203932 176374203 2105.6
    ## - CompanyName.chevrolet   1   4276208 176446479 2105.7
    ## + carlength               1     66061 172104209 2106.1
    ## + cylindernumber.six      1     32748 172137523 2106.1
    ## + enginetype.ohcv         1      7518 172162753 2106.2
    ## + wheelbase               1      7131 172163140 2106.2
    ## + doornumber              1      5823 172164448 2106.2
    ## + fuelsystem.mfi          1         0 172170271 2106.2
    ## - fuelsystem.mpfi         1   5998126 178168396 2107.1
    ## - CompanyName.bmw         1   6506449 178676720 2107.5
    ## - car_ID                  1   7239875 179410146 2108.1
    ## - CompanyName.volvo       1   8075178 180245449 2108.7
    ## - CompanyName.mercury     1   9165637 181335908 2109.6
    ## - CompanyName.saab        1   9168764 181339035 2109.6
    ## - stroke                  1   9313354 181483625 2109.7
    ## - CompanyName.volkswagen  1   9998336 182168606 2110.2
    ## - CompanyName.isuzu       1  10088271 182258542 2110.3
    ## - CompanyName.toyota      1  10438897 182609168 2110.6
    ## - CompanyName.honda       1  10735769 182906039 2110.8
    ## - fuelsystem.2bbl         1  10802027 182972298 2110.9
    ## - curbweight              1  10840568 183010838 2110.9
    ## - enginelocation          1  12155725 184325996 2111.9
    ## - CompanyName.nissan      1  12730899 184901170 2112.4
    ## - carwidth                1  13221472 185391743 2112.7
    ## - CompanyName.plymouth    1  13226932 185397202 2112.8
    ## - CompanyName.renault     1  13575294 185745565 2113.0
    ## - CompanyName.subaru      1  13756866 185927137 2113.2
    ## - CompanyName.peugeot     1  14189339 186359610 2113.5
    ## - CompanyName.mazda       1  16401534 188571804 2115.2
    ## - CompanyName.mitsubishi  1  17510861 189681131 2116.0
    ## - peakrpm                 1  17553227 189723497 2116.1
    ## - CompanyName.dodge       1  24027368 196197639 2120.8
    ## - aspiration              1  28248313 200418584 2123.9
    ## - enginetype.rotor        1  39050904 211221175 2131.4
    ## - enginesize              1  54728564 226898834 2141.6
    ## 
    ## Step:  AIC=2102.2
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + carheight + curbweight + enginesize + boreratio + 
    ##     stroke + compressionratio + horsepower + peakrpm + citympg + 
    ##     highwaympg + CompanyName.audi + CompanyName.bmw + CompanyName.buick + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.jaguar + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.fwd + drivewheel.rwd + enginetype.ohc + enginetype.rotor + 
    ##     cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi + 
    ##     fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - drivewheel.fwd          1    128646 172336161 2100.3
    ## - carheight               1    177308 172384824 2100.3
    ## - highwaympg              1    240929 172448445 2100.4
    ## - CompanyName.jaguar      1    296783 172504299 2100.4
    ## - symboling               1    432813 172640328 2100.6
    ## - CompanyName.buick       1    448097 172655612 2100.6
    ## - enginetype.ohc          1    911825 173119340 2100.9
    ## - citympg                 1    994071 173201587 2101.0
    ## - CompanyName.audi        1   1103856 173311372 2101.1
    ## - boreratio               1   1136403 173343918 2101.1
    ## - CompanyName.porsche     1   1432574 173640089 2101.4
    ## - fuelsystem.spdi         1   1743787 173951303 2101.6
    ## - horsepower              1   2182311 174389827 2102.0
    ## - carbody.hardtop         1   2412276 174619791 2102.2
    ## <none>                                172207516 2102.2
    ## - carbody.sedan           1   3241543 175449059 2102.9
    ## - compressionratio        1   3253582 175461098 2102.9
    ## - fueltype                1   3423726 175631241 2103.0
    ## - carbody.hatchback       1   3654361 175861877 2103.2
    ## - carbody.wagon           1   3926038 176133554 2103.4
    ## - drivewheel.rwd          1   4200878 176408393 2103.6
    ## + cylindernumber.four     1     37245 172170271 2104.2
    ## + carlength               1     35655 172171860 2104.2
    ## + wheelbase               1      9652 172197864 2104.2
    ## + cylindernumber.six      1      7139 172200377 2104.2
    ## + doornumber              1      3028 172204488 2104.2
    ## + enginetype.ohcv         1      1073 172206443 2104.2
    ## + fuelsystem.mfi          1       862 172206653 2104.2
    ## - cylindernumber.five     1   5653668 177861183 2104.8
    ## - fuelsystem.mpfi         1   5976610 178184126 2105.1
    ## - CompanyName.chevrolet   1   6202699 178410214 2105.3
    ## - car_ID                  1   7283118 179490633 2106.1
    ## - CompanyName.volvo       1   8425077 180632593 2107.0
    ## - CompanyName.saab        1   9414422 181621938 2107.8
    ## - stroke                  1   9562926 181770442 2107.9
    ## - CompanyName.mercury     1  10165051 182372566 2108.4
    ## - CompanyName.volkswagen  1  10284488 182492003 2108.5
    ## - fuelsystem.2bbl         1  10769460 182976975 2108.9
    ## - CompanyName.toyota      1  10794193 183001709 2108.9
    ## - CompanyName.isuzu       1  10926206 183133721 2109.0
    ## - curbweight              1  10941499 183149015 2109.0
    ## - CompanyName.honda       1  11735073 183942589 2109.6
    ## - enginelocation          1  12734356 184941872 2110.4
    ## - CompanyName.bmw         1  12891189 185098705 2110.5
    ## - carwidth                1  13386088 185593604 2110.9
    ## - CompanyName.nissan      1  13596441 185803957 2111.1
    ## - CompanyName.plymouth    1  13848051 186055566 2111.3
    ## - CompanyName.renault     1  14139180 186346695 2111.5
    ## - CompanyName.subaru      1  14244986 186452501 2111.6
    ## - CompanyName.peugeot     1  14421866 186629382 2111.7
    ## - CompanyName.mazda       1  18003530 190211046 2114.4
    ## - CompanyName.mitsubishi  1  18663140 190870656 2114.9
    ## - peakrpm                 1  20528932 192736448 2116.3
    ## - CompanyName.dodge       1  27926883 200134398 2121.7
    ## - aspiration              1  28938148 201145664 2122.4
    ## - enginetype.rotor        1  52050730 224258245 2138.0
    ## - enginesize              1  69400620 241608135 2148.6
    ## 
    ## Step:  AIC=2100.3
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + carheight + curbweight + enginesize + boreratio + 
    ##     stroke + compressionratio + horsepower + peakrpm + citympg + 
    ##     highwaympg + CompanyName.audi + CompanyName.bmw + CompanyName.buick + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.jaguar + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - carheight               1    157648 172493809 2098.4
    ## - CompanyName.jaguar      1    261596 172597757 2098.5
    ## - highwaympg              1    269890 172606051 2098.5
    ## - symboling               1    408041 172744202 2098.6
    ## - CompanyName.buick       1    472416 172808577 2098.7
    ## - enginetype.ohc          1    886948 173223109 2099.0
    ## - citympg                 1    901105 173237266 2099.1
    ## - boreratio               1   1051612 173387773 2099.2
    ## - CompanyName.audi        1   1233847 173570009 2099.3
    ## - CompanyName.porsche     1   1780444 174116605 2099.8
    ## - fuelsystem.spdi         1   1897353 174233514 2099.9
    ## - horsepower              1   2054223 174390384 2100.0
    ## <none>                                172336161 2100.3
    ## - carbody.hardtop         1   2575843 174912004 2100.4
    ## - compressionratio        1   3124988 175461149 2100.9
    ## - fueltype                1   3298997 175635158 2101.0
    ## - carbody.sedan           1   3322420 175658581 2101.0
    ## - carbody.hatchback       1   3702226 176038387 2101.3
    ## - carbody.wagon           1   3871085 176207246 2101.5
    ## + drivewheel.fwd          1    128646 172207516 2102.2
    ## + carlength               1     54748 172281413 2102.3
    ## + cylindernumber.four     1     30593 172305568 2102.3
    ## + cylindernumber.six      1      7758 172328403 2102.3
    ## + wheelbase               1      4239 172331922 2102.3
    ## + doornumber              1      3903 172332258 2102.3
    ## + enginetype.ohcv         1      2018 172334143 2102.3
    ## + fuelsystem.mfi          1        55 172336106 2102.3
    ## - cylindernumber.five     1   5654170 177990331 2102.9
    ## - fuelsystem.mpfi         1   5849161 178185322 2103.1
    ## - CompanyName.chevrolet   1   6230594 178566755 2103.4
    ## - car_ID                  1   7722162 180058323 2104.6
    ## - CompanyName.volvo       1   8841263 181177424 2105.5
    ## - stroke                  1   9519314 181855475 2106.0
    ## - CompanyName.saab        1   9750007 182086168 2106.2
    ## - CompanyName.mercury     1  10594515 182930676 2106.8
    ## - fuelsystem.2bbl         1  10680511 183016672 2106.9
    ## - CompanyName.volkswagen  1  10768028 183104190 2107.0
    ## - CompanyName.isuzu       1  11088197 183424358 2107.2
    ## - CompanyName.toyota      1  11356568 183692729 2107.4
    ## - drivewheel.rwd          1  11781345 184117506 2107.8
    ## - CompanyName.honda       1  12109779 184445941 2108.0
    ## - CompanyName.bmw         1  12845413 185181575 2108.6
    ## - enginelocation          1  13831734 186167895 2109.3
    ## - curbweight              1  13861198 186197359 2109.4
    ## - CompanyName.nissan      1  14197115 186533276 2109.6
    ## - CompanyName.plymouth    1  14432284 186768445 2109.8
    ## - CompanyName.peugeot     1  14663900 187000061 2110.0
    ## - CompanyName.renault     1  14744372 187080533 2110.0
    ## - carwidth                1  14921309 187257470 2110.2
    ## - CompanyName.subaru      1  14981920 187318082 2110.2
    ## - CompanyName.mazda       1  18686577 191022738 2113.0
    ## - CompanyName.mitsubishi  1  19289055 191625216 2113.5
    ## - peakrpm                 1  20410734 192746895 2114.3
    ## - CompanyName.dodge       1  28011982 200348143 2119.8
    ## - aspiration              1  29781641 202117802 2121.1
    ## - enginetype.rotor        1  52146636 224482797 2136.1
    ## - enginesize              1  69394435 241730596 2146.7
    ## 
    ## Step:  AIC=2098.43
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + boreratio + stroke + 
    ##     compressionratio + horsepower + peakrpm + citympg + highwaympg + 
    ##     CompanyName.audi + CompanyName.bmw + CompanyName.buick + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.jaguar + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - highwaympg              1    234047 172727855 2096.6
    ## - CompanyName.jaguar      1    288857 172782666 2096.7
    ## - symboling               1    289863 172783672 2096.7
    ## - CompanyName.buick       1    383894 172877703 2096.8
    ## - enginetype.ohc          1    864250 173358058 2097.2
    ## - citympg                 1    946690 173440498 2097.2
    ## - CompanyName.audi        1   1153467 173647276 2097.4
    ## - boreratio               1   1161069 173654877 2097.4
    ## - CompanyName.porsche     1   1640552 174134360 2097.8
    ## - fuelsystem.spdi         1   1831873 174325682 2097.9
    ## - horsepower              1   2268761 174762570 2098.3
    ## <none>                                172493809 2098.4
    ## - carbody.hardtop         1   2455775 174949583 2098.4
    ## - carbody.sedan           1   3184888 175678696 2099.1
    ## - compressionratio        1   3236532 175730340 2099.1
    ## - fueltype                1   3387907 175881715 2099.2
    ## - carbody.hatchback       1   3606734 176100543 2099.4
    ## - carbody.wagon           1   3772295 176266103 2099.5
    ## + carheight               1    157648 172336161 2100.3
    ## + drivewheel.fwd          1    108985 172384824 2100.3
    ## + carlength               1     62829 172430980 2100.4
    ## + wheelbase               1     21169 172472640 2100.4
    ## + enginetype.ohcv         1     18667 172475142 2100.4
    ## + cylindernumber.four     1     11728 172482081 2100.4
    ## + cylindernumber.six      1      8122 172485687 2100.4
    ## + fuelsystem.mfi          1      7305 172486504 2100.4
    ## + doornumber              1      6844 172486965 2100.4
    ## - fuelsystem.mpfi         1   5772241 178266050 2101.1
    ## - CompanyName.chevrolet   1   6079336 178573145 2101.4
    ## - cylindernumber.five     1   6172193 178666002 2101.5
    ## - car_ID                  1   7564517 180058325 2102.6
    ## - CompanyName.volvo       1   8696540 181190348 2103.5
    ## - stroke                  1   9467272 181961081 2104.1
    ## - CompanyName.saab        1   9679917 182173726 2104.2
    ## - CompanyName.mercury     1  10607355 183101163 2105.0
    ## - CompanyName.volkswagen  1  10641835 183135643 2105.0
    ## - fuelsystem.2bbl         1  10728733 183222542 2105.1
    ## - CompanyName.isuzu       1  10989224 183483032 2105.3
    ## - CompanyName.toyota      1  11206368 183700176 2105.4
    ## - CompanyName.honda       1  11996883 184490691 2106.1
    ## - drivewheel.rwd          1  12088257 184582066 2106.1
    ## - CompanyName.bmw         1  13738831 186232640 2107.4
    ## - enginelocation          1  13753664 186247473 2107.4
    ## - CompanyName.nissan      1  14045926 186539734 2107.6
    ## - CompanyName.plymouth    1  14274861 186768670 2107.8
    ## - CompanyName.renault     1  14587642 187081450 2108.0
    ## - CompanyName.peugeot     1  14626292 187120101 2108.1
    ## - carwidth                1  14795764 187289573 2108.2
    ## - CompanyName.subaru      1  14859031 187352839 2108.2
    ## - curbweight              1  15122335 187616143 2108.4
    ## - CompanyName.mazda       1  18603846 191097655 2111.1
    ## - CompanyName.mitsubishi  1  19140837 191634645 2111.5
    ## - peakrpm                 1  20944384 193438193 2112.8
    ## - CompanyName.dodge       1  27974987 200468795 2117.9
    ## - aspiration              1  29803056 202296864 2119.2
    ## - enginetype.rotor        1  52344854 224838662 2134.3
    ## - enginesize              1  70606757 243100565 2145.5
    ## 
    ## Step:  AIC=2096.63
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + boreratio + stroke + 
    ##     compressionratio + horsepower + peakrpm + citympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.jaguar + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.rwd + 
    ##     enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - CompanyName.jaguar      1    294303 173022158 2094.9
    ## - symboling               1    295790 173023646 2094.9
    ## - CompanyName.buick       1    412916 173140771 2095.0
    ## - enginetype.ohc          1    821752 173549607 2095.3
    ## - boreratio               1   1066864 173794719 2095.5
    ## - CompanyName.audi        1   1206288 173934143 2095.6
    ## - CompanyName.porsche     1   1552031 174279886 2095.9
    ## - fuelsystem.spdi         1   1813714 174541569 2096.1
    ## - horsepower              1   2140105 174867960 2096.4
    ## - carbody.hardtop         1   2299749 175027604 2096.5
    ## <none>                                172727855 2096.6
    ## - carbody.sedan           1   3022291 175750146 2097.1
    ## - compressionratio        1   3223127 175950982 2097.3
    ## - fueltype                1   3377788 176105643 2097.4
    ## - carbody.hatchback       1   3431653 176159508 2097.4
    ## - carbody.wagon           1   3668437 176396292 2097.6
    ## + highwaympg              1    234047 172493809 2098.4
    ## + drivewheel.fwd          1    136113 172591742 2098.5
    ## + carheight               1    121804 172606051 2098.5
    ## + carlength               1     68941 172658914 2098.6
    ## + cylindernumber.four     1     24212 172703643 2098.6
    ## + cylindernumber.six      1     20940 172706915 2098.6
    ## + fuelsystem.mfi          1     15748 172712107 2098.6
    ## + enginetype.ohcv         1     12229 172715627 2098.6
    ## + wheelbase               1      6829 172721027 2098.6
    ## + doornumber              1        19 172727836 2098.6
    ## - fuelsystem.mpfi         1   5664083 178391938 2099.2
    ## - CompanyName.chevrolet   1   6046191 178774046 2099.6
    ## - cylindernumber.five     1   6379423 179107278 2099.8
    ## - citympg                 1   6713037 179440892 2100.1
    ## - car_ID                  1   7459464 180187319 2100.7
    ## - CompanyName.volvo       1   8627180 181355035 2101.6
    ## - CompanyName.saab        1   9596343 182324199 2102.4
    ## - stroke                  1   9701215 182429070 2102.4
    ## - CompanyName.volkswagen  1  10532404 183260259 2103.1
    ## - fuelsystem.2bbl         1  10619654 183347509 2103.2
    ## - CompanyName.mercury     1  10745235 183473090 2103.3
    ## - CompanyName.toyota      1  11151880 183879735 2103.6
    ## - CompanyName.isuzu       1  11188645 183916501 2103.6
    ## - CompanyName.honda       1  12105464 184833319 2104.3
    ## - drivewheel.rwd          1  12253310 184981165 2104.4
    ## - CompanyName.bmw         1  13575644 186303499 2105.4
    ## - enginelocation          1  13661803 186389658 2105.5
    ## - CompanyName.nissan      1  13961399 186689254 2105.7
    ## - CompanyName.plymouth    1  14181889 186909744 2105.9
    ## - CompanyName.renault     1  14412196 187140051 2106.1
    ## - CompanyName.peugeot     1  14661926 187389781 2106.3
    ## - CompanyName.subaru      1  14856776 187584631 2106.4
    ## - carwidth                1  14950387 187678242 2106.5
    ## - curbweight              1  15113339 187841194 2106.6
    ## - CompanyName.mazda       1  18663965 191391820 2109.3
    ## - CompanyName.mitsubishi  1  19049667 191777522 2109.6
    ## - peakrpm                 1  20978461 193706316 2111.0
    ## - CompanyName.dodge       1  28170483 200898338 2116.2
    ## - aspiration              1  29962846 202690701 2117.5
    ## - enginetype.rotor        1  52121298 224849153 2132.3
    ## - enginesize              1  72010482 244738337 2144.5
    ## 
    ## Step:  AIC=2094.87
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + boreratio + stroke + 
    ##     compressionratio + horsepower + peakrpm + citympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.buick + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.ohc + 
    ##     enginetype.rotor + cylindernumber.five + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - CompanyName.buick       1    119694 173141852 2093.0
    ## - symboling               1    183563 173205721 2093.0
    ## - CompanyName.audi        1    912946 173935105 2093.6
    ## - enginetype.ohc          1    970983 173993142 2093.7
    ## - boreratio               1   1001367 174023526 2093.7
    ## - CompanyName.porsche     1   1283602 174305761 2093.9
    ## - fuelsystem.spdi         1   1739681 174761839 2094.3
    ## - horsepower              1   1848133 174870292 2094.4
    ## <none>                                173022158 2094.9
    ## - carbody.hardtop         1   2865275 175887433 2095.2
    ## - compressionratio        1   2931383 175953541 2095.3
    ## - fueltype                1   3098106 176120265 2095.4
    ## - carbody.sedan           1   3980721 177002879 2096.1
    ## + CompanyName.jaguar      1    294303 172727855 2096.6
    ## - carbody.hatchback       1   4614160 177636318 2096.6
    ## - carbody.wagon           1   4655009 177677167 2096.7
    ## + highwaympg              1    239493 172782666 2096.7
    ## + carlength               1    174750 172847408 2096.7
    ## + carheight               1    145709 172876450 2096.8
    ## + drivewheel.fwd          1     96739 172925420 2096.8
    ## + wheelbase               1      9072 173013087 2096.9
    ## + fuelsystem.mfi          1      5766 173016392 2096.9
    ## + enginetype.ohcv         1      4725 173017433 2096.9
    ## + cylindernumber.four     1      4673 173017485 2096.9
    ## + doornumber              1       178 173021980 2096.9
    ## + cylindernumber.six      1         2 173022157 2096.9
    ## - fuelsystem.mpfi         1   5544046 178566205 2097.4
    ## - cylindernumber.five     1   6273064 179295222 2098.0
    ## - citympg                 1   6714962 179737121 2098.3
    ## - CompanyName.chevrolet   1   7478187 180500345 2098.9
    ## - car_ID                  1   9673493 182695651 2100.7
    ## - fuelsystem.2bbl         1  10325438 183347597 2101.2
    ## - stroke                  1  10471905 183494063 2101.3
    ## - drivewheel.rwd          1  11982976 185005134 2102.4
    ## - CompanyName.volvo       1  12815407 185837565 2103.1
    ## - CompanyName.saab        1  13951339 186973498 2104.0
    ## - CompanyName.mercury     1  14508143 187530301 2104.4
    ## - curbweight              1  15285972 188308130 2105.0
    ## - enginelocation          1  15412173 188434332 2105.1
    ## - CompanyName.volkswagen  1  16006788 189028947 2105.5
    ## - carwidth                1  16597792 189619950 2106.0
    ## - CompanyName.isuzu       1  17012040 190034198 2106.3
    ## - CompanyName.toyota      1  17287017 190309176 2106.5
    ## - CompanyName.honda       1  21803702 194825861 2109.8
    ## - CompanyName.subaru      1  22063030 195085189 2110.0
    ## - CompanyName.bmw         1  22902296 195924454 2110.7
    ## - peakrpm                 1  23356351 196378509 2111.0
    ## - CompanyName.plymouth    1  24180781 197202939 2111.6
    ## - CompanyName.nissan      1  24269544 197291702 2111.6
    ## - CompanyName.renault     1  25010811 198032969 2112.2
    ## - CompanyName.peugeot     1  25230944 198253102 2112.3
    ## - aspiration              1  29825684 202847843 2115.6
    ## - CompanyName.mazda       1  35332845 208355004 2119.4
    ## - CompanyName.mitsubishi  1  35707617 208729775 2119.7
    ## - enginetype.rotor        1  54482917 227505075 2132.0
    ## - CompanyName.dodge       1  57605647 230627805 2134.0
    ## - enginesize              1  74802408 247824567 2144.2
    ## 
    ## Step:  AIC=2092.97
    ## price ~ car_ID + symboling + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + boreratio + stroke + 
    ##     compressionratio + horsepower + peakrpm + citympg + CompanyName.audi + 
    ##     CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - symboling               1    131073 173272925 2091.1
    ## - CompanyName.audi        1    805471 173947323 2091.6
    ## - boreratio               1   1140203 174282055 2091.9
    ## - enginetype.ohc          1   1148402 174290254 2091.9
    ## - CompanyName.porsche     1   1488515 174630367 2092.2
    ## - fuelsystem.spdi         1   1702828 174844680 2092.4
    ## - horsepower              1   1955508 175097360 2092.6
    ## <none>                                173141852 2093.0
    ## - compressionratio        1   2851014 175992866 2093.3
    ## - carbody.hardtop         1   2970503 176112355 2093.4
    ## - fueltype                1   3002344 176144196 2093.4
    ## - carbody.sedan           1   4092088 177233940 2094.3
    ## + highwaympg              1    260915 172880937 2094.8
    ## + carlength               1    231367 172910485 2094.8
    ## + drivewheel.fwd          1    150501 172991351 2094.8
    ## - carbody.hatchback       1   4765649 177907501 2094.8
    ## + CompanyName.buick       1    119694 173022158 2094.9
    ## + enginetype.ohcv         1     61571 173080281 2094.9
    ## + carheight               1     42541 173099312 2094.9
    ## + wheelbase               1     29125 173112727 2094.9
    ## + cylindernumber.six      1     12093 173129759 2095.0
    ## + fuelsystem.mfi          1      4704 173137148 2095.0
    ## + doornumber              1      1372 173140480 2095.0
    ## + CompanyName.jaguar      1      1081 173140771 2095.0
    ## + cylindernumber.four     1       815 173141037 2095.0
    ## - carbody.wagon           1   5008716 178150568 2095.1
    ## - fuelsystem.mpfi         1   5697510 178839362 2095.6
    ## - citympg                 1   6640809 179782661 2096.3
    ## - cylindernumber.five     1   6933475 180075328 2096.6
    ## - CompanyName.chevrolet   1   7993464 181135316 2097.4
    ## - fuelsystem.2bbl         1  10269183 183411036 2099.2
    ## - drivewheel.rwd          1  11863629 185005481 2100.4
    ## - stroke                  1  12077916 185219768 2100.6
    ## - enginelocation          1  15607958 188749810 2103.3
    ## - carwidth                1  16597484 189739337 2104.1
    ## - curbweight              1  17538468 190680320 2104.8
    ## - car_ID                  1  17640859 190782712 2104.8
    ## - CompanyName.isuzu       1  22506513 195648365 2108.4
    ## - peakrpm                 1  23254239 196396092 2109.0
    ## - CompanyName.mercury     1  25020717 198162569 2110.3
    ## - CompanyName.bmw         1  26033534 199175386 2111.0
    ## - CompanyName.saab        1  29404654 202546506 2113.4
    ## - CompanyName.volvo       1  29443964 202585816 2113.4
    ## - aspiration              1  29844815 202986667 2113.7
    ## - CompanyName.honda       1  31821938 204963790 2115.1
    ## - CompanyName.volkswagen  1  34527033 207668885 2117.0
    ## - CompanyName.toyota      1  37811892 210953744 2119.2
    ## - CompanyName.subaru      1  47796698 220938550 2125.8
    ## - CompanyName.renault     1  50692023 223833876 2127.7
    ## - CompanyName.peugeot     1  52968848 226110700 2129.1
    ## - CompanyName.plymouth    1  53967353 227109205 2129.8
    ## - enginetype.rotor        1  54714827 227856680 2130.2
    ## - CompanyName.nissan      1  57320648 230462500 2131.9
    ## - enginesize              1  74683753 247825605 2142.2
    ## - CompanyName.mitsubishi  1  80762146 253903998 2145.7
    ## - CompanyName.dodge       1  81128578 254270430 2145.9
    ## - CompanyName.mazda       1  81402756 254544608 2146.1
    ## 
    ## Step:  AIC=2091.08
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + CompanyName.audi + CompanyName.bmw + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.porsche + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + carbody.hardtop + 
    ##     carbody.hatchback + carbody.sedan + carbody.wagon + drivewheel.rwd + 
    ##     enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - CompanyName.audi        1    683873 173956798 2089.6
    ## - boreratio               1   1085832 174358758 2090.0
    ## - enginetype.ohc          1   1110637 174383562 2090.0
    ## - CompanyName.porsche     1   1421235 174694160 2090.2
    ## - fuelsystem.spdi         1   1698708 174971634 2090.5
    ## - horsepower              1   1946446 175219371 2090.7
    ## <none>                                173272925 2091.1
    ## - compressionratio        1   2769103 176042028 2091.3
    ## - fueltype                1   2906914 176179839 2091.5
    ## - carbody.hardtop         1   3359026 176631952 2091.8
    ## + highwaympg              1    259010 173013915 2092.9
    ## + carlength               1    149082 173123844 2092.9
    ## + drivewheel.fwd          1    132057 173140868 2093.0
    ## + symboling               1    131073 173141852 2093.0
    ## + enginetype.ohcv         1     71904 173201021 2093.0
    ## + CompanyName.buick       1     67204 173205721 2093.0
    ## + carheight               1     12179 173260746 2093.1
    ## + cylindernumber.six      1      7966 173264959 2093.1
    ## + doornumber              1      7409 173265516 2093.1
    ## + fuelsystem.mfi          1      3738 173269187 2093.1
    ## + CompanyName.jaguar      1      2150 173270776 2093.1
    ## + cylindernumber.four     1       529 173272397 2093.1
    ## + wheelbase               1       139 173272787 2093.1
    ## - fuelsystem.mpfi         1   5577599 178850525 2093.6
    ## - carbody.hatchback       1   5602306 178875231 2093.6
    ## - carbody.sedan           1   5646891 178919816 2093.7
    ## - citympg                 1   6738202 180011128 2094.5
    ## - carbody.wagon           1   6819690 180092616 2094.6
    ## - cylindernumber.five     1   7282995 180555920 2095.0
    ## - CompanyName.chevrolet   1   7884358 181157284 2095.4
    ## - fuelsystem.2bbl         1  10165563 183438488 2097.2
    ## - stroke                  1  12379948 185652873 2098.9
    ## - drivewheel.rwd          1  12587107 185860032 2099.1
    ## - enginelocation          1  16148774 189421700 2101.8
    ## - carwidth                1  16639079 189912004 2102.2
    ## - curbweight              1  17411966 190684892 2102.8
    ## - car_ID                  1  17906433 191179359 2103.1
    ## - CompanyName.isuzu       1  22536987 195809912 2106.6
    ## - peakrpm                 1  23296145 196569071 2107.1
    ## - CompanyName.mercury     1  24891107 198164033 2108.3
    ## - CompanyName.bmw         1  26128505 199401431 2109.2
    ## - CompanyName.volvo       1  29545573 202818499 2111.6
    ## - aspiration              1  30094934 203367859 2112.0
    ## - CompanyName.honda       1  31954189 205227114 2113.3
    ## - CompanyName.saab        1  32640222 205913148 2113.8
    ## - CompanyName.volkswagen  1  37251241 210524166 2116.9
    ## - CompanyName.toyota      1  38899744 212172670 2118.0
    ## - CompanyName.subaru      1  49628375 222901301 2125.1
    ## - CompanyName.peugeot     1  54040650 227313575 2127.9
    ## - CompanyName.renault     1  54292344 227565269 2128.1
    ## - enginetype.rotor        1  55952038 229224963 2129.1
    ## - CompanyName.plymouth    1  56399423 229672348 2129.4
    ## - CompanyName.nissan      1  61277177 234550102 2132.4
    ## - enginesize              1  77498664 250771589 2141.9
    ## - CompanyName.dodge       1  82931900 256204826 2145.0
    ## - CompanyName.mazda       1  85469105 258742031 2146.4
    ## - CompanyName.mitsubishi  1  89530779 262803704 2148.6
    ## 
    ## Step:  AIC=2089.64
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + boreratio + stroke + compressionratio + 
    ##     horsepower + peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.ohc + 
    ##     enginetype.rotor + cylindernumber.five + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - boreratio               1   1242304 175199103 2088.7
    ## - CompanyName.porsche     1   1505703 175462501 2088.9
    ## - enginetype.ohc          1   1687614 175644412 2089.0
    ## - fuelsystem.spdi         1   1735800 175692598 2089.1
    ## - horsepower              1   2436506 176393304 2089.6
    ## <none>                                173956798 2089.6
    ## - compressionratio        1   3380575 177337374 2090.4
    ## - carbody.hardtop         1   3387780 177344578 2090.4
    ## - fueltype                1   3484827 177441625 2090.5
    ## + CompanyName.audi        1    683873 173272925 2091.1
    ## + highwaympg              1    291176 173665622 2091.4
    ## + drivewheel.fwd          1    270181 173686618 2091.4
    ## + carlength               1    121789 173835009 2091.5
    ## + enginetype.ohcv         1     97268 173859530 2091.6
    ## + cylindernumber.four     1     32795 173924003 2091.6
    ## + carheight               1     16712 173940086 2091.6
    ## + fuelsystem.mfi          1     13454 173943344 2091.6
    ## + symboling               1      9475 173947323 2091.6
    ## + CompanyName.buick       1      9068 173947730 2091.6
    ## + CompanyName.jaguar      1      8849 173947949 2091.6
    ## + cylindernumber.six      1      6477 173950321 2091.6
    ## + doornumber              1      2609 173954189 2091.6
    ## + wheelbase               1      1107 173955691 2091.6
    ## - fuelsystem.mpfi         1   5316364 179273163 2091.9
    ## - carbody.hatchback       1   5739301 179696099 2092.3
    ## - carbody.sedan           1   5949511 179906309 2092.4
    ## - citympg                 1   6654705 180611503 2093.0
    ## - carbody.wagon           1   7168780 181125578 2093.4
    ## - CompanyName.chevrolet   1   7787903 181744702 2093.9
    ## - cylindernumber.five     1   9629035 183585833 2095.3
    ## - fuelsystem.2bbl         1  10360636 184317434 2095.9
    ## - stroke                  1  12049268 186006066 2097.2
    ## - drivewheel.rwd          1  12190963 186147761 2097.3
    ## - enginelocation          1  15468898 189425696 2099.8
    ## - carwidth                1  15955218 189912016 2100.2
    ## - curbweight              1  18555625 192512423 2102.1
    ## - peakrpm                 1  22693480 196650278 2105.2
    ## - CompanyName.isuzu       1  24440662 198397460 2106.4
    ## - CompanyName.mercury     1  25036900 198993698 2106.9
    ## - aspiration              1  29639059 203595857 2110.1
    ## - car_ID                  1  31079259 205036057 2111.2
    ## - CompanyName.honda       1  31524855 205481653 2111.5
    ## - CompanyName.saab        1  37431877 211388675 2115.5
    ## - CompanyName.bmw         1  38078490 212035288 2115.9
    ## - CompanyName.volvo       1  40972697 214929495 2117.9
    ## - CompanyName.volkswagen  1  48683956 222640754 2122.9
    ## - CompanyName.toyota      1  52842436 226799234 2125.6
    ## - enginetype.rotor        1  55341700 229298498 2127.1
    ## - CompanyName.subaru      1  62448305 236405103 2131.5
    ## - CompanyName.renault     1  62765608 236722406 2131.7
    ## - CompanyName.plymouth    1  67660803 241617601 2134.6
    ## - CompanyName.nissan      1  69428764 243385562 2135.7
    ## - CompanyName.peugeot     1  74807834 248764632 2138.8
    ## - enginesize              1  76820426 250777224 2139.9
    ## - CompanyName.mazda       1  86009661 259966459 2145.1
    ## - CompanyName.dodge       1  88400984 262357782 2146.4
    ## - CompanyName.mitsubishi  1  94916316 268873114 2149.9
    ## 
    ## Step:  AIC=2088.66
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + horsepower + 
    ##     peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.ohc + 
    ##     enginetype.rotor + cylindernumber.five + fuelsystem.2bbl + 
    ##     fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - horsepower              1   1963442 177162545 2088.2
    ## - fuelsystem.spdi         1   1994066 177193168 2088.3
    ## - enginetype.ohc          1   2077176 177276278 2088.3
    ## <none>                                175199103 2088.7
    ## - CompanyName.porsche     1   2636855 177835957 2088.8
    ## - carbody.hardtop         1   2824517 178023619 2088.9
    ## - compressionratio        1   3439100 178638202 2089.4
    ## - fueltype                1   3598652 178797755 2089.6
    ## + boreratio               1   1242304 173956798 2089.6
    ## + CompanyName.audi        1    840345 174358758 2090.0
    ## + cylindernumber.six      1    586258 174612844 2090.2
    ## + cylindernumber.four     1    461020 174738082 2090.3
    ## - carbody.hatchback       1   4632841 179831944 2090.4
    ## + highwaympg              1    188344 175010759 2090.5
    ## + drivewheel.fwd          1    176760 175022342 2090.5
    ## + CompanyName.jaguar      1     85056 175114046 2090.6
    ## + CompanyName.buick       1     69383 175129719 2090.6
    ## - carbody.sedan           1   4920267 180119370 2090.6
    ## + carheight               1     41501 175157602 2090.6
    ## + enginetype.ohcv         1     32013 175167090 2090.6
    ## + carlength               1     17096 175182007 2090.6
    ## + doornumber              1      4505 175194598 2090.7
    ## + wheelbase               1       603 175198499 2090.7
    ## + symboling               1       277 175198826 2090.7
    ## + fuelsystem.mfi          1        11 175199092 2090.7
    ## - fuelsystem.mpfi         1   5440416 180639519 2091.0
    ## - carbody.wagon           1   6103744 181302846 2091.6
    ## - citympg                 1   7748007 182947110 2092.8
    ## - cylindernumber.five     1   9799606 184998709 2094.4
    ## - CompanyName.chevrolet   1   9893517 185092619 2094.5
    ## - fuelsystem.2bbl         1  10510945 185710048 2095.0
    ## - drivewheel.rwd          1  14694019 189893121 2098.2
    ## - carwidth                1  15115477 190314580 2098.5
    ## - enginelocation          1  17658115 192857217 2100.4
    ## - curbweight              1  19034946 194234048 2101.4
    ## - stroke                  1  19230646 194429748 2101.6
    ## - peakrpm                 1  21967479 197166581 2103.6
    ## - CompanyName.isuzu       1  26583779 201782882 2106.9
    ## - aspiration              1  28452054 203651156 2108.2
    ## - car_ID                  1  31571736 206770839 2110.3
    ## - CompanyName.honda       1  31770901 206970004 2110.5
    ## - CompanyName.mercury     1  32773686 207972788 2111.2
    ## - CompanyName.bmw         1  36933722 212132824 2114.0
    ## - CompanyName.saab        1  42402639 217601741 2117.7
    ## - CompanyName.volvo       1  45133859 220332962 2119.4
    ## - CompanyName.volkswagen  1  49587716 224786818 2122.3
    ## - enginetype.rotor        1  54334612 229533714 2125.3
    ## - CompanyName.toyota      1  55662027 230861129 2126.1
    ## - CompanyName.renault     1  65057958 240257061 2131.8
    ## - CompanyName.plymouth    1  69885249 245084352 2134.7
    ## - CompanyName.nissan      1  73723749 248922851 2136.9
    ## - enginesize              1  77215573 252414676 2138.9
    ## - CompanyName.subaru      1  78968333 254167436 2139.9
    ## - CompanyName.peugeot     1  85041088 260240190 2143.2
    ## - CompanyName.dodge       1  94196191 269395293 2148.2
    ## - CompanyName.mazda       1  94506382 269705484 2148.3
    ## - CompanyName.mitsubishi  1  99844513 275043615 2151.2
    ## 
    ## Step:  AIC=2088.25
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + peakrpm + 
    ##     citympg + CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.ohc + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - enginetype.ohc          1    872688 178035233 2086.9
    ## - fuelsystem.spdi         1   2235313 179397857 2088.0
    ## - compressionratio        1   2486118 179648662 2088.2
    ## <none>                                177162545 2088.2
    ## - fueltype                1   2792428 179954973 2088.5
    ## + horsepower              1   1963442 175199103 2088.7
    ## - carbody.hardtop         1   3268293 180430838 2088.9
    ## + CompanyName.audi        1   1277624 175884921 2089.2
    ## - fuelsystem.mpfi         1   4183719 181346264 2089.6
    ## + boreratio               1    769240 176393304 2089.6
    ## + CompanyName.jaguar      1    445943 176716601 2089.9
    ## + cylindernumber.six      1    205425 176957119 2090.1
    ## + cylindernumber.four     1    122320 177040225 2090.2
    ## + carheight               1    105690 177056855 2090.2
    ## + CompanyName.buick       1     98507 177064037 2090.2
    ## + highwaympg              1     91300 177071245 2090.2
    ## + drivewheel.fwd          1     41601 177120944 2090.2
    ## + fuelsystem.mfi          1     24983 177137561 2090.2
    ## + wheelbase               1     18496 177144049 2090.2
    ## + doornumber              1     12878 177149666 2090.2
    ## + symboling               1      6410 177156135 2090.2
    ## + enginetype.ohcv         1      1573 177160971 2090.2
    ## + carlength               1        40 177162505 2090.2
    ## - carbody.sedan           1   5378274 182540819 2090.5
    ## - carbody.hatchback       1   5464324 182626869 2090.6
    ## - carbody.wagon           1   6590526 183753070 2091.5
    ## - cylindernumber.five     1   9838400 187000944 2094.0
    ## - citympg                 1  10278565 187441109 2094.3
    ## - fuelsystem.2bbl         1  10305906 187468451 2094.3
    ## - CompanyName.chevrolet   1  11018191 188180735 2094.9
    ## - carwidth                1  13326173 190488718 2096.6
    ## - curbweight              1  17722362 194884907 2099.9
    ## - CompanyName.porsche     1  19748446 196910991 2101.4
    ## - peakrpm                 1  20389765 197552310 2101.8
    ## - drivewheel.rwd          1  20850437 198012982 2102.2
    ## - stroke                  1  23429933 200592477 2104.0
    ## - CompanyName.isuzu       1  28978643 206141187 2107.9
    ## - enginelocation          1  28985391 206147935 2107.9
    ## - aspiration              1  29576451 206738996 2108.3
    ## - CompanyName.bmw         1  35069101 212231646 2112.1
    ## - CompanyName.honda       1  40546843 217709388 2115.7
    ## - car_ID                  1  41976262 219138807 2116.7
    ## - CompanyName.mercury     1  49297987 226460532 2121.4
    ## - enginetype.rotor        1  57235371 234397915 2126.3
    ## - CompanyName.volvo       1  59234267 236396812 2127.5
    ## - CompanyName.saab        1  61335517 238498061 2128.8
    ## - CompanyName.volkswagen  1  64788424 241950969 2130.8
    ## - CompanyName.renault     1  72051254 249213799 2135.1
    ## - CompanyName.toyota      1  72665459 249828003 2135.4
    ## - enginesize              1  78021916 255184460 2138.4
    ## - CompanyName.peugeot     1  84012282 261174827 2141.8
    ## - CompanyName.plymouth    1  90013369 267175914 2145.0
    ## - CompanyName.subaru      1  93973915 271136459 2147.1
    ## - CompanyName.nissan      1 101194699 278357243 2150.9
    ## - CompanyName.dodge       1 102536485 279699030 2151.6
    ## - CompanyName.mazda       1 117242955 294405499 2158.9
    ## - CompanyName.mitsubishi  1 126385450 303547994 2163.2
    ## 
    ## Step:  AIC=2086.95
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + peakrpm + 
    ##     citympg + CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi + fuelsystem.spdi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## - fuelsystem.spdi         1   2023899 180059132 2086.6
    ## - compressionratio        1   2123396 180158629 2086.7
    ## - fueltype                1   2467865 180503098 2086.9
    ## <none>                                178035233 2086.9
    ## + CompanyName.audi        1   1693495 176341737 2087.6
    ## + boreratio               1   1095700 176939533 2088.1
    ## + enginetype.ohc          1    872688 177162545 2088.2
    ## - carbody.hardtop         1   4182209 182217441 2088.3
    ## + cylindernumber.six      1    843028 177192205 2088.3
    ## + horsepower              1    758954 177276278 2088.3
    ## + cylindernumber.four     1    733918 177301314 2088.4
    ## + CompanyName.jaguar      1    480933 177554300 2088.6
    ## - fuelsystem.mpfi         1   4599138 182634370 2088.6
    ## + CompanyName.buick       1    220681 177814552 2088.8
    ## + drivewheel.fwd          1     95262 177939971 2088.9
    ## + highwaympg              1     91065 177944168 2088.9
    ## + enginetype.ohcv         1     80010 177955222 2088.9
    ## + carheight               1     45176 177990056 2088.9
    ## + symboling               1     41709 177993523 2088.9
    ## + fuelsystem.mfi          1     36852 177998381 2088.9
    ## + carlength               1     19610 178015623 2088.9
    ## + doornumber              1      9184 178026049 2088.9
    ## + wheelbase               1         0 178035232 2088.9
    ## - carbody.hatchback       1   5501870 183537103 2089.3
    ## - carbody.sedan           1   5530070 183565302 2089.3
    ## - carbody.wagon           1   6727547 184762780 2090.3
    ## - CompanyName.chevrolet   1  10244914 188280146 2093.0
    ## - citympg                 1  10577723 188612956 2093.2
    ## - fuelsystem.2bbl         1  10731908 188767140 2093.3
    ## - carwidth                1  12550183 190585416 2094.7
    ## - cylindernumber.five     1  12682252 190717485 2094.8
    ## - curbweight              1  18591715 196626947 2099.2
    ## - CompanyName.porsche     1  19282023 197317256 2099.7
    ## - drivewheel.rwd          1  19979374 198014607 2100.2
    ## - stroke                  1  27831067 205866299 2105.7
    ## - enginelocation          1  28757160 206792392 2106.4
    ## - CompanyName.isuzu       1  29630336 207665568 2107.0
    ## - peakrpm                 1  32064899 210100131 2108.6
    ## - aspiration              1  35057701 213092933 2110.7
    ## - CompanyName.bmw         1  37621801 215657033 2112.4
    ## - CompanyName.honda       1  41059026 219094258 2114.6
    ## - car_ID                  1  41114243 219149476 2114.7
    ## - CompanyName.mercury     1  52591274 230626506 2122.0
    ## - CompanyName.volvo       1  58769861 236805093 2125.8
    ## - CompanyName.saab        1  60468474 238503706 2126.8
    ## - CompanyName.volkswagen  1  63929446 241964678 2128.8
    ## - enginetype.rotor        1  69033473 247068706 2131.8
    ## - CompanyName.renault     1  71180926 249216159 2133.1
    ## - CompanyName.toyota      1  71886458 249921691 2133.5
    ## - CompanyName.plymouth    1  89153662 267188895 2143.0
    ## - CompanyName.peugeot     1  89423973 267459206 2143.2
    ## - CompanyName.subaru      1  99182576 277217809 2148.3
    ## - CompanyName.nissan      1 100428908 278464140 2148.9
    ## - enginesize              1 105752214 283787446 2151.6
    ## - CompanyName.dodge       1 105863672 283898904 2151.7
    ## - CompanyName.mazda       1 116466719 294501951 2156.9
    ## - CompanyName.mitsubishi  1 125515705 303550937 2161.2
    ## 
    ## Step:  AIC=2086.57
    ## price ~ car_ID + fueltype + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + peakrpm + 
    ##     citympg + CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi
    ## 
    ##                          Df Sum of Sq       RSS    AIC
    ## <none>                                180059132 2086.6
    ## - fuelsystem.mpfi         1   2595286 182654417 2086.6
    ## - fueltype                1   2759717 182818848 2086.8
    ## - compressionratio        1   2975971 183035102 2086.9
    ## + fuelsystem.spdi         1   2023899 178035233 2086.9
    ## + CompanyName.audi        1   1747397 178311734 2087.2
    ## + boreratio               1   1255886 178803245 2087.6
    ## - carbody.hardtop         1   3957740 184016871 2087.7
    ## + horsepower              1    984047 179075085 2087.8
    ## + fuelsystem.mfi          1    804875 179254257 2087.9
    ## + cylindernumber.six      1    769564 179289567 2088.0
    ## + cylindernumber.four     1    717563 179341568 2088.0
    ## + enginetype.ohc          1    661274 179397857 2088.0
    ## + CompanyName.jaguar      1    534350 179524781 2088.2
    ## + drivewheel.fwd          1    195969 179863162 2088.4
    ## + CompanyName.buick       1    165457 179893674 2088.4
    ## + highwaympg              1     67217 179991914 2088.5
    ## + doornumber              1     61047 179998085 2088.5
    ## + enginetype.ohcv         1     49919 180009212 2088.5
    ## + symboling               1     47031 180012100 2088.5
    ## + carheight               1     32525 180026607 2088.6
    ## + carlength               1     15403 180043729 2088.6
    ## + wheelbase               1      5614 180053518 2088.6
    ## - carbody.sedan           1   5144649 185203780 2088.6
    ## - carbody.hatchback       1   5336704 185395836 2088.8
    ## - carbody.wagon           1   6335789 186394921 2089.5
    ## - CompanyName.chevrolet   1   9633782 189692914 2092.0
    ## - citympg                 1   9640035 189699166 2092.0
    ## - fuelsystem.2bbl         1   9702546 189761677 2092.1
    ## - carwidth                1  13076187 193135318 2094.6
    ## - cylindernumber.five     1  14430047 194489179 2095.6
    ## - curbweight              1  17876737 197935869 2098.1
    ## - CompanyName.porsche     1  18919286 198978418 2098.9
    ## - drivewheel.rwd          1  19123512 199182643 2099.0
    ## - stroke                  1  27985603 208044734 2105.2
    ## - enginelocation          1  28591543 208650675 2105.7
    ## - CompanyName.isuzu       1  30233045 210292177 2106.8
    ## - peakrpm                 1  31618763 211677894 2107.7
    ## - CompanyName.bmw         1  36511520 216570652 2111.0
    ## - aspiration              1  36832431 216891563 2111.2
    ## - car_ID                  1  41076845 221135976 2114.0
    ## - CompanyName.honda       1  54350545 234409676 2122.3
    ## - CompanyName.mercury     1  55039318 235098449 2122.7
    ## - CompanyName.volvo       1  59603277 239662409 2125.5
    ## - CompanyName.saab        1  60865335 240924466 2126.2
    ## - CompanyName.volkswagen  1  63913194 243972326 2128.0
    ## - CompanyName.renault     1  71500404 251559536 2132.4
    ## - CompanyName.toyota      1  71880023 251939155 2132.6
    ## - enginetype.rotor        1  72423829 252482960 2132.9
    ## - CompanyName.plymouth    1  87581815 267640946 2141.2
    ## - CompanyName.peugeot     1  92133415 272192546 2143.7
    ## - CompanyName.subaru      1  99432991 279492123 2147.4
    ## - CompanyName.nissan      1 100209469 280268600 2147.8
    ## - enginesize              1 104013914 284073046 2149.8
    ## - CompanyName.dodge       1 115397741 295456873 2155.4
    ## - CompanyName.mazda       1 116337215 296396347 2155.8
    ## - CompanyName.mitsubishi  1 123507367 303566498 2159.3

``` r
    # Checking model equation
      step
```

    ## 
    ## Call:
    ## lm(formula = price ~ car_ID + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + stroke + compressionratio + 
    ##     peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
    ##     cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
    ##     data = train)
    ## 
    ## Coefficients:
    ##            (Intercept)                  car_ID                fueltype  
    ##             -24506.983                  88.649                6772.909  
    ##             aspiration          enginelocation                carwidth  
    ##              -2664.430               -7865.506                 480.577  
    ##             curbweight              enginesize                  stroke  
    ##                  3.252                  94.043               -2718.468  
    ##       compressionratio                 peakrpm                 citympg  
    ##               -500.359                   1.963                 129.709  
    ##        CompanyName.bmw   CompanyName.chevrolet       CompanyName.dodge  
    ##               4780.669               -4260.437               -8933.656  
    ##      CompanyName.honda       CompanyName.isuzu       CompanyName.mazda  
    ##              -6909.778               -7528.799              -10270.481  
    ##    CompanyName.mercury  CompanyName.mitsubishi      CompanyName.nissan  
    ##             -10377.647              -14074.935              -13396.312  
    ##    CompanyName.peugeot    CompanyName.plymouth     CompanyName.porsche  
    ##             -13693.764              -16648.215               -7316.088  
    ##    CompanyName.renault        CompanyName.saab      CompanyName.subaru  
    ##             -16891.887              -14637.866              -19942.160  
    ##     CompanyName.toyota  CompanyName.volkswagen       CompanyName.volvo  
    ##             -18806.258              -20249.766              -19183.981  
    ##        carbody.hardtop       carbody.hatchback           carbody.sedan  
    ##              -1388.620               -1540.073               -1473.467  
    ##          carbody.wagon          drivewheel.rwd        enginetype.rotor  
    ##              -1787.227               -1948.776                9555.455  
    ##    cylindernumber.five         fuelsystem.2bbl         fuelsystem.mpfi  
    ##              -2399.439                1632.705                 901.554

``` r
    # Execute model_2
      model_2 <- lm(formula = price ~ car_ID + fueltype + aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + compressionratio + 
                    peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
                    CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
                    carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
                  data = train)
    
    # Summary of the model
      summary(model_2)
```

    ## 
    ## Call:
    ## lm(formula = price ~ car_ID + fueltype + aspiration + enginelocation + 
    ##     carwidth + curbweight + enginesize + stroke + compressionratio + 
    ##     peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
    ##     carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
    ##     cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2801.9  -724.5    86.0   576.1  3608.3 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -2.451e+04  1.004e+04  -2.441  0.01632 *  
    ## car_ID                  8.865e+01  1.820e+01   4.871 3.99e-06 ***
    ## fueltype                6.773e+03  5.365e+03   1.263  0.20958    
    ## aspiration             -2.664e+03  5.777e+02  -4.612 1.14e-05 ***
    ## enginelocation         -7.866e+03  1.936e+03  -4.064 9.40e-05 ***
    ## carwidth                4.806e+02  1.749e+02   2.748  0.00707 ** 
    ## curbweight              3.252e+00  1.012e+00   3.213  0.00175 ** 
    ## enginesize              9.404e+01  1.213e+01   7.751 6.41e-12 ***
    ## stroke                 -2.718e+03  6.762e+02  -4.020  0.00011 ***
    ## compressionratio       -5.004e+02  3.816e+02  -1.311  0.19272    
    ## peakrpm                 1.963e+00  4.593e-01   4.273 4.27e-05 ***
    ## citympg                 1.297e+02  5.497e+01   2.360  0.02016 *  
    ## CompanyName.bmw         4.781e+03  1.041e+03   4.592 1.23e-05 ***
    ## CompanyName.chevrolet  -4.260e+03  1.806e+03  -2.359  0.02020 *  
    ## CompanyName.dodge      -8.934e+03  1.094e+03  -8.164 8.06e-13 ***
    ## CompanyName.honda      -6.910e+03  1.233e+03  -5.603 1.74e-07 ***
    ## CompanyName.isuzu      -7.529e+03  1.802e+03  -4.179 6.12e-05 ***
    ## CompanyName.mazda      -1.027e+04  1.253e+03  -8.197 6.82e-13 ***
    ## CompanyName.mercury    -1.038e+04  1.841e+03  -5.638 1.49e-07 ***
    ## CompanyName.mitsubishi -1.407e+04  1.666e+03  -8.446 1.93e-13 ***
    ## CompanyName.nissan     -1.340e+04  1.761e+03  -7.608 1.31e-11 ***
    ## CompanyName.peugeot    -1.369e+04  1.877e+03  -7.295 6.14e-11 ***
    ## CompanyName.plymouth   -1.665e+04  2.341e+03  -7.112 1.50e-10 ***
    ## CompanyName.porsche    -7.316e+03  2.213e+03  -3.306  0.00130 ** 
    ## CompanyName.renault    -1.689e+04  2.629e+03  -6.426 4.02e-09 ***
    ## CompanyName.saab       -1.464e+04  2.469e+03  -5.929 4.01e-08 ***
    ## CompanyName.subaru     -1.994e+04  2.631e+03  -7.578 1.51e-11 ***
    ## CompanyName.toyota     -1.881e+04  2.919e+03  -6.443 3.71e-09 ***
    ## CompanyName.volkswagen -2.025e+04  3.333e+03  -6.076 2.05e-08 ***
    ## CompanyName.volvo      -1.918e+04  3.270e+03  -5.867 5.31e-08 ***
    ## carbody.hardtop        -1.389e+03  9.184e+02  -1.512  0.13358    
    ## carbody.hatchback      -1.540e+03  8.772e+02  -1.756  0.08209 .  
    ## carbody.sedan          -1.473e+03  8.548e+02  -1.724  0.08772 .  
    ## carbody.wagon          -1.787e+03  9.343e+02  -1.913  0.05850 .  
    ## drivewheel.rwd         -1.949e+03  5.864e+02  -3.323  0.00123 ** 
    ## enginetype.rotor        9.555e+03  1.477e+03   6.468 3.31e-09 ***
    ## cylindernumber.five    -2.399e+03  8.311e+02  -2.887  0.00473 ** 
    ## fuelsystem.2bbl         1.633e+03  6.897e+02   2.367  0.01977 *  
    ## fuelsystem.mpfi         9.016e+02  7.364e+02   1.224  0.22359    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1316 on 104 degrees of freedom
    ## Multiple R-squared:  0.981,  Adjusted R-squared:  0.9741 
    ## F-statistic: 141.3 on 38 and 104 DF,  p-value: < 2.2e-16

``` r
    # Let us check for multicollinearity
      vif(model_2)
```

    ##                 car_ID               fueltype             aspiration 
    ##              92.391746             236.196633               4.221473 
    ##         enginelocation               carwidth             curbweight 
    ##               6.355196              11.981621              23.363835 
    ##             enginesize                 stroke       compressionratio 
    ##              21.078397               3.648684             213.666022 
    ##                peakrpm                citympg        CompanyName.bmw 
    ##               4.085122              10.988961               1.838487 
    ##  CompanyName.chevrolet      CompanyName.dodge      CompanyName.honda 
    ##               1.870957               2.689056               9.656969 
    ##      CompanyName.isuzu      CompanyName.mazda    CompanyName.mercury 
    ##               1.861752               9.967344               1.943019 
    ## CompanyName.mitsubishi     CompanyName.nissan    CompanyName.peugeot 
    ##              12.114003              21.164714              11.699419 
    ##   CompanyName.plymouth    CompanyName.porsche    CompanyName.renault 
    ##              18.191026              10.999979               7.869749 
    ##       CompanyName.saab     CompanyName.subaru     CompanyName.toyota 
    ##              16.986291              22.990566             107.766134 
    ## CompanyName.volkswagen      CompanyName.volvo        carbody.hardtop 
    ##              54.107912              41.106287               3.679658 
    ##      carbody.hatchback          carbody.sedan          carbody.wagon 
    ##              14.582480              14.761582               8.306113 
    ##         drivewheel.rwd       enginetype.rotor    cylindernumber.five 
    ##               6.624276               3.702836               3.364829 
    ##        fuelsystem.2bbl        fuelsystem.mpfi 
    ##               8.572813              10.998629

``` r
    # fueltype has a high VIF and insignificant p-value thus, we can remove fueltype variable and run the model again
      model_3 <- lm(formula = price ~ car_ID + aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + compressionratio + 
                    peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
                    CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + carbody.hardtop + carbody.hatchback + 
                    carbody.sedan + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
                  data = train)
    
    # Check VIF again
      vif(model_3)
```

    ##                 car_ID             aspiration         enginelocation 
    ##              92.070890               3.364970               6.355186 
    ##               carwidth             curbweight             enginesize 
    ##              11.417497              23.003412              19.926426 
    ##                 stroke       compressionratio                peakrpm 
    ##               3.642439               6.528638               4.003788 
    ##                citympg        CompanyName.bmw  CompanyName.chevrolet 
    ##              10.617151               1.758519               1.856145 
    ##      CompanyName.dodge      CompanyName.honda      CompanyName.isuzu 
    ##               2.601550               9.636443               1.806563 
    ##      CompanyName.mazda    CompanyName.mercury CompanyName.mitsubishi 
    ##               9.635586               1.881177              11.909635 
    ##     CompanyName.nissan    CompanyName.peugeot   CompanyName.plymouth 
    ##              20.909525              10.642458              17.989075 
    ##    CompanyName.porsche    CompanyName.renault       CompanyName.saab 
    ##              10.949962               7.797128              16.983937 
    ##     CompanyName.subaru     CompanyName.toyota CompanyName.volkswagen 
    ##              22.752057             106.979101              53.975484 
    ##      CompanyName.volvo        carbody.hardtop      carbody.hatchback 
    ##              40.699266               3.557543              14.243624 
    ##          carbody.sedan          carbody.wagon         drivewheel.rwd 
    ##              14.385414               8.025610               5.903649 
    ##       enginetype.rotor    cylindernumber.five        fuelsystem.2bbl 
    ##               3.638434               2.992890               7.744089 
    ##        fuelsystem.mpfi 
    ##               9.954533

``` r
    # Checking p-values of the variables
      summary(model_3)
```

    ## 
    ## Call:
    ## lm(formula = price ~ car_ID + aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + peakrpm + 
    ##     citympg + CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.hatchback + carbody.sedan + carbody.wagon + 
    ##     drivewheel.rwd + enginetype.rotor + cylindernumber.five + 
    ##     fuelsystem.2bbl + fuelsystem.mpfi, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2740.5  -754.0    96.2   649.6  3771.7 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -25075.438  10056.818  -2.493 0.014215 *  
    ## car_ID                     87.295     18.220   4.791 5.47e-06 ***
    ## aspiration              -2992.944    517.206  -5.787 7.50e-08 ***
    ## enginelocation          -7868.697   1940.990  -4.054 9.69e-05 ***
    ## carwidth                  432.672    171.185   2.528 0.012977 *  
    ## curbweight                  3.411      1.007   3.387 0.000996 ***
    ## enginesize                 97.624     11.830   8.252 4.89e-13 ***
    ## stroke                  -2683.149    677.486  -3.960 0.000136 ***
    ## compressionratio          -25.941     66.900  -0.388 0.698980    
    ## peakrpm                     1.881      0.456   4.125 7.44e-05 ***
    ## citympg                   116.943     54.184   2.158 0.033187 *  
    ## CompanyName.bmw          5054.786   1021.016   4.951 2.83e-06 ***
    ## CompanyName.chevrolet   -4057.548   1804.038  -2.249 0.026590 *  
    ## CompanyName.dodge       -8684.436   1079.351  -8.046 1.39e-12 ***
    ## CompanyName.honda       -6981.562   1235.424  -5.651 1.38e-07 ***
    ## CompanyName.isuzu       -7137.164   1779.780  -4.010 0.000114 ***
    ## CompanyName.mazda       -9981.889   1235.369  -8.080 1.17e-12 ***
    ## CompanyName.mercury     -9963.077   1816.162  -5.486 2.87e-07 ***
    ## CompanyName.mitsubishi -13801.664   1656.995  -8.329 3.30e-13 ***
    ## CompanyName.nissan     -13152.201   1755.143  -7.494 2.21e-11 ***
    ## CompanyName.peugeot    -12981.413   1795.432  -7.230 8.11e-11 ***
    ## CompanyName.plymouth   -16336.838   2334.277  -6.999 2.52e-10 ***
    ## CompanyName.porsche     -7504.504   2214.383  -3.389 0.000989 ***
    ## CompanyName.renault    -16573.094   2623.775  -6.317 6.56e-09 ***
    ## CompanyName.saab       -14674.558   2475.589  -5.928 3.96e-08 ***
    ## CompanyName.subaru     -19603.771   2625.175  -7.468 2.51e-11 ***
    ## CompanyName.toyota     -18491.349   2916.235  -6.341 5.85e-09 ***
    ## CompanyName.volkswagen -20041.597   3338.170  -6.004 2.80e-08 ***
    ## CompanyName.volvo      -18773.219   3262.561  -5.754 8.69e-08 ***
    ## carbody.hardtop         -1599.859    905.622  -1.767 0.080204 .  
    ## carbody.hatchback       -1708.895    869.391  -1.966 0.051983 .  
    ## carbody.sedan           -1645.741    846.200  -1.945 0.054466 .  
    ## carbody.wagon           -2003.988    920.948  -2.176 0.031797 *  
    ## drivewheel.rwd          -2192.948    555.117  -3.950 0.000142 ***
    ## enginetype.rotor         9309.460   1468.644   6.339 5.91e-09 ***
    ## cylindernumber.five     -2050.570    786.060  -2.609 0.010415 *  
    ## fuelsystem.2bbl          1361.973    657.361   2.072 0.040727 *  
    ## fuelsystem.mpfi           615.115    702.515   0.876 0.383252    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1320 on 105 degrees of freedom
    ## Multiple R-squared:  0.9807, Adjusted R-squared:  0.9739 
    ## F-statistic: 144.3 on 37 and 105 DF,  p-value: < 2.2e-16

``` r
    # As car_ID, carwidth, curbweight, enginesize, CompanyName.nissan,CompanyName.subaru, CompanyName.toyota, CompanyName.volkswagen, 
    #CompanyName.volvo and CompanyName.saab are having high VIF value but low p-value, so keep those variables and will check later
    # carbody.hatchback and carbody.sedan are having high VIF and insignificant p-value. Also car_ID VIF is very high and doesn't provide much information, so removing those and build model again
      model_4 <- lm(formula = price ~ aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + compressionratio + 
                    peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
                    CompanyName.porsche + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + carbody.hardtop + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
                  data = train)
    
    # Check VIF again
      vif(model_4)
```

    ##             aspiration         enginelocation               carwidth 
    ##               3.185591               6.146161              10.347728 
    ##             curbweight             enginesize                 stroke 
    ##              22.833059              18.011392               3.247245 
    ##       compressionratio                peakrpm                citympg 
    ##               6.125470               3.903793              10.214308 
    ##        CompanyName.bmw  CompanyName.chevrolet      CompanyName.dodge 
    ##               1.508479               1.651514               2.111439 
    ##      CompanyName.honda      CompanyName.isuzu      CompanyName.mazda 
    ##               6.191058               1.471948               4.181546 
    ##    CompanyName.mercury CompanyName.mitsubishi     CompanyName.nissan 
    ##               1.349319               3.268818               3.593023 
    ##    CompanyName.peugeot   CompanyName.plymouth    CompanyName.porsche 
    ##               3.276848               2.756890               5.503265 
    ##    CompanyName.renault       CompanyName.saab     CompanyName.subaru 
    ##               1.691788               2.530189               2.685273 
    ##     CompanyName.toyota CompanyName.volkswagen      CompanyName.volvo 
    ##               5.345851               2.846116               2.920010 
    ##        carbody.hardtop          carbody.wagon         drivewheel.rwd 
    ##               1.467641               1.684754               5.320021 
    ##       enginetype.rotor    cylindernumber.five        fuelsystem.2bbl 
    ##               3.546096               2.838873               7.308192 
    ##        fuelsystem.mpfi 
    ##               9.874421

``` r
    # Checking p-values of the variables
      summary(model_4)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + compressionratio + peakrpm + 
    ##     citympg + CompanyName.bmw + CompanyName.chevrolet + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.porsche + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     carbody.hardtop + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
    ##     cylindernumber.five + fuelsystem.2bbl + fuelsystem.mpfi, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3586.2  -985.7     0.0   933.7  3748.9 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -3.542e+04  1.066e+04  -3.323 0.001215 ** 
    ## aspiration             -3.398e+03  5.704e+02  -5.957 3.26e-08 ***
    ## enginelocation         -9.755e+03  2.164e+03  -4.508 1.66e-05 ***
    ## carwidth                6.150e+02  1.847e+02   3.329 0.001193 ** 
    ## curbweight              3.740e+00  1.137e+00   3.289 0.001358 ** 
    ## enginesize              1.136e+02  1.275e+01   8.910 1.39e-14 ***
    ## stroke                 -3.485e+03  7.251e+02  -4.806 5.01e-06 ***
    ## compressionratio        2.650e+01  7.346e+01   0.361 0.718956    
    ## peakrpm                 1.749e+00  5.104e-01   3.427 0.000864 ***
    ## citympg                 1.238e+02  6.024e+01   2.055 0.042277 *  
    ## CompanyName.bmw         3.471e+03  1.072e+03   3.238 0.001600 ** 
    ## CompanyName.chevrolet  -2.222e+03  1.929e+03  -1.152 0.251887    
    ## CompanyName.dodge      -7.508e+03  1.102e+03  -6.811 5.70e-10 ***
    ## CompanyName.honda      -4.022e+03  1.122e+03  -3.583 0.000511 ***
    ## CompanyName.isuzu      -4.744e+03  1.821e+03  -2.605 0.010484 *  
    ## CompanyName.mazda      -6.296e+03  9.225e+02  -6.825 5.32e-10 ***
    ## CompanyName.mercury    -6.545e+03  1.744e+03  -3.754 0.000282 ***
    ## CompanyName.mitsubishi -7.739e+03  9.840e+02  -7.864 3.01e-12 ***
    ## CompanyName.nissan     -6.136e+03  8.247e+02  -7.440 2.56e-11 ***
    ## CompanyName.peugeot    -6.640e+03  1.129e+03  -5.879 4.66e-08 ***
    ## CompanyName.plymouth   -6.792e+03  1.036e+03  -6.557 1.95e-09 ***
    ## CompanyName.porsche    -9.088e+02  1.780e+03  -0.511 0.610620    
    ## CompanyName.renault    -6.153e+03  1.385e+03  -4.441 2.17e-05 ***
    ## CompanyName.saab       -4.671e+03  1.083e+03  -4.312 3.59e-05 ***
    ## CompanyName.subaru     -8.787e+03  1.022e+03  -8.595 7.10e-14 ***
    ## CompanyName.toyota     -5.714e+03  7.390e+02  -7.732 5.89e-12 ***
    ## CompanyName.volkswagen -4.664e+03  8.689e+02  -5.367 4.61e-07 ***
    ## CompanyName.volvo      -4.361e+03  9.906e+02  -4.403 2.52e-05 ***
    ## carbody.hardtop         1.953e+02  6.594e+02   0.296 0.767701    
    ## carbody.wagon          -2.767e+02  4.783e+02  -0.578 0.564179    
    ## drivewheel.rwd         -1.526e+03  5.973e+02  -2.555 0.012006 *  
    ## enginetype.rotor        9.763e+03  1.644e+03   5.940 3.52e-08 ***
    ## cylindernumber.five    -2.081e+03  8.678e+02  -2.399 0.018176 *  
    ## fuelsystem.2bbl         1.928e+03  7.239e+02   2.664 0.008915 ** 
    ## fuelsystem.mpfi         6.984e+02  7.931e+02   0.881 0.380542    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1496 on 108 degrees of freedom
    ## Multiple R-squared:  0.9745, Adjusted R-squared:  0.9665 
    ## F-statistic: 121.4 on 34 and 108 DF,  p-value: < 2.2e-16

``` r
    # compressionratio, CompanyName.porsche and fuelsystem.mpfi are having high VIF and insignificant p-value
      model_5 <- lm(formula = price ~ aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + 
                    peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + carbody.hardtop + carbody.wagon + drivewheel.rwd + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl, 
                  data = train)
    
    # Check VIF again
      vif(model_5)
```

    ##             aspiration         enginelocation               carwidth 
    ##               2.402299               2.160750               8.461518 
    ##             curbweight             enginesize                 stroke 
    ##              20.576655              16.656022               3.220415 
    ##                peakrpm                citympg        CompanyName.bmw 
    ##               3.666340               4.976366               1.461096 
    ##  CompanyName.chevrolet      CompanyName.dodge      CompanyName.honda 
    ##               1.530141               2.039697               4.284535 
    ##      CompanyName.isuzu      CompanyName.mazda    CompanyName.mercury 
    ##               1.453314               3.874740               1.291148 
    ## CompanyName.mitsubishi     CompanyName.nissan    CompanyName.peugeot 
    ##               2.832079               3.430473               3.028232 
    ##   CompanyName.plymouth    CompanyName.renault       CompanyName.saab 
    ##               2.490799               1.663082               2.396102 
    ##     CompanyName.subaru     CompanyName.toyota CompanyName.volkswagen 
    ##               2.607739               5.131615               2.715040 
    ##      CompanyName.volvo        carbody.hardtop          carbody.wagon 
    ##               2.578314               1.459819               1.661070 
    ##         drivewheel.rwd       enginetype.rotor    cylindernumber.five 
    ##               5.183766               2.473953               2.477451 
    ##        fuelsystem.2bbl 
    ##               3.020681

``` r
    # Checking p-values of the variables
      summary(model_5)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + peakrpm + citympg + CompanyName.bmw + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.wagon + drivewheel.rwd + 
    ##     enginetype.rotor + cylindernumber.five + fuelsystem.2bbl, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3401.1  -923.5   -93.0   918.7  3840.3 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -3.465e+04  1.007e+04  -3.441 0.000817 ***
    ## aspiration             -3.147e+03  4.912e+02  -6.407 3.71e-09 ***
    ## enginelocation         -8.889e+03  1.272e+03  -6.987 2.20e-10 ***
    ## carwidth                6.020e+02  1.657e+02   3.634 0.000424 ***
    ## curbweight              3.788e+00  1.071e+00   3.539 0.000588 ***
    ## enginesize              1.127e+02  1.216e+01   9.267 1.74e-15 ***
    ## stroke                 -3.470e+03  7.161e+02  -4.846 4.11e-06 ***
    ## peakrpm                 1.749e+00  4.905e-01   3.565 0.000537 ***
    ## citympg                 1.117e+02  4.170e+01   2.679 0.008499 ** 
    ## CompanyName.bmw         3.535e+03  1.046e+03   3.379 0.001003 ** 
    ## CompanyName.chevrolet  -2.084e+03  1.841e+03  -1.132 0.260078    
    ## CompanyName.dodge      -7.527e+03  1.074e+03  -7.007 1.99e-10 ***
    ## CompanyName.honda      -4.412e+03  9.260e+02  -4.765 5.77e-06 ***
    ## CompanyName.isuzu      -4.937e+03  1.794e+03  -2.751 0.006937 ** 
    ## CompanyName.mazda      -6.326e+03  8.806e+02  -7.184 8.23e-11 ***
    ## CompanyName.mercury    -6.259e+03  1.691e+03  -3.701 0.000336 ***
    ## CompanyName.mitsubishi -7.904e+03  9.083e+02  -8.703 3.40e-14 ***
    ## CompanyName.nissan     -6.108e+03  7.991e+02  -7.644 8.11e-12 ***
    ## CompanyName.peugeot    -6.595e+03  1.077e+03  -6.126 1.40e-08 ***
    ## CompanyName.plymouth   -6.934e+03  9.763e+02  -7.102 1.24e-10 ***
    ## CompanyName.renault    -5.999e+03  1.362e+03  -4.404 2.46e-05 ***
    ## CompanyName.saab       -4.467e+03  1.045e+03  -4.274 4.08e-05 ***
    ## CompanyName.subaru     -8.702e+03  9.990e+02  -8.711 3.26e-14 ***
    ## CompanyName.toyota     -5.682e+03  7.179e+02  -7.915 2.03e-12 ***
    ## CompanyName.volkswagen -4.560e+03  8.416e+02  -5.418 3.54e-07 ***
    ## CompanyName.volvo      -4.147e+03  9.230e+02  -4.493 1.73e-05 ***
    ## carbody.hardtop         2.409e+02  6.521e+02   0.369 0.712487    
    ## carbody.wagon          -3.209e+02  4.710e+02  -0.681 0.497056    
    ## drivewheel.rwd         -1.478e+03  5.847e+02  -2.528 0.012877 *  
    ## enginetype.rotor        9.073e+03  1.361e+03   6.665 1.07e-09 ***
    ## cylindernumber.five    -2.015e+03  8.039e+02  -2.506 0.013657 *  
    ## fuelsystem.2bbl         1.451e+03  4.615e+02   3.143 0.002143 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1483 on 111 degrees of freedom
    ## Multiple R-squared:  0.9742, Adjusted R-squared:  0.967 
    ## F-statistic: 135.4 on 31 and 111 DF,  p-value: < 2.2e-16

``` r
    # drivewheel.rwd is having high VIF and insignificant p-value
      model_6 <- lm(formula = price ~ aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + 
                    peakrpm + citympg + CompanyName.bmw + CompanyName.chevrolet + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + carbody.hardtop + carbody.wagon + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl, 
                  data = train)
    
    # Check VIF again
      vif(model_6)
```

    ##             aspiration         enginelocation               carwidth 
    ##               2.391884               2.152409               8.206932 
    ##             curbweight             enginesize                 stroke 
    ##              18.980269              15.931730               3.085317 
    ##                peakrpm                citympg        CompanyName.bmw 
    ##               3.460826               4.914205               1.395351 
    ##  CompanyName.chevrolet      CompanyName.dodge      CompanyName.honda 
    ##               1.529030               2.021300               4.234603 
    ##      CompanyName.isuzu      CompanyName.mazda    CompanyName.mercury 
    ##               1.354087               3.873402               1.253780 
    ## CompanyName.mitsubishi     CompanyName.nissan    CompanyName.peugeot 
    ##               2.803959               3.426354               2.786471 
    ##   CompanyName.plymouth    CompanyName.renault       CompanyName.saab 
    ##               2.489533               1.661044               2.183180 
    ##     CompanyName.subaru     CompanyName.toyota CompanyName.volkswagen 
    ##               2.575736               4.956610               2.678335 
    ##      CompanyName.volvo        carbody.hardtop          carbody.wagon 
    ##               2.401865               1.397129               1.618382 
    ##       enginetype.rotor    cylindernumber.five        fuelsystem.2bbl 
    ##               2.159113               2.469752               2.957973

``` r
    # Some variables are having high VIF values but very low p-value, so we're not reving those at this point of time
    # Now look for the variables with high p values and then remove those
      summary(model_6)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + peakrpm + citympg + CompanyName.bmw + 
    ##     CompanyName.chevrolet + CompanyName.dodge + CompanyName.honda + 
    ##     CompanyName.isuzu + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + carbody.hardtop + carbody.wagon + enginetype.rotor + 
    ##     cylindernumber.five + fuelsystem.2bbl, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3380.5  -926.3   -95.1   904.1  4449.2 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -3.651e+04  1.028e+04  -3.552 0.000561 ***
    ## aspiration             -3.065e+03  5.018e+02  -6.108 1.49e-08 ***
    ## enginelocation         -9.088e+03  1.300e+03  -6.992 2.08e-10 ***
    ## carwidth                6.747e+02  1.670e+02   4.040 9.85e-05 ***
    ## curbweight              3.035e+00  1.053e+00   2.883 0.004725 ** 
    ## enginesize              1.063e+02  1.217e+01   8.729 2.79e-14 ***
    ## stroke                 -3.100e+03  7.175e+02  -4.320 3.39e-05 ***
    ## peakrpm                 1.455e+00  4.879e-01   2.983 0.003507 ** 
    ## citympg                 9.994e+01  4.242e+01   2.356 0.020218 *  
    ## CompanyName.bmw         2.974e+03  1.047e+03   2.842 0.005333 ** 
    ## CompanyName.chevrolet  -2.210e+03  1.884e+03  -1.173 0.243418    
    ## CompanyName.dodge      -7.269e+03  1.095e+03  -6.640 1.17e-09 ***
    ## CompanyName.honda      -4.159e+03  9.425e+02  -4.413 2.36e-05 ***
    ## CompanyName.isuzu      -6.122e+03  1.773e+03  -3.452 0.000785 ***
    ## CompanyName.mazda      -6.368e+03  9.014e+02  -7.065 1.45e-10 ***
    ## CompanyName.mercury    -6.986e+03  1.706e+03  -4.094 8.02e-05 ***
    ## CompanyName.mitsubishi -7.675e+03  9.252e+02  -8.296 2.70e-13 ***
    ## CompanyName.nissan     -6.178e+03  8.176e+02  -7.556 1.22e-11 ***
    ## CompanyName.peugeot    -7.364e+03  1.057e+03  -6.966 2.37e-10 ***
    ## CompanyName.plymouth   -6.989e+03  9.993e+02  -6.994 2.06e-10 ***
    ## CompanyName.renault    -5.878e+03  1.394e+03  -4.218 5.03e-05 ***
    ## CompanyName.saab       -3.679e+03  1.021e+03  -3.602 0.000472 ***
    ## CompanyName.subaru     -8.422e+03  1.016e+03  -8.286 2.84e-13 ***
    ## CompanyName.toyota     -6.018e+03  7.224e+02  -8.330 2.25e-13 ***
    ## CompanyName.volkswagen -4.312e+03  8.557e+02  -5.039 1.81e-06 ***
    ## CompanyName.volvo      -4.758e+03  9.121e+02  -5.216 8.45e-07 ***
    ## carbody.hardtop        -1.007e+02  6.531e+02  -0.154 0.877745    
    ## carbody.wagon          -1.300e+02  4.759e+02  -0.273 0.785183    
    ## enginetype.rotor        7.845e+03  1.302e+03   6.026 2.20e-08 ***
    ## cylindernumber.five    -1.901e+03  8.217e+02  -2.314 0.022502 *  
    ## fuelsystem.2bbl         1.619e+03  4.675e+02   3.462 0.000760 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1518 on 112 degrees of freedom
    ## Multiple R-squared:  0.9728, Adjusted R-squared:  0.9655 
    ## F-statistic: 133.3 on 30 and 112 DF,  p-value: < 2.2e-16

``` r
    # Removing "carbody.hardtop", "carbody.wagon" and "CompanyName.chevrolet"
      model_7 <- lm(formula = price ~ aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + 
                    peakrpm + citympg + CompanyName.bmw + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + enginetype.rotor + 
                    cylindernumber.five + fuelsystem.2bbl, 
                  data = train)
    
      summary(model_7)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + peakrpm + citympg + CompanyName.bmw + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     enginetype.rotor + cylindernumber.five + fuelsystem.2bbl, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3392.0  -988.5   -77.0   974.3  4364.9 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -3.892e+04  1.000e+04  -3.891 0.000168 ***
    ## aspiration             -3.025e+03  4.775e+02  -6.336 4.74e-09 ***
    ## enginelocation         -9.361e+03  1.208e+03  -7.750 4.01e-12 ***
    ## carwidth                7.277e+02  1.601e+02   4.545 1.37e-05 ***
    ## curbweight              2.929e+00  9.081e-01   3.225 0.001638 ** 
    ## enginesize              1.055e+02  1.090e+01   9.677  < 2e-16 ***
    ## stroke                 -3.117e+03  7.088e+02  -4.397 2.46e-05 ***
    ## peakrpm                 1.383e+00  4.766e-01   2.902 0.004445 ** 
    ## citympg                 8.642e+01  4.048e+01   2.135 0.034893 *  
    ## CompanyName.bmw         3.190e+03  1.025e+03   3.112 0.002343 ** 
    ## CompanyName.dodge      -6.911e+03  1.017e+03  -6.796 5.05e-10 ***
    ## CompanyName.honda      -3.750e+03  8.543e+02  -4.390 2.54e-05 ***
    ## CompanyName.isuzu      -5.639e+03  1.716e+03  -3.286 0.001350 ** 
    ## CompanyName.mazda      -6.013e+03  8.440e+02  -7.125 9.74e-11 ***
    ## CompanyName.mercury    -6.826e+03  1.690e+03  -4.040 9.69e-05 ***
    ## CompanyName.mitsubishi -7.309e+03  8.610e+02  -8.489 8.38e-14 ***
    ## CompanyName.nissan     -5.814e+03  7.329e+02  -7.933 1.55e-12 ***
    ## CompanyName.peugeot    -7.253e+03  1.041e+03  -6.967 2.15e-10 ***
    ## CompanyName.plymouth   -6.593e+03  9.170e+02  -7.190 7.02e-11 ***
    ## CompanyName.renault    -5.718e+03  1.341e+03  -4.264 4.14e-05 ***
    ## CompanyName.saab       -3.456e+03  9.904e+02  -3.489 0.000688 ***
    ## CompanyName.subaru     -8.125e+03  9.683e+02  -8.391 1.40e-13 ***
    ## CompanyName.toyota     -5.705e+03  6.585e+02  -8.664 3.31e-14 ***
    ## CompanyName.volkswagen -3.997e+03  8.080e+02  -4.947 2.60e-06 ***
    ## CompanyName.volvo      -4.616e+03  8.941e+02  -5.163 1.03e-06 ***
    ## enginetype.rotor        7.673e+03  1.260e+03   6.089 1.54e-08 ***
    ## cylindernumber.five    -1.832e+03  8.062e+02  -2.272 0.024918 *  
    ## fuelsystem.2bbl         1.558e+03  4.601e+02   3.385 0.000973 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1509 on 115 degrees of freedom
    ## Multiple R-squared:  0.9724, Adjusted R-squared:  0.9659 
    ## F-statistic:   150 on 27 and 115 DF,  p-value: < 2.2e-16

``` r
    # Removing "cylindernumber.five" and "citympg"
      model_8 <- lm(formula = price ~ aspiration + enginelocation + 
                    carwidth + curbweight + enginesize + stroke + 
                    peakrpm + CompanyName.bmw + 
                    CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                    CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                    CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                    CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                    CompanyName.volvo + enginetype.rotor + fuelsystem.2bbl, 
                  data = train)
    
      summary(model_8)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     curbweight + enginesize + stroke + peakrpm + CompanyName.bmw + 
    ##     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.renault + CompanyName.saab + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     enginetype.rotor + fuelsystem.2bbl, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3404.9  -916.0   -48.5   923.0  4346.5 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -2.459e+04  9.426e+03  -2.609 0.010271 *  
    ## aspiration             -2.823e+03  4.925e+02  -5.732 7.88e-08 ***
    ## enginelocation         -9.258e+03  1.256e+03  -7.374 2.58e-11 ***
    ## carwidth                6.115e+02  1.545e+02   3.957 0.000131 ***
    ## curbweight              1.810e+00  8.629e-01   2.097 0.038133 *  
    ## enginesize              1.131e+02  9.735e+00  11.617  < 2e-16 ***
    ## stroke                 -3.318e+03  7.300e+02  -4.545 1.35e-05 ***
    ## peakrpm                 8.239e-01  4.219e-01   1.953 0.053254 .  
    ## CompanyName.bmw         3.543e+03  1.014e+03   3.495 0.000669 ***
    ## CompanyName.dodge      -6.268e+03  9.912e+02  -6.323 4.85e-09 ***
    ## CompanyName.honda      -2.758e+03  8.110e+02  -3.400 0.000921 ***
    ## CompanyName.isuzu      -5.810e+03  1.754e+03  -3.312 0.001234 ** 
    ## CompanyName.mazda      -5.417e+03  7.786e+02  -6.957 2.14e-10 ***
    ## CompanyName.mercury    -6.098e+03  1.665e+03  -3.662 0.000378 ***
    ## CompanyName.mitsubishi -6.639e+03  8.023e+02  -8.275 2.35e-13 ***
    ## CompanyName.nissan     -5.136e+03  6.947e+02  -7.393 2.33e-11 ***
    ## CompanyName.peugeot    -6.054e+03  9.079e+02  -6.668 9.00e-10 ***
    ## CompanyName.plymouth   -5.885e+03  8.844e+02  -6.654 9.63e-10 ***
    ## CompanyName.renault    -5.180e+03  1.301e+03  -3.981 0.000119 ***
    ## CompanyName.saab       -2.795e+03  9.077e+02  -3.080 0.002584 ** 
    ## CompanyName.subaru     -7.802e+03  9.413e+02  -8.288 2.20e-13 ***
    ## CompanyName.toyota     -5.163e+03  5.822e+02  -8.868 9.93e-15 ***
    ## CompanyName.volkswagen -3.264e+03  7.635e+02  -4.276 3.91e-05 ***
    ## CompanyName.volvo      -3.614e+03  7.738e+02  -4.670 8.08e-06 ***
    ## enginetype.rotor        7.687e+03  1.251e+03   6.147 1.13e-08 ***
    ## fuelsystem.2bbl         1.454e+03  4.768e+02   3.050 0.002832 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1569 on 117 degrees of freedom
    ## Multiple R-squared:  0.9696, Adjusted R-squared:  0.9631 
    ## F-statistic: 149.4 on 25 and 117 DF,  p-value: < 2.2e-16

``` r
    # Removing "peakrpm" and "curbweight"
      model_9 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor + fuelsystem.2bbl, 
                   data = train)
    
      summary(model_9)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + stroke + CompanyName.bmw + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + enginetype.rotor + 
    ##     fuelsystem.2bbl, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3647.1  -979.8     0.0   845.0  3785.3 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -26122.276   8827.091  -2.959 0.003721 ** 
    ## aspiration              -2802.934    459.666  -6.098 1.37e-08 ***
    ## enginelocation          -9623.192   1232.484  -7.808 2.53e-12 ***
    ## carwidth                  767.743    145.295   5.284 5.80e-07 ***
    ## enginesize                121.484      7.617  15.948  < 2e-16 ***
    ## stroke                  -3454.506    728.525  -4.742 5.93e-06 ***
    ## CompanyName.bmw          3530.659   1042.270   3.387 0.000957 ***
    ## CompanyName.dodge       -6242.269    992.732  -6.288 5.52e-09 ***
    ## CompanyName.honda       -2742.164    786.526  -3.486 0.000686 ***
    ## CompanyName.isuzu       -5535.576   1797.621  -3.079 0.002576 ** 
    ## CompanyName.mazda       -5944.303    774.849  -7.672 5.16e-12 ***
    ## CompanyName.mercury     -6187.823   1713.563  -3.611 0.000448 ***
    ## CompanyName.mitsubishi  -6675.460    791.831  -8.430 9.34e-14 ***
    ## CompanyName.nissan      -5305.626    691.001  -7.678 4.99e-12 ***
    ## CompanyName.peugeot     -5916.957    828.678  -7.140 7.99e-11 ***
    ## CompanyName.plymouth    -5832.672    877.987  -6.643 9.70e-10 ***
    ## CompanyName.renault     -5513.272   1327.341  -4.154 6.19e-05 ***
    ## CompanyName.saab        -2514.871    923.761  -2.722 0.007455 ** 
    ## CompanyName.subaru      -8276.151    946.721  -8.742 1.75e-14 ***
    ## CompanyName.toyota      -5365.402    590.429  -9.087 2.71e-15 ***
    ## CompanyName.volkswagen  -3650.954    774.434  -4.714 6.65e-06 ***
    ## CompanyName.volvo       -3256.218    786.459  -4.140 6.51e-05 ***
    ## enginetype.rotor         8937.489   1210.974   7.380 2.34e-11 ***
    ## fuelsystem.2bbl          1095.738    459.617   2.384 0.018706 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1615 on 119 degrees of freedom
    ## Multiple R-squared:  0.9673, Adjusted R-squared:  0.9609 
    ## F-statistic: 152.9 on 23 and 119 DF,  p-value: < 2.2e-16

``` r
    # Removing "fuelsystem.2bbl"
      model_10 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_10)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + stroke + CompanyName.bmw + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.isuzu + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
    ##     CompanyName.saab + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + enginetype.rotor, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3958.7  -916.7     0.0   830.4  4088.2 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -23936.821   8949.050  -2.675 0.008521 ** 
    ## aspiration              -2458.554    444.812  -5.527 1.93e-07 ***
    ## enginelocation          -9346.234   1250.712  -7.473 1.40e-11 ***
    ## carwidth                  746.405    147.822   5.049 1.60e-06 ***
    ## enginesize                117.867      7.609  15.490  < 2e-16 ***
    ## stroke                  -3606.579    739.754  -4.875 3.36e-06 ***
    ## CompanyName.bmw          3205.491   1053.279   3.043 0.002875 ** 
    ## CompanyName.dodge       -5997.066   1006.475  -5.958 2.61e-08 ***
    ## CompanyName.honda       -3204.173    777.011  -4.124 6.90e-05 ***
    ## CompanyName.isuzu       -5035.171   1819.832  -2.767 0.006557 ** 
    ## CompanyName.mazda       -5511.079    767.798  -7.178 6.41e-11 ***
    ## CompanyName.mercury     -6218.292   1746.634  -3.560 0.000532 ***
    ## CompanyName.mitsubishi  -6342.936    794.514  -7.983 9.64e-13 ***
    ## CompanyName.nissan      -4999.728    692.107  -7.224 5.06e-11 ***
    ## CompanyName.peugeot     -6115.161    840.433  -7.276 3.87e-11 ***
    ## CompanyName.plymouth    -5514.516    884.558  -6.234 7.01e-09 ***
    ## CompanyName.renault     -5829.386   1346.228  -4.330 3.11e-05 ***
    ## CompanyName.saab        -2890.732    927.801  -3.116 0.002296 ** 
    ## CompanyName.subaru      -8134.599    963.120  -8.446 8.18e-14 ***
    ## CompanyName.toyota      -5400.365    601.655  -8.976 4.68e-15 ***
    ## CompanyName.volkswagen  -4077.076    768.089  -5.308 5.15e-07 ***
    ## CompanyName.volvo       -3423.660    798.457  -4.288 3.67e-05 ***
    ## enginetype.rotor         7847.622   1143.043   6.866 3.12e-10 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1646 on 120 degrees of freedom
    ## Multiple R-squared:  0.9657, Adjusted R-squared:  0.9594 
    ## F-statistic: 153.6 on 22 and 120 DF,  p-value: < 2.2e-16

``` r
    # Removing "+ CompanyName.isuzu"
      model_11 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
    summary(model_11)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + stroke + CompanyName.bmw + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4117.9  -927.9    37.9   924.6  4311.9 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -31813.566   8714.364  -3.651 0.000387 ***
    ## aspiration              -2430.981    456.767  -5.322 4.79e-07 ***
    ## enginelocation         -10057.093   1257.252  -7.999 8.51e-13 ***
    ## carwidth                  877.309    143.846   6.099 1.32e-08 ***
    ## enginesize                115.130      7.749  14.857  < 2e-16 ***
    ## stroke                  -3650.989    759.647  -4.806 4.46e-06 ***
    ## CompanyName.bmw          3594.307   1072.186   3.352 0.001070 ** 
    ## CompanyName.dodge       -5408.962   1010.467  -5.353 4.17e-07 ***
    ## CompanyName.honda       -2640.860    770.210  -3.429 0.000830 ***
    ## CompanyName.mazda       -5057.599    770.454  -6.564 1.37e-09 ***
    ## CompanyName.mercury     -6010.557   1792.368  -3.353 0.001066 ** 
    ## CompanyName.mitsubishi  -5823.982    793.007  -7.344 2.64e-11 ***
    ## CompanyName.nissan      -4464.179    682.519  -6.541 1.54e-09 ***
    ## CompanyName.peugeot     -5981.485    861.809  -6.941 2.08e-10 ***
    ## CompanyName.plymouth    -4923.397    881.661  -5.584 1.47e-07 ***
    ## CompanyName.renault     -5446.663   1375.437  -3.960 0.000127 ***
    ## CompanyName.saab        -2566.274    945.333  -2.715 0.007604 ** 
    ## CompanyName.subaru      -7642.548    972.242  -7.861 1.77e-12 ***
    ## CompanyName.toyota      -4883.924    587.489  -8.313 1.59e-13 ***
    ## CompanyName.volkswagen  -3664.115    773.891  -4.735 6.02e-06 ***
    ## CompanyName.volvo       -3242.112    817.348  -3.967 0.000124 ***
    ## enginetype.rotor         7689.847   1172.596   6.558 1.41e-09 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1690 on 121 degrees of freedom
    ## Multiple R-squared:  0.9635, Adjusted R-squared:  0.9572 
    ## F-statistic: 152.2 on 21 and 121 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.saab"
      model_12 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_12)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + stroke + CompanyName.bmw + CompanyName.dodge + 
    ##     CompanyName.honda + CompanyName.mazda + CompanyName.mercury + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + CompanyName.volvo + 
    ##     enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4174.7 -1003.2   -16.5   978.5  4051.0 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -33096.065   8925.808  -3.708 0.000316 ***
    ## aspiration              -2225.075    462.034  -4.816 4.25e-06 ***
    ## enginelocation         -10695.405   1266.899  -8.442 7.60e-14 ***
    ## carwidth                  857.527    147.364   5.819 4.88e-08 ***
    ## enginesize                117.249      7.909  14.826  < 2e-16 ***
    ## stroke                  -2978.059    736.571  -4.043 9.28e-05 ***
    ## CompanyName.bmw          4187.667   1076.722   3.889 0.000164 ***
    ## CompanyName.dodge       -4911.349   1019.312  -4.818 4.21e-06 ***
    ## CompanyName.honda       -2185.396    771.087  -2.834 0.005379 ** 
    ## CompanyName.mazda       -4465.914    758.026  -5.892 3.47e-08 ***
    ## CompanyName.mercury     -5140.655   1808.940  -2.842 0.005259 ** 
    ## CompanyName.mitsubishi  -5304.199    789.377  -6.719 6.18e-10 ***
    ## CompanyName.nissan      -3942.148    671.747  -5.869 3.87e-08 ***
    ## CompanyName.peugeot     -5244.134    838.966  -6.251 6.24e-09 ***
    ## CompanyName.plymouth    -4382.903    881.021  -4.975 2.17e-06 ***
    ## CompanyName.renault     -5319.291   1410.064  -3.772 0.000251 ***
    ## CompanyName.subaru      -6582.121    913.263  -7.207 5.19e-11 ***
    ## CompanyName.toyota      -4308.669    562.063  -7.666 4.77e-12 ***
    ## CompanyName.volkswagen  -3118.335    766.581  -4.068 8.45e-05 ***
    ## CompanyName.volvo       -2455.762    783.995  -3.132 0.002171 ** 
    ## enginetype.rotor         7774.086   1202.395   6.466 2.18e-09 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1734 on 122 degrees of freedom
    ## Multiple R-squared:  0.9613, Adjusted R-squared:  0.955 
    ## F-statistic: 151.5 on 20 and 122 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.honda"
      model_13 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_13)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + stroke + CompanyName.bmw + CompanyName.dodge + 
    ##     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.renault + CompanyName.subaru + CompanyName.toyota + 
    ##     CompanyName.volkswagen + CompanyName.volvo + enginetype.rotor, 
    ##     data = train)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##  -4183  -1133      0   1097   4700 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -34543.547   9162.393  -3.770 0.000252 ***
    ## aspiration              -2518.506    462.978  -5.440 2.76e-07 ***
    ## enginelocation         -10847.111   1301.450  -8.335 1.30e-13 ***
    ## carwidth                  904.822    150.544   6.010 1.95e-08 ***
    ## enginesize                123.484      7.811  15.810  < 2e-16 ***
    ## stroke                  -3854.920    687.286  -5.609 1.28e-07 ***
    ## CompanyName.bmw          4661.345   1093.657   4.262 3.99e-05 ***
    ## CompanyName.dodge       -3883.652    979.489  -3.965 0.000124 ***
    ## CompanyName.mazda       -3455.640    687.843  -5.024 1.74e-06 ***
    ## CompanyName.mercury     -4894.647   1857.792  -2.635 0.009505 ** 
    ## CompanyName.mitsubishi  -4291.424    723.704  -5.930 2.85e-08 ***
    ## CompanyName.nissan      -2977.825    595.530  -5.000 1.92e-06 ***
    ## CompanyName.peugeot     -4785.467    846.416  -5.654 1.04e-07 ***
    ## CompanyName.plymouth    -3321.517    819.946  -4.051 8.97e-05 ***
    ## CompanyName.renault     -3977.440   1365.645  -2.912 0.004259 ** 
    ## CompanyName.subaru      -6189.518    928.143  -6.669 7.79e-10 ***
    ## CompanyName.toyota      -3405.104    475.947  -7.154 6.62e-11 ***
    ## CompanyName.volkswagen  -2080.382    692.426  -3.004 0.003224 ** 
    ## CompanyName.volvo       -2115.341    796.580  -2.656 0.008967 ** 
    ## enginetype.rotor         7966.879   1234.311   6.455 2.26e-09 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1783 on 123 degrees of freedom
    ## Multiple R-squared:  0.9588, Adjusted R-squared:  0.9524 
    ## F-statistic: 150.5 on 19 and 123 DF,  p-value: < 2.2e-16

``` r
    # Removing "stroke"
      model_14 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_14)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + CompanyName.bmw + CompanyName.dodge + CompanyName.mazda + 
    ##     CompanyName.mercury + CompanyName.mitsubishi + CompanyName.nissan + 
    ##     CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
    ##     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
    ##     CompanyName.volvo + enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4840.3 -1234.5  -232.4  1247.6  5140.2 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -49408.898   9788.845  -5.047 1.55e-06 ***
    ## aspiration              -1916.955    502.667  -3.814 0.000215 ***
    ## enginelocation         -13326.910   1366.145  -9.755  < 2e-16 ***
    ## carwidth                  992.150    167.119   5.937 2.72e-08 ***
    ## enginesize                110.124      8.302  13.265  < 2e-16 ***
    ## CompanyName.bmw          5657.487   1204.412   4.697 6.88e-06 ***
    ## CompanyName.dodge       -4399.378   1088.365  -4.042 9.23e-05 ***
    ## CompanyName.mazda       -3562.144    767.397  -4.642 8.65e-06 ***
    ## CompanyName.mercury     -3644.782   2058.482  -1.771 0.079082 .  
    ## CompanyName.mitsubishi  -4753.044    802.474  -5.923 2.90e-08 ***
    ## CompanyName.nissan      -3077.622    664.365  -4.632 9.00e-06 ***
    ## CompanyName.peugeot     -4188.167    937.165  -4.469 1.75e-05 ***
    ## CompanyName.plymouth    -3665.279    912.569  -4.016 0.000102 ***
    ## CompanyName.renault     -6316.215   1451.389  -4.352 2.79e-05 ***
    ## CompanyName.subaru      -3580.329    896.384  -3.994 0.000111 ***
    ## CompanyName.toyota      -3221.133    529.934  -6.078 1.38e-08 ***
    ## CompanyName.volkswagen  -2619.324    765.328  -3.422 0.000841 ***
    ## CompanyName.volvo       -1066.013    864.183  -1.234 0.219704    
    ## enginetype.rotor         7466.963   1373.998   5.434 2.80e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1990 on 124 degrees of freedom
    ## Multiple R-squared:  0.9482, Adjusted R-squared:  0.9407 
    ## F-statistic: 126.1 on 18 and 124 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.mercury" and "CompanyName.volvo"
      model_15 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + enginetype.rotor, data = train)
    
      summary(model_15)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + CompanyName.bmw + CompanyName.dodge + CompanyName.mazda + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.subaru + 
    ##     CompanyName.toyota + CompanyName.volkswagen + enginetype.rotor, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4890.0 -1298.7  -235.1  1278.8  5177.6 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -46520.510   9654.351  -4.819 4.08e-06 ***
    ## aspiration              -1707.847    496.409  -3.440 0.000788 ***
    ## enginelocation         -13273.912   1377.540  -9.636  < 2e-16 ***
    ## carwidth                  936.352    164.149   5.704 7.89e-08 ***
    ## enginesize                112.853      8.184  13.789  < 2e-16 ***
    ## CompanyName.bmw          5798.655   1211.422   4.787 4.67e-06 ***
    ## CompanyName.dodge       -4157.264   1089.876  -3.814 0.000213 ***
    ## CompanyName.mazda       -3359.272    763.263  -4.401 2.27e-05 ***
    ## CompanyName.mitsubishi  -4506.517    797.241  -5.653 1.00e-07 ***
    ## CompanyName.nissan      -2915.800    662.929  -4.398 2.30e-05 ***
    ## CompanyName.peugeot     -3788.627    914.634  -4.142 6.26e-05 ***
    ## CompanyName.plymouth    -3449.257    912.506  -3.780 0.000241 ***
    ## CompanyName.renault     -6113.541   1458.130  -4.193 5.15e-05 ***
    ## CompanyName.subaru      -3371.816    895.662  -3.765 0.000255 ***
    ## CompanyName.toyota      -3059.949    525.158  -5.827 4.45e-08 ***
    ## CompanyName.volkswagen  -2350.339    754.774  -3.114 0.002285 ** 
    ## enginetype.rotor         7588.524   1383.674   5.484 2.18e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2007 on 126 degrees of freedom
    ## Multiple R-squared:  0.9464, Adjusted R-squared:  0.9396 
    ## F-statistic: 139.2 on 16 and 126 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.volkswagen"
      model_16 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_16)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + CompanyName.bmw + CompanyName.dodge + CompanyName.mazda + 
    ##     CompanyName.mitsubishi + CompanyName.nissan + CompanyName.peugeot + 
    ##     CompanyName.plymouth + CompanyName.renault + CompanyName.subaru + 
    ##     CompanyName.toyota + enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4989.3 -1361.1  -230.9  1456.1  5007.3 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -45514.444   9973.847  -4.563 1.17e-05 ***
    ## aspiration              -1742.611    512.995  -3.397 0.000910 ***
    ## enginelocation         -13386.646   1423.433  -9.404 2.90e-16 ***
    ## carwidth                  908.425    169.423   5.362 3.76e-07 ***
    ## enginesize                117.203      8.336  14.060  < 2e-16 ***
    ## CompanyName.bmw          6109.049   1247.967   4.895 2.92e-06 ***
    ## CompanyName.dodge       -3735.237   1117.831  -3.342 0.001095 ** 
    ## CompanyName.mazda       -2852.190    770.799  -3.700 0.000319 ***
    ## CompanyName.mitsubishi  -4058.139    810.534  -5.007 1.81e-06 ***
    ## CompanyName.nissan      -2486.566    670.275  -3.710 0.000309 ***
    ## CompanyName.peugeot     -3346.006    933.946  -3.583 0.000483 ***
    ## CompanyName.plymouth    -2990.689    930.869  -3.213 0.001666 ** 
    ## CompanyName.renault     -5687.802   1500.589  -3.790 0.000231 ***
    ## CompanyName.subaru      -2889.292    911.861  -3.169 0.001919 ** 
    ## CompanyName.toyota      -2622.336    523.044  -5.014 1.76e-06 ***
    ## enginetype.rotor         7753.160   1429.222   5.425 2.83e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2075 on 127 degrees of freedom
    ## Multiple R-squared:  0.9423, Adjusted R-squared:  0.9355 
    ## F-statistic: 138.3 on 15 and 127 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.dodge" and "CompanyName.subaru"
      model_17 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_17)
```

    ## 
    ## Call:
    ## lm(formula = price ~ aspiration + enginelocation + carwidth + 
    ##     enginesize + CompanyName.bmw + CompanyName.mazda + CompanyName.mitsubishi + 
    ##     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + 
    ##     CompanyName.renault + CompanyName.toyota + enginetype.rotor, 
    ##     data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5809.0 -1542.9  -273.8  1641.4  5104.7 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -56383.417  10238.374  -5.507 1.90e-07 ***
    ## aspiration              -1445.328    536.379  -2.695 0.007986 ** 
    ## enginelocation         -14293.611   1497.582  -9.544  < 2e-16 ***
    ## carwidth                 1082.084    174.589   6.198 7.14e-09 ***
    ## enginesize                113.512      8.784  12.922  < 2e-16 ***
    ## CompanyName.bmw          6573.351   1322.669   4.970 2.09e-06 ***
    ## CompanyName.mazda       -2313.196    808.426  -2.861 0.004923 ** 
    ## CompanyName.mitsubishi  -3344.958    844.511  -3.961 0.000123 ***
    ## CompanyName.nissan      -1821.818    694.134  -2.625 0.009723 ** 
    ## CompanyName.peugeot     -3094.960    991.361  -3.122 0.002218 ** 
    ## CompanyName.plymouth    -2190.466    970.833  -2.256 0.025736 *  
    ## CompanyName.renault     -5278.893   1592.839  -3.314 0.001193 ** 
    ## CompanyName.toyota      -1988.367    534.013  -3.723 0.000292 ***
    ## enginetype.rotor         7541.800   1519.171   4.964 2.14e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2207 on 129 degrees of freedom
    ## Multiple R-squared:  0.9337, Adjusted R-squared:  0.927 
    ## F-statistic: 139.7 on 13 and 129 DF,  p-value: < 2.2e-16

``` r
    # Removing "aspiration", "CompanyName.mazda", "CompanyName.nissan", "CompanyName.peugeot", "CompanyName.plymouth" and "CompanyName.renault"
      model_18 <- lm(formula = price ~ enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + CompanyName.mitsubishi + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_18)
```

    ## 
    ## Call:
    ## lm(formula = price ~ enginelocation + carwidth + enginesize + 
    ##     CompanyName.bmw + CompanyName.mitsubishi + CompanyName.toyota + 
    ##     enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -5121.3 -1757.6  -114.2  1508.8  6309.4 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)            -65112.300   9752.255  -6.677 5.82e-10 ***
    ## enginelocation         -14938.020   1651.160  -9.047 1.41e-15 ***
    ## carwidth                 1193.164    170.059   7.016 1.00e-10 ***
    ## enginesize                113.838      9.225  12.340  < 2e-16 ***
    ## CompanyName.bmw          7025.115   1472.042   4.772 4.67e-06 ***
    ## CompanyName.mitsubishi  -2139.434    919.555  -2.327 0.021475 *  
    ## CompanyName.toyota      -1271.378    554.853  -2.291 0.023490 *  
    ## enginetype.rotor         5835.777   1530.710   3.812 0.000208 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2485 on 135 degrees of freedom
    ## Multiple R-squared:  0.9121, Adjusted R-squared:  0.9075 
    ## F-statistic: 200.1 on 7 and 135 DF,  p-value: < 2.2e-16

``` r
    # Removing "CompanyName.mitsubishi" and "CompanyName.toyota"
      model_19 <- lm(formula = price ~ enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + enginetype.rotor, data = train)
    
      summary(model_19)
```

    ## 
    ## Call:
    ## lm(formula = price ~ enginelocation + carwidth + enginesize + 
    ##     CompanyName.bmw + enginetype.rotor, data = train)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ##  -5919  -1630   -157   1256   7085 
    ## 
    ## Coefficients:
    ##                   Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)      -71382.85    9730.40  -7.336 1.75e-11 ***
    ## enginelocation   -15620.31    1675.36  -9.324 2.61e-16 ***
    ## carwidth           1298.68     169.93   7.643 3.34e-12 ***
    ## enginesize          110.81       9.38  11.814  < 2e-16 ***
    ## CompanyName.bmw    7411.96    1504.27   4.927 2.37e-06 ***
    ## enginetype.rotor   6068.52    1568.95   3.868 0.000169 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2550 on 137 degrees of freedom
    ## Multiple R-squared:  0.906,  Adjusted R-squared:  0.9026 
    ## F-statistic: 264.2 on 5 and 137 DF,  p-value: < 2.2e-16

``` r
    # predicting the results in test dataset
      Predict_1 <- predict(model_19,test[,-20])
      test$test_price <- Predict_1
    
    # Now, we need to test the r square between actual and predicted price.
      r <- cor(test$price,test$test_price)
      rsquared <- cor(test$price,test$test_price)^2
      rsquared
```

    ## [1] 0.8606172

``` r
# Below is the Equation and Explanation for final Linear Model
      
    # "price = -71382.85 -15620.31*enginelocation + 129.68*carwidth + 110.81*enginesize + 7411.96*CompanyName.bmw + 6068.52*enginetype.rotor"
        # Unit increase in "carwidth" increase in car price
        # Unit increase in "enginesize" increase in car price
        # Unit increase in "carwidth" increase in car price
        # Front "enginelocation" leads to decrease in car price
        # If car is having "enginetype" as rotor, having more car price
```
