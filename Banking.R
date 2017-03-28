library(data.table)
library(h2o)
library(caret)
library(stringr)
library(e1071)

train <- fread("train_indessa.csv",na.strings = c(""," ",NA))
test <- fread("test_indessa.csv",na.strings = c(""," ",NA))

# Check Data --------------------------------------------------------------

dim(train)
dim(test)

str(train)
str(test)


# Data Preprocessing ---------------------------------------


# Check correlation and remove correlated variables -----------------------

num_col <- colnames(train)[sapply(train, is.numeric)]
num_col <- num_col[!(num_col %in% c("member_id","loan_status"))]

corrplot::corrplot(cor(train[,num_col,with=F]),method = "number")

train[,c("funded_amnt","funded_amnt_inv","collection_recovery_fee") := NULL]
test[,c("funded_amnt","funded_amnt_inv","collection_recovery_fee") := NULL]

# Extract term value and convert to integer -------------------------------

train[,term := unlist(str_extract_all(string = term,pattern = "\\d+"))]
test[,term := unlist(str_extract_all(string = term,pattern = "\\d+"))]

train[,term := as.integer(term)]
test[,term := as.integer(term)]

