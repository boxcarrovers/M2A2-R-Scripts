# Load the DBI package
library(DBI)

# Connect to the MySQL database: con
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "tweater", 
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
                 port = 3306,
                 user = "student",
                 password = "datacamp")

# Get table names
table_names <- dbListTables(con)

# Import all tables
# note that lapply runs the function dbReadTable across the vector of table_names
# function dbReadTable has following structure:
#     dbReadTable(conn, name, ...)

tables <- lapply(table_names,dbReadTable, conn = con)

# Print out tables
tables
# because it is lapply tables is a list

