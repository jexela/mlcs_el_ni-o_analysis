from netCDF4 import Dataset
import numpy as np
from numpy.ma import count
import pandas as pd
import matplotlib.pyplot as plt 
import matplotlib as mt
from mpl_toolkits.basemap import Basemap
from numpy import genfromtxt


precipitation_monthly_mean = 'C:/Users/Alexej/Desktop/precip.mon.mean.nc'
ds = Dataset(precipitation_monthly_mean)
lons = ds['lon'][:]
lats = ds['lat'][:]

plot_lags_1979_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags_filter.csv", delimiter=';',skip_header=1)
#plot_lags_1979_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags.csv", delimiter=';',skip_header=1)
#plot_lags_1979_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags_inter.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags_filter_2.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags_2.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Lags\csv\plot_lags_inter_2.csv", delimiter=';',skip_header=1)

corr = np.transpose(plot_lags_1979_2021)[2].reshape(lats.size,lons.size)
#corr = np.transpose(plot_lags_1979_2021_inter)[2].reshape(lats.size,lons.size)

print(corr)

f = plt.figure(1)

cr = Basemap(projection='cyl',
            llcrnrlon=lons.min(), 
            urcrnrlon=lons.max(),
            llcrnrlat=lats.min(),
            urcrnrlat=lats.max(),
            resolution = 'l')

lon, lat = np.meshgrid(lons, lats)
x,y = cr(lon,lat)
#plt.set_cmap('bwr')
#c_scheme = cr.contourf(x, y, np.squeeze(corr), vmin=-1,vmax=1)
levels =[0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5,12.5]
#levels =[-0.5,0.5,1.5,2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5]
#c_scheme = cr.contourf(x, y, corr, levels, vmin=1,vmax=12, cmap='turbo',levels=1000)
c_scheme = cr.pcolormesh(x, y, corr, cmap ='turbo', vmin = 1, vmax = 12)
#c_scheme = cr.pcolormesh(x, y, corr, vmin=1,vmax=12, cmap='RdYlBu')
#c_scheme = cr.imshow( corr, vmin=1,vmax=12, cmap='turbo',interpolation = 'bilinear')
cr.drawcoastlines()
cr.drawparallels(np.arange(-90,90,10),labels=(1,1,0,0))
cr.drawmeridians(np.arange(0,360,20),labels=[0,0,0,1])
cbar = cr.colorbar(c_scheme, location = 'bottom',pad=0.5)

cbar.set_ticks([1,2,3,4,5,6,7,8,9,10,11,12])
#cbar.set_ticks([0,1,2,3,4,5,6,7,8,9,10,11])
#cbar.set_label('Interquartile range of maximum correlation time lags of the windows 1979-1988,1980-1989,...,2012-2021 between precipitation anomalies and Oceanic Nino Index')
#cbar.set_label('Median maximum correlation time lags of the windows 1979-1988,1980-1989,...,2012-2021 between precipitation anomalies and Oceanic Nino Index')
cbar.set_label('Median maximum correlation time lags of the windows 1982-1991,1983-1992,...,2012-2021 between precipitation anomalies and Oceanic Nino Index')
#cbar.set_label('Median maximum correlation time lags of the windows 1979-1988,1980-1989,...,2012-2021 between precipitation anomalies and Oceanic Nino Index interquartile range <= 4')
#plt.title('Interquartile range of monthly time lags', fontdict = {'fontsize' : 35})
plt.title('Median maximum correlation time lags', fontdict = {'fontsize' : 31})
f.show()
input()

