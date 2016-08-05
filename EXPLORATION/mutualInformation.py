import numpy

def bayesianMutualInformaton(countsIJ):
    """
    Computes a Bayesian estimate of mutual information between two Bernoulli variables based on counts.

    The formula used is taken from Hutter M. (2001) Distribution of Mutual Information.
    
    Inputs:
        countsIJ - the counts (where i, j are from {0, 1} - the possible values of the variables)
    Returns:
        - the expected mutual information, based on counts, assuming uniform priors
    """
    ((c00, c01), (c10, c11)) = countsIJ
    n = c00 + c01 + c10 + c11 + 4
    n = n.astype(numpy.float) if isinstance(n, numpy.ndarray) else float(n)
    nij = ((c00 + 1, c01 + 1), (c10 + 1, c11 + 1))
    niplus = (nij[0][0] + nij[1][0], nij[0][1] + nij[1][1])
    njplus = (nij[0][0] + nij[0][1], nij[1][0] + nij[1][1])
    return sum((nij[j][i] / n) * (numpy.log(nij[j][i] * n) - numpy.log(niplus[i]*njplus[j])) for i in (0, 1) for j in (0, 1)) + 0.5 / n

def bayesianPointwiseMutualInformaton(countsIJ):
    """
    Computes a Bayesian estimate of mutual information between two Bernoulli variables based on counts.

    The formula used is taken from Hutter M. (2001) Distribution of Mutual Information.
    
    Inputs:
        countsIJ - the counts (where i, j are from {0, 1} - the possible values of the variables)
    Returns:
        - the expected mutual information, based on counts, assuming uniform priors
    """
    ((c00, c01), (c10, c11)) = countsIJ
    n = c00 + c01 + c10 + c11 + 4
    n = n.astype(numpy.float) if isinstance(n, numpy.ndarray) else float(n)
    nij = ((c00 + 1, c01 + 1), (c10 + 1, c11 + 1))
    niplus = (nij[0][0] + nij[1][0], nij[0][1] + nij[1][1])
    njplus = (nij[0][0] + nij[0][1], nij[1][0] + nij[1][1])
    return sum((nij[j][i] / n) * (numpy.log(nij[j][i] * n) - numpy.log(niplus[i]*njplus[j])) for i in (0,) for j in (0,)) + 0.5 / n
