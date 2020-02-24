#Script Notes from MEAP Book on ML
# Logistic Regression
# February 6, 2020

# Exercise/Example
# Build a logistic regression model using the Titanic dataset 
# and predict whether an individual would survive or not. 


# I. Load Titanic Dataset; Configure For Analysis -------------------------

library(mlr)
library(dplyr)
library(titanic)
library(tidyverse)
install.packages('titanic')
data(titanic_train,package = 'titanic')
titanic_tib <- as_tibble(titanic_train)

# Configure
titanic_clean <- titanic_tib %>%
  select(Survived,Pclass,Sex,Age,SibSp,Fare,Parch) %>%
  mutate(Family = SibSp+Parch) %>% 
  mutate(Sex = as.factor(Sex)) %>%
  mutate(Pclass = as.factor(Pclass)) %>%
  mutate(Survived = as.factor(Survived)) %>%
  select(Survived,Pclass,Sex,Age,Fare,Family)

# do a quick scatterplot of survived vs. each of the different variables
pairs(~Survived+Pclass+Family+Sex+Fare, data = titanic_clean, main = 'Simple Scatterplot')
# that didn't work too well because some of the variables are factors and 
# because survival is a binary condition you get a point on 0 and a point on 1, but no 
# idea of how many instances where that occurred.
jmtable <- table(titanic_clean$Survived,titanic_clean$Pclass,titanic_clean$Sex)
# this table pretty much tells you the broad brush strokes ... 
#            FEMALE CLASS
#  Survived   1   2    3
#   0         3   6    72
#   1       91   70    72
#
#              MALE CLASS
#  Survived   1   2    3
#   0         77  91   300
#   1         45  17   47
# women in 1/2 class survived; in 3rd had 50/50 chance; men in 1st class had 50/50 chance
# otherwise died.  model will improve on this greatly, i'm sure....

# so first pass i'm going to throw out the observations where no age is recorded (this is about 170 of 900)
titanic_clean2 <- titanic_clean %>%
  filter(!is.na(Age))


# II. Make First Pass Model with Abridged Data Set ------------------------

# create Task
titanic_task <- makeClassifTask(data= titanic_clean2, target = 'Survived')
Tlogreg <- makeLearner('classif.logreg')
TlogregModel <- train(Tlogreg, titanic_task)
# Do kFold Cross-Validation
kfold <- makeResampleDesc(method = 'RepCV', folds = 10,reps = 5, stratify = TRUE)
TlogregCV <- resample(Tlogreg,titanic_task,resampling = kfold, 
                      measures = list(acc,fpr,fnr))
# this shows about a 79% accuracy rate with a false positive rate of 29%; false negative of 15%
# confusion matrix is below:
#      predicted
# true   0     1
#   0   1802  318
#   1   421   1029
# by this matrix  15% of the time we said someone lived when they really died (318/(1802+318)) = false negative
# (though i would conceptually think of survivals as a positive, so i would be inclined to 
#  deem that a false positive..)
# the false positive rate of 29% = (421/(421+1029)) = in this case refers to how often we predicted someone
# was dead when they really survived (again, i would be inclined to call this a false negative).
# but it depends on how the confusion matrix is setup



# III.  Making Predictions on New Data ------------------------------------
# So the way the logistic regression model works is it builds a series of 
# log coefficient variables for regression.
# then an observation gets scored for all those variables and a probability
# score is calculated.  If that prob score > 0.5 (at least by default)
# then we assume 'survival'.  
# The prob score can be modulated to make the model more rigorous as needed (esp for
# low probability events.)

# below is a seciton of code from the book where some new observations from Titanic
# are modeled.

data(titanic_test, package = 'titanic')
titanicNew <- as_tibble(titanic_test)

# now clean the data to make it conform in shape to the model data developed above

titanicNewClean <- titanicNew %>%
   mutate_at(.vars = c('Sex','Pclass'), .funs = factor) %>%
   mutate(Family = SibSp+Parch) %>%
   select(Pclass,Sex,Age, Fare,Family) %>%
# eliminate observations with no age variable
# because I'm lazy and didn't impute a value
  filter(!is.na(Age))

jmresults <- predict(TlogregModel, newdata = titanicNewClean)
jmeval <- cbind(titanicNewClean,jmresults$data)

# what jmeval shows us is the actual predictions made for each observation.
# and it shows - for instance - that the only men predicted to live were
# first class passengers under the age of about 40
# while all women in 1st and 2nd class survived
# young women in 3rd class generally survived - older did not.
# some variation picked up for family size and fare - which is where the model
# attempted to capture ore subtle vairations.



# IV.  Interpreting The Model; Extracting Coefficients Etc ----------------

# One thing that the above doesn't show, however, is what the actual coefficients are
# and the actual generated raw prob scores (and odds ratios) for specific observations.
# Presumably if you're looking at your model closely, you would want to see what's driving
# it and feel comfortable with its conclusions.  Also, you'd then like to see how it
# performs on solid and edge cases... to get an intuitive feel for whether your model
# is acting properly and if there is a clear opportunity for improvement. 

# To do this, there's a key function called 'getLearnerModel'

TitModelData <- getLearnerModel(TlogregModel)
TitModelCoef <- coef(TitModelData)
# these coefficients represent hte log odds for each of hte primary variables in the model.
# The interecept is the log odds of surviving when everything is set to 0 (or base factor).

# because log odds are hard to read, typically we create the odds ratios by taking their
# exponent.

TitModOdds <- exp(TitModelCoef)
# if odds ratio is <1 then event is less likely to occur.
TitModOdds

# so for instance because Sexmale = 0.07 that means that a man was 1/.07 = 14.3x less
# likely to survive than a woman. 
# For continuous variables, it measures the discrete cahnge of one unit.
# For factor variables, the comparison is with respect to the base/reference factor.
# so Pclass2 = .28 => 3.6 ... means that a person traveling in 2nd class is 3.6x less
# likely to survive than someone in first class (the reference factor).

JMtest <- predict(TlogregModel, newdata = titanicNewClean, type = 'prob')


  