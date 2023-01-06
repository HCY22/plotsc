#!/usr//bin/python3
# usage : HierarchicalClustering.py dm.txt
# note  : Input should be a distance matrix.

import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import linkage, dendrogram, fcluster
from optparse import OptionParser


# set parameter

parser=OptionParser()
parser.add_option('-t','--title',type='string',dest='title')
parser.add_option('-m','--maxclust',type='int',dest='mc',default=1)

(opt,args)=parser.parse_args()

np.set_printoptions(threshold=np.inf)


# load distance matrix into a condensed version

dm=pd.read_csv(args[0],delimiter='\t',index_col=0)
cdm=[]
for i in range(dm.shape[0]-1):
    cdm+=list(dm.iloc[i,(i+1):])


# do hierarchical clustering and plot the dendrogram

plt.figure(figsize=(10,10))

lcdm=linkage(cdm,method='average')

dendrogram(lcdm,labels=dm.index)

plt.title(opt.title)
plt.savefig(args[0]+'.png')

print( lcdm );


# form flat cluster

if(opt.mc>1):
    fc=fcluster(lcdm,t=opt.mc,criterion='maxclust')
    for s,c in zip(dm.index,fc):
        print(s+'\t'+str(c))

