# Getting and Cleaning Data: Course Project

## Introduction

This is a repository for all course project files. 

The raw data used for this project is entitled "Human Activity Recognition Using Smartphones Data Set", available from UCI Center for Machine Learning and Intelligent Systems. 

It is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. For more information on the raw data please see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones as well as the raw data's README.txt file.

This repository includes an R script (run_analysis.R) which, when run, generates a tidy data text file that meets the principles of tidy data in the wide form (as detailed in David Hood's tidy data post: https://class.coursera.org/getdata-030/forum/thread?thread_id=107). It includes the columns for subject, activity, and the average of the mean and standard deviation measurements for that subject/activity combination. More information on the columns is detailed in the code book, also found in this repository. 

As David Hood noted: 
"producing a mean of the means gives you the typical measure for that particular person doing that particular activity. Producing a mean of the standard deviations gives you a measure for how much variation was there in that particular person doing that particular activity."
(https://class.coursera.org/getdata-030/forum/thread?thread_id=240#comment-765)

## Study Design

The following section details the steps taken in order to achieve the tidy data set from the raw data: 

### 0. Download and unzip the raw data. 
This step was added in order to assure the raw data is present (see: https://class.coursera.org/getdata-030/forum/thread?thread_id=238#post-966)

- Since the dplyr and reshape2 libraries are required, the are installed of missing, and loaded. This was added based on a suggestion by Gregory D. Horne (https://class.coursera.org/getdata-030/forum/thread?thread_id=203#comment-464).
- The raw data is downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
- It is then unzipped to a subfolder entitled "data".

### 1. Merge the training and the test sets to create one data set.

- In the "train" subfolder, the files "X_train.txt", "y_train.txt", and "subject_train.txt" are read into dataset and combined via cbind, in order to create a single dataset with the training data including the activity measured and the subject id. The resulting dataset has 7352 observations of 563 variables.
- Similarly, in the "test" subfolder, the files "X_test.txt", "y_test.txt", and "subject_test.txt" are read into dataset and combined via cbind, in order to create a single dataset with the test data including the activity measured and the subject id. The resulting dataset has 2947 observations of 563 variables.
- The resulting training and test datasets are then merged into a unified dataset via rbind.  The resulting dataset has 10299 observations of 563 variables.

### 2. Extract only the measurements on the mean and standard deviation for each measurement.

- The "features.txt" file is read to extract the names of the measured features. 
- A relevant features dataset is created by filtering the features dataset and returning only feature names that contain "mean" or "std" (and their corresponding numbers). 
- The numbers are then used to identify the relevant features' column and create a reduced set containing only the relevant features, the subject, and the activity. This is done via the select function. The resulting dataset has 2947 observations of 81 variables.

### 3. Use descriptive activity names to name the activities in the data set.

- The "activity_labels.txt" file is read to extract the names of the measured activities. The resulting dataset is converted into a factor and used to replace the numerical entries in the reduced dataset's activity column with their corresponding names. 

### 4. Appropriately label the data set with descriptive variable names.

- Looping along the relevant features set created in step #2, each feature column name in the reduced set is renamed with the corresponding feature name. This is done via the rename function. 

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

- Using the melt function, a new dataset is created with subject and activity identified as the id variables, and the additional variables identified as measure variables. The resulting dataset has 813621 observations of 4 variables.
- The resulting set is reshaped using the dcast function, displaying the subject and activity column (30 subject X 6 activities) and taking the average of each of the 79 measure variables, for each subject/activity combination. The resulting dataset has 180 observations of 81 variables.
- The tidy dataset's measure variable columns are renamed to reflect the fact the they display the average of each variable. 

### 6. Read the tidy data set. 
- The following command was used to write the dataset: 
write.table(tidy.set, file = "tidy.txt", row.names = FALSE)
- The script includes a 6th step which loads the submitted tidy dataset from Coursera. This is based on a suggestion David Hood made in https://class.coursera.org/getdata-030/forum/thread?thread_id=107#post-369.
