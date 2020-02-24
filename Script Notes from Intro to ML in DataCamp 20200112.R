# Jim's Notes from DataCamp Intro to ML Class

# January 9 2020

# I. BUILDING A DECISION TREE
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




# II.  Notes from an LM Model
# world_bank_train and cgdp_afg is available for you to work with

# Plot urb_pop as function of cgdp
# this is a simple scatterlot with x = cgdp, y = urb_pop)
plot(world_bank_train$cgdp,world_bank_train$urb_pop)

# Set up a linear model between the two variables: lm_wb
# note syntax lm (y ~ x, data_set)
lm_wb <- lm(urb_pop~cgdp,world_bank_train)

# Add a red regression line to your scatter plot
# i don't know what abline means or why one just picks the coefficients here - 
#  abline adds a straight line to a plot, based on the coefficients fed to it. 
abline(lm_wb$coefficients, col= 'red')

# Summarize lm_wb and select R-squared
# this is kind of an unusual syntax....
summary(lm_wb)$r.squared

# Predict the urban population of afghanistan based on cgdp_afg
predict(lm_wb, cgdp_afg)

#II. BUILDING A K-MEANS CLUSTER
# This Next Section Shows How to Build a K-Means Cluster 
# This uses the seeds dataset (which has 3 different seed types)
# Exercise shows how close one can come just by using a clustering algorithm to 
# predict/group appropriately....

# I went and grabbed the dataset and stored it in my data and analytics folder.
# I also went and manually added the column names based on the DC exercises.
setwd('~/Data and Analytics')
seeds <- read.delim('seeds_dataset.txt', header = FALSE)
colnames(seeds) <- c('area','perimeter','compactness','length','width',
                     'asymmetry','groove_length','type')


# Set random seed. Don't remove this line.
set.seed(100)

# Do k-means clustering with three clusters, repeat 20 times: seeds_km
seeds_km <- kmeans(seeds,3,nstart = 20)

# Print out seeds_km
seeds_km

# Compare clusters with actual seed types. Set k-means clusters as rows
table(seeds_km$cluster,seeds$type)

# Plot the length as function of width. Color by cluster

plot(seeds$width, seeds$length, xlab = "Length", ylab = "Width", col = seeds_km$cluster)
# plot shows how well the clustering worked at separating the seeds based on length & width
# the table shows that clustering actually did very well in matching up to true labels
# e.g. 1st cluster had 70 of 75 observations in 1 seed type; 
#      2nd cluster had 60 of 61
#  and 3rd cluster had 63 of 73.


