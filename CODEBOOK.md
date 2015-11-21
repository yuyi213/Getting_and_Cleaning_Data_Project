# Codebook
Yuyi Cheng      
Nov 21, 2015
## Getting and Cleaning Data Course Project
### Introduction
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 
For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Download file
Data can be downloaded from 

  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
We also need to load necessary packages such as 'plyr'.

### Load data
    #data
    x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
    x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
    #activity number
    y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
    y_test <- read.table('./UCI HAR Dataset/test/y_test.txt')
    #subject
    subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
    subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
    #features
    features <- read.table('./UCI HAR Dataset/features.txt')
    #activity labels
    activity_labels <- read.table('./UCI HAR Dataset/activity_labels.txt')

### Merges the training and the test sets to create one data set.
    x <- rbind(x_train,x_test)
    y <- rbind(y_train,y_test)
    subject <- rbind(subject_train,subject_test)
    dt <- cbind(x, subject, y)
    colnames(dt) <- c(as.vector(features$V2), 'Subject', 'Activity')
    head(dt,3)

### Extracts only the measurements on the mean and standard deviation for each measurement. 
    selected <- grep("mean\\(\\)|std\\(\\)",features$V2,value=TRUE)
    selected <- c(selected, 'Subject', 'Activity')
    dt <- subset(dt, select = selected)
    str(dt)
  
### Uses descriptive activity names to name the activities in the data set
    colnames(activity_labels) <- c('Activity','Activity_Name')
    dt <- merge(activity_labels, dt, by='Activity',all.x=TRUE)
    dt <- select(dt,-Activity)
    dt <- select(dt,Subject,everything())
    str(dt)
    'data.frame':	10299 obs. of  68 variables:
     $ tBodyAcc-mean()-X          : num  0.289 0.278 0.28 0.279 0.277 ...
     $ tBodyAcc-mean()-Y          : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
     ...
     $ Subject                    : int  1 1 1 1 1 1 1 1 1 1 ...
     $ Activity                   : int  5 5 5 5 5 5 5 5 5 5 ...
     
### Appropriately labels the data set with descriptive variable names. 
    names(dt)<-gsub("^t", "time", names(dt))
    names(dt)<-gsub("^f", "frequency", names(dt))
    names(dt)<-gsub("Acc", "Accelerometer", names(dt))
    names(dt)<-gsub("Gyro", "Gyroscope", names(dt))
    names(dt)<-gsub("Mag", "Magnitude", names(dt))
    names(dt)<-gsub("BodyBody", "Body", names(dt))

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    dt <- aggregate(.~Subject+Activity_Name,dt,mean)
    head(dt)
    if(file.exists('tidydt.txt')){
      unlink('tidydt.txt')
    }
    write.table(dt, 'tidydt.txt',row.name = F)
