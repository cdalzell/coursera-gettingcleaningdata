# Create one R script called run_analysis.R that can be run as long as the Samsung data is in your
# working directory that does the following:

# 1. Merges the training and the test sets to create one data set.
print("Loading X Data..")

xTest <- read.table("test/X_Test.txt")
xTrain <- read.table("train/X_train.txt")
xData <- rbind(xTest, xTrain)

print("Loading Y Data..")

yTest <- read.table("test/Y_Test.txt")
yTrain <- read.table("train/y_train.txt")
yData <- rbind(yTest, yTrain)

print("Loading Subject Data..")

subjectTest <- read.table("test/subject_test.txt")
subjectTrain <- read.table("train/subject_train.txt")
subjectData <- rbind(subjectTest, subjectTrain)

## TODO: get rid of the seperate test/train data to save memory?

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
featureData <- read.table("features.txt")
#View(featureData)

# find the columns that have mean or standard dev measuments
measurementCols <- grep("*mean\\(\\)|*std\\(\\)", featureData$V2)

xData <- xData[, measurementCols] # axe the data we don't need

# give the x data better names
names(xData) <- featureData[measurementCols, 2]
names(xData) <- gsub("\\(\\)", "", tolower(names(xData))) # get rid of the parens

# 3. Uses descriptive activity names to name the activities in the data set
activityData <- read.table("activity_labels.txt")

activityData$V2 <- gsub("_", " ", activityData$V2)

names(yData) <- "activity" # give the column a better title than "V1"
yData$activity <- activityData[yData$activity, 2]  # sub in descriptive activity names

# 4. Appropriately labels the data set with descriptive activity names.
# Was not sure how steps 3 and 4 are different, apparently they're not:
# https://class.coursera.org/getdata-002/forum/thread?thread_id=28#post-461

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Note: It is my understanding that this "second" data set is second to the original download that this data was
# sourced from.
#
# https://class.coursera.org/getdata-002/forum/thread?thread_id=105
# https://class.coursera.org/getdata-002/forum/thread?thread_id=146
#
# So.. No need to write out both datasets, just the final one with the averages..

names(subjectData) <- "subject"
cleanData <- cbind(subjectData, yData, xData)

# And even if I am wrong about not needing to write both data sets, uncommenting the next line is all that
# would need to be done:
#write.csv(cleanData, "tidy-data-set.csv", row.names=FALSE)

library(reshape2) # http://had.co.nz/reshape/

keyCols <- c("subject", "activity") # "lookup key" for each activity and each subject
measurementNames <- setdiff(colnames(cleanData), keyCols)

meltedData <- melt(cleanData, id = keyCols, measure.vars = measurementNames)
avgData <- dcast(meltedData, subject + activity ~ variable, mean)

write.csv(avgData, "tidy-data-set-avg.csv", row.names=FALSE)
