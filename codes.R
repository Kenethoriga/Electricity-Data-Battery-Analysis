# Load necessary libraries
library(readxl)
library(dplyr)
library(ggplot2)

# Load the data from the Excel file
file_path <- "Junior Data Analyst _ Data.xlsx"
data <- read_excel(file_path, sheet = "Raw Data", skip = 1)

# Fix the header issue as the actual headers are in the second row
col_names <- data[1, ]  # Assuming the first row contains the column names
data <- data[-1, ]  # Remove the first row which is not actual data
names(data) <- col_names

# Convert data to a data frame and change column types if necessary
data <- as.data.frame(data)
data <- mutate(data, across(where(is.character), as.numeric))

# View the first few rows of the dataset
print(head(data))

# Check for missing values in the dataset
colSums(is.na(data))

# Summary statistics to help identify outliers
summary(data)

# Plotting the average solar electricity generation and average electricity usage for each hour
avg_data <- data %>%
  group_by(Hour) %>%
  summarise(Avg_Solar_Generation = mean(`Solar electricity generation (kWh)`, na.rm = TRUE),
            Avg_Electricity_Usage = mean(`Electricity usage (kWh)`, na.rm = TRUE))

# Create the plot
ggplot(avg_data, aes(x = Hour)) +
  geom_line(aes(y = Avg_Solar_Generation, colour = "Solar Generation"), size = 1) +
  geom_line(aes(y = Avg_Electricity_Usage, colour = "Electricity Usage"), size = 1) +
  labs(title = "Average Solar Generation and Electricity Usage by Hour",
       x = "Hour of the Day",
       y = "Average kWh") +
  theme_minimal() +
  scale_colour_manual(values = c("Solar Generation" = "blue", "Electricity Usage" = "red"))

# Display the plot
print(ggplot(avg_data, aes(x = Hour)))


# Handling outliers in the electricity usage data
data <- data %>%
  mutate(`Electricity usage (kWh)` = ifelse(`Electricity usage (kWh)` < 0 | `Electricity usage (kWh)` > 1000, NA, `Electricity usage (kWh)`))

# Recalculate the averages after removing outliers
avg_data_corrected <- data %>%
  group_by(Hour) %>%
  summarise(Avg_Solar_Generation = mean(`Solar electricity generation (kWh)`, na.rm = TRUE),
            Avg_Electricity_Usage = mean(`Electricity usage (kWh)`, na.rm = TRUE))

# Replot the graph with corrected data
ggplot(avg_data_corrected, aes(x = Hour)) +
  geom_line(aes(y = Avg_Solar_Generation, colour = "Solar Generation"), linewidth = 1) +
  geom_line(aes(y = Avg_Electricity_Usage, colour = "Electricity Usage"), linewidth = 1) +
  labs(title = "Corrected Average Solar Generation and Electricity Usage by Hour",
       x = "Hour of the Day",
       y = "Average kWh") +
  theme_minimal() +
  scale_colour_manual(values = c("Solar Generation" = "blue", "Electricity Usage" = "red"))

# Display the corrected plot
print(ggplot(avg_data_corrected, aes(x = Hour)))



# Calculate the electricity bought from the provider
data$Electricity_Bought <- pmax(data$`Electricity usage (kWh)` - data$`Solar electricity generation (kWh)`, 0)

# Calculate the excess solar electricity
data$Excess_Solar <- pmax(data$`Solar electricity generation (kWh)` - data$`Electricity usage (kWh)`, 0)

# Initialize the battery charge level
data$Battery_Charge <- 0
max_battery_capacity <- 10  # Maximum battery capacity in kWh

# Calculate the cumulative battery charge level
data$Battery_Charge <- cumsum(data$Excess_Solar) - cumsum(data$Electricity_Bought)
data$Battery_Charge <- pmin(pmax(data$Battery_Charge, 0), max_battery_capacity)

# Output the first few rows to verify calculations
head(data)



# Calculate the electricity bought with battery installed
data$Electricity_Bought_With_Battery <- pmax(data$`Electricity usage (kWh)` - data$`Solar electricity generation (kWh)` - data$Battery_Charge, 0)

# Calculate the total cost without and with battery
price_per_kWh <- 0.20  # Price per kWh in dollars
total_cost_without_battery <- sum(data$Electricity_Bought) * price_per_kWh
total_cost_with_battery <- sum(data$Electricity_Bought_With_Battery) * price_per_kWh

# Calculate the savings
total_savings <- total_cost_without_battery - total_cost_with_battery

# Output the total costs and savings
data.frame(Total_Cost_Without_Battery = total_cost_without_battery, Total_Cost_With_Battery = total_cost_with_battery, Total_Savings = total_savings)



# Check for NA values in the relevant columns and handle them
data <- na.omit(data)

# Recalculate the electricity bought with battery installed
data$Electricity_Bought_With_Battery <- pmax(data$`Electricity usage (kWh)` - data$`Solar electricity generation (kWh)` - data$Battery_Charge, 0)

# Recalculate the total cost without and with battery
price_per_kWh <- 0.20  # Price per kWh in dollars
total_cost_without_battery <- sum(data$Electricity_Bought) * price_per_kWh
total_cost_with_battery <- sum(data$Electricity_Bought_With_Battery) * price_per_kWh

# Recalculate the savings
total_savings <- total_cost_without_battery - total_cost_with_battery

# Output the total costs and savings
data.frame(Total_Cost_Without_Battery = total_cost_without_battery, Total_Cost_With_Battery = total_cost_with_battery, Total_Savings = total_savings)




# Convert date to Date format and extract month and year
data$Date <- as.Date(data$`Date/hour start`, format='%d/%m/%y %H:%M')
data$Month <- format(data$Date, '%m')
data$Year <- format(data$Date, '%Y')

# Aggregate data by month
monthly_data <- aggregate(cbind(`Solar electricity generation (kWh)`, `Electricity usage (kWh)`, Electricity_Bought, Electricity_Bought_With_Battery) ~ Month + Year, data=data, FUN=sum)

# Plot the data
library(ggplot2)
ggplot(monthly_data, aes(x=Month)) +
  geom_line(aes(y=`Solar electricity generation (kWh)`, colour='Solar Generation')) +
  geom_line(aes(y=`Electricity usage (kWh)`, colour='Electricity Usage')) +
  geom_line(aes(y=Electricity_Bought, colour='Electricity Bought (No Battery)')) +
  geom_line(aes(y=Electricity_Bought_With_Battery, colour='Electricity Bought (With Battery)')) +
  labs(title='Monthly Electricity Data for 2020', x='Month', y='kWh') +
  scale_colour_manual(values=c('Solar Generation'='blue', 'Electricity Usage'='red', 'Electricity Bought (No Battery)'='green', 'Electricity Bought (With Battery)'='purple')) +
  theme_minimal()


# Adjust the grouping by ensuring the data is grouped by both month and year
data$Month_Year <- paste(data$Year, data$Month, sep='-')

# Re-aggregate data by Month_Year
monthly_data <- aggregate(cbind(`Solar electricity generation (kWh)`, `Electricity usage (kWh)`, Electricity_Bought, Electricity_Bought_With_Battery) ~ Month_Year, data=data, FUN=sum)

# Re-plot the data with corrected grouping
library(ggplot2)
ggplot(monthly_data, aes(x=Month_Year)) +
  geom_line(aes(y=`Solar electricity generation (kWh)`, colour='Solar Generation')) +
  geom_line(aes(y=`Electricity usage (kWh)`, colour='Electricity Usage')) +
  geom_line(aes(y=Electricity_Bought, colour='Electricity Bought (No Battery)')) +
  geom_line(aes(y=Electricity_Bought_With_Battery, colour='Electricity Bought (With Battery)')) +
  labs(title='Monthly Electricity Data for 2020', x='Month-Year', y='kWh') +
  scale_colour_manual(values=c('Solar Generation'='blue', 'Electricity Usage'='red', 'Electricity Bought (No Battery)'='green', 'Electricity Bought (With Battery)'='purple')) +
  theme_minimal()

# Check the structure of the Month_Year and other relevant columns to ensure they are appropriate for plotting
data$Month_Year <- as.Date(paste(data$Year, data$Month, '01', sep='-'), format='%Y-%m-%d')
print(head(data$Month_Year))

# Re-check the aggregation
monthly_data <- aggregate(cbind(`Solar electricity generation (kWh)`, `Electricity usage (kWh)`, Electricity_Bought, Electricity_Bought_With_Battery) ~ Month_Year, data=data, FUN=sum)
print(head(monthly_data))

# Attempt to plot again with the corrected date format
library(ggplot2)
ggplot(monthly_data, aes(x=Month_Year)) +
  geom_line(aes(y=`Solar electricity generation (kWh)`, colour='Solar Generation')) +
  geom_line(aes(y=`Electricity usage (kWh)`, colour='Electricity Usage')) +
  geom_line(aes(y=Electricity_Bought, colour='Electricity Bought (No Battery)')) +
  geom_line(aes(y=Electricity_Bought_With_Battery, colour='Electricity Bought (With Battery)')) +
  labs(title='Monthly Electricity Data for 2020', x='Month-Year', y='kWh') +
  scale_colour_manual(values=c('Solar Generation'='blue', 'Electricity Usage'='red', 'Electricity Bought (No Battery)'='green', 'Electricity Bought (With Battery)'='purple')) +
  theme_minimal()


# Define the initial cost and annual savings for the battery scenarios
initial_cost <- -5000  # Assuming an initial cost of $5000 for the battery installation

# Calculate annual savings based on previous calculations of electricity bought without and with battery
# Assuming the data has been aggregated annually, if not, we will need to aggregate it
annual_savings <- monthly_data$Electricity_Bought - monthly_data$Electricity_Bought_With_Battery
annual_savings <- sum(annual_savings) * 12  # Convert monthly to annual savings

# Define the cash flows for the IRR calculation
# Assuming a 10-year analysis period
cash_flows <- c(initial_cost, rep(annual_savings, 10))

# Calculate IRR
library('financer')
irr_result <- IRR(cash_flows)

# Print the IRR result
print(irr_result)


# Load the necessary library for handling text data
library(readr)

# Read the data from the text file
electricity_data <- read_delim('paste.txt', delim = "\	")

# Display the head of the dataframe to understand its structure
print(head(electricity_data))


