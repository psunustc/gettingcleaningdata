Run_analysis<-function(){
    # url <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    # download.file(url = url, destfile = "./data.zip", method = "curl")
    # unzip("./data.zip", exdir="./")
    if(! "./UCI HAR Dataset" %in% list.dirs(".", recursive = F))stop("Can't find the Samsung dataset!")
    # step 2,3: load and extract
    ##subject data
    subjectID <- rbind(read.table("UCI HAR Dataset/train/subject_train.txt"), 
                       read.table("UCI HAR Dataset/test/subject_test.txt"))
    
    ##activity data
    activityID <- rbind(read.table("UCI HAR Dataset/train/y_train.txt"), 
                        read.table("UCI HAR Dataset/test/y_test.txt"))
    activityTable <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
    ##rename activities
    activities <- lapply(activityID, function(x) {activityTable[x]})[[1]]
    
    ##feature data
    varnames <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors =F)[,2]
    varnameIndex <- grep(pattern = 'mean()|std()|angle(*)', x = varnames)
    varnames <- varnames[varnameIndex]
    features <- rbind(read.table("UCI HAR Dataset/train/X_train.txt"),
                      read.table("UCI HAR Dataset/test/X_test.txt"))[,varnameIndex]
    
    # step 1: merge
    data <- cbind(subjectID, activities, features, stringsAsFactors = F)
    
    # step 4: name columns
    varnames <- gsub(pattern='tB', replacement = 'Time.Domain.B', varnames)
    varnames <- gsub(pattern='fB', replacement = 'Frequency.Domain.B', varnames)
    varnames <- gsub(pattern='tG', replacement = 'Time.Domain.G', varnames)
    varnames <- gsub(pattern='Acc', replacement = '.Acceleration', varnames)
    varnames <- gsub(pattern='Jerk', replacement = '.Jerk', varnames)
    varnames <- gsub(pattern='Mag', replacement = '.Magnitude', varnames)
    varnames <- gsub(pattern='Gyro', replacement = '.Angular', varnames)
    varnames <- gsub(pattern='),', replacement = ',', varnames)
    varnames <- gsub(pattern='-', replacement = '', varnames)
    varnames <- gsub(pattern='mean\\(\\)', replacement = '.In.Average', varnames)
    varnames <- gsub(pattern='Mean', replacement = '.In.Average', varnames)
    varnames <- gsub(pattern='std\\(\\)', replacement = '.In.Standard.Deviation', varnames)
    varnames <- gsub(pattern='X', replacement = '.In.X', varnames)
    varnames <- gsub(pattern='Y', replacement = '.In.Y', varnames)
    varnames <- gsub(pattern='Z', replacement = '.In.Z', varnames)
    varnames <- gsub(pattern='meanFreq\\(\\)', replacement = '.In.Average.Frequency', varnames)
    varnames <- gsub(pattern=',', replacement = '.And', varnames)
    varnames <- gsub(pattern='gravity', replacement = '.Gravity', varnames)
    varnames <- gsub(pattern='angle\\(', replacement = 'Angle.Between', varnames)
    varnames <- gsub(pattern='\\)', replacement = '', varnames)
    varnames <- gsub(pattern='BetweenTime', replacement = 'Between.Time', varnames)
    varnames <- gsub(pattern='Between.In', replacement = 'Between', varnames)
    
    names(data) <- c("SubjectID", "Activities", varnames)
    
    # step 5: average
    rownames <- unique(data[order(data[,1], data[,2]),][c(1,2)])
    tidydata <- split(data[-c(1,2)], list(data[,1], data[,2]), drop=T)
    tidydata <- as.data.frame(t(as.matrix(as.data.frame(lapply(tidydata, colMeans)))))
    tidydata <- cbind(rownames, tidydata)
    names(tidydata) <- c("SubjectID", "Activities", varnames)
    write.table(x = tidydata, file = "tidydata.txt", row.name = FALSE)
}