from netCDF4 import Dataset
import numpy as np
import pandas as pd
import datetime  as dt
import timeit
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap

# Reading in the netCDF files
precipitation_monthly_mean = 'C:/Users/Alexej/Desktop/Bachelorarbeit/precip.mon.mean.nc'
percipitation_monthly_mean_error = 'C:/Users/Alexej/Desktop/Bachelorarbeit/precip.mon.mean.error.nc'
ds = Dataset(precipitation_monthly_mean)
es = Dataset(percipitation_monthly_mean_error)
precip = ds['precip'][:]
lons = ds['lon'][:]
lats = ds['lat'][:]
print(ds.variables)


# Displaying the names of the variables
print(ds.variables.keys())
print(es.variables.keys())

# Calculating the mean and standard deviations between January 1979 to today
precipitation_mean = precip.mean(axis=0)
precipitation_std = precip.std(axis=0)

#print(precipitation_mean)
#print(precipitation_std)

# Accessing the data from the variables
date_range = pd.date_range(start ='1/1/1979', end = dt.datetime.today().strftime("%m/%d/%Y"),freq = 'MS')
#date_range_lat_long = np.tile(date_range[0:ds['time'][:].size],ds['lat'][:].size*ds['lon'][:].size)

# Creating an empty pandas dataframe to fill with precipitation valus for every location
#dr = pd.DataFrame(0, columns = ['average monthly precipitation in mm/day'], index = date_range)
#df = pd.DataFrame(0, columns = ['average monthly precipitation in mm/day'], index = date_range_lat_long)

#Creating pandas DataFrame named temp with columns date, longitude, laditude, average monthly precipitation
dr_ts = pd.DataFrame(pd.Series(date_range[:-2]),columns = ['date'])
lons_ts = pd.DataFrame(pd.Series(lons),columns = ['longditude']) 
lats_ts = pd.DataFrame(pd.Series(lats),columns = ['laditude'])
temp = dr_ts.merge(lons_ts.merge(lats_ts, how='cross'), how='cross')
av = np.zeros(len(temp))
temp['average monthly precipitation in mm/day']=av
times = np.arange(0,ds.variables['time'][:].size)
longitudes = np.arange(0,ds.variables['lon'][:].size)
latitudes = np.arange(0,ds.variables['lat'][:].size)
pos=0

#Create a csv with all the precipitation data from 1979-today by fetching precipitation data from netCDF file precip.mon.mean.nc 
"""
for time in times:
    for lon in longitudes:
        for lat in latitudes:
            temp.at[pos,'average monthly precipitation in mm/day'] = ds['precip'][time,lat,lon]
            pos+=1
            print(pos)
            print(time,lon,lat)
temp.to_csv('precipitation_worldwide')

"""
"""
f = plt.figure(1)

mp = Basemap(projection='cyl',
            llcrnrlon=lons.min(), 
            urcrnrlon=lons.max(),
            llcrnrlat=lats.min(),
            urcrnrlat=lats.max(),
            resolution = 'h')

lon, lat = np.meshgrid(lons, lats)
x,y = mp(lon,lat)
c_scheme = mp.pcolor(x, y, np.squeeze(precip[0,:,:]), cmap = 'jet' )
mp.drawcoastlines()
cbar = mp.colorbar(c_scheme, location = 'bottom', pad = '10%')
cbar.set_label('Average Monthly Rate of Precipitation (mm/day)')
plt.title('Average precipitation on 01-01-1979')

f.show()

g = plt.figure(2)

mean = Basemap(projection='cyl',
            llcrnrlon=lons.min(), 
            urcrnrlon=lons.max(),
            llcrnrlat=lats.min(),
            urcrnrlat=lats.max(),
            resolution = 'h')

lon, lat = np.meshgrid(lons, lats)
x,y = mean(lon,lat)
c_scheme = mean.pcolor(lon, lat, np.squeeze(precipitation_mean[:,:]), cmap = 'jet' )
mean.drawcoastlines()
cbar = mean.colorbar(c_scheme, location = 'bottom', pad = '10%')
cbar.set_label('Average Monthly Rate of Precipitation (mm/day)')
plt.title('Average precipitation 1979-2021')
g.show()

input()
"""
#print(np.squeeze(precipitation_mean[:,:]))
#print(np.squeeze(precipitation_mean[:,:]))

print(precip[0,:,:])
print(precip[0,:,:].shape)