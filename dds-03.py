import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

def plot():
    # Use GGplot.
    matplotlib.style.use('ggplot')
    plt.show()

print 'hi there!'

# Some fake data with mean of 5 and standard deviation of 7.
x_1 = np.random.normal(loc=5, scale=7, size=1000)
# Plot the data
# plt.hist(x_1)

# Some fake "error terms."
true_error = np.random.normal(loc=0,scale=2,size=1000)
true_beta_0 = 1.1
true_beta_1 = -8.2
y = true_beta_0 + true_beta_1 * x_1 + true_error
# plt.hist(y)

# Problem 1 from chapter 3.
# Now we build a linear regression model.
lm = LinearRegression()
lm.fit(x_1.reshape(-1,1),y)
print 'true (beta_0,beta_1) = (%f,%f)' % (true_beta_0,true_beta_1)
print 'predict              = (%f,%f)' % (lm.intercept_,lm.coef_)

# Problem 2 from chapter 3.
x_2 = np.random.gamma(2, size=1000)
X = pd.DataFrame([x_1,x_2]).transpose()
X.columns = ['x_1','x_2']
y = x_1 + x_2
lm.fit(X,y)
