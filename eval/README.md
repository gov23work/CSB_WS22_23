# CSB_WS22_23 Evaluation

## Getting Started
Line 10 of every file needs to point to the data you want to analzye. Average contains the average of the other 3 data files, which can be better seen in the Excel Workbook.  
Line 28 needs to be adjusted for the different graphs, as the function takes the extra metrics as a parameter. Therefore, acceptable values for the function are 0, 1000, 10000, and 100000.  
Each data point seen here is the average of at least 120 data points. For scrape duration, the amount of data points depended on the amount of node exporters, as their scrape duration was averaged over all exporters. Therefore, for scrape duration up to 840 data points were considered