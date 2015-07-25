# Getting and Cleaning Data: Course Project

## Introduction

The raw data used for this project is entitled "Human Activity Recognition Using Smartphones Data Set", availabe from UCI Center for Machine Learning and Intelligent Systems. 

It is a Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. For more information on the raw data please see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones as well as the raw data's README.txt file.

This repository includes an R script (run_analysis.R) which, when run, generates a tidy data text file that meets the principles of tidy data in the wide form (as detailed in David Hood's tidy data post: https://class.coursera.org/getdata-030/forum/thread?thread_id=107). It includes the columns for subject, activity, and the average of the mean and standard deviation measurments for that subject/activity combination. More inforamtion on the columns is detailed in the code book. 

As David Hood noted: 
"producing a mean of the means gives you the typical measure for that particular person doing that particular activity. Producing a mean of the standard deviations gives you a measure for how much variation was there in that particular person doing that particular activity."
(https://class.coursera.org/getdata-030/forum/thread?thread_id=240#comment-765)

## Study Design

The following sction details the steps taken in order to acheive the tidy data set fromt the raw data: 

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
- The numbers are then used to identify the relevant features' column and create a reduced set condtaining only the relevant features, the subject, and the activity. This is done via the select fuction. The resulting dataset has 2947 observations of 81 variables.

### 3. Use descriptive activity names to name the activities in the data set.

- The "activity_labels.txt" file is read to extract the names of the measured activities. The resutling dataset is converted into a factor and used to replace the numerical entries in the reduced dataset's activity column with their corresponding names. 

### 4. Appropriately label the data set with descriptive variable names.

- Looping along the relevant features set created in step #2, each feature column name in the reduced set is renamed with the corresponding feature name. This is done via the rename fuction. 

### 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

- Using the melt function, a new dataset is created with subject and activity identified as the id variables, and the additional variables identified as measure variables. The resulting dataset has 813621 observations of 4 variables.
- The resulting set is reshaped using the dcast function, displaying the subject and activity column (30 subject X 6 activities) and taking the average of each of the 79 measure variables, for each subject/activity combination. 

## Code Book

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed 

six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S 

II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular 

velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has 

been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the 

test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width 

sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and 

body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational 

force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each 

window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file in the raw data zip for further details about this dataset. 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

subject - a number identifying the subject. 

activity - A string describing the nature of the activity measured. In total, 6 activities were measured for each sunject: 

walking, walking upstairs, walking downstairs, sitting, standing and laying. 

The additional 79 variables are: 
average-tBodyAcc-mean()-X
average-tBodyAcc-mean()-Y
average-tBodyAcc-mean()-Z
average-tBodyAcc-std()-X
average-tBodyAcc-std()-Y
average-tBodyAcc-std()-Z
average-tGravityAcc-mean()-X
average-tGravityAcc-mean()-Y
average-tGravityAcc-mean()-Z
average-tGravityAcc-std()-X
average-tGravityAcc-std()-Y
average-tGravityAcc-std()-Z
average-tBodyAccJerk-mean()-X
average-tBodyAccJerk-mean()-Y
average-tBodyAccJerk-mean()-Z
average-tBodyAccJerk-std()-X
average-tBodyAccJerk-std()-Y
average-tBodyAccJerk-std()-Z
average-tBodyGyro-mean()-X
average-tBodyGyro-mean()-Y
average-tBodyGyro-mean()-Z
average-tBodyGyro-std()-X
average-tBodyGyro-std()-Y
average-tBodyGyro-std()-Z
average-tBodyGyroJerk-mean()-X
average-tBodyGyroJerk-mean()-Y
average-tBodyGyroJerk-mean()-Z
average-tBodyGyroJerk-std()-X
average-tBodyGyroJerk-std()-Y
average-tBodyGyroJerk-std()-Z
average-tBodyAccMag-mean()
average-tBodyAccMag-std()
average-tGravityAccMag-mean()
average-tGravityAccMag-std()
average-tBodyAccJerkMag-mean()
average-tBodyAccJerkMag-std()
average-tBodyGyroMag-mean()
average-tBodyGyroMag-std()
average-tBodyGyroJerkMag-mean()
average-tBodyGyroJerkMag-std()
average-fBodyAcc-mean()-X
average-fBodyAcc-mean()-Y
average-fBodyAcc-mean()-Z
average-fBodyAcc-std()-X
average-fBodyAcc-std()-Y
average-fBodyAcc-std()-Z
average-fBodyAcc-meanFreq()-X
average-fBodyAcc-meanFreq()-Y
average-fBodyAcc-meanFreq()-Z
average-fBodyAccJerk-mean()-X
average-fBodyAccJerk-mean()-Y
average-fBodyAccJerk-mean()-Z
average-fBodyAccJerk-std()-X
average-fBodyAccJerk-std()-Y
average-fBodyAccJerk-std()-Z
average-fBodyAccJerk-meanFreq()-X
average-fBodyAccJerk-meanFreq()-Y
average-fBodyAccJerk-meanFreq()-Z
average-fBodyGyro-mean()-X
average-fBodyGyro-mean()-Y
average-fBodyGyro-mean()-Z
average-fBodyGyro-std()-X
average-fBodyGyro-std()-Y
average-fBodyGyro-std()-Z
average-fBodyGyro-meanFreq()-X
average-fBodyGyro-meanFreq()-Y
average-fBodyGyro-meanFreq()-Z
average-fBodyAccMag-mean()
average-fBodyAccMag-std()
average-fBodyAccMag-meanFreq()
average-fBodyBodyAccJerkMag-mean()
average-fBodyBodyAccJerkMag-std()
average-fBodyBodyAccJerkMag-meanFreq()
average-fBodyBodyGyroMag-mean()
average-fBodyBodyGyroMag-std()
average-fBodyBodyGyroMag-meanFreq()
average-fBodyBodyGyroJerkMag-mean()
average-fBodyBodyGyroJerkMag-std()
average-fBodyBodyGyroJerkMag-meanFreq()
