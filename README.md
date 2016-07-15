# MachineLearning-Titanic
Prediction of passenger survival based on a dataset (Kaggle competition)

This first version of the analysis was performed as a homework assignment for a data science course. I will continue to build improvements before submitting my predictions to the Kaggle competition.

In brief, this competition consists of a data set of the passengers of the Titanic, which includes information like age, sex, and whether the passenger survived or not. The goal is to train an algorithm that can predict whether a passenger survived or not based on the other parameters. To evaluate the model, Kaggle provides another data set where the survival of the passengers is not reported. The metric used for evaluation will be the percentage of correct predictions.

## Analysis approach
First I had to take care of data cleaning. The main problem was missing values in the data. To solve this, I replaced the missing values in each attribute by the mean or mode of that attribute across the entire training dataset. Specifically, I used the mean for numerical attributes and mode for categorical attributes. I ignored the attributes "PassengerId", "Cabin", "Name", and "Ticket" because they seemed unlikely to be relevant and would require additional processing to be used in machine learning.

The attributes which were used in the analysis were "Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked". The first one, “Pclass” is the passenger class on the ship, which is 1, 2, or 3. Sex and Age are self-explanatory. “SibSp” is the total number of siblings and spouses accompanying the passenger. “Parch” is the total number of siblings or children accompanying the passenger. “Fare” is the cost of the trip. Finally, “Embarked” is a letter indicating from which port the passenger embarked (C = Cherbourg; Q = Queenstown; S = Southampton).

After I cleaned the data, I randomly divided the training data into a training set (75%) and a cross validation set (25%). The two algorithms I have tested so far are logistic regression and random forests.

## Initial solution (logistic regression)
My first approach was to try a simple, high bias algorithm, namely logistic regression, before attempting more complicated ones. All the coding work was performed in the R programming language as a learning exercise.

After I trained the algorithm in the data set, I evaluated the model on the validation set to estimate its accuracy on new examples. In addition to this I created a learning curve, where I plotted the accuracy of the model on the training and validation sets as a function of training set size. To create smaller training sets I took random, independent subsets of varying sizes. 

The accuracy in the training and validation sets was 81.0% and 78.8%, respectively,  with a difference of 2.2%. The learning curve showed that the accuracy on both sets was varying very slowly as I got to large subsets of the data. These two facts combined indicate that the model has a high bias. Thus the most promising way to improve the accuracy would be to increase the complexity of the model, either by using more of the passenger attributes or by using an algorithm with lower tendency to bias.

## Revised Solution (random forests)
The low bias algorithm I tried was random forest. With this method the accuracy in the training and validation sets was 92.2% and 80.6%, respectively. The increase in the validation set accuracy is only a small improvement and the difference between them points to over-fitting. The learning curves are flat after using half of the training set, which means that even if I had more training data the improvement would not be significant.
