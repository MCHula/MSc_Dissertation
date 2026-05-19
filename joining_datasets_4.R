##merging the data frames to create a single data frame that contains all the genes, but only with samples that 
##have data for all 3 data frames


#Rename sample columns to first 12 characters as this is the patient unique identifier
rename_sample_columns <- function(df) {
  colnames(df) <- sapply(colnames(df), function(name) {
    if (name == "GeneSymbol") name else substr(name, 1, 12)
  })
  return(df)
}

normalised_mRNA_500 <- rename_sample_columns(normalised_mRNA_500)
normalised_miRNA_420 <- rename_sample_columns(normalised_miRNA_420)
normalised_DNA_500 <- rename_sample_columns(normalised_DNA_500)

#Finding common sample IDs
samples_mRNA <- setdiff(colnames(normalised_mRNA_500), "GeneSymbol")
samples_miRNA <- setdiff(colnames(normalised_miRNA_420), "GeneSymbol")
samples_DNA <- setdiff(colnames(normalised_DNA_500), "GeneSymbol")

common_samples <- Reduce(intersect, list(samples_mRNA, samples_miRNA, samples_DNA))

#Filter each data set by common sample IDs
filter_by_common_samples <- function(df, common_samples) {
  df %>%
    select(GeneSymbol, all_of(common_samples))
}

mRNA_filtered <- filter_by_common_samples(normalised_mRNA_500, common_samples)
miRNA_filtered <- filter_by_common_samples(normalised_miRNA_420, common_samples)
DNA_filtered <- filter_by_common_samples(normalised_DNA_500, common_samples)

#Transpose & prefix gene names for each data set to show which data set they come from
prepare_matrix <- function(df, prefix) {
  # Ensure default row names
  rownames(df) <- NULL
  
  df_t <- df %>%
    as.data.frame() %>%        
    column_to_rownames("GeneSymbol") %>%
    t() %>%
    as.data.frame()
  
  colnames(df_t) <- paste0(prefix, "_", colnames(df_t))
  df_t <- df_t %>% rownames_to_column("SampleID")
  
  return(df_t)
}

mRNA_t <- prepare_matrix(mRNA_filtered, "mRNA")
miRNA_t <- prepare_matrix(miRNA_filtered, "miRNA")
DNA_t <- prepare_matrix(DNA_filtered, "DNA")

#Merge all data sets by Sample ID
combined_data <- reduce(
  list(mRNA_t, miRNA_t, DNA_t),
  function(x, y) inner_join(x, y, by = "SampleID")
)

#samples as rows, features as columns
rownames(combined_data) <- combined_data$SampleID
combined_data$SampleID <- NULL













