#Notes from MEAP Machine Learning in R Book
# January 29, 2020

#I. Tidyverse Stuff

library(tidyverse)

# tibbles are better than dataframes. clearly list variable types in headings. also
# allow you to create variables on the fly.

seqTib <- tibble(nitems = c(12,40,105), cost = c(0.5,1.2,1.8), totalworth = nitems*cost)
seqTib

data(mtcars)
# Note - the following syntax below is WRONG.  It yields a tibble of 32 rows and 1 column 
mytib <- tibble(mtcars)
summary(mytib)
# This is the correct syntax.
jmtib <- as_tibble(mtcars)
summary(jmtib)

# Using dplyr
data(CO2)
CO2Tib <- as_tibble(CO2)
filtco2 <- filter(CO2Tib, uptake > 16)
# use group_by to help more easily summarize the data
groupCO2 <- group_by(filtco2, Plant)
summaryco2 <- summarize(groupCO2, meanup = mean(uptake), sdup = sd(uptake))

# Using Piping Notation
arrangedData <- CO2tib %>%
  select(c(1:3, 5)) %>%
  filter(uptake > 16) %>%
  group_by(Plant) %>%
  summarize(meanUp = mean(uptake), sdUp = sd(uptake)) %>%
  # these are a few extra steps taken in the book
  mutate(CV = (sdUp / meanUp) * 100) %>%
  arrange(CV)


# subset of mtcars using select
jmtibred <- select(jmtib, -qsec,-vs)
mtcarfilt <- filter(jmtibred, cyl != 8)


# quick assignment: group mtcaras by gear; summarize medians of mpg and disp, mutate a new var
# which is mpg median/disp median ... using piping technique

jm_mtcars <- as_tibble(mtcars) %>%
  group_by (gear) %>%
  summarize(med_mpg = median(mpg), med_disp = median(disp)) %>%
  mutate(new_med = (med_mpg/med_disp))

jm_mtcars

# onto section 2.5 with ggplot
# note - a quick commentary on the iris dataset....
#    petal measurements are of the petal/flowery part of the flower
#    sepal is the green section of the flower that makes up the outside of the bud
#       it also sits with/underneath the petal when the flower is in bloom

library(ggplot2)

data(iris)
jmplot <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) + 
  geom_point() + 
  theme_bw()

# grammar of graphics, aesthetic.  think layers. 
# first line says what to plot
# 2nd line says how to plot (geom_point) ... many options here
# 3rd line presents the theme in terms of color

# now add in add'l layers

jmplot2 <- jmplot + geom_density_2d() +
  geom_smooth()

# this adds density contours and a fitted line through the points

jmplot2

# now can add color based on type of iris

jmplot3 <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width,col = Species)) + 
  geom_point() + 
  theme_bw() +
  geom_smooth()

jmplot3

# on facets... an easy way to create small multiples/side-by-side views of the data set based on 
# a given characteristic or attribute.
# so this would particularly be helpful in an initial data exploration ... may come in handy obviously
# later as well. 

jmplotfacet <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width,col = Species)) + 
  facet_wrap(~ Species) +
  geom_point() + 
  theme_bw()

jmplotfacet

## EXERCISE
## create a scatterplot of DRAT and WT variables in MTCARS.  Color by CARB. 
##     see what happnes when you wrap the carb aesthetic mapping in  AS.FACTOR()

mtcars

# create as tibble

mtcarstib <- as_tibble(mtcars)

mtcarplot <- ggplot(mtcarstib, aes(x = drat, y = wt, col = carb)) +
    geom_point()
    
mtcarplot

# compare difference in color when carb is set as a factor
mtcarplot2 <- ggplot(mtcarstib, aes(x = drat, y = wt, col = as.factor(carb))) +
  geom_point()
mtcarplot2
# all this does is make a sharper contrast in colors.  when col = carb, everything is on a 
# blue black gradient.
# when set as factors, get more of a rainbow presentation of colors


#I.B.  TidyR - tidying up datasets examples
  
library(tibble)
library(tidyr)

patdata <- tibble(Patient = c('A','B','C'),
                  Month0 = c(21,17,29),
                  Month3 = c(20,21,27),
                  Month6 = c(21,22,23))

# so this dataset is not tidy because we have 3 observations per row, not one
# to take a dataset that is wide and make it long - to reduce to one observation per row
# need to 'gather' up the wide observations
# key = name of new variable we are gathering
pattidy <- gather(patdata,key = 'Month', value = "BMI", Month0:Month6)
# note this could also be done as 
#   gather(patdata, key = 'Month', value = 'BMI', - Patient)
#   since hte only thing we are not gathering and lumping into the new columns is the patient info

# to go the opposite way, from long to wide, use the spread function

# Ex 2.6  gather the vs, am, gear, and carb variables from mtcars into a single key-value pair

mtcars_tib <- as_tibble(mtcars)

mtcars_gat <- gather(mtcars_tib, key = 'Eng_Type', value = 'Specs',c('vs','am','gear','carb'))
# book answer
mtcars_gat2 <- gather(mtcars_tib, key = 'variable', value = 'variable', c(vs,am,gear,carb))


# PURRR

# a pure function is one which only returns a value and does not change the environment in any other way
# if a function changes a value or introduces a plot then it has changed the environment
# PURR basically is the apply functions in use with a cleaner syntax and format...

# map is the equivalent of lapply - runs a function over a list and returns a list as output
# map_dbl()  returns a vector of doubles (decimals)
# map_chr()  returns a character vector .... map_lgl() logical, map_int() integer, etc.

# Ex. 2.7.  use a function from the purrr package to return a locical vector indicating whether the 
#           sum of values in each columns of the mtcars data is greater than 1000

library(purrr)

jmdat <- map_dbl (mtcars_tib,sum)

# the . can be used to represent the element that map is currently iterating over
map_lgl(map(mtcars_tib,sum),function(.) .>1000)
# below is equivalent and generally considered to be better syntax where tilde is equiv to function
map_lgl(map(mtcars_tib,sum),~ .>1000)

# i am proud of myself.  need to create/make an anonymous function call within the map statement.
# book answer is below
map_lgl(mtcars, function(.) sum(.)>1000)
map_lgl(mtcars, ~ sum(.)>1000)


# ITERATING OVER MULTIPLE DATASETS SIMULTANEOUSLY

# map2 command can allow for this to run through a lot of combinations/scenarios quickly
listOfNumerics <- list(a = rnorm(5),
                       b = rnorm(9),
                       c = rnorm(10))
multipliers <- list (0.5,10,3)
map2(.x = listOfNumerics, .y = multipliers, ~.x*.y)
#  The execution of the above line of code now will create a new list where
# a is multipleid by .5, b by 10, and c by 3.

multipliers <- list (0.5)
map2(.x = listOfNumerics, .y = multipliers, ~.x*.y)
# here R just iterates the .5 over the entire list of numerics.

multipliers <- list (0.5, 2, 4, 6, 10, 1)
map2(.x = listOfNumerics, .y = multipliers, ~.x*.y)
# this fails because of wrong length


# II. KNN K Nearest Neighbors ---------------------------------------------

install.packages('mlr', dependencies = TRUE)
library(mlr)
library(tidyverse)

# book uses the diabetes dataset in building the model.

data(diabetes, package = 'mclust')
diabtib <- as_tibble(diabetes)
# dataset has about 150 rows .. classifications are either normal/chemical/overt
# variables measured include glucose, insulin, and sspg (stead state blood glucose)

# the book then shows three plots (each variable measured against one other)
# here is example of one and exercise 3.1


ggplot(diabtib, aes(glucose, insulin, shape = class, col = class)) +
  geom_point()  +
  theme_bw()

# the plot shows that higher levels of glucose (>125) & insulin (>750) exlcusively map
# to Overt Diabetes
# and that chemical diabetes shows consistently elevated insulin levels compared to normal

# NOte this is simple because all observational data (besides class) is numeric rather than
# categorical in nature.

# The k-NN model in R automatically normalizes the observations (sets to Z with SD)


# Nomenclature and process here looks a little different than what I did in datacamp.
# Process:
#  1. Define the task.  (In this case, classify the data)
#  2. Define the learner.  (State class of problem, type of algorithm to use.) 
#  3. Train the model.  Pass the task to the learner and let the learner generate a model
#     to make future predictions.




# First step is to define the TASK.
# In this case, it is to use the DATA (glu/ins/sspg) to predict the TARGET 
#  (class of diabetic)
# Note we are using ML here because the target is a categorical variable, not a number.
# If it were a number we would use regression.

diabTask <- makeClassifTask(data = diabtib, target = 'class')
diabLearn <- makeLearner('classif.knn',par.vals = list('k' = 2))

# note to see all the MLR algorithms we can feed in use the following code:
listLearners()$class
# this did not work for me... go back and check another time.

# MODEL = LEARNER + TASK
diabModel <- train(diabLearn,diabTask)
diabPredict <- predict(diabModel, newdata = diabtib)

# evaluate performance
performance(diabPredict,measures = list(mmce,acc))


# obviously, one issue here is we used the entire dataset to build the model.
# which then means we have no good idea of how well it will predict when new data
# shows up....


# Ways to cross-validate a model:
# 1. Hold-out  
# 2. k-fold
# 3.leave-one-out cross validation

# Holdout is most familiar concept where you split data between a training set and a
# test set.  Often 2/3 1/3 split is used. 
# It is generally seens as inferior to k-fold, but is computationally less expensive/time
# consuming to run. 

# TERMINOLOGY:  makeResampleDesc --> Resampling Description = method for splitting data into training and
#               test sets (training = what model is built on; test = what you use for cross-validation)

holdout <- makeResampleDesc(method = 'Holdout', split = 2/3, stratify = TRUE)
# note that stratify takes into account the degree of variation in the dataset
# so that if incidence of different classes is LOW you have a good chance of maintaining
# that proportion in your train/test sets. Otherwise, could lose a lot of predictive
# power.  Matters less when different classes are fairly common.  

holdoutCV <- resample(learner = diabLearn, task = diabTask, resampling = holdout,
                      measures = list(mmce,acc))
# calculate confusion matrix on this
calculateConfusionMatrix(holdoutCV$pred, relative = TRUE)

holdout2 <- makeResampleDesc(method = 'Holdout', split = 5/10, stratify = FALSE)
holdoutCV2 <- resample(learner = diabLearn, task = diabTask, resampling = holdout2,
                      measures = list(mmce,acc))
calculateConfusionMatrix(holdoutCV2$pred, relative = TRUE)

# a quick aside on taking a look at the actual test results - the input to 
# the confusion matrix and showing for each observation truth vs. response ..... being the geek that I am....
seethedata <- holdoutCV[['pred']]['data']



# K-Fold Cross-Validation
# Repeated K-Fold is preferred. so for example do a 10-fold cross validation
# with 5 repeats.  then estimate model performance based on the average of the 50
# runs. Note - because each model is arrived at a little differently because of the diff
# inputs 

# i actually am not sure how repeating the same folds will yield a different answer....

kFold <- makeResampleDesc(method = 'RepCV', folds = 10, reps = 50, stratify = TRUE)
# repCV = repeated cross-validation
kFoldDiab <- resample(learner = diabLearn, task = diabTask, resampling = kFold,
                      measures = list(mmce,acc))



# JM Deep Dive on kFoldand Repeated kFold ------------------------------------------------------

# I understand why kfold validation would be better than holdout.  You should be reducing variance
# because of sampling/overfitting error because you are running more tests.
# Each iteration uses a slightly different training set of data (so slight change to model parameters).
# And then because each test set is unique, it will have its own accuracy scores/ confusion matrix etc.

# So the first thing I want to take a look at is what do the test reuslts look like when there's NO
# repeating and we just go through the entire dataset once. 
# so if you do CrossValidate (no refold) you pretty much have to go with 10 folds. Here's the code:

KF5NoRepeat <- makeResampleDesc(method = 'CV', stratify = TRUE)
KF5NRCV <- resample(learner = diabLearn, task = diabTask, resampling = KF5NoRepeat,
                    measures = list(mmce,acc))
KF5Data <- as.data.frame(KF5NRCV[['pred']]['data'])
KF5Conf <- calculateConfusionMatrix(KF5NRCV$pred)
# in reviewing this, every record is used in the test and fold is identified by its 'data.iteration'.
# the accuracy of this ended up being 93%. (13 errors across 145 obs. - w most being overts misclassed as
# chems)

# Now I will do with 2 repeats.
KF5Repeat2x <- makeResampleDesc(method = 'RepCV', folds = 10, reps = 2, stratify = TRUE)
KF5Rep2CV <- resample(learner = diabLearn, task = diabTask, resampling = KF5Repeat2x,
                    measures = list(mmce,acc))
KF5Rep2Data <- as.data.frame(KF5Rep2CV[['pred']]['data'])
KF5Rep2Conf <- calculateConfusionMatrix(KF5Rep2CV$pred)

# so, a few thoughts:
#  1.  accuracy in this case dropped to 88%.  (35 errors across 290 obsv) - same kind of nature of misses
#  1.a.  There is random sampling going on as to blocks each time. so 2nd run of this got acc = 90% (28 err)
#  2.  it's clear that in the repeated cv that the first pass starts the tranches on first observation (obs
#      1-15 = block 1, 16-30 = block 2 etc for the first 10 fold... and i'm guessing that then the next time
#      around it starts with obs 2-16 -- or something similar.
#  3.  This is not exactly how it oges because the stratify = TRUE. so somehow R makes an adjustemnt.
#      And even with a pass where i made stratify = FALSE it's not so clean how R picks the test packets.





# Ex 3.3
# Define two new resampling descriptions ... one that performs 3-fold cross validation repeated 5x
# and one that performs 3-fold x valid repeated 500x.  Use resample() to cross... repeat the
# resample 5x for ea method and see which one gives more stable results.

kfoldshort <- makeResampleDesc(method = 'RepCV', folds = 3, reps = 5, stratify = TRUE)
kfoldlong <- makeResampleDesc(method = 'RepCV', folds = 3, reps = 500, stratify = TRUE)
# repCV = repeated cross-validation
kFoldDiabShort <- resample(learner = diabLearn, task = diabTask, resampling = kfoldshort,
                      measures = list(mmce,acc))
kFoldDiabLong <- resample(learner = diabLearn, task = diabTask, resampling = kfoldlong,
                           measures = list(mmce,acc))
# compare the confusion matrices
calculateConfusionMatrix(kFoldDiabShort$pred, relative = TRUE)
calculateConfusionMatrix(kFoldDiabLong$pred, relative = TRUE)


## Leave-one-out cross-validation
# in this case, training set = n-1 observations and test set = 1 observation
# rerun over the entire n observations
LOO <- makeResampleDesc(method = 'LOO')
DiabLOO <- resample(learner = diabLearn, task = diabTask, resampling = LOO,
                    measures = list(mmce,acc))
calculateConfusionMatrix(DiabLOO$pred, relative = TRUE)

# Note: if you are happy enough with the cross-validation of your model, you would then actually
# go take the full data set and build the model wehn building out for future predictions.


# II.B.  Optimizing K -----------------------------------------------------

# this goes through a methodology for finding hte best k.
# essentially picking several, running the knn model across each k and evaluating
# its effectiveness through cross-validation scores.
# then map this in with a 'grid search' to see what yields best results.
# presumably really low ks have greater likelihood of incorporating noise and overfitting
# (e.g. at k=1 mapping to the thing next to your observation implies a pattern that doesn't
#  exist; at k = n, you will essentially get the average of all observations and underfit. )

knnParamSpace <- makeParamSet(makeDiscreteParam ('k', values = 1:10))
gridSearch <- makeTuneControlGrid()
crossvaltune <- makeResampleDesc('RepCV', folds=  10, reps = 20)
tunedDiab <- tuneParams('classif.knn', task = diabTask, resampling = crossvaltune,
                        par.set = knnParamSpace, control = gridSearch)
# this gives a k of 7 in this example as being optimal  (lowest mmce)

knnTunedResults <- generateHyperParsEffectData(tunedDiab)
plotHyperParsEffect(knnTunedResults, x = "k", y = "mmce.test.mean",
                    plot.type = "line") +
  theme_bw()

# so a model with k = 7 is optimal.

diabLearnTuned <- makeLearner('classif.knn',par.vals = list('k' = 7))
# next line is old code, unchanged.
diabTask <- makeClassifTask(data = diabtib, target = 'class')
# MODEL = LEARNER + TASK
diabModelTuned <- train(diabLearnTuned,diabTask)
diabPredictTuned <- predict(diabModelTuned, newdata = diabtib)

# THERE IS A SECTION THAT FOLLOWS (APPROX PG. 83-87 IN BOOK) WHERE IT TOOKS ABOUT
# INNER AND OUTER WRAPPING AS PART OF MODEL VALIDATION.  I DON"T UNDERSTAND THIS
# NEED TO REVISIT.  "NESTED CROSS VALIDATION"


# FINAL EXERCISES INVOLVE BUILDING A KNN MODEL OFF THE IRIS DATASET.
# 3.5 = build a k-NN model to classify the three species of iris (including tuning
#     the k hyperparameter)

library(tidyr)
library(dplyr)
library(mlr)
iris_tib <- as_tibble(iris)
# create the task
iristask <- makeClassifTask(data = iris_tib, target = 'Species')
irislearn <- makeLearner('classif.knn', par.vals = list('k' = 10))
# start with a simple holdout approach and k = 5  - not too big, not too small
irismodel <- train(irislearn, iristask)
holdoutiris <- makeResampleDesc(method = 'Holdout', split = 6/10, stratify = TRUE)
holdoutiriscv <- resample(learner = irislearn, task = iristask,
                          resampling = holdoutiris, measures = list(mmce,acc))
calculateConfusionMatrix(holdoutiriscv$pred, relative = TRUE)                    

# so generally we are getting about 95% right (1-3 errors off 50-60 test observations)

# so first next step is to determine what might be the best value of K
# and then the next step will be to use cross validation on that 

choosingK <- makeParamSet(makeDiscreteParam('k', values = 1:20))
gridSearch <- makeTuneControlGrid()
xvaltune <- makeResampleDesc('Holdout', split = 6/10, stratify = TRUE)
tuneKforiris <- tuneParams('classif.knn', task = iristask,
                           resampling = xvaltune, par.set = choosingK,
                             control = gridSearch)
tuneKforirisdata <- generateHyperParsEffectData(tuneKforiris)
plotHyperParsEffect(tuneKforirisdata, x = 'k', y= 'mmce.test.mean', 
                    plot.type = 'line') +
  theme_bw()

# The answers definitely vary as i move the split and run several times.
# however, most of the time  <6<k<12 and the accuracy is >95% - periodically nailing 100%
# all 40-60 test examples.

# calculate a confusion matrix at k = 10
# so need to go back to irislearn and adjust the value of k there...
jmtest <- resample(learner = irislearn, task = iristask, resampling = xvaltune,
                   measures = list(mmce,acc))
calculateConfusionMatrix(jmtest$pred, relative = TRUE)


# Now I want to do a build a kNN model on iris but use k-fold cross-validation
# below is code for a 10 fold, no repeats.
kfoldiris <- makeResampleDesc(method = 'CV', stratify = TRUE)
# now will tuneK again but with this sampling method
tuneKiris2 <- tuneParams('classif.knn', task = iristask, 
                         resampling = kfoldiris, par.set = choosingK,
                         control = gridSearch)
# this typically is yielding results of 14<k<18
# so higher
calculateConfusionMatrix(tuneKiris2$pred, relative = TRUE) 




newPatients <- tibble(glucose = c(82,108,300), insulin = c(361,288,1052),
                      sspg = c(200,186,135))
newPatientsPred <- predict(diabModelTuned, newdata = newPatients)
getPredictionResponse(newPatientsPred)

