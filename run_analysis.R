## Getting and Cleaning Data Project
# load data
if(!file.info('UCI HAR Dataset')$isdir){
  temp <- tempfile()
  url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url,temp)
  file <- unzip(temp)
  unlink(temp)
  date_download <- date()
}
library(plyr)
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

#1.Merges the training and the test sets to create one data set.
x <- rbind(x_train,x_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)
dt <- cbind(x, subject, y)
colnames(dt) <- as.vector(features$V2), 'Subject', 'Activity')
head(dt,3)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
selected <- grep("mean\\(\\)|std\\(\\)",features$V2,value=TRUE)
selected <- c(selected, 'Subject', 'Activity')
dt <- subset(dt, select = selected)
str(dt)

#3.Uses descriptive activity names to name the activities in the data set
colnames(activity_labels) <- c('Activity','Activity_Name')
dt <- merge(activity_labels, dt, by='Activity',all.x=TRUE)
dt <- select(dt,-Activity)
dt <- select(dt,Subject,everything())
str(dt)

#4.Appropriately labels the data set with descriptive variable names. 
names(dt)<-gsub("^t", "time", names(dt))
names(dt)<-gsub("^f", "frequency", names(dt))
names(dt)<-gsub("Acc", "Accelerometer", names(dt))
names(dt)<-gsub("Gyro", "Gyroscope", names(dt))
names(dt)<-gsub("Mag", "Magnitude", names(dt))
names(dt)<-gsub("BodyBody", "Body", names(dt))

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
str(dt)
dt <- aggregate(.~Subject+Activity_Name,dt,mean)
head(dt)
if(file.exists('tidydt.txt')){
  unlink('tidydt.txt')
}
write.table(dt, 'tidydt.txt',row.name = F)
