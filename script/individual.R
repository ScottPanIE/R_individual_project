# individual projects
# datasets: housing price dataset or black friday dataset
# for housing price, do not use date, treat as a general dataset
# for blackfriday, do not use customerID
setwd("~/Desktop/IEMBD/TERM3/R/individual_project/script")

# need to split train into train and test
train <- read.csv('../data/house_price_train.csv')
# test sets is used for submission only
submission <- read.csv('../data/house_price_test.csv')

View(train)
# target variable: price
str(train)
str(submission)

# need to manipulate the data first, then split into train and test
