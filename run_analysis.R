#0. Download and unzip the raw data.

#some operations require dplr and reshape2 library functions
#therefore if the libraries are missing they are installed
if (!require(dplyr, quietly = TRUE)) install.packages('dplyr')
library(dplyr)
if (!require(reshape2, quietly = TRUE)) install.packages('reshape2')
library(reshape2)

archive.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
archive.file.path <- "./dataarchive.zip"
data.directory <- "./data"
download.file(archive.url, archive.file.path, method = "curl") #method not needed for Microsoft Windows users
if(!file.exists(data.directory)){
     dir.create(data.directory)
}
unzip(archive.file.path, exdir = data.directory)

#1. Merge the training and the test sets to create one data set.

training.set.file.path <- "UCI HAR Dataset/train/X_train.txt"
training.activities.file.path <- "UCI HAR Dataset/train/y_train.txt"
training.subjects.file.path <- "UCI HAR Dataset/train/subject_train.txt"

test.set.file.path <- "UCI HAR Dataset/test/X_test.txt"
test.activities.file.path <- "UCI HAR Dataset/test/y_test.txt"
test.subjects.file.path <- "UCI HAR Dataset/test/subject_test.txt"

training.set <- read.table(paste(data.directory, training.set.file.path, sep = "/"))
training.activities <- read.table(paste(data.directory, training.activities.file.path, sep = "/"))
training.activities <- rename(training.activities, activity = V1)
training.subjects <- read.table(paste(data.directory,training.subjects.file.path, sep = "/"))
training.subjects <- rename(training.subjects, subject = V1)
training <- cbind(training.subjects, training.activities, training.set)

test.set <- read.table(paste(data.directory, test.set.file.path, sep = "/"))
test.activities <- read.table(paste(data.directory,test.activities.file.path, sep = "/"))
test.activities <- rename(test.activities, activity = V1)
test.subjects <- read.table(paste(data.directory,test.subjects.file.path ,sep = "/"))
test.subjects <- rename(test.subjects, subject = V1)
test <- cbind(test.subjects, test.activities, test.set)

unified.set <- rbind(training,test)

#2. Extract only the measurements on the mean and standard deviation for each measurement.

features.file.path <- "UCI HAR Dataset/features.txt"
features.set <- read.table(paste(data.directory, features.file.path, sep = "/"))
relevant.features.set <- filter(features.set, grepl("-mean|-std",V2))
reduced.set <- select(unified.set, one_of(c("subject", "activity", paste("V", relevant.features.set$V1, sep=""))))

#3. Use descriptive activity names to name the activities in the data set.

activity.labels.file.path <- "UCI HAR Dataset/activity_labels.txt"
activities.set <- read.table(paste(data.directory,activity.labels.file.path,sep = "/"))
reduced.set$activity <- factor(reduced.set$activity, levels = activities.set$V1, labels = activities.set$V2)

#4. Appropriately label the data set with descriptive variable names.
relevant.features.length.seq <- seq_along(relevant.features.set$V1)
for (index in relevant.features.length.seq) {
  position <- which(names(reduced.set) == paste("V",relevant.features.set$V1[index],sep=""))
  names(reduced.set)[position] <- toString(relevant.features.set$V2[index])
}

#5. From the data set in step 4, create a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
molten.set <- melt(reduced.set, id=c("subject", "activity"), measure.vars = sapply(relevant.features.set$V2, as.character)) 
tidy.set <- dcast(molten.set, subject + activity ~ variable, mean)
names(tidy.set) <- c("subject", "activity", paste("average of ", sapply(relevant.features.set$V2, as.character), sep=" "))
names(tidy.set)<-gsub("mean\\(\\)", "mean value", names(tidy.set))
names(tidy.set)<-gsub("std\\(\\)", "standard deviation", names(tidy.set))
names(tidy.set)<-gsub("meanFreq\\(\\)", "weighted average of the frequency components", names(tidy.set))
names(tidy.set)<-gsub("X", "X axis", names(tidy.set))
names(tidy.set)<-gsub("Y", "Y axis", names(tidy.set))
names(tidy.set)<-gsub("Z", "Z axis", names(tidy.set))
names(tidy.set)<-gsub("BodyBody", "Body", names(tidy.set))
names(tidy.set)<-gsub("tBody", "body time domain signals ", names(tidy.set))
names(tidy.set)<-gsub("tGravity", "gravity time domain signals ", names(tidy.set))
names(tidy.set)<-gsub("fBody", "body frequency domain signals ", names(tidy.set))
names(tidy.set)<-gsub("Acc", "from accelerometer ", names(tidy.set))
names(tidy.set)<-gsub("Gyro", "from gyroscope ", names(tidy.set))
names(tidy.set)<-gsub("Jerk", " (linear acceleration and angular velocity derived in time)", names(tidy.set))
names(tidy.set)<-gsub("Mag", " calculated magnitude", names(tidy.set))
names(tidy.set)<-gsub("-", " ", names(tidy.set))
names(tidy.set)<-gsub("  ", " ", names(tidy.set))

#6. Reading the tidy data set. 
# To write the data set I used: 
# write.table(tidy.set, file = "tidy.txt", row.names = FALSE)
# This is the code which loads the submitted tidy data set from Coursera: 
address <- "https://s3.amazonaws.com/coursera-uploads/user-44bcf2d1d3f9b49f34e46930/975114/asst-3/351d84a0332d11e5a1f12fb4a4ccc86d.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)