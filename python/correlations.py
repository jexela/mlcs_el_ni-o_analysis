from netCDF4 import Dataset
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
import matplotlib as mt
from mpl_toolkits.basemap import Basemap
from numpy import genfromtxt

precipitation_monthly_mean = 'C:/Users/Alexej/Desktop/Bachelorarbeit/precip.mon.mean.nc'
ds = Dataset(precipitation_monthly_mean)
lons = ds['lon'][:]
lats = ds['lat'][:]

period_1979_1988 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1979_1988.csv", delimiter=';',skip_header=1)
period_1984_1993 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1984_1993.csv", delimiter=';',skip_header=1)
period_1989_1998 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1989_1998.csv", delimiter=';',skip_header=1)
period_1994_2003 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1994_2003.csv", delimiter=';',skip_header=1)
period_1999_2008 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1999_2008.csv", delimiter=';',skip_header=1)
period_2004_2013 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_2004_2013.csv", delimiter=';',skip_header=1)
period_2009_2018 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_2009_2018.csv", delimiter=';',skip_header=1)
period_2014_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_2014_2021.csv", delimiter=';',skip_header=1)

corr = np.transpose(period_1994_2003)[2].reshape(lats.size,lons.size)

print(corr)

f = plt.figure(1)

cr = Basemap(projection='cyl',
            llcrnrlon=lons.min(), 
            urcrnrlon=lons.max(),
            llcrnrlat=lats.min(),
            urcrnrlat=lats.max(),
            resolution = 'h')

lon, lat = np.meshgrid(lons, lats)
x,y = cr(lon,lat)
plt.set_cmap('seismic')
c_scheme = cr.pcolor(x, y, np.squeeze(corr), vmin=-1,vmax=1)
cr.drawcoastlines()
cbar = cr.colorbar(c_scheme, location = 'bottom',spacing='uniform')
cbar.set_label('Correlation coefficients between ONI and global precipitation anomalies')
plt.title('1994-2003 precipitation anomalies vs Oceanic Niño Index')

f.show()
input()
