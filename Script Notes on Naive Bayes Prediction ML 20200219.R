# Script Notes from MEAP Book on ML
# Naive Bayes Modeling & Support Vector Machines
# February 19, 2020
#
#  The Naive Bayes Model is particularly good for categorical predictions, where useful to incorporate
#  existing information. 
#  Datacamp example - given time of day, where am I located?
#  
#  Example in MEAP book is predicting whether congressman is D/R based on voting pattern.

# I. Set Out Key Capabilities,Load & Explore Data -------------------------------


library(mlr)
library(tidyverse)
library(dplyr)
library(plyr)

# a quick google search can tell you that mlbench is the package that contains the dataset - see RDocumentation.Org
library(mlbench)
data(HouseVotes84)
VotesTib <- as_tibble(HouseVotes84)

# some quick investigatory work using map_dlb function to calculate how many yeses/nos/NAs across the dataset
# map_dbl is like sapply over every column of a tibble - applying the function over each column
map_dbl(VotesTib, ~length(which(. == 'y')))
# i have no idea how i would have figured that line of code out
map_dbl(VotesTib, ~sum(is.na(.)))
# my way - which typically has worked is to count out in a table
#jmtable <- table(VotesTib, vars = c('x','y'))

# here i'm just copying some code for a great ggplot that gives a quick visualization
# of how democrats and republicans voted on each issue

# Want to make untidy but then facet against the predictors (R/D)
UntidyVotes <- gather(VotesTib,'Variable','Value',-Class)
ggplot(UntidyVotes, aes(Class,fill = Value)) +
  facet_wrap(~Variable, scales = 'free_y')+
  geom_bar() +
  #  geom_bar(position = 'fill')+  # This makes them all scale to 100%
  theme_bw()  # maybe a little cleaner this way

# so the facet wrap is what repeats the pattern across all the different votes (in this case 'Variable')
# this is really nice....'small multiples'


# II. Train Model Using Naive Bayes Method --------------------------------

# create a task, a learner set and then train the model

votestask <- makeClassifTask(data = VotesTib, target = 'Class')
bayes <- makeLearner("classif.naiveBayes")
bayesModel <- train(bayes,votestask)

# now do cross-validation using kfold
# recall: makeResampleDesc = make resampling description ... have to describe method of resampling...
# the cross validation comes when you've combined the task, the learner, and the method of cross validation
# note also that at this point we are not explicitly using 'bayesmodel' the trained model
kfold <- makeResampleDesc(method = 'RepCV', folds = 10, reps = 10, stratify = TRUE)
bayesCV <- resample(learner = bayes, task = votestask, resampling = kfold,
                    measures = list (mmce,acc,fpr,fnr))

# now do a sample prediction off a 'new' politician
politician <- tibble(V1 = "n", V2 = "n", V3 = "y", V4 = "n", V5 = "n",
                     V6 = "y", V7 = "y", V8 = "y", V9 = "y", V10 = "y",
                     V11 = "n", V12 = "y", V13 = "n", V14 = "n",
                     V15 = "y", V16 = "n")
politpred <- predict(bayesModel, newdata = politician)
# to see response
getPredictionResponse(politpred)


## Ex. 6.2.  'Wrap your naive Bayes Model inside the getLearnerModel() function.  Can you identify
#             the prior probabiliites and likelihoods for each vote?

JMCheck <- getLearnerModel(bayesModel)
JMCheck$tables



# III. Support Vector Machine Algorithms ----------------------------------


