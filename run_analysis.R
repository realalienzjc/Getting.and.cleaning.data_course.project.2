# Q1: Merges the training and the test sets to create one data set
x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", sep="", header=F, colClasses="numeric")
subject_train <-  read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="", header=F, colClasses="factor")
y_train  <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep="", header=F, colClasses="factor")

x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", sep="", header=F) # -454
subject_test <-  read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="", header=F, colClasses="factor")
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep="", header=F, colClasses="factor")

train <- cbind(subject_train, y_train, x_train)
test  <- cbind(subject_test, y_test, x_test)

merged <- rbind(train, test)

# 1.4662419E461494e-001

# optional: basic titles
colnames(merged)[1:2] <- c("subject", "activity")
colnames(merged)[3:563] <- c(1:561)

# Q2: Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.csv("./UCI HAR Dataset/features.txt", sep="", header=F)
sub.features.mean.and.std <- features[grepl("-mean()|-std()", features$V2),] # column idx
merged.mean.and.std <- merged[, c(1,2,sub.features.mean.and.std$V1+2)]  # +2 due to heading cols 'subject' and 'activity'

# Q3: Uses descriptive activity names to name the activities in the data set
activities <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep="", header=F)
merged.mean.and.std$activity <-  activities[merged.mean.and.std$activity,2] # CODE_SMELL: via index, not dictionary-alike lookup

# Q4: Appropriately labels the data set with descriptive variable names. 
ncol(merged.mean.and.std) # 81
colnames(merged.mean.and.std)[3:81] <- as.character(sub.features.mean.and.std$V2) #  starting from 3 due to heading cols 'subject' and 'activity'

# Q5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
ncol(merged)
colnames(merged)[1:2] <- c("subject", "activity")
colnames(merged)[3:563] <- as.character(features$V2)
average_measures <- aggregate(merged, by=list(as.factor(merged$subject), as.factor(merged$activity)), mean )



# ---------------------------------------------------------------------------------------------------------


library(plyr)
average_measures <- ddply(merged, .(subject, activity), mean)


levels(as.factor(merged.mean.and.std$subject))
levels(as.factor(merged.mean.and.std$activity))

activities[1,1]
rows.test <- nrow(x_test)
cols.test <- ncol(x_test)
for(j in 1:rows.test){
        for ( i in 1:cols.test ) {
                if ( !is.numeric(x_test[j,i]) ){
                        print(sprintf("%d, %d",j,i));
                }
        }
}



# --------------------------------------

library(stringr)


#1. Merges the training and the test sets to create one data set.
# read file 
train.lines <- readLines("./UCI HAR Dataset/train/X_train.txt")
test.lines <- readLines("./UCI HAR Dataset/test/X_test.txt")
# process one line at a time
str.to.numbers <- function(str){
        b <- str_split(str, " ")
        c <- b[[1]]    # str_split returns a list, only the first one is of interest. 
        d <- c[c!=""]  # remove empty slot
        as.numeric(d)  # fix data type
}
# generate clean data
# NOTE: because cbind produces list inside matrix, it's hard for later processing. Thus interation is used.
a <- lapply(train.lines, str.to.numbers))

b <- as.data.frame(a)


cleaned.test.data <- c()
for (elem in a){
        cleaned.test.data <- rbind(cleaned.test.data, aelem)
}


cleaned.test.data <- data.frame( lapply(test.lines, str.to.numbers) )  
# TODO: there is warning msg, locate the problems







# ----------  preemption, check "wc -l" and data readed.
# return a data frame
readFromFile <- function(path){
        d <- read.csv(path, sep="  ", strip.white=T, blank.lines.skip=T, header=F, colClasses="character")
        d
} 

train_data <- readFromFile("./UCI HAR Dataset/train/X_train.txt")
train_activity <- readFromFile("./UCI HAR Dataset/train/y_train.txt")

test_data <- readFromFile("./UCI HAR Dataset/test/X_test.txt")
test_activity <- readFromFile("./UCI HAR Dataset/test/y_test.txt")
# the difference is number of of columns
nrow(train_data)   # 662
nrow(test_data)    # 667
# step: expand train_data to allow merge
train_data[663:667] = NA
# step: merge
merged_data <- rbind(train_data, test_data)