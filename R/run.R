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

# Predict with the voting information and export it into a CSV file
#x <- predict(rfFit$finalModel, testSplit, type="vote", norm.votes=FALSE, predict.all=TRUE)
#write.table(x["individual"], file="/tmp/votes.csv", sep=",")
#best_tree <- getTree(rfFit$finalModel, 63, labelVar=TRUE)
#best_tree

print("Results...")
importance = varImp(rfFit)
importance

# Confusion matrix
confusionMatrix(table(rfPred, testSplit[,1]))
