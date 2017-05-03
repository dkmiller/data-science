import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

matplotlib.style.use('ggplot')

# Some helper functions
def Hasse(p):
    return 2*np.sqrt(p)
def ST(x):
    return (2/np.pi) * np.sin(x)**2
def CDF(x):
    return (x - np.sin(x)*np.cos(x)) / np.pi

# Read data from file
df = pd.read_csv('rank2.txt')

# Compute Satake parameters
df['Satake'] = np.arccos(df.trace / (2*np.sqrt(df.prime)))

# Small chunk of data for easy plots:
df_mini = df.head(5000)


# First plot point-counts:
plt.scatter(df_mini.prime, df_mini.prime + 1 - df_mini.trace)
plt.show()

# Plot trace of Frobenius:
plt.scatter(df_mini.prime, df_mini.trace)
plt.show()

# Plot trace of Frobenius vs Hasse bound:
ax = plt.figure().add_subplot(1,1,1)
ax.scatter(df_mini.prime,df_mini.trace)
x = np.linspace(0,50000)
ax.plot(x, Hasse(x),linewidth=5)
ax.plot(x, -Hasse(x),linewidth=5)
plt.show()

# Plot Satake params:
plt.scatter(df_mini.prime, df_mini.Satake)
plt.show()

# Histogram of Satake parameters (without legend)
plt.hist(df.Satake,bins=100,normed=True)
plt.legend([])
plt.show()

# Histogram of Satake params vs predicted distribution
ax = plt.figure().add_subplot(1,1,1)
ax.hist(df.Satake,100,normed=True)
x = np.linspace(0,np.pi)
ax.plot(x,ST(x),linewidth=5)
#df.hist('Satake', bins=100)
plt.show()

# Now plot discrete CDF vs continuous CDF
ax = plt.figure().add_subplot(1,1,1)
ax.hist(df.Satake,)
ax.hist(df.Satake,100,cumulative=True,normed=True)
x = np.linspace(0,np.pi)
ax.plot(x,CDF(x))
plt.show()
