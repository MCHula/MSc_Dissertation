##t-SNE Stochastic Neighbor Embedding

install.packages("Rtsne")
library(Rtsne)

#pca on scaled data
pca_sne <- prcomp(scaled_combined_data, center = TRUE, scale. = TRUE)

#taking the top 30 PCAs
pca_number <- pca_sne$x[, 1:30]

#running t-sne on PCA output (seed set for reproducibility). max_iter at 500 as gains are marginal from this point
set.seed(123)
tsne_pca <- Rtsne(pca_number, dims = 2, perplexity = 50, verbose = TRUE, max_iter = 500) 

#prepare t-sne output
tsne_df <- as.data.frame(tsne_pca$Y)
colnames(tsne_df) <- c("tSNE1", "tSNE2")
tsne_df$cluster <- factor(km2$cluster)

#Plotting with colour by cluster
ggplot(tsne_df, 
       aes(x = tSNE1, y = tSNE2, color = cluster)) +
  geom_point(size = 2, alpha = 0.8) +
  labs(title = "t-SNE on PCA data", x = "t-SNE 1", y = "t-SNE 2") +
  theme_minimal()


