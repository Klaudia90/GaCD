# getting data
xtest = read.table('./test/X_test.txt', header = FALSE,stringsAsFactors = F, fill = T)
ytest = read.table('./test/Y_test.txt', header = FALSE,stringsAsFactors = F, fill = T)
subtest = read.table('./test/subject_test.txt', header = FALSE,stringsAsFactors = F, fill = T)
xtrain = read.table('./train/X_train.txt', header = FALSE,stringsAsFactors = F, fill = T)
ytrain = read.table('./train/Y_train.txt', header = FALSE,stringsAsFactors = F, fill = T)
subtrain = read.table('./train/subject_train.txt', header = FALSE,stringsAsFactors = F, fill = T)
features = read.table('./features.txt', header = FALSE,stringsAsFactors = F, fill = T)

# creating vector with columns names
f <- features[,2]
f2 <- c(f, "activity", "subject")

# 1. Merging datasets
test <- cbind( xtest, ytest, subtest)
train  <- cbind( xtrain, ytrain, subtrain)
mergedata <- rbind(test, train)

# giving names to the dataset
colnames(mergedata) <-f2

# 2. Extracts columns
library(dplyr)
final <-select(mergedata, contains("mean"), contains("std"), contains("activity"), contains("subject"), - contains("meanFreq"), - contains("angle"))

# 3. Uses descriptive activity names to name the activities in the data set
oldvalues <-        c(1,2,3,4,5,6)
newvalues <- factor(c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")) 
final$activity <- newvalues[ match(final$activity, oldvalues) ]


# 4.Appropriately labels the data set with descriptive variable names
#I'm sure it is an easier way to achieve this ;)

x <- gsub("-","",names(final))
y <- sub("^t","Time",x)
z <- sub("^f","Frequency",y)
zz <- sub("[()]","",z)
zzz <- sub("[)]","",zz)
z4 <- sub("std","StandardDeviation",zzz)
z5 <- sub("[Mm]ean", "MeanValue",z4)
z6 <- sub("BodyBody", "Body", z5)
z7 <- sub("Acc", "Accelerometer",z6)
z8 <- sub("Gyro", "Gyroscope",z7)
z9 <- sub("^a", "A",z8)
z10 <- sub("^s", "S",z9)

# giving new names to the dataset
colnames(final) <- z10

#5. creating data set with the average of each variable for each activity and each subject
library(plyr)
ddply(final, .(Activity, Subject), numcolwise(mean))

