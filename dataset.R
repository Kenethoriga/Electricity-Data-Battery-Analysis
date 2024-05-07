# Load necessary libraries
library(readxl)
library(dplyr)

# Load the data from the Excel file
file_path <- "Junior Data Analyst _ Data.xlsx"
data <- read_excel(file_path, sheet = "Raw Data")

# Fix the header issue as the actual headers are in the second row
col_names <- data[2, ]  # Assuming the second row contains the column names
data <- data[-c(1, 2), ]  # Remove the first two rows which are not actual data
names(data) <- col_names

# Convert data to a data frame and change column types if necessary
data <- as.data.frame(data)
data <- mutate(data, across(where(is.character), as.numeric))

# View the first few rows of the dataset
head(data)