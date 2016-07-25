# Look at trump voters and then those who aren't. Do you still see claims of unfair treatment of trump?

library(lme4)
library(lmerTest)
lmm.data <- read.table("../DATA/all_results/flattened_no_title.csv", header=TRUE, sep = ",", quote = "'")
nrow(lmm.data)
head(lmm.data)

# drop NaN's
lmm.data <- lmm.data[complete.cases(lmm.data),]
nrow(lmm.data)

#label levels
lmm.data$is_complex = factor(lmm.data$is_complex, labels=c('Low','High'))
lmm.data$source <- factor(lmm.data$source, labels=c('CNN','Fox','None','AP')) 
lmm.data$gender <- factor(lmm.data$gender)
lmm.data$party <- factor(lmm.data$party)
lmm.data$voting_for <- factor(lmm.data$voting_for)

# Overall:
with(lmm.data, tapply(trust, list(is_complex, candidate), mean))
with(lmm.data, tapply(fair, list(is_complex, candidate), mean))

with(lmm.data, tapply(trust, list(candidate, source), mean))
with(lmm.data, tapply(fair, list(candidate, source), mean))