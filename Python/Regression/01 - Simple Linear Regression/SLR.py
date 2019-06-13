#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug 11 18:03:46 2018

@author: abdul
"""

#SLR  = Simple linear regression


# Importing Library
import numpy as np    #for mathematical calculation 
import matplotlib.pyplot as plt #for ploting nice chat and graph
import pandas as pd  #for managing data set

# Importing Dataset
dataset = pd.read_csv('Salary_Data.csv') 

X = dataset.iloc[:, :-1].values
y = dataset.iloc[:,1].values

# Spliting data into train and test
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 1/3, random_state = 0)

# Fitting simple linear regression to the tranning set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

# Predicting the test set result
y_pred = regressor.predict(X_test)

# Visualising the tranning set
plt.scatter(X_train, y_train, color = 'red')
plt.plot(X_train,regressor.predict(X_train), color = 'blue')
plt.title('Salary vs Experiance (training set)')
plt.xlabel('year of experiance')
plt.ylabel('salary')
plt.show()


# Visualising the test set
plt.scatter(X_test, y_test, color = 'red')
plt.plot(X_train,regressor.predict(X_train), color = 'blue')
plt.title('Salary vs Experiance (test set)')
plt.xlabel('year of experiance')
plt.ylabel('salary')
plt.show()

