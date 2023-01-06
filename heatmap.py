#!/usr/bin/python3
# usage : heatmap_vj.py [-t -v] [matrix]
# to do :

import os
import sys
from optparse import OptionParser
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# set parameter
parser = OptionParser()
parser.add_option( '-x', '--xlabel', type='string', dest='xlabel', default='' )
parser.add_option( '-y', '--ylabel', type='string', dest='ylabel', default='' )
parser.add_option( '-t', '--title',  type='string', dest='title')
parser.add_option( '-v', '--vmax',   type='float', dest='vmax', default=None)

(opt,args) = parser.parse_args()

# load data
fn = os.path.basename(args[0])
df = pd.read_csv(args[0], sep="\t", header=0, index_col=0)
df = df.T

# plt_size
plt.figure(figsize=(16,9))

# heat_map
ax = sns.heatmap(data=df, cmap='GnBu', vmax=opt.vmax, linewidths=.1, xticklabels=1, yticklabels=1, square=True, center=3)
plt.yticks(rotation=0)

if opt.xlabel:
    plt.xlabel(opt.xlabel)
if opt.ylabel:
    plt.ylabel(opt.ylabel)
if opt.title:
    plt.title(opt.title, fontsize=14, loc='left')

# layout
plt.savefig(fn +'.png', bbox_inches = "tight")
#plt.show()
