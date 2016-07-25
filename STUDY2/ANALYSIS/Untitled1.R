library(lme4)
library(lmerTest)

lmm.data <- read.table('../DATA/all_results/flattened_coded.csv', header=TRUE, sep = ",", quote = "'")
nrow(lmm.data)
head(lmm.data)
# remove NaN for some reason the python code breaks the CSV
lmm.data <- lmm.data[complete.cases(lmm.data),]
nrow(lmm.data)

lmm.data2 <- read.table('../DATA/all_results/flattened_no_title.csv', header=TRUE, sep = ",", quote = "'")
lmm.data2 <- lmm.data2[complete.cases(lmm.data2),]
nrow(lmm.data2)

summary(lmm.data)
summary(lmm.data2)

f1 <- lmer(fair ~ is_complex * source * candid.party + (1|worker_id), lmm.data) 
summary(f1)

f2 <- lmer(fair ~ is_complex * source * candid.party + (1|worker_id), lmm.data2) 
summary(f2)