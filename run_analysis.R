library(dplyr)

## Load Data Sets
# test set
X_test <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
# trainings set
X_train <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
# get feature names
names <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt")
# get activity labels
activityLabels <- read.table("getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

## Combine training and test data sets
x <- rbind(X_train, X_test)
y <- rbind(Y_train, Y_test)

## set column names
names(x) <- names[,2]
names(y) <- "activityType"

## combine x and y into one data set
data <- cbind(y,x)

# Extract Mean and Standard deviation for each measurement and keep the activity Type
data <- data[,grepl("^activityType$|mean\\(\\)|std\\(\\)", names(data))]

# convert activity type from int to factor with meanigful labels
data$activityType <- factor(data$activityType, labels = activityLabels[,2])

## group data by activity Type and calculate means for each activity and subject
data_grouped_averages <- data %>% group_by(activityType) %>% summarize_all(funs(mean))

## save data set to a file
write.table(data_grouped_averages,"grouped_averages.txt", row.names = FALSE)

