# This script performs a random forest algorithm on the training data.

# Open training and validation data.
train<-read.csv("train_simple.csv", na.strings = c(""))
validate<-read.csv("validate_simple.csv", na.strings = c(""))

# Combine sets
train<-rbind(train, validate)

# Convert age to numeric
train$Age<-as.numeric(train$Age)
validate$Age<-as.numeric(validate$Age)

# Convert Pclass to factor
train$Pclass<-as.factor(train$Pclass)
validate$Pclass<-as.factor(validate$Pclass)

# Convert Title to factor
train$Title<-as.factor(train$Title)
validate$Title<-as.factor(validate$Title)

# Random forest
library(randomForest)

# Train model
set.seed(111)
model <- randomForest(as.factor(Survived) ~ Pclass+Sex+Age+SibSp+ Parch+ Fare+Embarked ,data=train,
                      importance=TRUE, ntree=2000)
print(model)
summary(model)
#plot(model)
varImpPlot(model)

