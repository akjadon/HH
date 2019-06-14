#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
############################################################## Recommendation System:: BeerMart ####################################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Data Understanding----
  ## Load Libraries
    library(recommenderlab)
    library(ggplot2)
    library(ggthemes)
    library(dplyr)

  ## Load Data file
    beer_data <- read.csv("beer_data.csv", stringsAsFactors = FALSE)
    
    str(beer_data)   # 475984 obs. of  3 variables
    View(beer_data)
    
    
### Data Preparation----
  ## checking for 'NA' values
    sapply(beer_data, function(x) sum(is.na(x)))  #Dataset doesn't contain 'NA' values
    
  ## Checking for the blank/empty values
    sapply(beer_data, function(x) length(which(x=="")))  #100 users without profile name
    
    # beer_beerid review_profilename     review_overall 
    # 0                100                  0 
  
  ## Removing the records with the empty profilename
    beer_data[beer_data == ""] <-NA
    beer_data <- beer_data[!is.na(beer_data$review_profilename),]
    nrow(beer_data) #475884
    
  ## Removing the duplicate records (or the user who provided the review for same beer more than once)
    beer_data_deduplicated <- beer_data[!duplicated(beer_data[,1:2]),]
    nrow(beer_data_deduplicated)  #Removed 1422 duplicate records
    
  ## Removing the beers with '0' rating
    # Checking if there are records with rating '0'
      table(beer_data_deduplicated$review_overall)  #6 records
      
    # Revmoved the rows(or beer) with '0' rating
      beer_data_filtered <- subset(beer_data_deduplicated, beer_data_deduplicated$review_overall !=0)
      nrow(beer_data_filtered)  # Removed 6 rows where rating were '0'

            
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
### Data Preparation and Exploratory Data Analysis (EDA)----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
        
### 1. Choose only those beers that have at least N number of reviews
   
    ## Creating a data frame to store the review counts for each beerid
      beer_review_count <- as.data.frame(table(beer_data_filtered$beer_beerid))
      colnames(beer_review_count) <- c("beerid", "review_counts")
      View(beer_review_count)
    
      # Analysing beerid review counts
        summary(beer_review_count$review_counts)
        quantile(beer_review_count$review_counts, probs = seq(0, 1, .01))  # Around 40% beer having single review
        ggplot(beer_review_count, aes(x=review_counts)) + geom_histogram(bins = 100) # Most of the beers having single review count
        
      # Taking the average number of reviews as >11
        beer_review_count_filter <- subset(beer_review_count, beer_review_count$review_counts>11)
      
    ## Calculating the frequency of review counts
      beer_review_count_freq <- as.data.frame(table(beer_review_count$review_counts))
      colnames(beer_review_count_freq) <- c("review_counts", "review_counts_frequency")
      ggplot(beer_review_count_freq,aes(x=review_counts,y=review_counts_frequency)) + geom_point() #review=1 having maximum number of counts
      
    ## Aggregating the reviews by userprofile
      beer_user_review_count <- as.data.frame(table(beer_data_filtered$review_profilename))
      colnames(beer_user_review_count) <- c("profilename", "review_counts")
      View(beer_user_review_count)
      
      #  Analysing userid review counts
        summary(beer_user_review_count$review_counts)
        quantile(beer_user_review_count$review_counts, probs = seq(0, 1, .01))  # Around 30% of users has provided a review for one beer
        ggplot(beer_user_review_count, aes(x=review_counts)) + geom_histogram(bins = 30) # Most of the beers having single review count
        
      # Taking the average number of reviews as >21
        beer_user_review_count_filter <- subset(beer_user_review_count, beer_user_review_count$review_counts>21)

    ## Creating a data frame based on the above filters
      beer_data_final <- beer_data_filtered[(beer_data_filtered$beer_beerid %in% beer_review_count_filter$beerid)& 
                                          (beer_data_filtered$review_profilename %in% beer_user_review_count_filter$profilename),]
      
      str(beer_data_final)
      
      # Converting "beerid" and "profilename" in to factor, Also "review_overall" into integer
        beer_data_final$beer_beerid <- as.factor(beer_data_final$beer_beerid)
        beer_data_final$review_profilename <- as.factor((beer_data_final$review_profilename))
        beer_data_final$review_overall <- as.integer(beer_data_final$review_overall)
        
      # Interchanging the column order, making profilename (or User) as first column and Beerid as 2nd column
        beer_data_final <- beer_data_final[,c(2,1,3)]
      
    
### 2. Converting the Dataframe into realRatingMatrix
    beer_rating <- as(beer_data_final, "realRatingMatrix")
    class(beer_rating)
    
  ## get some informtaion
    dim(beer_rating)
    dimnames(beer_rating)
    rowCounts(beer_rating)
    colCounts(beer_rating)
    rowMeans(beer_rating)

    
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~      
### Data Exploration----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
    
### 1.Determine how similar the first ten users are with each other and visualise it
    similar_users <- similarity(beer_rating[1:10, ], method = "cosine", which = "users")
    
    ## Similarity matrix
      as.matrix(similar_users)
    
    ## Visualise similarity matrix
      image(as.matrix(similar_users), main = "User similarity")

            
### 2.Compute and visualise the similarity between the first 10 beers
    similar_beers <- similarity(beer_rating[,1:10 ], method = "cosine", which = "items")
    
    ## Similarity matrix
      as.matrix(similar_beers)
     
    ## Visualise similarity matrix   
      image(as.matrix(similar_beers), main = "Beer similarity")

          
### 3.What are the unique values of ratings?
    ratings <- as.vector(beer_rating@data)
    unique_ratings <- unique(ratings)
    sort(unique_ratings)   # 0 1 2 3 4 5
    
    
### 4.Visualise the rating values and notice:
    table(ratings)
    
    # Removing the Rating=0, as 0 was genereated beacuse of the missing values while converting the data frame in to realRatingMatrix
      ratings <- factor(ratings[ratings != 0])
      
    # Visualizing the beer ratings
      qplot(ratings, xlab = "Ratings", ylab = "Frequency", main = "Frequency of Ratings", fill = ratings) + 
      theme_hc(base_size = 18, base_family = "sans")
      # Most the reviews given by user having rating 4 followed by 3
      
      
  ## a.The average beer ratings
      avg_beer_rating <- colMeans(beer_rating)
      summary(avg_beer_rating)  #3.5
      
      # Visualizing the average beer rating through plot
        qplot(avg_beer_rating, xlab = "Average Beer Rating", ylab = "Frequency", main = "Distribution of average Beer rating") + 
        stat_bin(binwidth = 0.05) + theme_hc(base_size = 18, base_family = "sans")
   
             
  ## b.The average user ratings
      avg_user_rating <- rowMeans(beer_rating)
      summary(avg_user_rating)  #3.6
        
      # Visualizing the average beer rating through plot
        qplot(avg_beer_rating, xlab = "Average User Rating", ylab = "Frequency", main = "Distribution of Average User Rating") + 
        stat_bin(binwidth = 0.05) + theme_hc(base_size = 18, base_family = "sans")
  
        
  ## c.The average number of ratings given to the beers
      qplot(rowCounts(beer_rating), main = "Average number of ratings given to the beers") + stat_bin(binwidth = 10)
      summary(rowCounts(beer_rating)) #84
      
      number_of_ratings_beer <- group_by(beer_data_final,beer_beerid) %>% summarise(rating_counts =n())
      summary(number_of_ratings_beer)  
        
  ## d.The average number of ratings given by the users
      qplot(colCounts(beer_rating), main = "Average number of ratings given by the users") + stat_bin(binwidth = 10)
      summary(colCounts(beer_rating))  #53
      
      number_of_ratings_user <- group_by(beer_data_final,review_profilename) %>% summarise(rating_counts =n())
      summary(number_of_ratings_user) 
 
   
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### Recommendation Models
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### List of models available
    recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
    names(recommender_models)# 9 types of models
      
### Description of recommendation system algorithms/models used
    lapply(recommender_models, "[[", "description")
      
### Checking the parameters of IBCF and UBCF models
    recommender_models$IBCF_realRatingMatrix$parameters  
    recommender_models$UBCF_realRatingMatrix$parameters
     
### Filtering the records in realRatingMatrix, as it was taking more time for experimenting different values of "k" and "train_split" in order to build model 
    #and do evaluation
    beer_data_final <- beer_data_final[which(beer_data_final$review_overall >3),]
    beer_rating <-  as(beer_data_final, "realRatingMatrix") #converting to real rating matrix
    beer_rating <- beer_rating[rowCounts(beer_rating) >20,colCounts(beer_rating) >30 ]
    
      
### 1.Divide your data into training and testing datasets
    
    ## Initilizing blank DF for storing  accuracy measures for UBCF and IBCF
      error_UBCF <- data.frame()
      error_IBCF <- data.frame()
    
    ## Generating sequence for train split
      train_split <- seq(0.7,0.9,by=0.05)
    
    ## Generating sequnce for K 
      k_split <- seq(1,5)
  
    ## Figuring out the best values for "k" and "train split". Then Building, evaluating and make Predictions. It took around 27 mins to execute
      for (i in train_split){
        for (j in k_split){
        
          # Declaring the scheme
          set.seed(100)
          scheme <- evaluationScheme(beer_rating, method = "split", train = i,k = j, given=7 , goodRating = 4)
        
          # Building the recommendation models
          recom_UBCF<-Recommender(getData(scheme, "train"), "UBCF") 
          recom_IBCF <- Recommender(getData(scheme, "train"), "IBCF") 
        
          # Making the Predictions
          predict_UBCF <- predict(recom_UBCF, getData(scheme, "known"), type="ratings") 
          predict_IBCF<- predict(recom_IBCF, getData(scheme, "known"), type="ratings")
        
          # Evaluating the performance parameters
          error_recom_UBCF<-calcPredictionAccuracy(predict_UBCF, getData(scheme, "unknown"))
          error_recom_IBCF<-calcPredictionAccuracy(predict_IBCF, getData(scheme, "unknown"))
        
          # Storing the result in a dataframe
          error_UBCF1 <- cbind(data.frame(iteration=paste("split_",i,"k_",j)),t(data.frame(error_recom_UBCF)))
          error_UBCF <- rbind(error_UBCF1,error_UBCF)
        
          error_IBCF1 <- cbind(data.frame(iteration=paste("split_",i,"k_",j)),t(data.frame(error_recom_IBCF)))
          error_IBCF <- rbind(error_IBCF1,error_IBCF)
        }
      }  
    
    
    ## Viewing the performance measures for both UBCF and IBCF
      View(error_UBCF)
      View(error_IBCF)
    
    ## Find out the minimum RMSE value among all the iterationshe
      min(error_UBCF$RMSE)  # 0.2884068
      error_UBCF$iteration[error_UBCF$RMSE==min(error_UBCF$RMSE)]  # split = 0.75, k = 2
    
      min(error_IBCF$RMSE) # 0.4143252
      error_IBCF$iteration[error_IBCF$RMSE==min(error_IBCF$RMSE)]  # split = 0.9, k = 2

      
    ## Scheme2 evaluation using cross-validation
      scheme2 <- evaluationScheme(beer_rating, method = "cross-validation",k = 5, given = 7, goodRating = 4)
        
      # Building the recommendation models  
        recom_UBCF_2<-Recommender(getData(scheme2, "train"), "UBCF") 
        recom_IBCF_2 <- Recommender(getData(scheme2, "train"), "IBCF") 
          
      # Making the Predictions
        predict_UBCF_2 <- predict(recom_UBCF_2, getData(scheme2, "known"), type="ratings") 
        predict_IBCF_2 <- predict(recom_IBCF_2, getData(scheme2, "known"), type="ratings")

        
           
### 3.Compare the performance of the two models and suggest the one that should be deployed. Plot the ROC curves for UBCF and IBCF and compare them
    
  ## Evaluating schema using values: split=0.75 and k=2
    set.seed(100)
    scheme_final <- evaluationScheme(beer_rating, method = "split", train = .75, k = 2, given=7 , goodRating = 4)
    scheme_final
    
    algorithms <- list(
      "user-based CF" = list(name="UBCF", param=list(normalize = "Z-score", method="Cosine", nn=30, minRating=4)),
      "item-based CF" = list(name="IBCF", param=list(normalize = "Z-score"))
    )
      
  ## Running algorithms to predict next n movies
    results <- evaluate(scheme_final, algorithms, n=c(1, 3, 5, 10, 15, 20))  ##result of "split" evaluation scheme
    class(results)
    
    result2 <- evaluate(scheme2, algorithms, n=c(1, 3, 5, 10, 15, 20))  #result of "cross-validation" evaluation scheme
    class(result2)
    
  ## Plotting ROC Curves
    plot(results, annotate = 1:4, legend="topleft")  # UBCF model is better than the IBCF model
    # We can deploy UBCF model for recommendations
    
    plot(result2, annotate = 1:4, legend="topleft")  # UBCF model is better than the IBCF model
    # We can deploy UBCF model for recommendations
    
    
### 4.Give the names of the top 5 beers that you would recommend to the users "cokes", "genog" & "giblet"  
  
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
  ## Using the UBCF model to recommend top 5 beers
    recommendation_UBCF<-Recommender(getData(scheme_final, "train"), "UBCF") #using scheme with method type as "split"
    
  ## Top 5 beer recommendation for "cokes"
    recommendations_UBCF_cokes <- predict(recommendation_UBCF, beer_rating["cokes",], n=5)
    
    # Displaying the recommendations (or recommended beer)
      as(recommendations_UBCF_cokes, "list")
      # "1010"  "54827" "7971"  "2093"  "17112" 
    
      
  ## Top 5 beer recommendation for "genog"
    recommendations_UBCF_geong <- predict(recommendation_UBCF, beer_rating["genog",], n=5)
      
    # Displaying the recommendations (or recommended beer)
      as(recommendations_UBCF_geong, "list")
      # "7971" "2093" "226"  "694"  "356" 
    
    
  ## Top 5 beer recommendation for "giblet"
      recommendations_UBCF_giblet <- predict(recommendation_UBCF, beer_rating["giblet",], n=5)
      
    # Displaying the recommendations (or recommended beer)
      as(recommendations_UBCF_giblet, "list")
      # "5"  "6"  "7"  "10" "14"
   
   
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
  ## Using the IBCF model to recommend top 5 beers
    recommendation_IBCF<-Recommender(getData(scheme_final, "train"), "IBCF")
      
  ## Top 5 beer recommendation for "cokes"
    recommendations_IBCF_cokes <- predict(recommendation_IBCF, beer_rating["cokes",], n=5)
      
    # Displaying the recommendations (or recommended beer)
      as(recommendations_IBCF_cokes, "list")
      # "255"  "932"  "1550" "3680" "6646"
      
      
  ## Top 5 beer recommendation for "genog"
    recommendations_IBCF_geong <- predict(recommendation_IBCF, beer_rating["genog",], n=5)
      
    # Displaying the recommendations (or recommended beer)
      as(recommendations_IBCF_geong, "list")
      # "10"  "310" "356" "449" "570"
      
      
  ## Top 5 beer recommendation for "giblet"
    recommendations_IBCF_giblet <- predict(recommendation_IBCF, beer_rating["giblet",], n=5)
      
    # Displaying the recommendations (or recommended beer)
      as(recommendations_IBCF_giblet, "list")
      # character(0) means user does not found in matrix 
    
    
    