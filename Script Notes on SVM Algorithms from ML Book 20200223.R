# Script Notes from MEAP Book on ML
# Support Vector Machines 
# February 23, 2020
#
#  Support Vector Machines Algorithms are good for classification prediction problems.
#  They use several tricks/features to help identify/describe a hyperplane (a line in 2 dim problem)
#  that separates classes of observations.

#  The optimal hyperplane has several attributes:
#      1.  The space between the two  classes is maximized (as measured by the edge observations)
#      2.  If there is no 'pure' hyperplane solution, it finds the optimal case with the least 'cost' (ie transgressing
#          observations.)
#      3.  It can use kernels (think balls under a blanket) to create distortions in the shape but make it easier than to describe
#          'pure' class regions.

#  SVM is not good on categorial variables; is good on continuous ones.  

# I. Set Out Key Capabilities,Load & Explore Data -------------------------------


library(mlr)
library(tidyverse)
library(dplyr)
library(plyr)

# load spam dataset ... last column is called 'type' and is our target vairable, indicating whether spam or not.
data(spam, package = 'kernlab')
spamtib <- as_tibble(spam)
# it appears most of these variables are giving share counts as % of total characters in email on presence of variables
# here is code to get the scoop on descriptions
?kernlab::spam

# II. Define Task, Learner, Model, Hyperparameter Selection ---------------

spamtask <- makeClassifTask(data = spamtib, target = 'type')
SVM <- makeLearner(('classif.svm'))

# many options on choosing hyperparamters.
# In general, most important ones are 
#   i) the kernel
#   ii) the cost
#   iii) the degree
#   iv)  gamma

# here i am dumbly just copying what has been done in the book.  
kernels <- c('polynomials','radial','sigmoid')
svmParamSpace <- makeParamSet(
  makeDiscreteParam('kernel', values = kernels),
  makeIntegerParam('degree', lower = 1, upper = 3),
  makeNumericParam('cost', lower = 0.1, upper = 10),
  makeNumericParam('gamma', lower = 0.1, upper= 10))

# this creates an enormous number of possibilities of the optimal hyperparameter. 
# rather than going through each one explicitly, will do a random search of n possibilities
# then take the best of those and use it.  

randomsearch <- makeTuneControlRandom(maxit = 20)
CVForTuning <- makeResampleDesc('Holdout', split = 2/3)

# again continuing stupidly here... this is about how the program runs through the various
# random permutations. apparently want to make sure that there is some parallel processing going on
# so that this doesn't atke forever....

library(parallelMap)
library(parallel)

parallelStartSocket(cpus = detectCores())
tunedsvmPars <- tuneParams('classif.svm', task = spamtask, resampling = CVForTuning,
                           par.set = svmParamSpace,
                           control = randomsearch)
parallelStop()



# III.  Train the model with the determined hyperparameters ---------------

tunedSvm <- setHyperPars(makeLearner("classif.svm"),
                         par.vals = tunedsvmPars$x)
tunedSvmModel <- train(tunedSvm, spamtask)

  