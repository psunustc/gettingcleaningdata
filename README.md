---
title: "Explanation of the R Code"
author: "peng"
date: "September 13, 2014"
output: html_document
---

Line 2-4: download the data, which is commented.

Line 5: check if the data set is in the current working directory. If not, the program will stop.

Line 8-9: load and bind subject ID data from train/ and test/.

Line 12-13: load and bind the activity label data from both train/ and test/

Line 14: rename the activities

Line 16: change activity labels to character names

Line 19: get the names of features

Line 20: find the index of the names with mean() or std() or angle(*) (* means any string) in the 
feature list

Line 21: get the extracted names from the feature list

Line 22-23: load and combine the features from train/ and test/, only with the wanted features

Line 26: bind all the target data together

Line 29-50: use regular expression to change all the feature names to the descriptive column names 
for the data frame

Line 52: add the front 2 column names to the column name list

Line 55: from the full extracted data, for the first two columns, pick up the unique ones and form a new data frame

line 56: split the rest columns by the first two columns and form a list such that each element in the list is a data frame of all the measurements (mean and std) for each activity for each subject

Line 57: for each data frame in the list, apply column mean. And then transform the new list of vectors of means for each measurement back to the data frame with the right row dimensions as the data frame from Line 55

Line 58: column bind the above two data frames to form the final tidy data set

Line 59: write the tidy data set out to a file called "tidydata.txt" without row names