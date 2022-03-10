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



period_1979_1988= my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1979_1988_countours_adj_nino3.csv", delimiter=';',skip_header=1)
period_1980_1989 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1980_1989_countours_adj.csv", delimiter=';',skip_header=1)
period_1981_1990 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1981_1990_countours_adj.csv", delimiter=';',skip_header=1)
period_1982_1991 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1982_1991_countours_adj.csv", delimiter=';',skip_header=1)
period_1983_1992 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1983_1992_countours_adj.csv", delimiter=';',skip_header=1)
period_1984_1993 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1984_1993_countours_adj.csv", delimiter=';',skip_header=1)
period_1985_1994 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1985_1994_countours_adj.csv", delimiter=';',skip_header=1)
period_1986_1995 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1986_1995_countours_adj.csv", delimiter=';',skip_header=1)
period_1987_1996 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1987_1996_countours_adj.csv", delimiter=';',skip_header=1)
period_1988_1997 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1988_1997_countours_adj.csv", delimiter=';',skip_header=1)
period_1989_1998 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1989_1998_countours_adj.csv", delimiter=';',skip_header=1)
period_1990_1999 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1990_1999_countours_adj.csv", delimiter=';',skip_header=1)
period_1991_2000 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1991_2000_countours_adj.csv", delimiter=';',skip_header=1)
period_1992_2001 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1992_2001_countours_adj.csv", delimiter=';',skip_header=1)
period_1993_2002 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1993_2002_countours_adj.csv", delimiter=';',skip_header=1)
period_1994_2003 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1994_2003_countours_adj.csv", delimiter=';',skip_header=1)
period_1995_2004 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1995_2004_countours_adj.csv", delimiter=';',skip_header=1)
period_1996_2005 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1996_2005_countours_adj.csv", delimiter=';',skip_header=1)
period_1997_2006 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1997_2006_countours_adj.csv", delimiter=';',skip_header=1)
period_1998_2007 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1998_2007_countours_adj.csv", delimiter=';',skip_header=1)
period_1999_2008 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1999_2008_countours_adj.csv", delimiter=';',skip_header=1)
period_2000_2009 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2000_2009_countours_adj.csv", delimiter=';',skip_header=1)
period_2001_2010 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2001_2010_countours_adj.csv", delimiter=';',skip_header=1)
period_2002_2011 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2002_2011_countours_adj.csv", delimiter=';',skip_header=1)
period_2003_2012 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2003_2012_countours_adj.csv", delimiter=';',skip_header=1)
period_2004_2013 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2004_2013_countours_adj.csv", delimiter=';',skip_header=1)
period_2005_2014 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2005_2014_countours_adj.csv", delimiter=';',skip_header=1)
period_2006_2015 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2006_2015_countours_adj.csv", delimiter=';',skip_header=1)
period_2007_2016 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2007_2016_countours_adj.csv", delimiter=';',skip_header=1)
period_2008_2017 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2008_2017_countours_adj.csv", delimiter=';',skip_header=1)
period_2009_2018 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2009_2018_countours_adj.csv", delimiter=';',skip_header=1)
period_2010_2019 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2010_2019_countours_adj.csv", delimiter=';',skip_header=1)
period_2011_2020 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2011_2020_countours_adj.csv", delimiter=';',skip_header=1)
period_2012_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_2012_2021_countours_adj.csv", delimiter=';',skip_header=1)

period_1982_2021 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\csv_contours\period_1982_2021_countours_adj.csv", delimiter=';',skip_header=1)


#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_nino4.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_oni.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_oni_con_nino12.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_nino12.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_oni_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_tni_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino12_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino3_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino4_con_everything.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\partial_correlation.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\partial_correlation_maps_preticipation_oni.csv", delimiter=';',skip_header=1)
#period_1979_1988 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1979_1988_countours_adj.csv", delimiter=';',skip_header=1)
corr = np.transpose(period_2000_2009)[2].reshape(lats.size,lons.size)

print(corr)
plt.figure(figsize=(19.20,10.80))
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

#levels1=[-0.25192,0.25192]
levels1=[-0.263,0.263]

levels = [-1,-0.263,0.263,1]
#levels =[-10,-1,-0.8,-0.6,-0.4,-0.2,-0.1,0.1,0.2,0.4,0.6,0.8,1,10]

c_scheme = cr.pcolormesh(x, y, corr, cmap ='bwr', vmin = -1, vmax = 1)
c_scheme = c_scheme = cr.contourf(x, y,corr, levels,cmap ='bwr', vmin = -1, vmax = 1)
cr.contour(x,y,corr,levels1,colors=('k'),linewidth=(0.1,),linestyles = 'solid')
cr.drawcoastlines()
cr.drawparallels(np.arange(-90,90,10),labels=(1,1,0,0))
cr.drawmeridians(np.arange(0,360,20),labels=[0,0,0,1])

cbar = cr.colorbar(c_scheme, location = 'bottom',pad=0.5)
cbar.set_ticks([-1,-0.263,0.263,1])
#cbar.set_ticks([-10,-1,-0.8,-0.6,-0.4,-0.2,-0.1,0.1,0.2,0.4,0.6,0.8,1,10])

cbar.set_label('correlation coefficient', fontdict = {'fontsize' : 20})

#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Nino 4 Index -> Precip(lat,long)| Oceanic Niño Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip(lat,long)| Niño 4 Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip(lat,long)| Niño 1+2 Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Niño 1+2 Index -> Precip(lat,long)| Oceanic Niño Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute partial correlation coefficients for Oceanic Niño Index -> Precip(lat,long)| Nino 4 Index obtained from PCMCI algorithm 1982-2021 (471 months)')

#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip(lat,long)| (Niño 1+2, Niño 3, Niño 4, Trans Niño Index) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Trans Niño Index -> Precip(lat,long)| (Niño 1+2, Niño 3, Niño 4, Oceanic Niño Index) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 1+2 Index -> Precip(lat,long)| (Niño 3, Niño 4, Oceanic Niño Index, Trans Niño Index) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 3 Index -> Precip(lat,long)| (Niño 1+2, Niño 4, Oceanic Niño Index, Trans Niño Index) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 4 Index -> Precip(lat,long)| (Niño 1+2, Niño 3, Oceanic Niño Index, Trans Niño Index) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')

plt.title('2000-2009 correlation map precipitation anomalies vs Oceanic Niño Index', fontdict = {'fontsize' : 30})
#plt.title('Causal map for Oceanic Niño Index -> Precip(lat,long)| Niño 4 Index', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Niño 4 Index -> Precip(lat,long)| Oceanic Niño Index ', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Oceanic Niño Index -> Precip(lat,long)| Niño 1+2 Index', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Niño 1+2 Index -> Precip(lat,long)| Oceanic Niño Index', fontdict = {'fontsize' : 23})


#plt.title('Causal map for Oceanic Niño Index -> Precip(lat,long)| Niño 1+2, Niño 3, Niño 4, Trans Niño Index', fontdict = {'fontsize' : 20})
#plt.title('Causal map for Trans Niño Index -> Precip(lat,long)| Niño 1+2, Niño 3, Niño 4, Oceanic Niño Index', fontdict = {'fontsize' : 20})
#plt.title('Causal map for Niño 1+2 Index -> Precip(lat,long)| Niño 3, Niño 4, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 20})
#plt.title('Causal map for Niño 3 Index -> Precip(lat,long)| Niño 1+2, Niño 4, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 20})
#plt.title('Causal map for Niño 4 Index -> Precip(lat,long)| Niño 1+2, Niño 3, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 20})

plt.savefig("correlation_contours_between_oni_precipitation_anomilies_2000-2009.pdf")
f.show()
input()