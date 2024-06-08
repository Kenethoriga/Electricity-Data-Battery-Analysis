
Files:

Junior Data Analyst _ Data.xlsx: The Excel file containing the raw electricity data.
paste.txt: A text file containing additional data (not used in this analysis).
script.R: The R script file containing the code for data loading, cleaning, analysis, and visualization.
Script Overview: The script.R file performs the following tasks:

Loads the necessary libraries (readxl, dplyr, ggplot2) and data from the Excel file.
Cleans and preprocesses the data, including fixing header issues and converting data types.
Performs data analysis, including calculating summary statistics and identifying outliers.
Visualizes the data using ggplot2, including plotting average solar generation and electricity usage by hour.
Handles outliers in the electricity usage data and recalculates averages.
Calculates the electricity bought from the provider and excess solar electricity.
Simulates the installation of a battery and calculates the electricity bought with and without the battery.
Calculates the total cost without and with the battery, and the total savings.
Aggregates data by month and year, and plots the monthly electricity data.
Calculates the internal rate of return (IRR) for the battery installation.
Requirements: To run this script, you need to have R installed on your system, along with the necessary libraries (readxl, dplyr, ggplot2, financer). You also need to have the Junior Data Analyst _ Data.xlsx file in the same directory as the script.

Author: Keneth origa

License: This project is licensed under the MIT License.

Contact: If you have any questions or issues, please contact kenethoriga@live.com
