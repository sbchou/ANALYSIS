library(psych)
library(lme4)
library(lmerTest)

lmm.data <- read.table('../DATA/all_results/flattened_no_title.csv', header=TRUE, sep = ",", quote = "'")
nrow(lmm.data)
head(lmm.data)
# remove NaN for some reason the python code breaks the CSV
lmm.data <- lmm.data[complete.cases(lmm.data),]
nrow(lmm.data)

scores = lmm.data[,c("trust","fair")]

trust = data.frame(lmm.data$trust)
fairness = data.frame(lmm.data$fair)

t.test(lmm.data$trust, lmm.data$fair)
wilcox.test(lmm.data$trust, lmm.data$fair)
