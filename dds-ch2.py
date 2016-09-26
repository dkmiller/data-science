import numpy
import pandas
import matplotlib
import matplotlib.pyplot

# Use GGplot stype.
matplotlib.style.use('ggplot')

# Read NYT ad click data.
data = pandas.read_csv("http://stat.columbia.edu/~rachel/datasets/nyt1.csv")

# Add new column grouping users by age.
data["Age_group"] = pandas.cut(data["Age"], [-numpy.inf, 18, 24, 34, 44, 54, 64, numpy.inf])

# Histograms for number of impressions, for each age group.
number_impressions = data["Impressions"].hist(by=data["Age"])