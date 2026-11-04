##PCAs

#run PCA on scaled data
inital_pca <- prcomp(scaled_combined_data, center = TRUE, scale. = TRUE)

#adding 2 clusters to PCA
pca_df <- as.data.frame(inital_pca$x)
pca_df$cluster <- factor(km2$cluster)

#plotting PCA, samples coloured by cluster
ggplot(pca_df,
       aes(x = PC1, y = PC2, colour = cluster)) +
  geom_point(size = 2, alpha = 0.8) +
  labs(title = "PCA of samples", x = "PC1", y = "PC2") +
  theme_minimal()






