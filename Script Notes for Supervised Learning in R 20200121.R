# These are my notes on supervised learning in R - classification
# A Datacamp Class
# January 21, 2020


# I. Background
# note - syntax on how subset works. 
# some of the examples do not use dplyr and use of select. 
mtcars_sub <- subset(mtcars, mtcars$gear ==4)

# using dplyr i think the following would yiedl the same reuslts
library(dplyr)
mtcars_dpl <- mtcars %>%
    filter(gear == 4)

# to check
all(mtcars_sub == mtcars_dpl)
# since this is TRUE, the datasets are identical. They may have different titles or headings, but 
# the internal data is the same. 


# II.  Naive Bayes - calculating incrementality - incorporating information to make a better forecast
library(naivebayes)

#Note: course datasets are not typically available for download...




# III.  Logistic Regression

# syntax to set a regression model to be a binary logistic regression model
# model <- glm(y ~ x1 + x2+ x3, data = my_dataset, family = 'binomial')
# prob sets the probabilty across the range of test data
# SY:  prob <- predict(model, test_data, type = 'response')
# but then to convert back to a specific outcome for an observation need to translate back to a  0 or 1
# e.g. SY:  ifelse (prob >0.5, 1,0)
# note if you want to be more/less aggressive with your model you can adjust your prob score off of 0.5

# ROC curves are used to indicate how much the model is doing better than chance given the natural probability
# of event occurrence in the dataset
# a model that does not better is graphed as a line with a 45 deg angle. So integral of ROC from 0-1 = 0.5.
# a perfect model would have area under curve of 1; your milesage may vary.  
# The integral measure is called AUC (Area Under Curve)
library(pROC)



# IV. DECISION TREES

library(rpart)
model <- rpart(outcome ~ loan_amount + credit_score, data  = loans, method = 'class')

