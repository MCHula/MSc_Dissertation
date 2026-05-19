##transforming data with  log2(exp +1)
DNA_transformed <- DNA_data_filtered %>%
  mutate(across(where(is.numeric), ~ log2(. + 1)))

mRNA_transformed <- mRNA_data_filtered %>%
  mutate(across(where(is.numeric), ~ log2(. + 1)))
         
miRNA_transformed <- miRNA_data_filtered %>%
  mutate(across(where(is.numeric), ~ log2(. + 1)))

#checking the genetic data are dataframes (better for feature selection)
DNA_transformed <- as.data.frame(DNA_transformed)
mRNA_transformed <- as.data.frame(mRNA_transformed)
miRNA_transformed <- as.data.frame(miRNA_transformed)

##feature selection, selecting features which explain the highest amount of variation
install.packages("matrixStats")
library(matrixStats)

#separating the gene names from numeric data, and then making the gene names the row numbers and converting to matrix
DNA_gene_names <- DNA_transformed$GeneSymbol 
numeric_DNA <- DNA_transformed[, -1]
rownames(numeric_DNA) <- DNA_gene_names
DNA_matrix <- as.matrix(numeric_DNA)

mRNA_unique_gene_symbols <- make.unique(mRNA_transformed$GeneSymbol) #making gene symbols unique due to duplicates
numeric_mRNA <- mRNA_transformed[, -1]
rownames(numeric_mRNA) <- mRNA_unique_gene_symbols
mRNA_matrix <- as.matrix(numeric_mRNA)

miRNA_gene_names <- miRNA_transformed$GeneSymbol
numeric_miRNA <- miRNA_transformed[, -1]
rownames(numeric_miRNA) <- miRNA_gene_names
miRNA_matrix <- as.matrix(numeric_miRNA)

#calculating row-wise variances for each row/gene
DNA_variances <- rowVars(DNA_matrix)
mRNA_variances <- rowVars(mRNA_matrix)
miRNA_variances <- rowVars(miRNA_matrix)

#sorting features in decreasing order
sorted_DNA_variances <- sort(DNA_variances, decreasing = TRUE)
sorted_mRNA_variances <- sort(mRNA_variances, decreasing = TRUE)
sorted_miRNA_variances <- sort(miRNA_variances, decreasing = TRUE)

#getting the top 500 from DNA
num_DNA_features_selected <- min(500, length(sorted_DNA_variances))
top_500_DNA_gene_symbols <- names(sorted_DNA_variances[1:num_DNA_features_selected])

DNA_500_features_final <- DNA_transformed[match(top_500_DNA_gene_symbols, DNA_transformed$GeneSymbol), ]

#getting the top 500 from mRNA
num_mRNA_features_selected <- min(500, length(sorted_mRNA_variances))
top_500_mRNA_gene_symbols <- names(sorted_mRNA_variances[1:num_mRNA_features_selected])

mRNA_500_features_final <- mRNA_transformed[match(top_500_mRNA_gene_symbols, mRNA_transformed$GeneSymbol), ]

#getting the top 500 from miRNA (only 420 as thats all the features)
num_miRNA_features_selected <- min(420, length(sorted_miRNA_variances))
top_420_miRNA_gene_symbols <- names(sorted_miRNA_variances[1:num_miRNA_features_selected])

miRNA_420_features_final <- miRNA_transformed[match(top_420_miRNA_gene_symbols, miRNA_transformed$GeneSymbol), ]
