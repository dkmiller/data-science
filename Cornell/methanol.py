import pandas as pd
from sklearn.linear_model import LinearRegression

data = pd.read_csv('methanol_data.csv')
features = []
for i in xrange(1,6):
    name = 'x' + str(i)
    features.append(name)
    data[name] = data['x']**i

X = data[features]
y = data['y']

lm = LinearRegression()
lm.fit(X,y)

def predict(val):
    test = pd.DataFrame([[val**i for i in xrange(1,6)]], columns=features)
    return lm.predict(test)[0]
