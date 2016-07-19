# This script cleans the data so it can be used in machine learning. It also separates the training
# data into twosets: training and validation. It creates new csv files for those sets and 
# also one for the test data, which it also cleans.

# In addition, it creates a new column called Title (explained below)

# List of created filenames: "train_simple_title.csv", "validate_simple_title.csv",
# "test_simple_title.csv"

# Important choices that were made:
# 1) Missing values in Age and Fare are replaced by the average.
# 2) No variables are removed.
# 3) Missing values in Embarked are replaced by the most common ("S").
# 4) Training and variance sets will be split to (75%, 25%).
# 5) Adds new column Title which is one of (Mr, Mrs, Miss, Master, Other)

# Ideas for improvement
# 1) Create an additional logical variable for Age indicating whether it is known or missing.

# Open training dataset and prediction set
data<-read.csv("train.csv", na.strings = c(""))
data2<-read.csv("test.csv", na.strings = c(""))

# Add title information
Title<-rep("Other", length(data$Name))
for (x in 1:length(data$Name)) {
    if (grepl("Mrs", data$Name[x])) {
        Title[x]<-"Mrs"
    } else if (grepl("Mr", data$Name[x])) {
        Title[x]<-"Mr"
    } else if (grepl("Miss", data$Name[x])) {
        Title[x]<-"Miss"
    } else if (grepl("Master", data$Name[x])) {
        Title[x]<-"Master"
    }
}
Title<-as.factor(Title)
data<-cbind(data, Title)
rm (Title)

Title<-rep("Other", length(data2$Name))
for (x in 1:length(data2$Name)) {
    if (grepl("Mrs", data2$Name[x])) {
        Title[x]<-"Mrs"
    } else if (grepl("Mr", data2$Name[x])) {
        Title[x]<-"Mr"
    } else if (grepl("Miss", data2$Name[x])) {
        Title[x]<-"Miss"
    } else if (grepl("Master", data2$Name[x])) {
        Title[x]<-"Master"
    }
}
Title<-as.factor(Title)
data2<-cbind(data2, Title)

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
data2$Embarked[is.na(data2$Embarked)]<-"S"

# Generate training and validation subsets.
set.seed(42)
nobs<-length(data[[1]])
orig_set_index<-1:nobs
train_index<-sample(orig_set_index, ceiling(nobs*.75))
validation_index<-setdiff(orig_set_index, train_index)

training<-data[train_index, ]
validation<-data[validation_index, ]

# Save files.
write.csv(data[train_index, ], file="train_simple_title.csv", row.names = FALSE)
write.csv(data[validation_index, ], file="validate_simple_title.csv", row.names = FALSE)
write.csv(data2, file="test_simple_title.csv", row.names = FALSE)
