#######################################################################################################################################
#                                                     :: AirBnB Price Prediction ::
######################################################################################################################################

### Install EBImage
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite("EBImage")

### Data Understanding---
  ## Load Libraries
    library(data.table)
    library(EBImage)
    library(ggplot2)
    library(dplyr)
    library(corrplot)
    library(foreach)
    library(doParallel)
    library(geosphere)
    library(caret)
    library(xgboost)
    library(stringr)
    library(tm) # framework for text mining; it loads NLP package
    library(RColorBrewer)
    library(wordcloud)

  ## Load Data
    df_train <- fread("train.csv", sep = ",", header = TRUE, na.strings=c("","NA"))
    df_test <- fread("test.csv", sep = ",", header = TRUE, na.strings=c("","NA"))
    
  ## Combine Training and Test Dataset
    ids = df_test$id
    df_test$log_price <- NA
    
    df_all <- rbind(df_train,df_test)
    

    
############################################################################################################################    
#                                             :: Exploratory Data Analysis ::
############################################################################################################################
    
### Checking for NA values
  sapply(df_all, function(x) sum(is.na(x)))
  
  # Columns: bathrooms, first_review, host_has_profile_pic, host_identity_verified, host_response_rate, host_since,
  #         last_review, neighbourhood, thumbnail_url, zipcode, bedrooms and beds having NA values
    
    
### Log price by Property Type
  df_train %>% ggplot(aes(x=property_type, y=log_price, fill=property_type)) + geom_boxplot() + 
  theme(legend.position="none",axis.text.x = element_text(colour = "black", angle=90, vjust = 0.5),plot.title = element_text(hjust = 0.5)) + 
  labs(x="Property Type",y=" Log Price") + ggtitle("Log Price By Property Type") 
    
### Log price by Room Type
  df_train %>% ggplot(aes(x=room_type, y=log_price, fill=room_type)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Room Type",y=" Log Price") + ggtitle("Log Price By Room Type") 
  
### Log price by Room Type
  df_train %>% ggplot(aes(x=as.factor(accommodates), y=log_price, fill=accommodates)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Accommodates",y=" Log Price") + ggtitle("Log Price By Accommodates") 
  
  ## Mean log price by Room Type
  df_train %>% group_by(accommodates) %>% summarise(mean_log_price=mean(log_price)) %>% data.frame() %>% 
  ggplot(aes(x=as.factor(accommodates), y=mean_log_price, fill=accommodates)) + geom_bar(stat = "identity", width = 0.7) + 
  labs(x="Accommodates",y=" Mean Log Price") + ggtitle("Mean Log Price By Accommodates") 
   
### Log price by Bathrooms
  df_train %>% ggplot(aes(x=as.factor(bathrooms), y=log_price, fill=bathrooms)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Bathrooms",y="Log Price") + 
  ggtitle("Log Price per Bathroom") 
    
### Log price by Bed Type
  df_train %>% ggplot(aes(x=as.factor(bed_type), y=log_price, fill=bed_type)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Bed Type",y="Log Price") + 
  ggtitle("Log Price By Bed Type") 
  
  
### Log price by Cancellation Policy
  df_train %>% ggplot(aes(x=as.factor(cancellation_policy), y=log_price, fill=cancellation_policy)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Cancellation Policy",y="Log Price") + 
  ggtitle("Log Price By Cancellation Policy")
    
  ## Average log price by Cancellation Policy
  df_train %>% group_by(cancellation_policy) %>% summarise(mean_log_price=mean(log_price)) %>% data.frame() %>% 
  ggplot(aes(x=as.factor(cancellation_policy), y=mean_log_price, fill=cancellation_policy)) + geom_bar(stat = "identity", width = 0.5) + 
  labs(x="Cancellation Policy",y="Average Log Price") + ggtitle("Average Log Price By Cancellation Policy") + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5))
  
  
### Log price by Cleaning Fee
  df_train %>% ggplot(aes(x=as.factor(cleaning_fee), y=log_price, fill=cleaning_fee)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Cleaning Fee",y="Log Price") + 
  ggtitle("Log Price By Cleaning Fee")
  
  
### Log price by City
  df_train %>% ggplot(aes(x=as.factor(city), y=log_price, fill=city)) + geom_boxplot() + 
    theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="City",y="Log Price") + 
    ggtitle("Log Price By City")
  
    ## Average log price by Cancellation Policy
    df_train %>% group_by(city) %>% summarise(mean_log_price=mean(log_price)) %>% data.frame() %>% 
    ggplot(aes(x=as.factor(city), y=mean_log_price, fill=city)) + geom_bar(stat = "identity", width = 0.5) + 
    labs(x="City",y="Average Log Price") + ggtitle("Average Log Price By City") + 
    theme(legend.position="none",plot.title = element_text(hjust = 0.5))
  
    
### Log price by Instant Bookable
  df_train %>% ggplot(aes(x=as.factor(instant_bookable), y=log_price, fill=instant_bookable)) + geom_boxplot() + 
  theme(legend.position="none",plot.title = element_text(hjust = 0.5)) + labs(x="Instant Bookable",y="Log Price") + 
  ggtitle("Log Price By Instant Bookable")

  #Very less variation in price
  
  
### Log Price based on Number of reviews
  df_train %>% ggplot(aes(x=number_of_reviews, y=log_price)) + geom_point() + geom_smooth() +
  theme(plot.title = element_text(hjust = 0.5)) + labs(x="Instant Bookable",y="Log Price") + 
  ggtitle("Log Price Based on Number of Reviews")

  

    
############################################################################################################################    
#                                                     :: Data Cleaning ::
############################################################################################################################
    
### Missing values treatment
  ## Replacing missing values with median value
    df_all$bathrooms[which(is.na(df_all$bathrooms)==TRUE)] <- 1
    df_all$review_scores_rating[which(is.na(df_all$review_scores_rating)==TRUE)] <- 96
    df_all$review_scores_rating[which(is.na(df_all$review_scores_rating)==TRUE & df_all$number_of_reviews==0)] <- 0
    df_all$bedrooms[which(is.na(df_all$bedrooms)==TRUE)] <- 1
    df_all$beds[which(is.na(df_all$beds)==TRUE)] <- 1
    
  ## Categorize the missing values
    df_all$neighbourhood[which(is.na(df_all$neighbourhood)==TRUE)] <- "Other"
    df_all$host_has_profile_pic[which(is.na(df_all$host_has_profile_pic)==TRUE)] <- "unknown"
    df_all$host_identity_verified[which(is.na(df_all$host_identity_verified)==TRUE)] <- "unknown"
    
  ## Replacing missing values with mean value
    df_all$host_response_rate[which(is.na(df_all$host_response_rate)==TRUE)] <- 94
    
    
## Converting "host_response_rate" column in to numeric
  df_all$host_response_rate = as.numeric(gsub("\\%", "", df_all$host_response_rate))
  
  
### Changing the column data Types
    
    col_factor <- c("property_type", "room_type", "bed_type", "cancellation_policy", "cleaning_fee", "city", "host_has_profile_pic", 
                    "host_identity_verified", "instant_bookable")
    
    col_numeric <- c("accommodates", "bathrooms", "host_response_rate", "latitude", "longitude", "number_of_reviews", 
                     "review_scores_rating", "bedrooms", "beds")
    
  ## Converting columns to factor
    df_all[,(col_factor):= lapply(.SD, as.factor), .SDcols = col_factor]
    
  ## Converting columns to numeric
    df_all$accommodates <- as.numeric(df_all$accommodates)


    
############################################################################################################################    
#                                                   :: Feature Extraction ::
############################################################################################################################
    
### 1. Extracting Brightness and RGB component from an image(i.e. thubnal_url)
    
  ## Subsetting the dataframe to get id's and thumbnail_url where thumbnail_url is not blank
    url_df <- subset(df_all, !is.na(thumbnail_url), select=c(id, thumbnail_url))

  ## Removing the last characters from the url to get an image
    url_df$thumbnail_url = substr(url_df$thumbnail_url,1,nchar(url_df$thumbnail_url)-17)
    
  ## Setting up parallel processing to process images
    no_cores <- detectCores()-1
    registerDoParallel(makeCluster(no_cores))
    
    stopImplicitCluster()
    
  ## Extracting Brightness and RGB Component of an image
    comb <- function(x, ...) {
      lapply(seq_along(x),function(i) c(x[[i]], lapply(list(...), function(y) y[[i]])))
    }
    
    #It will take sometime to execute
    oper <- foreach(i=1:88494, .combine='comb', .multicombine=TRUE, .init=list(list(), list(), list(), list(), list())) %dopar% {
        tryCatch({
          url <- url_df$thumbnail_url[i]
          image <- EBImage::readImage(url)
          image_resize <- EBImage::resize(image,216,144) #Resizing an image to the actual size (as present in the dataset)
          
          #Converting image to grayscale
          grayimage <- EBImage::channel(image, "gray")
          
          list(mean(image[,,1]),mean(image[,,2]),mean(image[,,3]),mean(grayimage), url_df$id[i])
          
        }, error=function(e){})
      }
  
  ## Extracting each component separately
    red <- unlist(oper[[1]])
    green <- unlist(oper[[2]])
    blue <- unlist(oper[[3]])
    brightness <- unlist(oper[[4]])
    id <- unlist(oper[[5]])
    
    image_components <- cbind(red, green, blue, brightness, id)
    
  ## Merging the image_component data frame with the orignal dataframe (df_all)
    df_all <- merge(df_all,image_components,by="id")
    
  ## Imputing the NA values in image components
    df_all$red[which(is.na(df_all$red)==TRUE)] <- mean(df_all$red, na.rm = TRUE)
    df_all$green[which(is.na(df_all$green)==TRUE)] <- mean(df_all$green, na.rm = TRUE)
    df_all$blue[which(is.na(df_all$blue)==TRUE)] <- mean(df_all$blue, na.rm = TRUE)
    df_all$brightness[which(is.na(df_all$brightness)==TRUE)] <- mean(df_all$brightness, na.rm = TRUE)
    
    
### 2. Creating column "property_room_Type" (combination of property_type and room_type)
  df_all$property_room_type <- paste0(df_all$property_type," - ",df_all$room_type)
  df_all$property_room_type <- as.factor(df_all$property_room_type) #Converting the variable to factor
  
    
### 3. Creating "amenities_count" variable from the amenities column
  df_all$amenities_count <- count.fields(textConnection(df_all$amenities), sep = ",")
  df_all$amenities_count <- as.numeric(df_all$amenities_count) #Converting the variable to numeric
  
  
### 4. Creating "distance_from_airport" column using latitude/longitude columns and external data
###    which captures the distance between the AirBnB listing and the nearest Airport
  
  ## Loading airport detials
    download.file("http://ourairports.com/data/airports.csv","airport_data.csv")
    airport_info <- fread("airport_data.csv", stringsAsFactors = FALSE)
    
    US_airport_info <- subset(airport_info, (iso_country=="US" & iso_region %in% 
                                               c("US-NY","US-NC","US-DC","US-LA","US-IL","US-MI","US-MA")))
    
    system.time({  
    dis_res <- foreach(i= 1:99569, .packages = ("doParallel")) %dopar% {
      r<- foreach(j = 1:nrow(US_airport_info), .packages = ("geosphere")) %dopar% {
          geosphere::distm(c(df_all$longitude[i], df_all$latitude[i]), c(US_airport_info$longitude_deg[j], US_airport_info$latitude_deg[j]),
                                  fun = distHaversine)
      }
      return(min(unlist(r)))
    }
    }) #Will take sometime to execute

    ##Adding the "min_distance_from_airport" column to the dataframe
      df_all$min_distance_from_airport <- unlist(dis_res)
    
    
    
### Clustering the location based on the latitude and longitude
  location_clust <- subset(df_all, select = c(id,latitude,longitude)) 
  location_clust_1 <- location_clust[,-1]
    
  ## Finding the optimal value of K
    r_sq<- rnorm(20)
    
    for (number in 1:20){clus <- kmeans(location_clust_1, centers = number, nstart = 50)
    r_sq[number]<- clus$betweenss/clus$totss
    }
    
    plot(r_sq) 
    #It comes out that optimalvalue of k is 4 (based on the elbow method)
    
  ## Creating clusters using kmeans algorithm
    clus <- kmeans(location_clust_1, centers = 4, iter.max = 50, nstart = 50)
    
  ## Appending the ClusterIDs to the data
    location_km <- cbind(location_clust$id,clus$cluster)
    colnames(location_km) <- c("id", "cluster_id")
    
  ## Merging the cluster the data with the orignal data
    df_all <- merge(df_all,location_km,by="id")
    df_all$cluster_id <- as.factor(df_all$cluster_id) #Converting the cluster_id column to factor
    

    
###########################################################################################################################
#                                                 :: Data Exploration ::
##########################################################################################################################
    
### Plotting the correlation between variables
  col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
  M <- df_all[,c("accommodates", "bathrooms", "host_response_rate", "latitude", "longitude", "number_of_reviews", 
                 "review_scores_rating", "bedrooms", "beds", "amenities_count")]
  
  M <- sapply(M, as.numeric) #Converting the variables to numeric
  
  ## Plotting the correlation
  corrplot(cor(M), method="number", type = "upper")

    
### Text Analytics::
    
  ## Text Analytics for amenities (creating wordcloud)
  ## Prepare the text by lower casing, removing numbers and white spaces, punctuation and unimportant words. 
    amenities <- tolower(df_all$amenities)
    amenities <- tm::removeNumbers(amenities)
    amenities <- str_replace_all(amenities, "  ", "")  #replace double spaces with single space
    amenities <- str_replace_all(amenities, pattern = "[[:punct:]]", " ")
    amenities <- tm::removeWords(x = amenities, stopwords("english"))
    
    amenities_corpus <- tm::Corpus(VectorSource(amenities)) # turn into corpus
    amenities_tdm <- tm::TermDocumentMatrix(amenities_corpus)  # create tdm from the corpus

    tm::termFreq(amenities) # find the frequency of words
    
    # Creating word cloud for amenities
      wordcloud(amenities_corpus, max.words = 300,random.order=FALSE, rot.per=0.10, use.r.layout=TRUE, 
              colors=brewer.pal(8, "Dark2"))

    
  ## Text Analytics for the "description" column
  ## Prepare the text by lower casing, removing numbers and white spaces, punctuation and unimportant words. 
    
    df_description <- data.frame(doc_id=row.names(df_all),text=df_all$description)
    
    description.corpus <- Corpus(DataframeSource(data.frame(head(df_description, n=100000))))
    description.corpus <- tm_map(description.corpus, removePunctuation)
    description.corpus <- tm_map(description.corpus, stripWhitespace)
    description.corpus <- tm_map(description.corpus, content_transformer(tolower))
    description.corpus <- tm_map(description.corpus, removeWords, stopwords("english"))
    
    # Creating word cloud for description
      wordcloud(description.corpus,max.words = 10000,random.order=FALSE, rot.per=0.1, use.r.layout=FALSE, 
              colors=brewer.pal(8, "Spectral"))
    
      
  ## Text Analytics for the "description" column
  ## Prepare the text by lower casing, removing numbers and white spaces, punctuation and unimportant words. 
      
    df_name <- data.frame(doc_id=row.names(df_all),text=df_all$name)
      
    name.corpus <- Corpus(DataframeSource(data.frame(head(df_name, n=100000))))
    name.corpus <- tm_map(name.corpus, removePunctuation)
    name.corpus <- tm_map(name.corpus, stripWhitespace)
    name.corpus <- tm_map(name.corpus, content_transformer(tolower))
    name.corpus <- tm_map(name.corpus, removeWords, stopwords("english"))
    
    # Creating word cloud for name column
      wordcloud(name.corpus,max.words = 10000,random.order=FALSE, rot.per=0.10, use.r.layout=FALSE, 
              colors=brewer.pal(8, "Accent"))
    
    
    

###########################################################################################################################
#                                                 :: Variable Selectipn ::
##########################################################################################################################
   
### Removed below mentioned attributes, as those are having large number of missing values or some are text columns 
  df_all <- subset(df_all, select = -c(amenities, description, first_review, host_since, last_review, name, 
                                       neighbourhood, thumbnail_url, zipcode) )


### Dummy Variable Creation----
  dmy <- dummyVars("~ property_type + room_type + bed_type + cancellation_policy + cleaning_fee + city + host_has_profile_pic + 
                   host_identity_verified + instant_bookable + property_room_type + cluster_id", data = df_all, fullRank = T)
    
  dummy_1 <- data.frame(predict(dmy,newdata = df_all))
  
  View(dummy_1)
  
    
  ## Removing orignal columns for those dummy variables are generated
    df_all <- subset(df_all, select = -c(property_type, room_type, bed_type, cancellation_policy, cleaning_fee, city, host_has_profile_pic, 
                                         host_identity_verified, instant_bookable, property_room_type, cluster_id))
    
    df_all <- cbind(df_all,dummy_1)
    dim(df_all)
    
    
### Convert Variables either in numeric or facor based on the their values
  df_all[,3:159] <- lapply(df_all[,3:159], function(x) as.numeric(x))
  
    
  
############################################################################################################################    
#                                                     :: Model Building ::
############################################################################################################################
  
### Divide the datafame in train and test dataset with same records as in original datasets
  train <- df_all[!df_all$id %in% ids,]
  test <- df_all[df_all$id %in% ids,]
    
  train1 <- train[,- c("id", "log_price")]   # Removing the "id" and "log_price" columns from the training dataset
  test1 <- test[,-c("id", "log_price")]     # Removing "id" and "log_price" columns from the test dataset
    

### Preparing Matrix (converting data frame to matrix)      
  
  labels <- as.numeric(train$log_price)
  train_1 <- as.matrix(train1)
  dtrain <- xgb.DMatrix(data = train_1,label = labels)
  
  tst_lbl <- as.numeric(test$log_price)
  test_1 <- as.matrix(test1)
  dtest <- xgb.DMatrix(data = test_1, label=tst_lbl)
  
  
### Model Building
  
  ## Cross Validation
    set.seed(200)
  
    params <- list(booster = "gbtree", objective = "reg:linear", eta=0.3, gamma=0, max_depth=11, min_child_weight=1, subsample=0.8, colsample_bytree=1)
    xgbcv <- xgb.cv( params = params, data = dtrain, nrounds = 1000, nfold = 5, showsd = T, stratified = T, print_every_n = 10, 
                     early_stopping_round = 20, maximize = F)
    
  ## first default - model training
    xgb1 <- xgb.train (params = params, data = dtrain, nrounds = 22, watchlist = list(train=dtrain), print_every_n = 10, early_stoppimg_rounds = 10, 
                       maximize = F , eval_metric = "rmse")

    
### Hyperparameter tuning
    cv.ctrl <- trainControl(method = "repeatedcv", repeats = 1,number = 3, allowParallel = TRUE)
    
    xgb.grid <- expand.grid(nrounds = 1000, max_depth = 10,eta = c(0.025, 0.05, 0.1, 0.3), gamma =c(0, 0.05, 0.1, 0.5, 0.6, 0.8, 1.0),
                            colsample_bytree = 1, min_child_weight=c(1,2,3), subsample = c(0.5,0.8, 1))
    
    xgb_tune <-caret::train(log_price~.,data=train, method="xgbTree", metric = "RMSE", trControl=cv.ctrl, tuneGrid=xgb.grid)
    
    
### Final Model based on the tuning parameters
    
  set.seed(200)
  params <- list(booster = "gbtree", objective = "reg:linear", eta=0.01, gamma=0.6, max_depth=10, min_child_weight=2, subsample=0.8, colsample_bytree=1)
  xgbcv7 <- xgb.cv( params = params, data = dtrain, nrounds = 1000, nfold = 5, showsd = T, stratified = T, print_every_n = 10, 
                    early_stopping_round = 20, maximize = F)
  
    
  ## Final Model
    xgb_final <- xgb.train (params = params, data = dtrain, nrounds =476, watchlist = list(train=dtrain), print_every_n = 10, early_stoppimg_rounds = 10, 
                                    maximize = F , eval_metric = "rmse")
    
    
    
############################################################################################################################ 
#                                               :: Prediction on Test Data ::
############################################################################################################################     
    
### Predicting log_price for test daatset
  xgbpred <- predict (xgb_final,dtest)
    
  sample_submission <- data.frame(id =test$id, log_price = xgbpred)
  write.csv(sample_submission, "submission.csv", row.names = FALSE)
  
  
  
############################################################################################################################ 
    
    
    
    
    
