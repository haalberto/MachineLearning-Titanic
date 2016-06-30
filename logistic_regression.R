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

# Convert categorical data to dummy variables.
# Pclass and Embarked both have 3 possible values.
contrasts(train$Pclass) = contr.sum(3)
contrasts(validate$Pclass) = contr.sum(3)
contrasts(train$Embarked) = contr.sum(3)
contrasts(validate$Embarked) = contr.sum(3)
# Sex has two values: "female" and "male", which correspond to levels 1 and 2.
# Change levels to 0 and 1.
train$Sex<-as.integer(train$Sex)-1
validate$Sex<-as.integer(validate$Sex)-1

# Logistic regression
# Train model
model <- glm(Survived ~.,family=binomial(link='logit'),data=train)
summary(model)
# Test model
# On the training set
predictions_train <- predict(model,newdata=train,type='response')
predictions_train <- ifelse(predictions_train  > 0.5,1,0)
Error_train <- mean(predictions_train != train$Survived)
print(paste('Accuracy (training set):',1-Error_train))
# On the validation set
predictions_validation <- predict(model,newdata=validate,type='response')
predictions_validation <- ifelse(predictions_validation  > 0.5,1,0)
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
    model <- glm(Survived ~.,family=binomial(link='logit'),data=trainsub)
    predictions_train <- predict(model,newdata=trainsub,type='response')
    predictions_train <- ifelse(predictions_train  > 0.5,1,0)
    train_acc[x] <- mean(predictions_train == trainsub$Survived)
    predictions_validation <- predict(model,newdata=validate,type='response')
    predictions_validation <- ifelse(predictions_validation  > 0.5,1,0)
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
