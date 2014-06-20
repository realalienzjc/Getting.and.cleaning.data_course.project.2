
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
# NOTE: because cbind produces list inside matrix, its hard for later processing. Thus interation is used.
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


}'
