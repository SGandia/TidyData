#This script downloads and cleans a dataset of wearable computing measurements
#and then provides a separate dataset giving the mean of each variable for each
#activity and each subject.

#Load the R packages used in this script
library(plyr)
library(dplyr)
library(reshape2)

#Download the data from website
if(!file.exists("./data")) {dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/activity.zip", mode = 'wb')
unzip("./data/activity.zip", overwrite = TRUE)

#Read in and merge the datasets
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
traintest <- rbind(train, test)
#Add an ID column to keep track of original data order
ID <- seq(1, nrow(traintest))
traintest <- cbind(ID, traintest)
#Read in variable names from features.txt file provided
varnames <- read.table("./UCI HAR Dataset/features.txt")
#Make names more descriptive, correct and/or syntactically correct for R
varnamelist <- gsub("-", "_", varnames[, 2])
varnamelist <- gsub(",", "to", varnamelist)
varnamelist <- gsub("mean()", "mean", varnamelist, fixed=TRUE)
varnamelist <- gsub("std()", "std", varnamelist, fixed=TRUE)
varnamelist <- gsub("BodyBody", "Body", varnamelist, fixed=TRUE)
varnamelist <- gsub("[[:punct:]]", "_", varnamelist)
#Add the variable names to the dataset
colnames(traintest) <- c("ID", varnamelist)
#Identify the columns with mean measurements and subset including the ID column
varmeans <- grep("mean()", varnames$V2, value=FALSE, fixed=TRUE)
varmeans <- varmeans + 1
meandata <- traintest[, c(1, varmeans)]
#Identify the columns with standard deviation measurements and subset 
#including the ID column
varstd <- grep("std()", varnames$V2, value=FALSE, fixed=TRUE)
varstd <- varstd + 1
stddata <- traintest[, c(1, varstd)]
#Combine mean and standard deviation datasets back together
meanstd <- merge(meandata, stddata, by="ID", all=TRUE)

#Read in activity names from text file provided
activenames <- read.table("./UCI HAR Dataset/activity_labels.txt")
#Read in and merge the activities data
activetrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
activetest <- read.table("./UCI HAR Dataset/test/y_test.txt")
activetraintest <- rbind(activetrain, activetest)
#Add an ID column to keep track of original data order
ID <- seq(1, nrow(activetraintest))
activetraintest <- cbind(ID, activetraintest)
#Add the activity names to the activities dataset
descnames <- merge(activetraintest, activenames, by="V1", all=TRUE)
colnames(descnames) <- c("ActivityNum", "ID", "ActivityName")
descnames <- arrange(descnames, ID)
#Add the activity names to the dataset
namedmeanstd <- merge(descnames, meanstd, by="ID", all=TRUE)

#Read in and merge the subject data
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjtraintest <- rbind(subjtrain, subjtest)
#Add an ID column to keep track of original data order
ID <- seq(1, nrow(subjtraintest))
subjtraintest <- cbind(ID, subjtraintest)
#Name the columns
colnames(subjtraintest) <- c("ID", "SubjectID")
#Add the subject IDs to the dataset
subjmeanstd <- merge(subjtraintest, namedmeanstd, by="ID", all=TRUE)

#Reshape data, summarize by means of each variable and change names
subj_activity <- melt(subjmeanstd, id=1:4)
mean_summary <- dcast(subj_activity, SubjectID + ActivityName ~ variable, mean)
goodnames <- paste("Meanof", colnames(mean_summary), sep=".")
goodnames <- gsub("Meanof.SubjectID", "SubjectID", goodnames, fixed=TRUE)
goodnames <- gsub("Meanof.ActivityName", "ActivityName", goodnames, fixed=TRUE)
colnames(mean_summary) <- goodnames

#Write to table to be easily read with R
write.table(mean_summary, file = "tidydata.txt", row.names=FALSE,
            sep=" ")


