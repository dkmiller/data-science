import pandas
import matplotlib
import matplotlib.pyplot as plt
import numpy as np

# See http://pandas.pydata.org/pandas-docs/stable/visualization.html


matplotlib.style.use('ggplot')


data = pandas.read_csv('filename.csv')
print(data.columns.values)

data['ColName'].plot.hist(bins=n)
plt.show() # In command line, this shows current plot.

# Adds new column categorizing ColName
data["NewCol"] = pandas.cut(data["ColName"], [-np.inf,50,100], labels=["young","old"])