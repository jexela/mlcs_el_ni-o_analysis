from netCDF4 import Dataset
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
import matplotlib as mt
from mpl_toolkits.basemap import Basemap
from numpy import genfromtxt
from matplotlib import ticker

precipitation_monthly_mean = 'C:/Users/Alexej/Desktop/precip.mon.mean.nc'
ds = Dataset(precipitation_monthly_mean)
lons = ds['lon'][:]
lats = ds['lat'][:]

period_1979_1988 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\reds.csv", delimiter=';',skip_header=1)

#period_1979_1988 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1979_1988.csv", delimiter=';',skip_header=1)
period_1980_1989 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1980_1989.csv", delimiter=';',skip_header=1)
period_1981_1990 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1981_1990.csv", delimiter=';',skip_header=1)
period_1982_1991 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1982_1991.csv", delimiter=';',skip_header=1)
period_1983_1992 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1983_1992.csv", delimiter=';',skip_header=1)
period_1984_1993 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1984_1993.csv", delimiter=';',skip_header=1)
period_1985_1994 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1985_1994.csv", delimiter=';',skip_header=1)
period_1986_1995 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1986_1995.csv", delimiter=';',skip_header=1)
period_1987_1996 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1987_1996.csv", delimiter=';',skip_header=1)
period_1988_1997 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1988_1997.csv", delimiter=';',skip_header=1)
period_1989_1998 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1989_1998.csv", delimiter=';',skip_header=1)
period_1990_1999 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1990_1999.csv", delimiter=';',skip_header=1)
period_1991_2000 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1991_2000.csv", delimiter=';',skip_header=1)
period_1992_2001 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1992_2001.csv", delimiter=';',skip_header=1)
period_1993_2002 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1993_2002.csv", delimiter=';',skip_header=1)
period_1994_2003 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1994_2003.csv", delimiter=';',skip_header=1)
period_1995_2004 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1995_2004.csv", delimiter=';',skip_header=1)
period_1996_2005 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1996_2005.csv", delimiter=';',skip_header=1)
period_1997_2006 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1997_2006.csv", delimiter=';',skip_header=1)
period_1998_2007 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1998_2007.csv", delimiter=';',skip_header=1)
period_1999_2008 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_1999_2008.csv", delimiter=';',skip_header=1)
period_2000_2009 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2000_2009.csv", delimiter=';',skip_header=1)
period_2001_2010 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2001_2010.csv", delimiter=';',skip_header=1)
period_2002_2011 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2002_2011.csv", delimiter=';',skip_header=1)
period_2003_2012 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2003_2012.csv", delimiter=';',skip_header=1)
period_2004_2013 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2004_2013.csv", delimiter=';',skip_header=1)
period_2005_2014 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2005_2014.csv", delimiter=';',skip_header=1)
period_2006_2015 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2006_2015.csv", delimiter=';',skip_header=1)
period_2007_2016 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2007_2016.csv", delimiter=';',skip_header=1)
period_2008_2017 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2008_2017.csv", delimiter=';',skip_header=1)
period_2009_2018 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2009_2018.csv", delimiter=';',skip_header=1)
period_2010_2019 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2010_2019.csv", delimiter=';',skip_header=1)
period_2011_2020 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2011_2020.csv", delimiter=';',skip_header=1)
period_2012_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\period_2012_2021.csv", delimiter=';',skip_header=1)

corr = np.transpose(period_1979_1988)[2].reshape(lats.size,lons.size)

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
#plt.set_cmap('bwr')
#c_scheme = cr.contourf(x, y, np.squeeze(corr), vmin=-1,vmax=1)
#levels = [-1,-0.8,-0.6,-0.4,-0.2,-0.03,0,0.03,0.2,0.4,0.6,0.8,1]
levels =[-1,-0.179,0.179,1]
c_scheme = cr.contourf(x, y, corr, levels, vmin=-1,vmax=1, cmap='bwr')
#c_scheme = cr.contour(x, y, corr,vmin=-1,vmax=1, cmap='bwr')
cr.drawcoastlines()
cr.drawparallels(np.arange(-90,90,10),labels=(1,1,0,0))
cr.drawmeridians(np.arange(0,360,20),labels=[0,0,0,1])
cbar = cr.colorbar(c_scheme, location = 'bottom',pad=0.5)
#cbar.set_ticks([-1,0,1])
cbar.set_ticks([-1,-0.179,0.179,1])
cbar.set_label('Correlation coefficients contours between ONI and global precipitation anomalies')
plt.title('1979-1988 countours precipitation anomalies vs Oceanic Niño Index')

f.show()
input()