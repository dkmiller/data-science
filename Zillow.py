# Should be run with Python 2.7. Format: python Daniel_Miller.py train_file_name test_file_name.

from collections import OrderedDict
from datetime import datetime as dt
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn.linear_model import LinearRegression
from sklearn.utils import check_array
import sys

# Possible sets of features. OrderedDict with keys 'bad', 'nonull', and 'prev'.
global options


# Helper functions for EDA, not used when program is run.
def plot():
    # Use GGplot.
    matplotlib.style.use('ggplot')
    plt.show()
def scatter(a, b):
    plt.scatter(a, b)
    plot()
def scatter3d(a, b, c):
    ax = plt.figure().add_subplot(111, projection='3d')
    ax.scatter(a, b, c)
    plot()


# Three models, for when there is missing data, when main data is not null,
# and when there is a previous price, along with main data.
def create_options():
    global options
    options = OrderedDict()
    dummies = ['viewtypeid_' + str(n) for n in xrange(2,14)]
    nice = ['bathroomcnt', 'bedroomcnt', 'finishedsquarefeet_log'] + dummies
    options['prev'] = nice + ['transvalue_previous_log']
    options['nonull'] = nice
    options['bad'] = ['longitude', 'latitude']

# Call only after options has been set. Usage:
# training = load_training_set(filename)
def load_training_set(filename):
    global options
    # Load the data.
    training = pd.read_csv(filename)

    # Add extra features for modeling.
    training['transvalue_log'] = np.log(training['transvalue'])
    training['transvalue_previous_log'] = np.log(training['transvalue_previous'])
    training['finishedsquarefeet_log'] = np.log(training['finishedsquarefeet'])

    # 'Main' features, with dummy variables for the different view type IDs.
    for f in options['nonull']:
        if f[:11] == 'viewtypeid_':
            n = int(f[11:])
            def viewid_to_int(row):
                return 1 if row['viewtypeid'] == n else 0
            training[f] = training.apply(viewid_to_int, axis=1)

    # Add a new column for listing classification (bad, no nulls, or previous
    # transaction price known).
    def classify_listing(row):
        for o in options:
            if all([pd.notnull(row[f]) for f in options[o]]):
                return o
    training['type'] = training.apply(classify_listing, axis=1)

    return training

# Usage:
# models = create_models(training)
# lm = models['bad']
def create_models(training):
    global options
    models = {'bad' : None}
    for o in ['nonull', 'prev']:
        temp = training.loc[training.type == o]
        # Create parameters and 'true values'
        X = temp[options[o]]
        y = temp['transvalue_log']
        # Apply linear regression.
        models[o] = LinearRegression()
        models[o].fit(X,y)
    return models

def apply_models(models, data):
    global options
    for o in options:
        def pred(row):
            if row['type'] == o:
                if o != 'bad':
                    return models[o].predict(row[options[o]].reshape(1,-1))[0]
                else:
                    return 12.5 # Bad prediction for edge cases.
            else:
                if 'transvalue_log_pred' in row:
                    return row['transvalue_log_pred']
                else:
                    return None
        data['transvalue_log_pred'] = data.apply(pred, axis=1)

# Median Absolute Percent Error
def MAPE(d):
    return np.median(np.abs((d.y - d.y_pred) / d.y))

# Percentage of predictions within X of actual.
# Assumes d has columns with names 'y' and 'y_pred'
def PE(X, d):
    def close_to(c):
        a = c['y']
        p = c['y_pred']
        if abs(p-a)/a < X:
            return 1
        else:
            return 0
    d['close'] = d.apply(close_to, axis=1)
    result = float(len(d[d.close == 1])) / len(d)
    return result


# Program code begins here.
if len(sys.argv) != 3:
    print 'format should be python Daniel_Miller.py training_file test_file'
    sys.exit(0)

# Get file names of training and testing data.
train_file_name, test_file_name = sys.argv[1], sys.argv[2]

create_options()

print 'Opening training files...'
training = load_training_set(train_file_name)

print 'Training model...'
# Create model for log of price.
models = create_models(training)
apply_models(models, training)

training['y'] = training.transvalue
training['y_pred'] = np.exp(training.transvalue_log_pred)

print 'Accuracy of model training data:'
print 'MAPE: %f' % MAPE(training)
for X in [0.05, 0.1, 0.2]:
    print 'PE %.2f: %f' % (X, PE(X, training))



print 'Opening test data...'
test = load_training_set(test_file_name)

print 'Predicting transaction values...'
apply_models(models, test)
test['transvalue'] = np.exp(test.transvalue_log_pred).astype(int)

filename = 'Daniel_Miller_predictions.csv'
print 'Writing predictions to %s.' % filename
test.to_csv(filename, columns=['propertyid', 'transvalue'])
