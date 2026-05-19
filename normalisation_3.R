##l2 normalisation

#separating the gene symbols and numeric data
#dna
DNA_genes <- DNA_500_features_final[[1]]
numeric_500_DNA <- DNA_500_features_final[, -1]

DNA_l2_norm <- function(x) {
  x / sqrt(sum(x^2))
}

normalized_DNA_numeric <- t(apply(numeric_500_DNA, 1, DNA_l2_norm))

normalised_DNA_500 <- data.frame(GeneSymbol = DNA_genes, normalized_DNA_numeric, check.names = FALSE)


#mRNA
mRNA_genes <- mRNA_500_features_final[[1]]
numeric_500_mRNA <- mRNA_500_features_final[, -1]

mRNA_l2_norm <- function(x) {
  x / sqrt(sum(x^2))
}

normalised_mRNA_numeric <- t(apply(numeric_500_mRNA, 1, mRNA_l2_norm))

normalised_mRNA_500 <- data.frame(GeneSymbol = mRNA_genes, normalised_mRNA_numeric, check.names = FALSE)


#miRNA
miRNA_genes <- miRNA_420_features_final[[1]]
numeric_420_miRNA <- miRNA_420_features_final[, -1]

miRNA_l2_norm <- function(x) {
  x / sqrt(sum(x^2))
}

normalised_miRNA_numeric <- t(apply(numeric_420_miRNA, 1, miRNA_l2_norm))

normalised_miRNA_420 <- data.frame(GeneSymbol = miRNA_genes, normalised_miRNA_numeric, check.names = FALSE)








