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


# Copy of the readme:
"""
# Zillow
Data science exercise as part of interview process.

## Features: how do they matter (EDA).

### propertyid
Is not reasonably distributed. A huge majority of these values have first digit
5. Not sure if this matters.

_Don't use this to predict price._

### transdate
Pretty uniform, with no clear dependence of price on this.

_Don't use this to predict price._

### transvalue
The log of this is reasonably distributed. log(transvalue) has a roughly
linear dependence on log(finishedsquarefeet).

### transdate_previous
This only exists for some houses, but is reasonably distributed.

_Don't use this to predict price._

### transvalue_previous
The property value seems to be a rapidly increasing function of the previous
value, when it is recorded.

_Use this (when available) to predict price._

### bathroomcnt
Price has roughly linear (with some significant outliers) dependence on this.

_Use this (when available) to predict price._

### bedroomcnt
Price has roughly linear (with some significant outliers) dependence on this.

_Use this (when available) to predict price._

### builtyear
Concentrated heavily towards recent years.

_Don't use this to predict price._

### finishedsquarefeet
Pretty clear linear / quadratic dependence of price on this.

_Use this (when available) to predict price._

### lotsizesquarefeet
No clear dependence of price on this.

_Don't use this to predict price._

### storycnt
No clear dependence of price on this.
_Don't use this to predict price._

### (longitude, latitude)
Locations all lie near Seattle, in Kings County, WA.

_Don't use this to predict price._

### usecode
Only takes one value, so ignore.

_Don't use this to predict price._

### censustract
Data fits into two distinct clumps, use 2-means here.

_Don't use this to predict price._


### viewtypeid
Generally three clumps. Values 2, 4, 9, 12, and 13 have much less variability in price than homes with value 3.

_Use this (when available, as several dummy variables) to predict price._


## Initial attempt: just use linear regression.
A simple linear regression of the form transvalue ~ finishedsquarefeet fails
miserably.

Next, we try using linear regression on the following:
* transvalue_previous_log (when available)
* bathroomcnt
* bedroomcnt
* finishedsquarefeet_log
* viewtypeid (as dummy variables)

so one training set with transvalue_previous_log, one without. This works
pretty well, with MAPE < 0.19.

## Further refinements etc.
One clear further refinement is to run linear regression as not just
model the (log of the) value of a property as a linear function the (log of ) its
finished square feet, but to directly model the value as a linear function of
some polynomial in the other features. This would involve choosing the degree
(possibly fractional) of the polynomial, which would ideally be accompanied by
careful heuristics.

To scale this model to the entire country, it would make most sense to first
cluster properties by a combination of bathroom count, bedroom count, and
finished square feet. Within such groups (each of which will be more manageable)
run linear regression to predict price as a function of the other features.
"""
