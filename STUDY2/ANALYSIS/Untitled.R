library(lme4)
library(lmerTest)
lmm.data <- read.table("polar_ends.csv", header=TRUE, sep = ",")
head(lmm.data)

#f <- lmer(trust ~ complexity + source  + disclose_source  + (1|worker_id), lmm.data) 
#f2 <- lmer(trust ~ disclose_source + (1|worker_id), lmm.data) 
#f <- lmer(trust ~ complexity * source  * disclose_source  + (1|worker_id), lmm.data) 
#f2 <- lmer(trust ~ disclose_source  + (1|worker_id), lmm.data) 
f <- aov(trust ~ complexity + source + disclose_source  + Error(worker_id/(complexity * source * disclose_source)),data=lmm.data)
#aov(trust ~ complexity * source * disclose_source  + Error(worker_id/(complexity * source * disclose_source)),data=lmm.data)
summary(f)


