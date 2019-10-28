# Load libraries
library(caret)
library(randomForest)
library(pROC)

# Set directory
setwd("/dga")

# Load original data
clean   <- read.table( "/dga/clean.csv", header=FALSE, sep=",", na.strings="NaN", dec=",", strip.white=TRUE)
dga     <- read.table( "/dga/dga.csv",   header=FALSE, sep=",", na.strings="NaN", dec=",", strip.white=TRUE)

m = ncol(clean)

# Convert to numeric (disabled, weird result)
for (j in 4:m)
{
    clean[,j]   <- as.numeric( clean[,j]   )
    dga[,j]     <- as.numeric( dga[,j]     )
}

# Split in usable data and additional information
selected_rows = 3:ncol(clean)
#selected_rows1 <- c('V3', 'V21', 'V16','V20','V19', 'V5', 'V6'),
#selected_rows2 <- c('V3', 'V24', 'V16','V20','V23', 'V6', 'V5'),
#selected_rows3 <- c('V3', 'V84', 'V16','V20','V27', 'V6', 'V5'),
#selected_rows4 <- c('V3', 'V16', 'V184','V20','V19', 'V89', 'V5'),
#selected_rows <- selected_rows3

data_clean_full <- clean[,selected_rows]
data_dga_full   <- dga[,selected_rows]
data <- rbind( data_clean_full, data_dga_full )

# Create train and test sets for each dataset
set.seed(1234)

print("Selecting train and test data set")
splitIndex <- createDataPartition(data$V3, p = .60,list = FALSE,times = 1)
trainSplit      <- data[splitIndex,]
testSplit       <- data[-splitIndex,]
print("Done")

# Remove old variables
rm( clean, dga, splitIndex, data_clean_full, data_dga_full )

#### CLASSIFIERS #### => https://topepo.github.io/caret/modelList.html

set.seed(1234)

# Train control
print("Train control")
ctrl <- trainControl(method = "repeatedcv",repeats = 3,classProbs = TRUE,summaryFunction = twoClassSummary)
print("Done")

# Random Forest with the small training set
print("Training...")
system.time({
rfFit <- train(V3~.,data = trainSplit,method = "rf",trControl = ctrl,metric = "ROC")
})
print("Done")

# Test with the test set
print("Testing...")
system.time({
rfPred <- predict(rfFit, testSplit)
})
print("Done")

print("Results...")
importance = varImp(rfFit)
importance

# Confusion matrix
confusionMatrix(rfPred, testSplit[,1])
