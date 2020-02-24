#I.A. LINEAR REGRESSION - NOT CLASSIFICATION MODEL
# syntax for simple linear model 
lm (temperature ~ chirps_sec, data = cricket)
# for all available variables
lm (temperature ~ ., data = cricket)

# ways to get better information than summary when looking at hte output of an LM model

glance(unemployment_model)
wrapFTest(unemployment_model)

JimLM <- lm(mpg~., data = mtcars)
library(broom)
glance(JimLM)
library(sigr)

wrapFTest(JimLM)
