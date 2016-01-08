# -*- coding: utf-8 -*-

# the idea is to plot test (benchmark) results with C time at x axis and
# language time at y axis; different languages by different colours, different
# tests by different marker types

import matplotlib
import matplotlib.pyplot as plt
from matplotlib import gridspec

# provides dictionary with results
import results

lw = 0.7 # linewidth
ms = 7 # marker size
mew = 1.25 # marker edge width
m = 1.2 # additional space in xlim is proportional to m - 1
defaultstyle = {'markersize': ms, 'markeredgewidth': 0}

# kwargs which define different style for different languages
langstyle = {'C': {'color': 'DodgerBlue'}, 'C++': {'color': 'DeepSkyBlue'},
        'Julia': {'color': 'DeepPink'}, 'Pypy': {'color': 'YellowGreen'},
        'Python': {'color': 'Gold'}, 'Haskell': {'color': 'BlueViolet'}, 'R' :
        {'color': 'Gray'}, 'C#': {'color': 'Thistle'}, 'Rust': {'color': 'none',
            'markeredgecolor': 'DarkOrange', 'markeredgewidth': mew}}
# kwargs which define different style for different tests
teststyle = {'generation': {'marker': 'o'}, 'output': {'marker': '>'}, 'input':
        {'marker': '<'}}

print(results.set1)

f = plt.figure(figsize=(6.65, 5.9), dpi = 300)
gs = gridspec.GridSpec(2, 2)
gs.update(left=0.09, right=0.98, bottom=0.08, top=0.99, wspace = 0.17)
font = {'family' : 'Liberation Serif',
        'weight' : 'normal',
        'size'   : 10}
matplotlib.rc('font', **font)
matplotlib.rc('lines', linewidth=lw)
matplotlib.rc('axes', linewidth=lw)

def plotPoints(yscale, rset):
    maxctime = 0
    for testname in rset:
        print(testname)
        ctime = rset[testname][0]
        if ctime > maxctime:
            maxctime = ctime
        style = {key: value for key, value in defaultstyle.items()}
        style.update(langstyle['C'])
        style.update(teststyle[testname])
        plt.plot(ctime, ctime, **style)
        for langname in rset[testname][1]:
            print(' ' * 4 + langname)
            for langtime in rset[testname][1][langname]:
                print(' ' * 8 + str(langtime))
                style = {key: value for key, value in defaultstyle.items()}
                style.update(langstyle[langname])
                style.update(teststyle[testname])
                plt.plot(ctime, langtime, **style)
                plt.xlim(0, maxctime * m)
                plt.ylim(0, maxctime * m * yscale)

# makes y-range of plots wider
yscales = [1.5, 4, 11, 50]

for i in range(4):
    plt.subplot(gs[int(i / 2), i % 2])
    plotPoints(yscales[i], results.set1)
    plt.xlabel('C time, s')
    plt.ylabel('lang time, s')

plt.savefig('results.png')

