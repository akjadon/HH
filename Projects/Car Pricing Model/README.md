# Problem Statement:
A Chinese automobile company aspired to enter the US market by setting up their manufacturing unit there and producing cars locally to give competition to their US and European counterparts. 

So, They want to understand the factors on which the pricing of a car depends. Specifically, they want to understand the factors affecting the pricing of cars in the American marketing, since those may be very different from the Chinese market. Essentially, the company wants to know:

1. Which variables are significant in predicting the price of a car
2. How well those variables describe the price of a car

Dataset is having 21k records with 26 variables

# Solution:
As a part of the solution, I've done the
1. Data preparation
	- Cleaning data
	- checking for missing value
	- oulier detection

2. Exploratory Data Analysis
3. Created the dummy variables for the categorical features
4. Divided the data in to the training and the test data
5. Build a linear regression model using the lm() function in R

Linear Regression is used When the dependent variable which we have to predict is the continuous variable
But when the dependent variable is numeric but has some order so we won't use the linear regression in this case
* First build a general model with all the variables
* Then used the StepAIC function to remove the insignificant variables (direction as "both"). **_There are three variant of stepAIC function- forward, backward and both_**.
* I've checked for the p-value and VIF for further removing the variables

Also, I'd used the VIF to check the multicollinearity, multicollinearity is a phenomenon in which one predictor variable in a multiple regression model can be linearly predicted from the others with a substantial degree of accuracy. So removing those variable is a good idea

**Model Evaluation:** There are measures like R-square, adjusted R-square

* **R2** is a number which explains what portion of the given data variation is explained by the developed model. It always takes a value between 0 & 1. In general term, it provides a measure of how well actual outcomes are replicated by the model, based on the proportion of total variation of outcomes explained by the model, i.e. expected outcomes. Overall, the higher the R-squared, the better the model fits your data.
	-  **R2=1-RSS/TSS**
	-  **RSS (Residual Sum of Squares):** In statistics, it is defined as the total sum of error across the whole sample. It is the measure of the difference between the expected and the actual output. A small RSS indicates a tight fit of the model to the data.
	-  **TSS (Total sum of squares):** It is the sum of errors of the data points from mean of response variable.

* **Adjusted R-squared** is a better metric than R-squared to assess how good the model fits the data. R-squared always increases if additional variables are added into the model, even if they are not related to the dependent variable. R-squared thus is not a reliable metric for model accuracy. Adjusted R-squared, on the other hand, penalises R-squared for unnecessary addition of variables. So, if the variable added does not increase the accuracy adequately, adjusted R-squared decreases although R-squared might increase.
