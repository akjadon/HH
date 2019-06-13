#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 19 08:14:34 2018

@author: uber-abdul
"""

import numpy as np    #for mathematical calculation 
import matplotlib.pyplot as plt #for ploting nice chat and graph
import pandas as pd 

dataset = pd.read_csv('Position_Salaries.csv')

X = dataset.iloc[:, 1:2].values
y = dataset.iloc[:,2].values

"""
This data doesnt requires splitting data into test and tranning as data is less

** Linear regression is also done as to compare the data with linear and 
non-linear regression
"""

# fitting linear regression to dataset
from sklearn.linear_model import LinearRegression
lin_reg = LinearRegression()
lin_reg.fit(X,y)

# fitting polynomial regression to dataset
from sklearn.preprocessing import PolynomialFeatures
poly_reg = PolynomialFeatures(degree = 4)
X_poly = poly_reg.fit_transform(X)
poly_reg.fit(X_poly, y)
lin_reg2 = LinearRegression()
lin_reg2.fit(X_poly, y)

# Visualation the linear regression results
plt.scatter(X, y, color = 'red')
plt.plot(X,lin_reg.predict(X), color = 'blue')
plt.title('Truth or bluff linear regression')
plt.xlabel('Position level')
plt.ylabel('Salary')
plt.show()

# Visualation the polynomial regression results
plt.scatter(X, y, color = 'red')
plt.plot(X, lin_reg2.predict(poly_reg.fit_transform(X)), color = 'blue')
plt.title('Truth or bluff polynomial regression')
plt.xlabel('Position level')
plt.ylabel('Salary')
plt.show()

# predicting a new result with linear Regression
lin_reg.predict(6.5)

# predicting a new result with polynomial regression
lin_reg2.predict(poly_reg.fit_transform(6.5))


