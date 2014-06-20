

# Path manipulations for specifying directory raw datasets. 
# NOTE: Please specify the top directory of raw data unzipped to vairable basedir, the default is './UCI HAR Dataset'.
dataset.rel.path <- function(rel.path){
    basedir = "./UCI HAR Dataset"
    file.path(basedir,rel.path)
}


## Q1: Merges the training and the test sets to create one data set
x_train <- read.delim(dataset.rel.path("train/X_train.txt"), sep="", header=F, colClasses="numeric")
subject_train <-  read.delim(dataset.rel.path("train/subject_train.txt"), sep="", header=F, colClasses="factor")
y_train  <- read.delim(dataset.rel.path("train/y_train.txt"), sep="", header=F, colClasses="factor")
x_test <- read.delim(dataset.rel.path("test/X_test.txt"), sep="", header=F, colClasses="numeric")
subject_test <-  read.delim(dataset.rel.path("test/subject_test.txt"), sep="", header=F, colClasses="factor")
y_test <- read.delim(dataset.rel.path("test/y_test.txt"), sep="", header=F, colClasses="factor")

## assert: same number of rows for rbind
# nrow(subject_train) == nrow(y_train) , nrow(subject_train) == nrow(x_train)
# nrow(subject_test) == nrow(y_test) , nrow(subject_test) == nrow(x_test)

train <- cbind(subject_train, y_train, x_train)
test  <- cbind(subject_test, y_test, x_test)

## assert: same number of columns
# ncol(train) == ncol(test)

merged <- rbind(train, test)


## basic titles setup
colnames(merged)[1:2] <- c("subject", "activity")
colnames(merged)[3:563] <- c(1:561)


## Q2: Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.delim(dataset.rel.path("features.txt"), sep="", header=F)
sub.features.mean.and.std <- features[grepl("-mean()|-std()", features$V2),] # column idx
merged.mean.and.std <- merged[, c(1,2,sub.features.mean.and.std$V1+2)]  # +2 due to heading cols 'subject' and 'activity'

# Q3: Uses descriptive activity names to name the activities in the data set
activities <- read.delim(dataset.rel.path("activity_labels.txt"), sep="", header=F)
merged.mean.and.std$activity <-  activities[merged.mean.and.std$activity,2] # CODE_SMELL: via index, not dictionary-alike lookup

## Q4: Appropriately labels the data set with descriptive variable names. 
# ncol(merged.mean.and.std) # 81
colnames(merged.mean.and.std)[3:81] <- as.character(sub.features.mean.and.std$V2) #  starting from 3 due to heading cols 'subject' and 'activity'

## Q5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# ncol(merged)  # 563
colnames(merged)[1:2] <- c("subject", "activity")
colnames(merged)[3:563] <- as.character(features$V2)
average_measures <- aggregate(merged[3:563], by=list(as.factor(merged$subject), as.factor(merged$activity)), mean )
colnames(average_measures)[1:2] <- c("subject", "activity")  # set column names
average_measures$subject <- as.numeric(average_measures$subject)  # convert to number for proper ordering
average_measures$activity <-  activities[as.numeric(average_measures$activity),2] # activity: number to text
average_measures <- average_measures[order(as.numeric(average_measures$subject)),] # order by subject no.
names(average_measures)[3:563]  <- paste( "average", names(average_measures)[3:563] , sep="_" )  # columns name refining


## Save data
if (!file.exists("./data")){
    dir.create("./data")
}  
write.table(merged.mean.and.std, file="./data/meansurements.mean.std.with.subject.activity.csv", row.names = F, sep = ",")
write.table(average_measures, file="./data/average.meansurements.group.by.subject.activity.csv", row.names = F,sep = ",")


## verification of output
#test_merged.mean.and.std <- read.delim("./data/meansurements.mean.std.with.subject.activity.csv", sep=",", header=T)
#test_average_measures <-  read.delim("./data/average.meansurements.group.by.subject.activity.csv", sep=",", header=T)

