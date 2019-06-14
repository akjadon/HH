## Business Understanding

## Data Understanding
  - Training and test dataset contains the attributes like –
    - accommodates 	- bathrooms 	- bedrooms		- beds
    - Latitude		- Longitude		- Zipcode		- property_type
    - Room_type		- bed_type		- cancellation_policy	- city
    - Amenities		- description		- no_of_reviews	- review_score_rating

  - Also, I have downloaded the external dataset from the (airport.csv) from the http://ourairports.com/data, which I used to calculate the nearest airport distance for each listing.
  
 ## Data Cleaning
  - Standardized the host_response_rate column by removing the special characters.
  - Standardized the thumbnail_url for extracting out the image components.
  - Imputed the missing values: Categorical variables with different levels and Continuous variables with mean value for that variable.
  - Converted the continuous variables to numeric and categorical variables to factor.
  - Performed the one-hot encoding of categorical variables, to feed into model.
  - Removed the text columns like amenities, name, description etc. but have performed the text analytics separately.
  - Removed the zipcode column as it has too many factors and also we have latitude and longitude column to use in place of zipcode.

## Feature Engineering
  - Extracted RGB component and Brightness from the images (i.e. thumbnail_url)
  - Using the external dataset, calculate the nearest airport for each latitude and longitude combination.
  - Derived a column which is a combination of property_type and room_type.
  - Derived a column amenities_count for each listings by counting the number of amenities provided/available.
  - Created the clusters (using k-means algorithm) based on latitude and longitude.
  
## Model Building and Evaluation
  - I started the basic Linear Regression Model to build the predictive model for pricing, I had also tried the Regularized models (lasso And Ridge), models were good but still more improvement was required in terms of accuracy.
  - Second Model I tried was the Random Forest model, using the complete training dataset with 5-fold cross validation along with the hyperparameter tuning. The accuracy was improved much compared to the previous models.
  - Final model that I have built is the eXtreme Gradient Boosting(XGBoost). Build the model on complete training dataset with 5-fold cross-validation. Also, I have tuned the hyperparameters like – maxdepth (Maximum tree depth), eta (Learning rate), colsample_bytree (Column Sampling), subsample (Row Sampling).
  - Evaluation metrics used is Root Mean Squared Error (RMSE).




