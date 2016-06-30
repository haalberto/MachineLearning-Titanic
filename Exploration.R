# This file contains scripts for preeliminary exploration of the Titanic dataset.

# Open dataset
data<-read.csv("train.csv", na.strings = c(""))

# Show summaries and sample data
# ---
head(data)
str(data)
summary(data)
# ---

# Check number and percentage of missing values in each field
# ---
numNAs<-1:ncol(data)
for (x in 1:ncol(data)) {
    missing <- is.na(data[[x]])
    numNAs[[x]]<-sum(missing)
}
percentNAs<-numNAs/nrow(data)
print(numNAs)
print(percentNAs)
# A similar analysis can be done with sapply(data,function(x) sum(is.na(x)))
sapply(data,function(x) sum(is.na(x)))
