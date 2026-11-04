##clustering, and identifying optimal number of clusters using elbow and/or silhouette methods

install.packages(c("factoextra", "cluster", "NbClust"))
library(factoextra)
library(cluster)
library(NbClust)

#scaling the data
scaled_combined_data <- scale(combined_data)

#elbow method to identify optimal number of clusters
fviz_nbclust(scaled_combined_data, kmeans, method = "wss", k.max = 10) +
  geom_vline(xintercept = c(2, 3), linetype = 2) +
  labs(subtitle = "Elbow method")

#silhouette method
fviz_nbclust(scaled_combined_data, kmeans, method = "silhouette") +
  labs(subtitle = "Silhouette method")

#looking at both silhouette and elbow and below, the optimal number of clusters will be 2, as silhouette 
#clearly shows 2 as the optimal, while elbow method suggests 3, and below suggests 2.
km3 <- kmeans(scaled_combined_data, centers = 3, nstart = 25)
fviz_cluster(km3, data = scaled_combined_data)

cluster_assignments <- km2$cluster
cluster_assignments <- as.factor(cluster_assignments)
view(cluster_assignments)

km4 <- kmeans(scaled_combined_data, centers = 4, nstart = 25)
fviz_cluster(km4, data = scaled_combined_data)

km2 <- kmeans(scaled_combined_data, centers = 2, nstart = 25)
fviz_cluster(km2, data = scaled_combined_data)



##mapping clusters to colon cancer stage

#removing the a,b from stages in the patient df
patients_cleaned_data <- patient_data %>%
  mutate(
    stage = tolower(ajcc_pathologic_tumor_stage),               
    stage = str_extract(stage, "i{1,3}v?")) 


#Getting sample IDs from your scaled data
patient_sample_id <- rownames(scaled_combined_data)

#data frame linking sample ID to cluster
linked_cluster_df <- data.frame(
  bcr_patient_barcode = patient_sample_id,
  cluster = cluster_assignments)

#joining cluster info with patient stage
cluster_stage_df <- linked_cluster_df %>%
  left_join(
    patients_cleaned_data[, c("bcr_patient_barcode", "stage")],
    by = "bcr_patient_barcode"
  )

#view result
head(cluster_stage_df)
table(cluster_stage_df$cluster, cluster_stage_df$stage, useNA = "ifany")

#visualising clusters and stages
ggplot(cluster_stage_df, 
       aes(x = cluster, fill = stage)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of Stage by Cluster", x = "cluster", y = "Count") +
  theme_minimal()








