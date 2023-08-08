# Load required libraries
library(dplyr)

# Generate random data
num_points <- 100
data <- data.frame(
  X = runif(num_points, 0, 10),
  Y = rnorm(num_points, mean = 5, sd = 2)
)

# Save data to a tab-separated value file
write.table(data, "data.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

# Print a message
cat("Generated data and saved to data.tsv\n")