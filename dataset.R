# Load necessary libraries
# The 'readxl' library is used to read Excel files, and 'dplyr' is used for data manipulation.
library(readxl)
library(dplyr)

# Load the data from the Excel file
# Specify the file path of the Excel file containing the data. In this case, the file is named "Junior Data Analyst _ Data.xlsx".
file_path <- "Junior Data Analyst _ Data.xlsx"
data <- read_excel(file_path, sheet = "Raw Data")

# Fix the header issue as the actual headers are in the second row
# Set the column names to the values in the second row of the data.
col_names <- data[2, ]  # Assuming the second row contains the column names
data <- data[-c(1, 2), ]  # Remove the first two rows which are not actual data
names(data) <- col_names

# Convert data to a data frame and change column types if necessary
# Convert the 'data' object to a data frame, and change the column types to numeric if they are character type.
data <- as.data.frame(data)
data <- mutate(data, across(where(is.character), as.numeric))

# View the first few rows of the dataset
# Display the first few rows of the 'data' data frame to check if the data has been loaded and processed correctly.
head(data)
