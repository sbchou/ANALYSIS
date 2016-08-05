from scipy.stats import fisher_exact
from mutualInformation import bayesianMutualInformaton, bayesianPointwiseMutualInformaton
import numpy

def fisherportrait(userstat, jointstat, verbose = False):
    """
    "portrait" of a person or group of people by their most statistically peculiar words. 
    
    Inputs:
    userstat - dictionary of counts of words in tweets of target user (or group)
    jointstat - dictionary of counts of words in everyone tweets
    verbose - if True, adds frequencies and counts to the output (useful for debugging)
    
    Returns:
        - The list of pairs (word, Fisher's p-value) if verbose = False
        - The list of tuples (word, frequency by user, frequency by everyone else, count by user, count by everyone else, Fisher's p-value) if verbose = True
        
    where Fisher's p-value is computed using Fisher's exact test and estimates from counts the probability that random variables 
    'word is particular word' and 'word is produced by user' are independent
    """
    pvalues = []
    userTotal = sum(userstat.values())
    allTotal = sum(jointstat.values())
    elseuserTotal = allTotal - userTotal
    for word, userCount in userstat.items():
        userElsecount = userTotal - userCount
        elseuserCount = jointstat[word] - userCount
        elseuserElsecount = elseuserTotal - elseuserCount
        userFreq = float(userCount) / float(userTotal)
        elseFreq = float(elseuserCount) / float(elseuserTotal)
        if userFreq < elseFreq:
            continue
        #if min((userCount, elseuserCount, userElsecount, elseuserElsecount)) < 10:
        _, pvalue = fisher_exact(((userCount,     elseuserCount),
                                  (userElsecount, elseuserElsecount)))
        #else:
        #    _, pvalue = chisquare(f_obs = (userCount, userElsecount), f_exp = (elseuserCount, elseuserElsecount), ddof=1)
        if verbose:
            pvalues.append((word, userFreq, elseFreq, userCount, elseuserCount, pvalue))
        else:
            pvalues.append((word, pvalue))
    return pvalues

def miportrait(userstat, jointstat, verbose = False):
    """
    Mutual information "portrait" of a person or group of people. 
    
    Inputs:
    userstat - dictionary of counts of words in tweets of target user (or group)
    jointstat - dictionary of counts of words in everyone tweets
    verbose - if True, adds frequencies and counts to the output (useful for debugging)
    
    Returns:
        - The list of pairs (word, mutual information) if verbose = False
        - The list of tuples (word, frequency by user, frequency by everyone else, count by user, count by everyone else, mutual information) if verbose = True
    """
    mis = []
    userTotal = sum(userstat.values())
    everyTotal = sum(jointstat.values())
    elseTotal = everyTotal - userTotal
    for word, userCount in userstat.items():
        elseCount = jointstat[word] - userCount
        userfreq = float(userCount) / userTotal
        elsefreq = float(elseCount) / elseTotal
        if userfreq < elsefreq:
            continue
        mi = bayesianMutualInformaton(((userCount,             elseCount),
                                       (userTotal - userCount, elseTotal - elseCount)))
        if verbose:
            mis.append((word, userfreq, elsefreq, userCount, elseCount, mi))
        else:
            mis.append((word, mi))
    return mis

def miportraitNumpy(statIterator, jointstat):
    """
    Mutual information "portrait" of a person or group of people - numpy version. 
    
    Inputs:
    statIterator - iterator, where each returned element is (id, selectedIndices as numpy.array(dtype = int), counts as numpy.array)
    jointstat - counts of words in everyone tweets
    
    Yields:
        - The list (id, positivelyCorrelatedWords, mutualInformation as numpy.array(dtype = float))
    """
    everyTotal = float(numpy.sum(jointstat))
    aveFreqs = jointstat / everyTotal
    for i, selected, counts in statIterator:
        iTotal = float(numpy.sum(counts))
        userFreqs = counts / iTotal
        freqFilter = userFreqs > aveFreqs[selected]
        selected = selected[freqFilter]
        counts = counts[freqFilter]
        elseTotal = everyTotal - iTotal
        elseCounts = jointstat[selected] - counts
        mi = bayesianMutualInformaton(((counts,          elseCounts),
                                       (iTotal - counts, elseTotal - elseCounts)))
        yield (i, selected, mi)
        
def miportraitNumpySigned(statIterator, jointstat):
    """
    Mutual information "portrait" of a person or group of people - numpy version. 
    
    Inputs:
    statIterator - iterator, where each returned element is (id, selectedIndices as numpy.array(dtype = int), counts as numpy.array)
    jointstat - counts of words in everyone tweets
    
    Yields:
        - The list (id, positivelyCorrelatedWords, mutualInformation as numpy.array(dtype = float))
    """
    everyTotal = float(numpy.sum(jointstat))
    aveFreqs = jointstat / everyTotal
    for i, selected, counts in statIterator:
        iTotal = float(numpy.sum(counts))
        elseTotal = everyTotal - iTotal
        userFreqs = counts / iTotal
        mi = numpy.zeros(len(selected), dtype = numpy.float)
        freqFilterPlus  = userFreqs > aveFreqs[selected]
        freqFilterMinus = userFreqs <= aveFreqs[selected]
        for sign, freqFilter in ((1, freqFilterPlus), (-1, freqFilterMinus)):
            selectedA = selected[freqFilter]
            countsA = counts[freqFilter]
            elseCountsA = jointstat[selectedA] - countsA
            miA = bayesianMutualInformaton(((countsA,           elseCountsA),
                                           (iTotal - countsA,   elseTotal - elseCountsA)))
            mi[freqFilter] = sign * miA
        yield (i, selected, mi)
        
def pmiportraitNumpy(statIterator, jointstat):
    """
    Mutual information "portrait" of a person or group of people - numpy version. 
    
    Inputs:
    statIterator - iterator, where each returned element is (id, selectedIndices as numpy.array(dtype = int), counts as numpy.array)
    jointstat - counts of words in everyone tweets
    
    Yields:
        - The list (id, positivelyCorrelatedWords, mutualInformation as numpy.array(dtype = float))
    """
    everyTotal = float(numpy.sum(jointstat))
    #aveFreqs = jointstat / everyTotal
    for i, selected, counts in statIterator:
        iTotal = float(numpy.sum(counts))
        #userFreqs = counts / iTotal
        #freqFilter = userFreqs > aveFreqs[selected]
        #selected = selected[freqFilter]
        #counts = counts[freqFilter]
        elseTotal = everyTotal - iTotal
        elseCounts = jointstat[selected] - counts
        mi = bayesianPointwiseMutualInformaton(((counts,          elseCounts),
                                               (iTotal - counts, elseTotal - elseCounts)))
        yield (i, selected, mi)
