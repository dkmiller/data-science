from keras.models import Sequential
from keras.layers import Dense
import numpy as np
from urllib2 import urlopen

# Code based on the tutorial here:
# http://machinelearningmastery.com/tutorial-first-neural-network-python-keras/

np.random.seed(42)

# Load data.
url = 'http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data'
f = urlopen(url)
data = np.loadtxt(f, delimiter=',')
X = data[:,0:8]
Y = data[:,8]

# Create model.
model = Sequential()
model.add(Dense(12, input_dim=8, activation='relu'))
model.add(Dense(8, activation='relu'))
model.add(Dense(1, activation='sigmoid'))
model.compile(loss='binary_crossentropy', optimizer = 'adam', metrics=['accuracy'])

model.fit(X, Y, epochs=150, batch_size=10)

scores = model.evaluate(X, Y)
print('\n%s: %.2f%%' % (model.metrics_names[1], scores[1]*100))

print 'Done!'
