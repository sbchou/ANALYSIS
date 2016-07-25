###############################################
# By rec of Gary King, use multinomial logit  #
###############################################

library("Zelig")
library("ZeligChoice")
library("MASS")

lmm.data <- read.table('../DATA/all_results/flattened_coded.csv', header=TRUE, sep = ",", quote = "'")
nrow(lmm.data)
head(lmm.data)
lmm.data <- lmm.data[complete.cases(lmm.data),]
nrow(lmm.data)
# SHOULD BE 1278!!

lmm.data$is_complex = factor(lmm.data$is_complex, labels=c('Low','High'))
lmm.data$source <- factor(lmm.data$source, labels=c('CNN','Fox','none','AP')) 
lmm.data$gender <- factor(lmm.data$gender)
lmm.data$party <- factor(lmm.data$party)
lmm.data$voting_for <- factor(lmm.data$voting_for)

# Code candidate party
candid.party = rep(0,nrow(lmm.data))
candid.party = (lmm.data$candidate=="cruz") | (lmm.data$candidate=="trump")
lmm.data = cbind(lmm.data, candid.party)
lmm.data$candid.party <- factor(lmm.data$candid.party, labels=c('democrat','republican')) 

#lmm.data$fair = as.factor((lmm.data$fair))
lmm.data$fair <- factor(lmm.data$fair, ordered = TRUE,
                         levels = c(-2, -1, 0, 1,2))
#lmm.data$trust = as.factor((lmm.data$trust))

##### Let's do an ordinal logit with polr #####
z.out <- polr(fair ~ is_complex *  source * candid.party, data=lmm.data)


##### Let's do an ordinal logit #####
z.out <- zelig(fair ~ is_complex *  source * candid.party,
               model = "ologit", data = lmm.data)
x.out <- setx(z.out)
s.out <- sim(z.out, x = x.out)
summary(s.out)
plot(s.out)





  