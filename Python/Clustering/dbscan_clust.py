# -*- coding: utf-8 -*-
"""
Created on Wed Oct 14 12:50:42 2020

@author: HP
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("C:/Users/HP/Desktop/datasets/Wholesale customers data.csv");
df.isna().sum()
df.head()
df.info()
customers=df.drop(columns=['Channel','Region'])
array=customers.values
array

#####normalize data############
from sklearn.preprocessing import StandardScaler
stsclr=StandardScaler().fit(array)
norm_data=stsclr.transform(array)

#############DBSCAN clustering#########
from sklearn.cluster import DBSCAN
model=DBSCAN(eps=0.8,min_samples=6).fit(norm_data)
clusters=pd.DataFrame(model.labels_,columns=['clusters'])
clusters.value_counts()
#-1 cluster represents outliers which means we have 80 datapts as outliers
final_data=pd.concat([clusters,df],axis=1)
final_data.groupby(final_data.clusters).sum()
