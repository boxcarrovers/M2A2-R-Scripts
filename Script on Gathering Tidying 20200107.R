View(iris)
library(dplyr,tidyr)

jmiris <-   iris %>%
  gather(part,value,-Species) %>%
  separate(part,c('Part','Measure'))

jmiris2 <-   iris %>%
  gather(part,value,-Species) 
