# This script cleans the data so it can be used in machine learning. It also separates the training
# data into three sets: Training, validation, and test. It creates new csv files for those sets and 
# also one for the prediction data, which it also cleans.

# List of created filenames: "train_v1.csv", "validate_v1.csv", "test_v1.csv", "predict_v1.csv"

# Important choices that were made:
# 1) Missing values in Age and Fare are replaced by the average.
# 2) These variables were removed: "PassengerId", "Cabin", "Name", "Ticket".
# 3) Missing values in Embarked are replaced by the most common ("S").
# 4) Training, covariance, and test sets will be split to (60%, 20%, 20%).

# Ideas for improvement
# 1) Create an additional logical variable for Age indicating whether it is known or missing.

# Open training dataset and prediction set
data<-read.csv("train.csv", na.strings = c(""))
data2<-read.csv("test.csv", na.strings = c(""))

# Remove data that will not be used.
data<-data[ , !names(data) %in% c("PassengerId", "Cabin", "Name", "Ticket")]
data2<-data2[ , !names(data2) %in% c("PassengerId", "Cabin", "Name", "Ticket")]

# Fill missing values in Age: Replace with average (of training set)
ageavg<-mean(data$Age, na.rm = TRUE)
data$Age[is.na(data$Age)]<-ageavg
data2$Age[is.na(data2$Age)]<-ageavg

# Fill missing values in Fare: Replace with average (of training set)
fareavg<-mean(data$Fare, na.rm = TRUE)
data$Fare[is.na(data$Fare)]<-fareavg
data2$Fare[is.na(data2$Fare)]<-fareavg

# Fill missing values in Embarked: Replace with most common ("S")
data$Embarked[is.na(data$Embarked)]<-"S"
data2$Embarked[is.na(datas$Embarked)]<-"S"

# Generate training, validation, and testing data subsets.
set.seed(42)
nobs<-length(data[[1]])
orig_set_index<-1:nobs
train_index<-sample(orig_set_index, ceiling(nobs*.6))
rest<-setdiff(orig_set_index, train_index)
validation_index<-sample(rest, ceiling(length(rest)*.5))
test_index<-setdiff(rest, validation_index)

training<-data[train_index, ]
validation<-data[validation_index, ]
test<-data[test_index, ]

# Save files.
write.csv(data[train_index, ], file="train_v1.csv", row.names = FALSE)
write.csv(data[validation_index, ], file="validate_v1.csv", row.names = FALSE)
write.csv(data[test_index, ], file="test_v1.csv", row.names = FALSE)
write.csv(data2, file="predict_v1.csv", row.names = FALSE)

# factor_to_dummy<- function (v) {
#     # Takes a vector with categorical data and returns dummy variables. Uses "deviation coding".
#     
#     # Find number of levels.
#     N<-nlevels(v)
#     # Convert to integer type.
#     ints=as.integer(v)
#     contrasts(hsb2$race.f) = contr.sum(4)
#     
#     # Initialize matrix
#     M<-matrix(NA, length(v), N)
#     for (x in 1:N) {
#         M[ ,x]<- as.integer(ints==x)
#     }
#     return(M)
# }