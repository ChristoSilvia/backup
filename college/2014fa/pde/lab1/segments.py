from matplotlib import pyplot as plt
import numpy as np

class LineBuilder:
  def __init__(self,line,plot):
    self.plot = plot
    self.line = line
    self.xs = list(line.get_xdata())
    self.ys = list(line.get_ydata())
    self.cid = line.figure.canvas.mpl_connect('button_press_event',self)

  def __call__(self, event):
    print 'click', event
    self.plot.clear()
    self.xs.append(event.xdata)
    self.ys.append(event.ydata)
    self.xs, self.ys = map(lambda x:list(x),
                         zip(
                           *sorted(
                             zip(self.xs,self.ys), 
                             reverse=True, 
                             key=lambda x: x[0])))
    self.plot.scatter(self.xs,self.ys)
    poly = np.poly1d((np.polyfit(self.xs,self.ys,4)))
    X = np.linspace(-1,1)
    self.plot.plot(X,poly(X))
    self.plot.plot(self.xs,self.ys)
    self.line.set_data(self.xs, self.ys)
    self.line.figure.canvas.draw()

fig = plt.figure()
ax = fig.add_subplot(111)
ax.set_title('click to build line segments')
line, = ax.plot([-1,1],[0,0])
linebuild = LineBuilder(line,ax)

plt.show()
