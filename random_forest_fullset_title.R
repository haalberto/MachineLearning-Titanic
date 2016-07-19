# This script performs a random forest algorithm on the training data.

# Open training and validation data.
train<-read.csv("train_simple_title.csv", na.strings = c(""))
validate<-read.csv("validate_simple_title.csv", na.strings = c(""))
# Open test set
test<-read.csv("test_simple_title.csv", na.strings = c(""))

# Combine sets
train<-rbind(train, validate)

# Convert age to numeric
train$Age<-as.numeric(train$Age)
validate$Age<-as.numeric(validate$Age)
test$Age<-as.numeric(test$Age)

# Convert Pclass to factor
train$Pclass<-as.factor(train$Pclass)
validate$Pclass<-as.factor(validate$Pclass)
test$Pclass<-as.factor(test$Pclass)

# Convert Title to factor
train$Title<-as.factor(train$Title)
validate$Title<-as.factor(validate$Title)
test$Title<-as.factor(test$Title)

# Random forest
library(randomForest)

# Train model
set.seed(111)
model <- randomForest(as.factor(Survived) ~ Pclass+Sex+Age+SibSp+ Parch+ Fare+Embarked+Title ,data=train,
                      importance=TRUE, ntree=4000)
print(model)
summary(model)
#plot(model)
varImpPlot(model)

# Generate predictions for test set.
Survived <- predict(model,newdata=test,type='class')
# Create data frame and save to file
predictions<-data.frame(test$PassengerId, Survived)
names(predictions)<-c("PassengerId", "Survived")
write.csv(predictions, file = "Predictions.csv", row.names=FALSE)
