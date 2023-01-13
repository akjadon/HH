
# Naive Bayes
from sklearn.naive_bayes import GaussianNB
Model = GaussianNB()
Model.fit(X_train, y_train)

y_pred = Model.predict(X_test)

# Summary of the predictions made by the classifier
print(classification_report(y_test, y_pred))
print(confusion_matrix(y_test, y_pred))
# Accuracy score
print('accuracy is',accuracy_score(y_pred,y_test))

### Code
Naivebase algorithm: <br />
<img src="https://github.com/akjadon/HH/blob/master/Python/MachineLearning/images/naivebase.PNG" width="600"> <br />



Naive Bayes is a probabilistic algorithm that is based on Bayes' theorem. The basic idea behind the algorithm is to calculate the probability of an event occurring given some prior knowledge or evidence. In the case of Naive Bayes, the prior knowledge is the probability of each class, and the evidence is the feature vector of the instance to be classified.

There are different types of Naive Bayes algorithms, such as Gaussian Naive Bayes, Multinomial Naive Bayes, and Bernoulli Naive Bayes. The Gaussian Naive Bayes algorithm is used for continuous data, the Multinomial Naive Bayes algorithm is used for discrete data, and the Bernoulli Naive Bayes algorithm is used for binary data.

The Gaussian Naive Bayes algorithm assumes that the data is normally distributed and estimates the probability density function for each class using the mean and standard deviation of the feature values. The Multinomial Naive Bayes algorithm estimates the probability of each class based on the frequency of each feature value in the training set. The Bernoulli Naive Bayes algorithm estimates the probability of each class based on the frequency of each feature value being 1 in the training set.

The Naive Bayes algorithm is known for its simplicity and speed, and it is often used in text classification, spam filtering, and sentiment analysis.
