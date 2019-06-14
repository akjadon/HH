## Problem Statement:

**"BeerMart"**, an online beer store in the United States wants to build a recommendation system (collaborative) for their store, where customers will be recommended the beer that they are most likely to buy. They have the data about the ratings that the customers have provided in the past.

## Data Description:

Each record is composed of a beer's name, the name of the user along with ratings provided by users. All ratings are on a scale from 1 to 5 with 5 being the best.

## Solution:

1. **Data preparation**
	- Choose only those beers that have at least N number of reviews
		- Figured out an appropriate value of N using EDA; Didn't choose beers having extremely low number of ratings.

	- Converted the data frame to a “realratingMatrix”

2. **Data Exploration**

	- Determined and Visualized the similarity between first ten users with each other.
	- Computed and visualised the similarity between the first 10 beers
	- Determined the unique values of ratings?
	- Visualised the rating values and noticed:
		- The average beer ratings
		- The average user ratings
		- The average number of ratings given to the beers
		- The average number of ratings given by the users

3. **Recommendation Models**

	- Divided the data into training and testing datasets
		- Experimented with 'split' and 'cross-validation' evaluation schemes

	- Build **IBCF** and **UBCF** models

	- Compared the performance of the two models and found which one should be deployed
		- Ploted the ROC curves for UBCF and IBCF and compared them

	- Recommended the top 5 beers to the users "cokes", "genog" & "giblet"
