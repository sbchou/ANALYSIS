library(lme4)
library(lmerTest)
library(glmnet)
library(sjPlot)

# Following Cleo's lead, simplifying model to search for effects.
lmm.data <- read.table('../DATA/all_results/flattened_coded.csv', header=TRUE, sep = ",", quote = "'")
nrow(lmm.data)
head(lmm.data)
# remove NaN for some reason the python code breaks the CSV
lmm.data <- lmm.data[complete.cases(lmm.data),]
nrow(lmm.data)
# SHOULD BE 1278!!

lmm.data$is_complex = factor(lmm.data$is_complex, labels=c('Low','High'))
lmm.data$source <- factor(lmm.data$source, labels=c('CNN','Fox','none','AP')) 
lmm.data$gender <- factor(lmm.data$gender)
lmm.data$party <- factor(lmm.data$party)
lmm.data$voting_for <- factor(lmm.data$voting_for)

#lmm.data$fair = factor(lmm.data$fair, labels=c('Very Unfair', 'Unfair','Neutral','Fair','Very Fair')
#lmm.data$trust = as.numeric(lmm.data$trust)
lmm.data$fair = as.numeric((lmm.data$fair))
lmm.data$trust = as.numeric((lmm.data$trust))

# Code candidate party
candid.party = rep(0,nrow(lmm.data))
candid.party = (lmm.data$candidate=="cruz") | (lmm.data$candidate=="trump")
lmm.data = cbind(lmm.data, candid.party)
lmm.data$candid.party <- factor(lmm.data$candid.party, labels=c('democrat','republican')) 

###### FAIRNESS #############
###### Models that don't take into account reader features ################
# First: source, party of candidate, complexity (no party of reader)
f1 <- lmer(fair ~ is_complex * source * candid.party + (1|worker_id), lmm.data) 
summary(f1) # sourceAP:candid.partyrepublican *, source Fox .

f2 <- lmer(fair ~ source * candid.party + is_complex + (1|worker_id), lmm.data) # removes three way interaction
summary(f2) # sourceFox *, sourceAP:candid.partyrepublican .
anova(f1, f2) # don't reject null hypothesis. models similiar. p are not significantly diff

f3 <- lmer(fair ~ source * candid.party + (1|worker_id), lmm.data) # because complexity has no effect on response
summary(f3) # again sourceFox * and sourceAP:candid.partyrepublican .
anova(f2, f3) # 0.5206 no reject H_0




l1 <- lmer(fair ~  is_complex * source* candid.party + (1 | worker_id), lmm.data)
summary(f1)
summary(l1)
# not sure why lmer not giving me same answer.

# Test: no error terms
t1 <- aov(fair ~  is_complex * source* candid.party, data=lmm.data)
summary(t1)
t2 <- lmer(fair ~  is_complex * source* candid.party +  (1 ), data=lmm.data)
summary(t2)
t3 <- lm(fair ~  is_complex * source* candid.party, data=lmm.data)

# Code disclose / non disclose
lmm.data$disclose[lmm.data$source == 'None']= "no source"
lmm.data$disclose[lmm.data$source %in% c('CNN','Fox','AP')]= "show source"
lmm.data$disclose <- factor(lmm.data$disclose) 

# Just show source or no
f2 <- aov(fair ~  is_complex * disclose * candid.party + Error(worker_id/(is_complex*candid.party)), data=lmm.data)
summary(f2)

l2 <- lmer(fair ~   is_complex * disclose  + (1 | worker_id), lmm.data)
summary(l2)




stand1 = rep(0,nrow(lmm.data))
#stand1[lmm.data$party %in% c("independent_other", "no_affiliation")] = 1
stand1[as.character(lmm.data$candid.party) == as.character(lmm.data$party)] = 2
lmm.data = cbind(lmm.data, stand1)
#lmm.data$stand1 <- factor(lmm.data$stand1, labels=c('opposite','neutral','matching')) 
lmm.data$stand1 <- factor(lmm.data$stand1, labels=c('no matching','matching')) 

f <- aov(fair ~  is_complex * source* stand1 + Error(worker_id/(is_complex*stand1)), data=lmm.data)
summary(f)
lmm.data2 = lmm.data
lmm.data2$source <- factor(lmm.data$source, labels=c('democrat','republican','none','neutral')) 

lmm.data2[as.character(lmm.data$source) %in% c('neutral','democrat','republican'),7]= 1
lmm.data2$source[lmm.data$source == 'none']= "not disclose"
lmm.data2$source <- factor(lmm.data$source)

stand2 = rep(0,nrow(lmm.data))
#stand1[lmm.data$party %in% c("independent_other", "no_affiliation")] = 1
stand2[as.character(lmm.data$source) == as.character(lmm.data$party)] = 2
lmm.data = cbind(lmm.data, stand2)
#lmm.data$stand1 <- factor(lmm.data$stand1, labels=c('opposite','neutral','matching')) 
lmm.data$stand2 <- factor(lmm.data$stand2, labels=c('no matching','matching')) 

f <- aov(fair ~  is_complex * stand2* stand1*source + Error(worker_id/(is_complex*stand1*stand2)), data=lmm.data)
summary(f)

with(lmm.data, tapply(fair, list(is_complex, source), mean))
with(lmm.data, tapply(trust, list(is_complex, source), mean))

f <- lmer(fair ~  is_complex * source + (1|worker_id), data=lmm.data)
f <- lmer(fair ~  is_complex * source * party + (1|worker_id), data=lmm.data)
f <- lmer(fair ~  is_complex * source * gender * party * voting_for + (1|worker_id), data=lmm.data)

#with(lmm.data, tapply(trust, list(disclose_source, complexity, source), mean))

#f2 <- lmer(trust ~ disclose_source + (1|worker_id), lmm.data) 
#f <- lmer(trust ~ complexity * source  * disclose_source  + (1|worker_id), lmm.data) 
#f2 <- lmer(trust ~ disclose_source  + (1|worker_id), lmm.data) 
#aov(trust ~ complexity * source * disclose_source  + Error(worker_id/(complexity * source * disclose_source)),data=lmm.data)

# worker_id flesch_code org_coded trust party_coded gender_coded age_coded voting4_coded
# candidate_coded disclose_source