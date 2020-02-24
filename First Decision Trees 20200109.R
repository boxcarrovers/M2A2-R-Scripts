# Jim's Notes on How to Build A Decision Tree
# Machine Learning / Classification Problem
# January 9 2020

# This example is from datacamp and uses the titanic dataset
titanic <- datasets::Titanic
# note - this will not work as is as the titanic dataset here is different than the one used
# by datacamp.. datacamp has the full 714 records...

set.seed(1)
library(rpart,rattle,rpart.plot)
library(RColorBrewer)

# installed above packages; am having toruble with RColorBrewer...

# line of code below asks for prediction of survived using all variables (.) with 
# method of class since this is a classification problem

tree <- rpart(Survived ~ ., train, method = 'class')
s

# Notes from an LM Model
# world_bank_train and cgdp_afg is available for you to work with

# Plot urb_pop as function of cgdp
# this is a simple scatterlot with x = cgdp, y = urb_pop)
plot(world_bank_train$cgdp,world_bank_train$urb_pop)

# Set up a linear model between the two variables: lm_wb
# note syntax lm (y ~ x, data_set)
lm_wb <- lm(urb_pop~cgdp,world_bank_train)

# Add a red regression line to your scatter plot
# i don't know what abline means or why one just picks the coefficients here - 
# presumably abline is a graph of a line based on the coefficients fed to it. 
abline(lm_wb$coefficients, col= 'red')

# Summarize lm_wb and select R-squared
# this is kind of an unusual syntax....
summary(lm_wb)$r.squared

# Predict the urban population of afghanistan based on cgdp_afg
predict(lm_wb, cgdp_afg)
