# Load Libraries----
    library(caret)
    library(tidyr)
    library(MASS)
    library(car)

# Load Car Price data ----
    carprice <- read.csv("CarPrice_Assignment.csv")
    View(carprice)

    #Let us examine the structure of the dataset
    str(carprice)
    
    
# Data Cleaning----
    # Dervide CompanyName from the CarName variable
      carprice <- separate(carprice,CarName, "CompanyName", sep = " ")
    # CompanyName to lowercase
      carprice$CompanyName <- tolower(carprice$CompanyName)
    # Correcting car Comapny Name, treatinf misspelled values as one
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="porcshce","porsche")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="maxda","mazda")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="toyouta","toyota")
      carprice$CompanyName <- replace(carprice$CompanyName,carprice$CompanyName=="vokswagen" | carprice$CompanyName=="vw","volkswagen")
    # CompanyName to factor
      carprice$CompanyName <- as.factor(carprice$CompanyName)
    
# Dummy Variable Creation----
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
    
# Model Building----
    # Build model 1 containing all variables
      model_1 <-lm(price~.,data=train)
      summary(model_1)
    
    # Using stepAIC for removing the insignificant variables
      step <- stepAIC(model_1, direction="both")
    
    # Checking model equation
      step
    
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
    
    # Let us check for multicollinearity
      vif(model_2)
    
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
    # Checking p-values of the variables
      summary(model_3)
    
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
    # Checking p-values of the variables
      summary(model_4)
    
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
    # Checking p-values of the variables
      summary(model_5)
    
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
    # Some variables are having high VIF values but very low p-value, so we're not reving those at this point of time
    # Now look for the variables with high p values and then remove those
      summary(model_6)
    
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

    # Removing "fuelsystem.2bbl"
      model_10 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + CompanyName.isuzu + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_10)

    # Removing "+ CompanyName.isuzu"
      model_11 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.saab + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
    summary(model_11)
    
    # Removing "CompanyName.saab"
      model_12 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.honda + 
                     CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_12)
    
    # Removing "CompanyName.honda"
      model_13 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + stroke + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_13)
 
    # Removing "stroke"
      model_14 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mercury + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + 
                     CompanyName.volvo + enginetype.rotor, data = train)
    
      summary(model_14)
    
    # Removing "CompanyName.mercury" and "CompanyName.volvo"
      model_15 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + CompanyName.volkswagen + enginetype.rotor, data = train)
    
      summary(model_15)

    # Removing "CompanyName.volkswagen"
      model_16 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + 
                     CompanyName.dodge + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + 
                     CompanyName.subaru + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_16)

    # Removing "CompanyName.dodge" and "CompanyName.subaru"
      model_17 <- lm(formula = price ~ aspiration + enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + CompanyName.mazda + CompanyName.mitsubishi + 
                     CompanyName.nissan + CompanyName.peugeot + CompanyName.plymouth + CompanyName.renault + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_17)
    
    # Removing "aspiration", "CompanyName.mazda", "CompanyName.nissan", "CompanyName.peugeot", "CompanyName.plymouth" and "CompanyName.renault"
      model_18 <- lm(formula = price ~ enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + CompanyName.mitsubishi + CompanyName.toyota + enginetype.rotor, data = train)
    
      summary(model_18)
    
    # Removing "CompanyName.mitsubishi" and "CompanyName.toyota"
      model_19 <- lm(formula = price ~ enginelocation + 
                     carwidth + enginesize + CompanyName.bmw + enginetype.rotor, data = train)
    
      summary(model_19)
    
    
    # predicting the results in test dataset
      Predict_1 <- predict(model_19,test[,-20])
      test$test_price <- Predict_1
    
    # Now, we need to test the r square between actual and predicted price.
      r <- cor(test$price,test$test_price)
      rsquared <- cor(test$price,test$test_price)^2
      rsquared
      
      
# Below is the Equation and Explanation for final Linear Model
      
    # "price = -71382.85 -15620.31*enginelocation + 129.68*carwidth + 110.81*enginesize + 7411.96*CompanyName.bmw + 6068.52*enginetype.rotor"
        # Unit increase in "carwidth" increase in car price
        # Unit increase in "enginesize" increase in car price
        # Unit increase in "carwidth" increase in car price
        # Front "enginelocation" leads to decrease in car price
        # If car is having "enginetype" as rotor, having more car price
      
    