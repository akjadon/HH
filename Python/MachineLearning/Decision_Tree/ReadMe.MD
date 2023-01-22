# Decision Tree Classification

### Importing the libraries
```python
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
```

### Importing the dataset
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
### Fitting Decision Tree Classification to the Training set
```python
from sklearn.tree import DecisionTreeClassifier
classifier = DecisionTreeClassifier(criterion = 'entropy', random_state = 0)
classifier.fit(X_train, y_train)
```
### Predicting the Test set results
```python
y_pred = classifier.predict(X_test)
```
### Making the Confusion Matrix
```python
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
```
### Visualising the Training set results
```python
from matplotlib.colors import ListedColormap
X_set, y_set = X_train, y_train
X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1, stop = X_set[:, 0].max() + 1, step = 0.01),
                     np.arange(start = X_set[:, 1].min() - 1, stop = X_set[:, 1].max() + 1, step = 0.01))
plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
             alpha = 0.75, cmap = ListedColormap(('red', 'green')))
plt.xlim(X1.min(), X1.max())
plt.ylim(X2.min(), X2.max())
for i, j in enumerate(np.unique(y_set)):
    plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1],
                c = ListedColormap(('red', 'green'))(i), label = j)
plt.title('Decision Tree Classification (Training set)')
plt.xlabel('Age')
plt.ylabel('Estimated Salary')
plt.legend()
plt.show()
```
### Visualising the Test set results
```python
from matplotlib.colors import ListedColormap
X_set, y_set = X_test, y_test
X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1, stop = X_set[:, 0].max() + 1, step = 0.01),
                     np.arange(start = X_set[:, 1].min() - 1, stop = X_set[:, 1].max() + 1, step = 0.01))
plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
             alpha = 0.75, cmap = ListedColormap(('red', 'green')))
plt.xlim(X1.min(), X1.max())
plt.ylim(X2.min(), X2.max())
for i, j in enumerate(np.unique(y_set)):
    plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1],
                c = ListedColormap(('red', 'green'))(i), label = j)
plt.title('Decision Tree Classification (Test set)')
plt.xlabel('Age')
plt.ylabel('Estimated Salary')
plt.legend()
plt.show()
```





## Note : How does continuous Variable get split

In a decision tree, continuous variables are typically split by finding the optimal split point that maximizes the reduction in impurity (such as Gini impurity or entropy). This is done by evaluating all possible split points and selecting the one that results in the largest decrease in impurity. The data is then split into two groups based on the chosen split point, and the process is repeated recursively on each group until a stopping criterion is met (such as a minimum number of samples per leaf or a maximum tree depth)






## There are several different criteria that can be used to determine the best split point when constructing a decision tree:

01-Gini impurity: This measure calculates the probability of a randomly chosen sample being classified incorrectly if it were randomly labeled according to the class distribution in the current node.

02-Entropy: This measure calculates the disorder or randomness of the class distribution in the current node.

03-Misclassification Error: This measure calculates the number of misclassified samples in the current node.

04-Information gain: This measure calculates the reduction in entropy after a split is made.

05-Gain ratio : This measure tries to resolve the issue of bias towards variables with many outcomes. It is the ratio of information gain to the intrinsic information of the split.

06-Gini index: This measure calculates the probability of a sample falling into the wrong group if it were randomly assigned a class according to the group proportions in the current node.







