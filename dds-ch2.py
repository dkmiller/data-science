import numpy
import pandas
import matplotlib
import matplotlib.pyplot

# Use GGplot stype.
matplotlib.style.use('ggplot')
def plot():
    matplotlib.pyplot.show()

# Read NYT ad click data.
data = pandas.read_csv("http://stat.columbia.edu/~rachel/datasets/nyt1.csv")

# Add new variable grouping users by age.
data["Age_group"] = pandas.cut(data["Age"], [-numpy.inf, 18, 24, 34, 44, 54, 64, numpy.inf])

# Histograms for number of impressions, for each age group.
data.hist("Impressions", by="Age_group")
plot()

# Create new feature: click-through rate.
data["Click_through"] = data["Clicks"] / data["Impressions"]

# Plot distribution of click-through rate, for each age group.
data.hist("Click_through", by="Age_group")
plot()

# Plot distribution of non-zero click-through rates (i.e., distribution of 
#users who actually click), for each age group.
data[data.Click_through != 0].hist("Click_through", by="Age_group")
plot()

# Add new variable grouping users by click behavior
data["Lotsa_clicks"] = pandas.cut(data["Age"], [-numpy.inf, 0.8, numpy.inf])

# Plot distribution of age, for low-click vs high-click users.
data.hist("Age", by="Lotsa_clicks")