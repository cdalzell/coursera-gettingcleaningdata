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
names(xData) <- gsub("\\(\\)", "", names(xData)) # get rid of the parens

# 3. Uses descriptive activity names to name the activities in the data set

# 4. Appropriately labels the data set with descriptive activity names.

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

