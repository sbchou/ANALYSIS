library(lme4)
library(lmerTest)
lmm.data <- read.table("../DATA/part1_results/flattened.csv", header=TRUE, sep = ",")
head(lmm.data)

lmm.data$is_complex = factor(lmm.data$is_complex, labels=c('Low','High'))
lmm.data$source <- as.character(lmm.data$source)
lmm.data$source[lmm.data$source == "&nbsp;"] <- 'None'
lmm.data$source <- as.factor(lmm.data$source)
#lmm.data$fair = factor(lmm.data$fair, labels=c('Very Unfair', 'Unfair','Neutral','Fair','Very Fair')
#lmm.data$trust = as.numeric(lmm.data$trust)
lmm.data$fair = as.numeric((lmm.data$fair))

with(lmm.data, tapply(trust, list(disclose_source, complexity, source), mean))




#f <- lmer(fair ~  disclose_source * complexity * source + (1|worker_id), data=lmm.data)

#with(lmm.data, tapply(trust, list(disclose_source, complexity, source), mean))

#f2 <- lmer(trust ~ disclose_source + (1|worker_id), lmm.data) 
#f <- lmer(trust ~ complexity * source  * disclose_source  + (1|worker_id), lmm.data) 
#f2 <- lmer(trust ~ disclose_source  + (1|worker_id), lmm.data) 
#aov(trust ~ complexity * source * disclose_source  + Error(worker_id/(complexity * source * disclose_source)),data=lmm.data)

# worker_id flesch_code org_coded trust party_coded gender_coded age_coded voting4_coded
# candidate_coded disclose_source