#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Aug 18 23:20:36 2018

@author: abdul
"""

# Multi Linear Regression

import numpy as np    #for mathematical calculation 
import matplotlib.pyplot as plt #for ploting nice chat and graph
import pandas as pd 

dataset = pd.read_csv('50_Startups.csv')

X = dataset.iloc[:, :-1].values
y = dataset.iloc[:,4].values

# handling categorical data
from sklearn.preprocessing import OneHotEncoder, LabelEncoder

labelencoder_X = LabelEncoder()
X[:, 3] = labelencoder_X.fit_transform(X[:,3])
onehotencoder = OneHotEncoder(categorical_features = [3])
X = onehotencoder.fit_transform(X).toarray()

# avoiding dummy varibale trap
X = X[:, 1:]

# splitting data to train and test
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X,y, test_size = 0.2, random_state = 0)

# Fitting multiple linear regression to the tranning set
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(X_train, y_train)

# Predicting the test set result
y_pred = regressor.predict(X_test)
