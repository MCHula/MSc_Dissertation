##load readr package, tidyverse, ggplot2
install.packages("ggplot2")
library(readr)
library(tidyverse)
library(ggplot2)

##loading in the data
miRNA_data <- read_csv("COAD__miRNAExp__ReadCount.csv")
mRNA_data <- read_csv("COAD__geneExp.csv")
DNA_data <- read_csv("COAD__methylation_450__TSS200-TSS1500.csv")
patient_data <- read_csv("clinical_patient_coad.csv")

##checking for na values
any(is.na(miRNA_data)) #FALSE
any(is.na(mRNA_data)) #FALSE
any(is.na(DNA_data)) #TRUE

##removing NA genes/features and features with > 20% '0' values from DNA_data
DNA_data_filtered <- DNA_data %>%
  rowwise() %>%
  filter(mean(c_across(where(is.numeric)) == 0 | is.na(c_across(where(is.numeric)))) < 0.2) %>%
  ungroup()

#removing genes/features if > 20% of their values are 0 from the mi and mRNA data sets
mRNA_data_filtered <- mRNA_data %>%
  rowwise() %>%
  filter(mean(c_across(where(is.numeric)) == 0) < 0.20) %>% 
  ungroup()

miRNA_data_filtered <- miRNA_data %>%
  rowwise() %>%
  filter(mean(c_across(where(is.numeric)) == 0) < 0.20) %>%
  ungroup()


