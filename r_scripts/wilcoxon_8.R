##wilcoxon test for differential gene expression by cluster

install.packages("rstatix")
library(rstatix)

#transpose to make genes rows, and samples columns
gene_expression_matrix <- t(scaled_combined_data)

#Ordering gene expression matrix columns to match cluster assignment names
gene_expression_matrix <- gene_expression_matrix[, names(cluster_assignments)]

#Transform gene_expression_matrix into a tidy format
tidy_expression_data <- as.data.frame(gene_expression_matrix) %>%
  rownames_to_column(var = "gene") %>%
  pivot_longer(
    cols = -gene, 
    names_to = "sample_id",
    values_to = "expression"
  ) %>%
  #Join with cluster assignments
  left_join(
    data.frame(sample_id = names(cluster_assignments), 
               cluster = cluster_assignments),        
    by = "sample_id"
  )

#Making sure cluster is a factor
tidy_expression_data$cluster <- factor(tidy_expression_data$cluster)


#Wilcoxon test without adjustment (since only 2 clusters)
results_df_rstatix <- tidy_expression_data %>%
  group_by(gene) %>%
  wilcox_test(expression ~ cluster, p.adjust.method = "none") %>%
  ungroup()

#Add adjusted p-values manually
results_df_rstatix <- results_df_rstatix %>%
  mutate(p.adj = p.adjust(p, method = "BH"))

#Filter significant genes using FDR
significant_genes_df <- results_df_rstatix %>%
  filter(p.adj < 0.05)



##top 20 significant genes
top20_genes_df <- results_df_rstatix %>%
  arrange(p.adj) %>%
  slice_head(n = 20)

##top 10 genes for miRNA, mRNA, DNA
top_miRNA <- results_df_rstatix %>%
  filter(str_starts(gene, "miRNA_")) %>%
  arrange(p.adj) %>%
  slice_head(n = 10)

top_mRNA <- results_df_rstatix %>%
  filter(str_starts(gene, "mRNA_")) %>%
  arrange(p.adj) %>%
  slice_head(n = 10)

top_DNA <- results_df_rstatix %>%
  filter(str_starts(gene, "DNA_")) %>%
  arrange(p.adj) %>%
  slice_head(n = 10)

#Combine all into one data frame 
top10_genes_by_type <- bind_rows(top_miRNA, top_mRNA, top_DNA)











