library(lme4)
library(lmerTest)
library(stargazer)
library(xtable)
library(texreg)

library(MASS)
library(AER)

data <- read.table('../DATA/all_results/flattened_no_title.csv', header=TRUE, sep = ",", quote = "'")
nrow(data)
head(data)
# remove NaN for some reason the python code breaks the CSV
data <- data[complete.cases(data),]
nrow(data)
# SHOULD BE 1278!!

data$reading_level = factor(data$is_complex) #, labels=c('Low','High'))
data$source <- factor(data$source, labels=c('CNN','Fox','None','AP')) 
data$party <- factor(data$party)
data$voting_for <- factor(data$voting_for)
data$trust = as.numeric((data$trust))

# Code candidate party
candid.party = rep(0,nrow(data))
candid.party = (data$candidate=="cruz") | (data$candidate=="trump")
data = cbind(data, candid.party)
data$candid.party <- factor(data$candid.party, labels=c('democrat','republican')) 

### First, Reading Level Effects: easy, we can't find any. ###
model.lm.reading_level <- lm(trust ~ reading_level, data)
summary(model.lm.reading_level)
stargazer(model.lm.reading_level)


### Media Brand Effects ###
model.lm.source <- lm(trust ~ source, data)
summary(model.lm.source)
stargazer(model.lm.source)

# Code disclose / non disclose
data$disclose[data$source == 'None']= "no source"
data$disclose[data$source %in% c('CNN','Fox','AP')]= "show source"
data$disclose <- factor(data$disclose) 

model.lm.disclose <- lm(trust ~ disclose, data)
summary(model.lm.disclose)
stargazer(model.lm.disclose)
 
######### Hostile Media Effects ##########
model.lm.sourceparty <- lm(trust ~ disclose * party, data)
summary(model.lm.sourceparty)
#stargazer(model.lm.sourceparty)

partisans <- read.table('../DATA/all_results/partisans_match.csv', header=TRUE, sep = ",", quote = "'")
nrow(partisans)
head(partisans)
# remove NaN for some reason the python code breaks the CSV
partisans <- partisans[complete.cases(partisans),]
nrow(partisans) 

partisans$trust = as.numeric((partisans$trust))
partisans$match = factor(partisans$match, labels = c('Neutral', 'Disagree', 'Agree')) 

model.lm.match <- lm(trust ~ match, data=partisans)
summary(model.lm.match)

stargazer(model.lm.match)

part

