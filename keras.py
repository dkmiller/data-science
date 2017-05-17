from keras.models import Sequential
from keras.layers import Dense
import numpy as np
from urllib2 import urlopen

# Code based on the tutorial here: 
# http://machinelearningmastery.com/tutorial-first-neural-network-python-keras/

np.random.seed(42)

url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data'
f = urlopen(url)
data = np.loadtxt(f, delimiter=',')

X = dataset[:,0:8]
Y = dataset[:,8]
