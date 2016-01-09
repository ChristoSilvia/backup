import matplotlib.pyplot as plt
import mpld3

fig, ax = plt.subplots()
ax.plot([3,1,4,1,5], 'ks-', mec='w', mew=5, ms=20)
open("fig.html", "w+").write(mpld3.fig_to_html(fig))
