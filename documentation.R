# Load the necessary library for Word document creation
# 'officer' package is used to create Word documents programmatically
install.packages('officer', repos='https://cran.rstudio.com/')
library(officer)

# Create a new Word document
doc <- read_docx()

# Add sections to the document
# Each body_add_par() function call adds a new paragraph to the document
doc <- doc %>% 
  body_add_par('Internal Rate of Return (IRR) Model Documentation', style = 'heading 1') %>% 
  # Add a heading for the introduction
  body_add_par('Introduction', style = 'heading 2') %>% 
  body_add_par('This document provides an overview of the model used to calculate the Internal Rate of Return (IRR) for a battery installation scenario.', style = 'normal') %>% 
  body_add_par('Model Description', style = 'heading 2') %>% 
  body_add_par('The model calculates the IRR based on the initial cost of the battery and the projected annual savings from reduced electricity costs.', style = 'normal') %>% 
  body_add_par('Data Inputs', style = 'heading 2') %>% 
  body_add_par('The model uses the following data inputs: initial cost of the battery, annual electricity cost savings.', style = 'normal') %>% 
  body_add_par('Calculations', style = 'heading 2') %>% 
  body_add_par('The model performs the following calculations: Initial Cost, Annual Savings, IRR Calculation.', style = 'normal') %>% 
  body_add_par('Results', style = 'heading 2') %>% 
  body_add_par('The results section summarizes the IRR calculated from the model.', style = 'normal') %>% 
  body_add_par('Conclusion', style = 'heading 2') %>% 
  body_add_par('The document concludes with insights drawn from the analysis.', style = 'normal') %>% 
  body_add_par('Code Appendix', style = 'heading 2') %>% 
  body_add_par('The R code used in the calculations is provided below. No local file paths are embedded to ensure functionality across different environments.', style = 'normal') %>% 
  body_add_par('library(officer)', style = 'code') %>% 
  body_add_par('initial_cost <- -5000', style = 'code') %>% 
  body_add_par('cash_flows <- c(initial_cost, rep(1200, 10))', style = 'code') %>% 
  body_add_par('irr_result <- uniroot(function(r) sum(cash_flows / (1 + r)^(0:10)), c(0, 1))$root', style = 'code')

# Save the document
doc <- print(doc, target = 'IRR_Model_Documentation.docx')

# Output the file path
print('IRR_Model_Documentation.docx')
