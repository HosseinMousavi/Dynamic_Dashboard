
load("~/Documents/NMSU_2023/GTEx/GTExVST.RData")

# Transpose df1
df1_transpose <- t(df1)

# Merge datasets
df_merged <- cbind(colData, df1_transpose)

######################################## Data cleansing ####

# Identifying and dealing with missing values in the dataset
if (any(is.na(df_merged))) {
  # Remove rows with missing values
  df_merged <- na.omit(df_merged)
}

# Remove duplicate entries from the dataset
df_merged <- df_merged[!duplicated(df_merged), ]

# Check and report the datatype of each column
for (col_name in names(df_merged)) {
  if (!is.numeric(df_merged[[col_name]])) {
    print(paste("Column", col_name, "is not numeric. It is", class(df_merged[[col_name]])))
  }
}

# Convert certain variables to categorical data
df_merged$sex <- as.factor(df_merged$sex)
df_merged$tissueType <- as.factor(df_merged$tissueType)

#### Finish data cleansing ####

# Convert the sex and tissueType columns to factors
df_merged$sex <- as.factor(df_merged$sex)
df_merged$tissueType <- as.factor(df_merged$tissueType)

######################################## t-test for each gene ####

# Perform a t-test for each gene to compare the means of two groups: sex and tissue type
# Initialize vectors to store the p-values obtained from the tests
p_values_sex <- c()
p_values_tissue <- c()

for (i in 4:ncol(df_merged)) {
  t_test_result_sex <- t.test(df_merged[df_merged$sex == 1, i], df_merged[df_merged$sex == 2, i])
  t_test_result_tissue <- t.test(df_merged[df_merged$tissueType == "Adipose - Subcutaneous", i], df_merged[df_merged$tissueType == "Adipose - Visceral (Omentum)", i])
  
  # Append the p-values from the t-tests to the lists
  p_values_sex <- c(p_values_sex, t_test_result_sex$p.value)
  p_values_tissue <- c(p_values_tissue, t_test_result_tissue$p.value)
}

# Correct for multiple comparisons using the Benjamini-Hochberg procedure
p_values_sex_adj <- p.adjust(p_values_sex, method = "BH")
p_values_tissue_adj <- p.adjust(p_values_tissue, method = "BH")

# Create a new dataframe with the names of the genes and their adjusted p-values
df_p_values <- data.frame(Gene = colnames(df_merged)[4:ncol(df_merged)], P_Value_Sex = p_values_sex_adj, P_Value_Tissue = p_values_tissue_adj)

# Select the top 50 genes with the lowest p-values for sex and tissue type
df_top50_genes_sex <- df_p_values[order(df_p_values$P_Value_Sex), ][1:50, ]
df_top50_genes_tissue <- df_p_values[order(df_p_values$P_Value_Tissue), ][1:50, ]

######################################## Merge ####
# Add labels to the gene lists indicating the type
df_top50_genes_sex$Gene_Type <- "Sex"
df_top50_genes_tissue$Gene_Type <- "Tissue"

# Combine the two lists into a single dataframe
df_combined <- merge(df_top50_genes_sex, df_top50_genes_tissue, by = c("Gene", "P_Value_Sex", "P_Value_Tissue", "Gene_Type"), all = TRUE)

# Replace any remaining missing values with zeros
df_combined[is.na(df_combined)] <- 0

##### Add gene expression from df_merged to df_combined:

# Transpose the combined dataframe and add it to the merged dataframe
df_combined_transposed <- setNames(data.frame(t(df_combined[, -1])), df_combined$Gene)

# Select columns from the merged dataframe that exist in the transposed combined dataframe
columns_to_keep <- intersect(colnames(df_merged), colnames(df_combined_transposed))
columns_to_keep <- c("tissueType", "sex", columns_to_keep)

# Create a subset of the merged dataframe that includes only the selected columns
df_merged_subset <- df_merged[, columns_to_keep]

# Save the subset dataframe and the transposed combined dataframe as R objects
save(df_merged_subset, file = "~/Documents/NMSU_2023/GTEx/df_merged_subset.RData")
save(df_combined_transposed, file = "~/Documents/NMSU_2023/GTEx/df_combined_transposed.RData")

# Export the subset dataframe and the transposed combined dataframe as CSV files
write.csv(df_merged_subset, file = "~/Documents/NMSU_2023/GTEx/df_merged_subset.csv", row.names = FALSE)
write.csv(df_merged_subset, file = "~/Documents/NMSU_2023/GTEx/df_combined_transposed.csv", row.names = FALSE)

