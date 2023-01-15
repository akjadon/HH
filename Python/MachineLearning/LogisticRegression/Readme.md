
In logistic regression, the cost function is a measure of the difference between the predicted probability of the outcome and the actual outcome. The goal of the logistic regression model is to minimize this cost function, in order to find the best possible coefficients for the predictor variables.

**The most commonly used cost function in logistic regression is the log loss or cross-entropy loss. The log loss cost function is defined as the negative log-likelihood of the true labels given the predicted probabilities. Mathematically, it can be represented as:**

**-log(L) = - (y * log(p) + (1-y) * log(1-p))**

Where p is the predicted probability of the outcome, y is the actual outcome (0 or 1), and L is the likelihood of the observed data.

This cost function is chosen because it penalizes heavily the predictions that are confident but incorrect. It's a convex function, which means that there is only one global minimum and it can be optimized using gradient descent or other optimization algorithms.

#####################################################################################

**cross-entropy can be described by the following formula,**

![image](https://user-images.githubusercontent.com/47466906/212528555-5c576f26-4b58-4ff6-8d09-3f28e811bbe8.png)

####################################################################################



## Classification algorithms

### [Logistic regression with Titanic data]()
### [Naive bayes]()
### [Support vector machine with breast cancer data]()
### [Skewed logistic regression (imbalanced class divisions)]()
### [k-Nearest neighbor classification]()

# Logistic Regression


<p align="center">
  <img src="https://github.com/Avik-Jain/100-Days-Of-ML-Code/blob/master/Info-graphs/Day%204.jpg">
</p>

## The DataSet | Social Network 

<p align="center">
  <img src="https://github.com/Avik-Jain/100-Days-Of-ML-Code/blob/master/Other%20Docs/data.PNG">
</p> 

This dataset contains information of users in a social network. Those informations are the user id the gender the age and the estimated salary. A car company has just launched their brand new luxury SUV. And we're trying to see which of these users of the social network are going to buy this brand new SUV And the last column here tells If yes or no the user bought this SUV we are going to build a model that is going to predict if a user is going to buy or not the SUV based on two variables which are going to be the age and the estimated salary. So our matrix of feature is only going to be these two columns.
We want to find some correlations between the age and the estimated salary of a user and his decision to purchase yes or no the SUV.

## Step 1 | Data Pre-Processing

### Importing the Libraries

```python
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
```
### Importing the dataset

Get the dataset from [here](https://github.com/Avik-Jain/100-Days-Of-ML-Code/blob/master/datasets/Social_Network_Ads.csv)
```python
dataset = pd.read_csv('Social_Network_Ads.csv')
X = dataset.iloc[:, [2, 3]].values
y = dataset.iloc[:, 4].values
```

### Splitting the dataset into the Training set and Test set

```python
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.25, random_state = 0)
```

### Feature Scaling

```python
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)
```
## Step 2 | Logistic Regression Model

The library for this job which is going to be the linear model library and it is called linear because the logistic regression is a linear classifier which means that here since we're in two dimensions, our two categories of users are going to be separated by a straight line. Then import the logistic regression class.
Next we will create a new object from this class which is going to be our classifier that we are going to fit on our training set.

### Fitting Logistic Regression to the Training set

```python
from sklearn.linear_model import LogisticRegression
classifier = LogisticRegression()
classifier.fit(X_train, y_train)
```
## Step 3 | Predection

### Predicting the Test set results

```python
y_pred = classifier.predict(X_test)
```

## Step 4 | Evaluating The Predection

We predicted the test results and now we will evaluate if our logistic regression model learned and understood correctly.
So this confusion matrix is going to contain the correct predictions that our model made on the set as well as the incorrect predictions.

### Making the Confusion Matrix

```python
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
```

## Visualization

<p align="center">
  <img src="https://github.com/Avik-Jain/100-Days-Of-ML-Code/blob/master/Other%20Docs/training.png">
</p> 

<p align="center">
  <img src="https://github.com/Avik-Jain/100-Days-Of-ML-Code/blob/master/Other%20Docs/testing.png">
</p> 



## Logistic Regression Model Code sample
import numpy as np\
import pandas as pd\
from sklearn.model_selection import train_test_split\
from sklearn.preprocessing import StandardScaler\
from sklearn.linear_model import LogisticRegression

### Load the data
df = pd.read_csv('data.csv')\

### Preprocess the data
X = df.drop(columns='target')\
y = df['target']\
scaler = StandardScaler()\
X = scaler.fit_transform(X)

### Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)\

### Train the model
model = LogisticRegression()\
model.fit(X_train, y_train)

### Evaluate the model
train_score = model.score(X_train, y_train)\
test_score = model.score(X_test, y_test)\
print(f'Train score: {train_score:.2f}')\
print(f'Test score: {test_score:.2f}')

### Make predictions on new data
new_data = np.array([[...], [...], ...], dtype=np.float64)  # Replace with appropriate values\
predictions = model.predict(new_data)


## Evaluation Matrics
import numpy as np\
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

### Make predictions on the test set
predictions = model.predict(X_test)

### Calculate evaluation metrics
accuracy = accuracy_score(y_test, predictions)\
precision = precision_score(y_test, predictions)\
recall = recall_score(y_test, predictions)\
f1 = f1_score(y_test, predictions)

### Print the results
print(f'Accuracy: {accuracy:.2f}')\
print(f'Precision: {precision:.2f}')\
print(f'Recall: {recall:.2f}')\
print(f'F1 score: {f1:.2f}')




## ROC curve

import matplotlib.pyplot as plt\
from sklearn.metrics import roc_curve, roc_auc_score

### Make predictions on the test set
predictions = model.predict_proba(X_test)[:, 1]  # Predict probability of the positive class

### Calculate the false positive rate and true positive rate
fpr, tpr, thresholds = roc_curve(y_test, predictions)

### Calculate the AUC
auc = roc_auc_score(y_test, predictions)

### Plot the ROC curve
plt.plot(fpr, tpr, label=f'AUC = {auc:.2f}')\
plt.xlabel('False Positive Rate')\
plt.ylabel('True Positive Rate')\
plt.legend()\
plt.show()

