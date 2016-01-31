##  Getting and Cleaning Data
##  Course project

##  Step 1 - download zip file and extract files
setwd("C:/Users/Home/Documents/Dad/Coursera/Getting Cleaning Data")

if (!file.exists("data")) {
    dir.create("data")
}

## Code should run as long as Samsung data is in the working directory

## PART 1 - MERGE TRAINING AND TEST DATA
## =====================================

## Load the train data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt", header=FALSE)
subj_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)


## Load the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt", header=FALSE)
subj_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)


## Load the label data
lbl_feat <- read.table("./data/UCI HAR Dataset/features.txt", header=FALSE)
lbl_actv <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header=FALSE)

## create column names in the data frames

feat_names <- t(lbl_feat)
colnames(x_test) <- feat_names[2,]
colnames(x_train) <- feat_names[2,]

colnames(y_train) <- c("Activity")
colnames(subj_train) <- c("Subject")
colnames(y_test) <- c("Activity")
colnames(subj_test) <- c("Subject")


## Replace activity codes with the activity names

y_test$Activity[y_test$Activity == "1"] <- "WALKING"
y_test$Activity[y_test$Activity == "2"] <- "WALKING_UPSTAIRS"
y_test$Activity[y_test$Activity == "3"] <- "WALKING_DOWNSTAIRS"
y_test$Activity[y_test$Activity == "4"] <- "SITTING"
y_test$Activity[y_test$Activity == "5"] <- "STANDING"
y_test$Activity[y_test$Activity == "6"] <- "LAYING"


y_train$Activity[y_train$Activity == "1"] <- "WALKING"
y_train$Activity[y_train$Activity == "2"] <- "WALKING_UPSTAIRS"
y_train$Activity[y_train$Activity == "3"] <- "WALKING_DOWNSTAIRS"
y_train$Activity[y_train$Activity == "4"] <- "SITTING"
y_train$Activity[y_train$Activity == "5"] <- "STANDING"
y_train$Activity[y_train$Activity == "6"] <- "LAYING"

## add the subject and activity to the main data frames
temp_test <- cbind(x_test, y_test)
test_data <- cbind(temp_test, subj_test)

temp_train <- cbind(x_train, y_train)
train_data <- cbind(temp_train, subj_train)

## merge the data to create one data set
all_data <- rbind(test_data, train_data)
rm("temp_test")
rm("temp_train")

## select measurements of mean and standard deviation
slct_data <- all_data[, c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241,
                          253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543, 562:563)]
                

##  CREATE THE INDEPENDENT TIDY DATA SET
##  ====================================
itds <- slct_data %>% group_by(Activity, Subject) %>% summarise_each(funs(mean))

## write the tidy data set to a txt file
write.table(itds, file = "itds.txt", row.name=FALSE)

