# This is a quick sanity check on the case study
# i had for my interview with CarMax.

# 100 paintings.  Can see only once and appraise.  What is your rstrategy to get the best one?
# My answer:
#    Take a read on the first 10. Calculate Mean and Std Dev.  As soon as I hit 2 SD above, buy.
#    If nothing in 1st 10, recalibrate at 20.
#    Objective is to get in top 90-95%.

# First try with a normal distribution

c <- rnorm(1:100)
first10 <- c[1:10]
first10mean <- mean (first10)
first10sd <- sd(first10)
threshold <- first10mean + 2*first10sd


library(dplyr)
csort <- as_tibble(cbind(c,c(1:100)))
csort <- arrange(csort,c)


portrait <- 0

i <- 11
while (c[i] < threshold & i<101) 
  {
  i <- i+1
  }
portrait <- c[i]
print(i)
print(portrait)
match(portrait,csort$c)
#
# determine what rank my result is...


# Some Quick Takeaways
# 1. My approach seems to be pretty good for a normal distribution.  Most times doing 2 SDs got me in the top 5%.
# 2. I did not do a reset at 20th piece, but that would be a good idea.
# 3. The approach does not work well for uniform distribution.  So a revision to the theory is appropriate.
# 4. The art market probably doesn't have a normal distribution ....first - nothing negative, 2nd value is 
#    highly skewed to the extreme end.  HOwever, that doesn't mean that you can't make an ifnerence on a given
#    collection.  

