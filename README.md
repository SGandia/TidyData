# TidyData
Getting and Cleaning Data - Course Project 2

The [run_analysis.R](https://github.com/SGandia/TidyData/blob/master/run_analysis.R) script downloads and cleans a dataset of wearable computing measurements and then provides a separate dataset giving the mean of each variable for each
activity and each subject.   
   
The analysis steps performed by run_analysis.R are detailed below:   
   
1. Load the "plyr", "dplyr", "reshape2" R packages for use in this script   
2. Original data is downloaded from website and unzipped into a folder named "UCI HAR Dataset" in the working directory   
NOTE: The original data and detailed descriptions of the variables and measurements can be found at the following link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip   
3. Two datasets are read into a table representing training data and test data     
4. The datasets are merged into one table
5. An ID column is added to keep track of original data order throughout the analysis   
6. Variable names are read in from the features.txt file provided    
7. Variable names are edited to be more descriptive, correct and/or syntactically correct for R   
8. The descriptive variable names are added to the dataset   
NOTE: I added the variable names to the dataset earlier than called for in the assignment because it seemed much easier to add them while the number of columns from the features.txt file matches the number of columns in the combined dataset   
9. Identify the columns with mean measurements and subset including the ID column    
10. Identify the columns with standard deviation measurements and subset including the ID column   
11. Combine mean and standard deviation datasets back together   
12. Read in activity names from text file provided     
13. Read in and merge the activities data    
14. Add an ID column to keep track of original data order   
15. Add the activity names to the activities dataset    
16. Add the activity names to the dataset   
17. Read in and merge the subject data   
18. Add an ID column to keep track of original data order   
19. Name the columns in the subject dataset   
20. Add the subject IDs to the dataset   
21. Reshape data and summarize by means of each variable     
22. Edit the column names to show that they are now means   
NOTE: An explanation of all the variables in the tidydata.txt file can be found in the [tidy data Code Book](https://github.com/SGandia/TidyData/blob/master/tidydataCodeBook.md)   
23. Write to table to be easily read with R   
NOTE: You can use the following R code to read the table from the working directory:   
```
data <- read.table("tidydata.txt")   
```
From here, you can explore the tidy dataset using R functions like head(), tail(), etc   


