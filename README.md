This repository contains a full analysis for my MSc Data Science Dissertation "Predicting sub populations in colon cancer intergrating DNA methylation, mRNA and
miRNA expression datasets".
The aim of this work was to predict sub populations of colon cancer, based on samples genomic data. Additonally, biomarkers that differentially express across 
subpopulations were aimed to be identified. Correctly identifiying a cancers moleculer subtype can improve personalised treatment and increase our undserstanding
for how cancers develop. Also, finding biomarkers that differentiate based on a cancers sub population is likely to improve diagnosis accuracy.

DATA:
This project uses fully annoymised and private data, containing no revealing or personal information. Data was taken from The GDC Analysis Center 
(Genomic Data Commons Analysis Center), specifically samples from the colon cancer cohort. The three datasets analysed are COADs of DNA methylation, 
mRNA expression and miRNA expression profiles, in addition to clinical patient information dataset for reference.

REQUIRMENTS:
This project uses R studio version 4.4.1. The following packages were used: tidyverse (Wickham et al, 2019), ggplot2 (Wickham, 2016), matrixStats 
(Bengtsson, 2015), factoextra (Kassambara & Mundt, 2020), cluster (Maechler et al, 2025), NbClust (Charrad et al, 2014), Rtsne (Krijthe, 2015), 
rstatix (Kassambara, 2023).

HOW TO RUN:
The R scripts are numbered in order, from 1 (initial_filtering) to 8 (wilcoxon). Additionally, all output results/figures are included as png files.
The .csv files contain all datasets used.

METHODOLOGY & DATA PREPERATION/CLEANING:
Only samples that overlap in all three genomic datasets were analysed. Features where 20% or more of their values were 0 are removed. Features with any na 
values were also removed. The genomic datasets were transformed via log2(exp(x) +1). Feature selection was used to keep the 500 most significant DNA and mRNA
features, and the top 420 miRNA features (due to less features in its dataset). Next, L2 normalisation was carried out before using an inner join to join all
three genomic datasets based on overlapping IDs. 

K-means clustering was used to identify subpopulations, with parameters based off elbow and silhouette graphs. The optimal number of clusters was visualised via
PCA. T-distributed Stochastic Neighbour Embedding (t-SNE) was also used. To identify biomarkers, a Wilcoxon test without adjustment was run.

RESULTS:
The optimum number of clusters and therefore subpopulations was two. This differs from the traditional four stages of colon cancer used for clinical applications 
and classifying tumour progression.  Additionally, many biomarkers showed a significant difference in methylation or expression between the two clusters, 
with a mix of biomarkers that have and have not previously been related to colon cancer. hsa-mir-625 shows potential in being a pan cancer-subpopulation 
biomarker, while LY6G6D and GNG4 demonstrate variance between clusters.
