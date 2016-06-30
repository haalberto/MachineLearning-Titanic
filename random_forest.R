# This script performs logistic regression on the training set and uses the validation set to evaluate
# the performance of the model.

# Open training and validation data.
train<-read.csv("train_v1.csv", na.strings = c(""))
validate<-read.csv("validate_v1.csv", na.strings = c(""))

# Convert age to numeric
train$Age<-as.numeric(train$Age)
validate$Age<-as.numeric(validate$Age)

# Convert Pclass to factor
train$Pclass<-as.factor(train$Pclass)
validate$Pclass<-as.factor(validate$Pclass)

# Random forest
library(randomForest)
# Train model
model <- randomForest(as.factor(Survived) ~ Pclass+Sex+Age+SibSp+ Parch+ Fare+Embarked ,data=train,
                      importance=TRUE, nTree=2000)
summary(model)
varImpPlot(model)
# Test model
# On the training set
predictions_train <- predict(model,newdata=train,type="class")
Error_train <- mean(predictions_train != train$Survived)
print(paste('Accuracy (training set):',1-Error_train))
# On the validation set
predictions_validation <- predict(model,newdata=validate,type='class')
Error_validate <- mean(predictions_validation != validate$Survived)
print(paste('Accuracy (validation set):',1-Error_validate))

# Create learning curves
Npoints<-20L
train_acc<-rep(0,Npoints)
val_acc<-train_acc
trainlength<-length(train[[1]])
Training_set_size<-ceiling((1:Npoints)/Npoints*trainlength)
for (x in 1:Npoints) {
    sampleIndex<-sample(1:trainlength, Training_set_size[x])
    trainsub<-train[sampleIndex, ]
    model <- randomForest(as.factor(Survived) ~ Pclass+Sex+Age+SibSp+ Parch+ Fare+Embarked ,
                          data=trainsub, importance=TRUE, nTree=2000)
    predictions_train <- predict(model,newdata=trainsub,type='class')
    train_acc[x] <- mean(predictions_train == trainsub$Survived)
    predictions_validation <- predict(model,newdata=validate,type='class')
    val_acc[x] <- mean(predictions_validation == validate$Survived)
}

# Reshape information as data frame
learning<-data.frame(append(Training_set_size,Training_set_size),
                     append(train_acc,val_acc),
                     append(rep("Training set", Npoints),rep("Validation set", Npoints)))
names(learning) <- c("Training.set.size", "Accuracy", "Set.type")
# Plot learning curves
library(ggplot2)
ggplot(learning, aes(x=Training.set.size, y=Accuracy)) + geom_point(aes(color=Set.type, shape=Set.type), size=3)
#ggplot(learning, aes(Training_set_size))+geom_point(y=train_acc, color = "blue")+geom_point(y=val_acc, color = "red")

# Further analysis of results
# Here I try to find out what kind of passengers the algorithm fails to predict correcttly.

# Find wrongly predicted passengers on the validation set.
wrongpreds<-predictions_validation == validate$Survived

# plot Survival versus Age for this set
ggplot(validate[wrongpreds, ], aes(x=Age, y=Survived)) +
    geom_point(aes(color=Survived, shape=as.factor(Survived)), size=2.5, position = position_jitter(w = 0, h = 0.7))

# plot Survival versus Sex for this set
ggplot(validate[wrongpreds, ], aes(x=Sex, y=Survived)) +
    geom_point(aes(color=Survived, shape=as.factor(Survived)), size=2.5, position = position_jitter(w = 0, h = 0.7))

# plot Survival versus Pclass for this set
ggplot(validate[wrongpreds, ], aes(x=Pclass, y=Survived)) +
    geom_point(aes(color=Survived, shape=as.factor(Survived)), size=2.5, position = position_jitter(w = 0, h = 0.7))

# plot Sex versus Pclass
ggplot(validate[wrongpreds, ], aes(x=Pclass, y=Sex)) +
    geom_point(aes(color=Survived, shape=as.factor(Survived)), size=2.5, position = position_jitter(w = 0.3, h = 0.7))

# plot Sex versus Embarked
ggplot(validate[wrongpreds, ], aes(x=Embarked, y=Sex)) +
    geom_point(aes(color=Survived, shape=as.factor(Survived)), size=2.5, position = position_jitter(w = 0.3, h = 0.7))
