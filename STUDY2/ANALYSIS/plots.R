library(lme4)
library(lmerTest) 
library(sjPlot)
library(sjmisc)
library(ggplot2)
library(xtable)
library(stargazer)

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
lmm.data$party <- factor(lmm.data$party)

#lmm.data$fair = factor(lmm.data$fair, labels=c('Very Unfair', 'Unfair','Neutral','Fair','Very Fair')
#lmm.data$trust = as.numeric(lmm.data$trust)
lmm.data$fair = as.numeric((lmm.data$fair))
lmm.data$trust = as.numeric((lmm.data$trust))

# Code candidate party
candid.party = rep(0,nrow(lmm.data))
candid.party = (lmm.data$candidate=="cruz") | (lmm.data$candidate=="trump")
lmm.data = cbind(lmm.data, candid.party)
lmm.data$candid.party <- factor(lmm.data$candid.party, labels=c('democrat','republican')) 

f0 <- lmer(trust ~ is_complex * source * party + (1|worker_id), lmm.data) 
summary(f0)

# plot interaction b/t source and candidate party
interaction.plot(lmm.data$source, lmm.data$is_complex, lmm.data$trust, type="b",
                 trace.label = "Candidate's Party",
                 #leg.bty="o", per2.leg.bg="beige",lwd=2, pch=c(18,24,22), 
                 xlab= "Source",
                 ylab="Trust", 
                 #title="Interaction Between Source and Candidate's Party",
                 cex.lab=1.25, cex.axis=1.25, cex.main=1.25, cex.sub=1.25) 


f1 <- lmer(trust ~ is_complex * source * candid.party * party + (1|worker_id), lmm.data) 
summary(f1)

test <- lmer(trust ~ source * candid.party * party + (1|worker_id), lmm.data) 
summary(test)

#sourceFox                                                               .                         
#sourcenone:candid.partyrepublican                                       *  
#sourceAP:candid.partyrepublican                                         .  
#sourcenone:partyrepublican                                              *   
#is_complexHigh:sourcenone:partyrepublican                               * 
#sourcenone:candid.partyrepublican:partyno_affiliation                   ***
#sourcenone:candid.partyrepublican:partyrepublican                       *  

# plot interaction b/t source and candidate party

lmm.data2 = lmm.data[(lmm.data$source=='Fox') | (lmm.data$source=='CNN'),]
interaction.plot(lmm.data2$source, lmm.data2$candid.party, lmm.data2$trust, type="b",
                trace.label = "Candidate's Party",
                #leg.bty="o", per2.leg.bg="beige",lwd=2, pch=c(18,24,22), 
                xlab= "Source",
                ylab="Trust", 
                #title="Interaction Between Source and Candidate's Party",
                cex.lab=1.25, cex.axis=1.25, cex.main=1.25, cex.sub=1.25) 

# plot interaction b/t source and reader party




############# Analysis w/ Only Fox & CNN ######################
lmm.data2 = lmm.data[(lmm.data$source=='Fox') | (lmm.data$source=='CNN'),]
f2 <- lmer(trust ~ is_complex  * source * candid.party * party + (1|worker_id), lmm.data2) 
summary(f2)
 
############# Analysis w/ Only CNN & AP ######################
lmm.data3 = lmm.data[(lmm.data$source=='CNN') | (lmm.data$source=='AP'),]
f3 <- lmer(trust ~ is_complex  * source * candid.party * party + (1|worker_id), lmm.data3) 
summary(f3)
# sourceAP:candid.partyrepublican                                        -0.46131    0.26824 536.00000  -1.720   0.0861 .  

############# Analysis w/ Only AP & None ######################
lmm.data4 = lmm.data[(lmm.data$source=='none') | (lmm.data$source=='AP'),]
f4 <- lmer(trust ~ is_complex  * source * candid.party * party + (1|worker_id), lmm.data4) 
summary(f4)

#is_complexHigh:partyrepublican                                          0.67647    0.32060 534.20000   2.110 0.035320 *  
#sourceAP:partyindependent_other                                         0.07703    0.51367 264.00000   0.150 0.880908    
#sourceAP:partyno_affiliation                                            0.83190    0.48621 264.00000   1.711 0.088257 .  
#sourceAP:partyrepublican                                                0.80917    0.48208 264.00000   1.679 0.094429 .  
#candid.partyrepublican:partyindependent_other                           0.78560    0.39509 541.40000   1.988 0.047268 *  
#candid.partyrepublican:partyno_affiliation                              1.61029    0.47253 534.20000   3.408 0.000704 ***
#candid.partyrepublican:partyrepublican                                  1.27696    0.32060 534.20000   3.983 7.75e-05 ***
#sourceAP:candid.partyrepublican:partyno_affiliation                    -1.40467    0.56872 534.20000  -2.470 0.013828 * 

############# Analysis w/ Only CNN & None ######################
lmm.data5 = lmm.data[(lmm.data$source=='none') | (lmm.data$source=='CNN'),]
f5 <- lmer(trust ~ is_complex  * source * candid.party * party + (1|worker_id), lmm.data5) 
summary(f5)

# sourcenone:candid.partyrepublican                                        -0.6728     0.2743 534.1000  -2.453 0.014497 *  
#  sourcenone:partyrepublican                                               -0.9357     0.4211 207.2000  -2.222 0.027358 * 
# is_complexHigh:sourcenone:partyrepublican                                 1.0515     0.4522 534.1000   2.325 0.020423 *  
# sourcenone:candid.partyrepublican:partyno_affiliation                     1.9645     0.5776 534.1000   3.401 0.000722 ***
# sourcenone:candid.partyrepublican:partyrepublican                         1.0270     0.4522 534.1000   2.271 0.023531 *  
  
   

############# Collapse disclose / no disclose  ######################
# Code disclose / non disclose
disclose = rep(0,nrow(lmm.data))
disclose = (lmm.data$source %in% c('CNN','Fox','AP'))
lmm.data = cbind(lmm.data, disclose)
lmm.data$disclose<- factor(lmm.data$disclose) 
 
f6 <- lmer(trust ~ is_complex * disclose * candid.party * party + (1|worker_id), lmm.data) 

summary(f6) # sourceAP:candid.partyrepublican *, source Fox .

# plot interaction b/t disclose and candidate party
interaction.plot(lmm.data$disclose, lmm.data$party, lmm.data$trust, type="b",
                 trace.label = "Reader's Party",
                 #leg.bty="o", per2.leg.bg="beige",lwd=2, pch=c(18,24,22), 
                 xlab= "Source",
                 ylab="Trust", 
                 #title="Interaction Between Source and Candidate's Party",
                 cex.lab=1.25, cex.axis=1.25, cex.main=1.25, cex.sub=1.25) 


############# Box Plots  ######################
boxplot(trust~disclose,data=lmm.data, main="Disclosing Source", 
        xlab="Trust Score", ylab="Source Disclosed")

boxplot(trust~candidate,data=lmm.data, main="Trust Scores for Stories About...", 
        xlab="Who is the story about?", ylab="Trust Score (Strongly Disagree, D")
 
#hist(lmm.data$trust,breaks=6)


############# Pretty Latex Tables ######################
detach("package:lmerTest", unload=TRUE)
sessionInfo()
