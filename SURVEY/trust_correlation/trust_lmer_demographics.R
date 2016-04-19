library(lme4)
library(lmerTest)
lmm.data <- read.table("trust.csv", header=TRUE, sep = ",")
head(lmm.data)

lmm.data$complexity = factor(lmm.data$complexity, labels=c('Low','Medium','High'))
lmm.data$source = factor(lmm.data$source, labels=c('CNN', 'Fox News', 'The New York Times', 'The Wall Street Journal', 'the Associated Press'))
lmm.data$disclose_source = factor(lmm.data$disclose_source,labels=c('Not Disclose', 'Disclose'))
lmm.data$trust = as.numeric(lmm.data$trust)


f <- lmer(trust ~  disclose_source * complexity * source + (1|worker_id), data=lmm.data)

with(lmm.data, tapply(trust, list(disclose_source, complexity, source), mean))

#f2 <- lmer(trust ~ disclose_source + (1|worker_id), lmm.data) 
#f <- lmer(trust ~ complexity * source  * disclose_source  + (1|worker_id), lmm.data) 
#f2 <- lmer(trust ~ disclose_source  + (1|worker_id), lmm.data) 
#aov(trust ~ complexity * source * disclose_source  + Error(worker_id/(complexity * source * disclose_source)),data=lmm.data)

# worker_id flesch_code org_coded trust party_coded gender_coded age_coded voting4_coded
# candidate_coded disclose_source