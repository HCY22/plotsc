#!/usr/bin/python3
# usage : StackedBarChart.py [option] file
# to do : draw stacked bar chart

import sys
from optparse import OptionParser
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# set parameter

parser = OptionParser()
parser.add_option( '-t', '--title', type='string', dest='title', default='' )
parser.add_option( '-x', '--xlabel', type='string', dest='xlabel', default='' )
parser.add_option( '-y', '--ylabel', type='string', dest='ylabel', default='' )
parser.add_option( '-w', '--width', type='float', dest='width', default=0.5 )
parser.add_option( '-l', '--legend', type='int', dest='legend', default=0 )

(opt, args) = parser.parse_args()


# load data points

df = pd.read_csv(args[0], delimiter='\t', index_col=0)

plt.figure(figsize = (12, 5))
#fig, ax = plt.subplots()


lab = list(df.columns)
bot = np.zeros(len(lab))

for i in df.index:
    row = np.array(df.loc[i])
    if (opt.legend == 0):
        plt.bar(lab, row, opt.width, bottom=bot)
    else:
        plt.bar(lab, row, opt.width, bottom=bot, label=i)
    bot = bot + row

if (opt.legend == 1):
    handles, labels = plt.gca().get_legend_handles_labels()
    plt.legend(reversed(handles), reversed(labels), bbox_to_anchor=(1,1))
    
plt.ylabel(opt.ylabel)
plt.savefig(args[0]+'.png')
