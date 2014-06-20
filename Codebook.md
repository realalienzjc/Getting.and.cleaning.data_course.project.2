
### Notice

* The data files and related materials here are only for demonstrating personal course project, not intended to be reused in other statistical researches.   

* No warrant about the authenticity of the content of the data files. The author will not be responsible for any damage or loss caused by using these data files.

* Some of the content is copied from the codebook of the raw data sets in order to demonstrate proper content for a codebook of data procesing flow without referring too much information to other texts or links. 

* Nouns like 'variables', 'measurements',et al. should be interpreterred as common name about the data or the statistics, not as computer science jargon. Without explicit explanations, 'variables' and 'measurement' are interchangeable when referring to the data.


* The author can be reached via email neilalaer@gmail.com. Any suggestion or advice is welcome.



### The experiment and the raw data sets


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


The raw datasets are not included in this project due to the size of files. One can download from [here](<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>). The experiment described above is also mentioned in the README.md enclosed.

The variables of the raw data sets are described respectively among files, which are enclosed in the zipped file.


### Processing Steps


   (Optional) validate the data after reading into columns, check for NAs.


1. Combine seperate train/test raw data set into one data frame
	* Validate if same number of observation in order to do cbind.
	* Combine data. The experiment recording and subject(the volunteers) are in the X_train.txt and y_train.txt respectively, so cbind(x,...) is used, this also applies to test raw data(X_test.txt and y_test.txt). The 'subject' is put at the leftmost, next comes the 'activity', and then followed by the other 561 features (variables).
	* After combining subject and recordings, validate both train data and test share the same length of columns in order to rbind them.
	* Use rbind(x,...) to combined.
	* NOTE: Because there is a bad-formatted recording in the raw data file X_test.txt(line 454, column 375, "1.4662419E461494e-001"), when reading from file, colClasses="numeric" is ignored to avoid process abort. When reading without specifying 'colClasses', that recording is implicitly intepretered as something like '1.46624-001', reasonable enough to accept.   
	
2.  Assign basic colnames to easier column-referencing.   
	* After combining, the colnames of the data frame will look like "V1, V1, V1, V2, ....", so "subject" and "activity" is assigned to the names of the leftmost two columns, then use number 1 to 561 for the next 561 variables.  
	
	
3.  Extracts only the measurements on the mean and standard deviation for each measurement.
	* One way to extract the target measurement is to collect a vector of sequence numbers of the features from file 'features.txt', then use that vector to select the target measurements.
	* NOTE: Because there are two columns (subject and activity) at the leftmost in the combined data, to correctly select columns, the vector elements should plus two for indexing the tareget columns. 
	* To select target features from file 'features.txt', use grepl() as conditions. A new data frame containing  selected features (numbers and names) is generated
	* NOTE: Because 'mean' text appears in "fBodyAcc-meanFreq()-X" and "fBodyAcc-mean()-X", use "-mean()" with hyphen and parenthesis included to avoid unwanted features.


4. Uses descriptive activity names to name the activities in the data set.
	* Activity names(WALKIING, SITTING, etc) are listed in activity_labels.txt, after reading into a data frame, the row.names and sequence numbers are the same, so the activity names can be retrieved by specifying [row,column]. Changed the activity names from number to text.
	
5. Appropriately labels the data set with descriptive variable names. 
	* From step 3, a new data frame with selected features are included. The names vectors can be used for descriptive variable names.
	
6. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	* From step 1, the column names of the combined data is not descriptive, use features vectors generated in Step 3 for updating. The leftmost two columns named 'subject' and 'activity'.
	* Use aggregate(x,by="",...) to aggregate the data by columns 'subject' and 'activity'. Calculate the average for each measurements.
	* Replace group.name with 'subject' and 'activity' names.
	* Aggragation of data will make 'subject' column as character type, observations of one subject(voluteer) are not consecutive, so converting the subject to numeric for ordering.
	* Replace the column names of each feature to express the mean(...) result. 'Average_<feature_name>' is used.

7. Saved data.


### Data Files

- Total 2 data files are generated after executing run_analysis.R.

- Each observation is in a seperate row, data is separated by comma. 


#### 1. data/meansurements.mean.std.with.subject.activity.csv

nrow : 10299  
ncol : 81   
column names:  "subject", "activity", 561 features mentioned in features.txt of raw data set.


#### 2. data/average.meansurements.group.by.subject.activity.csv

nrow : 180  
ncol : 563   
column names:  "subject", "activity", 561 features mentioned in features.txt of raw data set.


