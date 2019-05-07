# individual projects
# datasets: housing price dataset or black friday dataset
# for housing price, do not use date, treat as a general dataset
# for blackfriday, do not use customerID
setwd("~/Desktop/IEMBD/TERM3/R/individual_project/script")
# need to split train into train and test
train <- read.csv('../data/house_price_train.csv')
# test sets is used for submission only
submission <- read.csv('../data/house_price_test.csv')

library(tidyr)
library(dplyr)
View(train)
# target variable: price
str(train)
str(submission)
# process:
# manipulate the data
# split into train and test
# baseline model
# feature engineering
# tuning model
# finalize

# manipulate the data:
# 1.check the variables
head(train)
dim(train)
# 17277 rows 21 variables
# variables:
names(train)
# id: we can drop it because it's just identification of each observation
# date: may be able to extract useful information like year month date
# price: target variable
# bedrooms: number of bedrooms
# bathrooms: number of bathrooms
# sqft_living: area of the living room?
# sqft_lot: area of the lot? what is lot? probably the entire sqft of the house?
# floors: number of floors
# waterfront: bool
# view: not sure about this variable
# condition: level of house condition? measurement of the new or old?
# grade: ?
# sqft_above: ?
# sqft_basement: area of the basement, as not all of them have basement, can treate it as bool
# for the ones have basements, factorize the area of the basement into different levels
# yr_built: the year been built, maybe extract important year?
# or just use subtraction: how many years from now
# yr_renovated: first treate as bool b/c not all have been renovated, then factorlize
# zipcode: prensents the district geographically, so probably only need zipcode or lat and long
# sqft_living15: ???
# sqft_lot15: ???


glimpse(train)
summary(train)

# as shown in hist, most of the houses are concerntrated in the low price
hist(train$price)

# check for the relationship between yearbuilt and the price
# as shown there is no big difference for the houses various different year built
# also not for year renovated
plot(train$yr_built, train$price)
plot(train$yr_renovated, train$price)
# however most of the early year built house are renovated
# so maybe there are some relationship between whether renovated and price for the old houses
# then how do we define an old house????
plot(train$yr_built, train$yr_renovated)


# the function used to clean the data
# will first try everything then put them into functions and apply to both train and submission
clean_data <- function(df){
  # split the sales date to year month day and convert to factor
  df_ymd <- separate(df, col = date, into = c("month", "day","year"), sep = "/")
  df_ymd$year <- as.factor(df_ymd$year)
  df_ymd$month <- as.factor(df_ymd$month)
  df_ymd$day <- as.factor(df_ymd$day)
  
  df_ymd <- select(df_ymd,-c(id,lat,long))
  
  return(df_ymd)
}

# 1. split the date into year month day
train_ymd <- separate(train, col = date, into = c("month", "day","year"), sep = "/")
# 2. drop id
train_ymd <- select (train_ymd,-c(id,lat,long))
# 3. check for NA over the dataset
apply(train_ymd, 2, function(x) any(is.na(x)))
# as shown from the result there are no missing values in the dataset
glimpse(train_ymd)

any(is.na(train_ymd))
train_ymd$year <- as.factor(train_ymd$year)
train_ymd$month <- as.factor(train_ymd$month)
train_ymd$day <- as.factor(train_ymd$day)
train_ymd$bedrooms <- as.factor(train_ymd$bedrooms)
train_ymd$bathrooms <- as.factor(train_ymd$bathrooms)
train_ymd$floors <- as.factor(train_ymd$floors)
train_ymd$zipcode <- as.factor(train_ymd$zipcode)
train_ymd$view <- as.factor(train_ymd$view)
train_ymd$condition <- as.factor(train_ymd$condition)
train_ymd$grade <- as.factor(train_ymd$grade)
train_ymd$yr_built <- as.factor(train_ymd$yr_built)
train_ymd$yr_renovated <- as.factor(train_ymd$yr_renovated)


glimpse(train_ymd)

hist(train_ymd$zipcode)
hist(train_ymd$month)


formula<-as.formula(price~.)   # price against all other variables
library(randomForest)

rf_0<-randomForest(formula=formula, data=train_ymd)
print(rf_0)