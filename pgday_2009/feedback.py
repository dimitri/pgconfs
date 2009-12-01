#! /usr/bin/env python
#
# http://matplotlib.sourceforge.net/examples/pylab_examples/bar_stacked.html

from pylab import *
import numpy as np

clf()
subplot(111)

N = 4

# http://html-color-codes.info/ for inspiration
scoreColors   = (('#F5D0A9', '#F7BE81', '#FAAC58', '#FF8000', '#DF7401'),
                 ('#A9F5A9', '#81F781', '#58FA58', '#2EFE2E', '#01DF01'))

# data from the mail
expHMScores   = ((0, 0, 1, 2, 5),
                 (0, 0, 1, 3, 4),
                 (0, 0, 0, 0, 8),
                 (0, 0, 0, 3, 5))

stagingScores = ((0, 0, 0, 3, 3),
                 (0, 1, 1, 1, 3),
                 (0, 0, 1, 1, 4),
                 (0, 0, 0, 4, 2))

ind = np.arange(N)    # the x locations for the groups
width = 0.4       # the width of the bars: can also be len(x) sequence

hd = array([expHMScores[x][0] for x in range(0, 4)])
hp = bar(ind, hd, width, color = scoreColors[0][0])

sd = array([stagingScores[x][0] for x in range(0, 4)])
sp = bar(ind+width, sd, width, color = scoreColors[1][0])

for s in range(1, 5):
    d = array([expHMScores[x][s] for x in range(0, 4)])
    bar(ind, d, width, color = scoreColors[0][s], bottom = hd)
    hd += d

    d = array([stagingScores[x][s] for x in range(0, 4)])
    bar(ind+width, d, width, color = scoreColors[1][s], bottom = sd)
    sd += d

ylabel('Scores')
title('PGday 2009 feedback')
xticks(ind+width,
       ('Topic Importance',
        'Content Quality',
        'Speaker knowledge',
        'Speaker Quality') )

legend([hp[0], sp[0]], ["Hi-Media", "pg_staging"])

grid(True)
savefig('feedback.png', dpi=75, orientation='portrait')
