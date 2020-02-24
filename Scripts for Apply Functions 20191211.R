# Notes on the use of apply family of functions
# From DataCamp
# Dec 2019


# Code from previous exercise:
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)
# lapply applies the function 'tolower' across all the elements of 'split'



# Write function select_first()
select_first <- function(x) {
  x[1]
}

# Apply select_first() over split_low: names
names <- lapply(split_low,select_first)

# Write function select_second()
select_second <- function(x) {
  x[2]
}