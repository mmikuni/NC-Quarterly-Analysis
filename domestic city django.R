library(reshape2)
library(ggplot2)
library(plyr)

#used django for each month and searched by "Date Occurred"
#delete blank rows - http://www.techrepublic.com/blog/microsoft-office/a-quick-way-to-delete-blank-rows-in-excel/
city2014q3 <- read.csv("DomesticAlerts2014Q3.csv", header = TRUE, stringsAsFactors = FALSE)
city2014q4 <- read.csv("DomesticAlerts2014Q4.csv", header = TRUE, stringsAsFactors = FALSE)

#combine City and State with ',' separator to make sure cities with same name aren't merged
city2014q3$citystate <- paste(city2014q3$City, city2014q3$State, sep = ", ")
city2014q4$citystate <- paste(city2014q4$City, city2014q4$State, sep = ", ")

#counts the number of incidents for each citystate value
citytable2014q3 <- data.frame(table(city2014q3$citystate))
citytable2014q4 <- data.frame(table(city2014q4$citystate))

#merging two data frames, all = TRUE makes sure all values in both dfs are preserved
merged2014Q3Q4 <- merge(citytable2014q3, citytable2014q4, by = c("Var1"), all = TRUE)

#replacing all NA values with 0
merged2014Q3Q4[is.na(merged2014Q3Q4)] <- 0

#subtracting Q4 from Q3 to get quarterly change
merged2014Q3Q4$Change <- (merged2014Q3Q4$Freq.y - merged2014Q3Q4$Freq.x)

merged2014Q3Q4$Total <- (merged2014Q3Q4$Freq.y + merged2014Q3Q4$Freq.x)

colnames(merged2014Q3Q4) <- c("City and State", "2014 Q3", "2014 Q4", "Change", "Total")

library(xlsx)
write.xlsx(merged2014Q3Q4, "merged2014Q3Q4.xlsx")

View(arrange(merged2014Q3Q4, Change))
View(arrange(merged2014Q3Q4, -Change))
View(arrange(merged2014Q3Q4, -Total))