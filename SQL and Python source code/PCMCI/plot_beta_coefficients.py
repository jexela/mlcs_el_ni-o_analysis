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

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_oni_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino12_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino3_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_nino4_con_everything.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\everything_without_nino34\beta_coefficients_maps_precipitation_tni_con_everything.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_nino4.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_oni.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_oni_con_nino12.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\beta_coefficients_maps_precipitation_nino12.csv", delimiter=';',skip_header=1)

plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\beta_coefficients_maps_precipitation_oni_wo_conditioning.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\beta_coefficients_maps_precipitation_nino12_wo_conditioning_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\beta_coefficients_maps_precipitation_nino3_wo_conditioning_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\beta_coefficients_maps_precipitation_nino4_wo_conditioning.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\beta_coefficients_maps_precipitation_tni_wo_conditioning.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_oni_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_tni_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino12_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino3_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino4_con_everything_2002_2021.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_oni_con_everything_2002_2021.csv", delimiter=';',skip_header=1)

#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_oni_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_tni_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino12_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino3_con_everything_2002_2021.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\PCMCI_partitioned\2002-2021\beta_coefficients_maps_precipitation_nino4_con_everything_2002_2021.csv", delimiter=';',skip_header=1)


#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\partial_correlation.csv", delimiter=';',skip_header=1)
#plot_lags_1982_2021_inter = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\partial_correlation_maps_preticipation_oni.csv", delimiter=';',skip_header=1)
#period_1979_1988 = my_data = np.genfromtxt(r"C:\Users\Alexej\Desktop\period_1979_1988_countours_adj.csv", delimiter=';',skip_header=1)
corr = np.transpose(plot_lags_1982_2021_inter)[2].reshape(lats.size,lons.size)

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
levels1=[-0.1,0.1]

#levels = [-1,-0.25,0.25,1]
#levels =[-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4,0.5,0.6]
levels =[-5,-1,-0.8,-0.6,-0.4,-0.2,-0.1,0.1,0.2,0.4,0.6,0.8,1,5]

c_scheme = cr.pcolormesh(x, y, corr, cmap ='bwr', vmin = -1, vmax = 1)
c_scheme = c_scheme = cr.contourf(x, y,corr, levels,cmap ='bwr', vmin = -1, vmax = 1)
cr.contour(x,y,corr,levels1,colors=('k'),linewidth=(0.1,),linestyles = 'solid')
cr.drawcoastlines()
cr.drawparallels(np.arange(-90,90,10),labels=(1,1,0,0))
cr.drawmeridians(np.arange(0,360,20),labels=[0,0,0,1])

cbar = cr.colorbar(c_scheme, location = 'bottom',pad=0.5)
#cbar.set_ticks([-1,-0.25,0.25,1])
#cbar.set_ticks([-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0.1,0.2,0.3,0.4,0.5,0.6])
cbar.set_ticks([-5,-1,-0.8,-0.6,-0.4,-0.2,-0.1,0.1,0.2,0.4,0.6,0.8,1,5])

#cbar.set_label('Correlation coefficients contours between Oceanic Niño Index and global precipitation anomalies for a 5% significance level with a false discovery rate correction')

cbar.set_label('\u03B2 coefficient', fontdict = {'fontsize' : 20})
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip_anom(lat,lon)| Niño 4 Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip_anom(lat,lon)| Niño 1+2 Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum \u03B2 coefficients (lag 1-12) for Niño 1+2 Index -> Precip_anom(lat,lon)| Oceanic Niño Index obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute partial correlation coefficients for Oceanic Niño Index -> Precip_anom(lat,lon)| Nino 4 Index obtained from PCMCI algorithm 1982-2021 (471 months)')

#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 0-12) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) obtained from PCMCI algorithm followed by multiple linear regression 1982-2001 (240 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) obtained from PCMCI algorithm followed by multiple linear regression 1982-2001 (240 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) obtained from PCMCI algorithm followed by multiple linear regression 1982-2001 (240 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) obtained from PCMCI algorithm followed by multiple linear regression 1982-2001 (240 months)')

#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Oceanic Niño Index -> Precip_anom(lat,lon) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Trans Niño Index -> Precip_anom(lat,lon) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 1+2 Index -> Precip_anom(lat,lon) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 3 Index -> Precip_anom(lat,lon) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')
#cbar.set_label('Maximum absolute \u03B2 coefficients (lag 1-12) for Niño 4 Index -> Precip_anom(lat,lon) obtained from PCMCI algorithm followed by multiple linear regression 1982-2021 (471 months)')


#plt.title('1982-2021 contours precipitation anomalies vs Oceanic Niño Index', fontdict = {'fontsize' : 30})
#plt.title('Causal map for Oceanic Niño Index -> Precip_anom(lat,lon)| Niño 4 Index', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Niño 4 Index -> Precip_anom(lat,lon)| Oceanic Niño Index ', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Oceanic Niño Index -> Precip_anom(lat,lon)| Niño 1+2 Index', fontdict = {'fontsize' : 23})
#plt.title('Causal map for Niño 1+2 Index -> Precip_anom(lat,lon)| Oceanic Niño Index', fontdict = {'fontsize' : 23})


#plt.title('Causal map for Oceanic Niño Index -> F(lat,lon)| Niño 1+2, Niño 3, Niño 4, Trans Niño Index', fontdict = {'fontsize' : 23.2})
#plt.title('Causal map for Trans Niño Index -> F(lat,lon)| Niño 1+2, Niño 3, Niño 4, Oceanic Niño Index', fontdict = {'fontsize' : 23.3})
#plt.title('Causal map for Niño 1+2 Index -> F(lat,lon)| Niño 3, Niño 4, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 21.8})
#plt.title('Causal map for Niño 3 Index -> F(lat,lon)| Niño 1+2, Niño 4, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 21.8})
#plt.title('Causal map for Niño 4 Index -> F(lat,lon)| Niño 1+2, Niño 3, Oceanic Niño Index, Trans Niño Index', fontdict = {'fontsize' : 21.8})

#plt.title('Causal map for Oceanic Niño Index -> F(lat,lon)', fontdict = {'fontsize' : 22.5})
#plt.title('Causal map for Trans Niño Index -> F(lat,lon)', fontdict = {'fontsize' : 22.5})
#plt.title('Causal map for Niño 1+2 Index -> F(lat,lon)', fontdict = {'fontsize' : 22.5})
plt.title('Causal map for Niño 3 Index -> F(lat,lon)', fontdict = {'fontsize' : 22.5})
#plt.title('Causal map for Niño 4 Index -> F(lat,lon)', fontdict = {'fontsize' : 22.5})


plt.savefig("nino3_wo_conditioning_1.pdf")
#plt.savefig("tni_wo_2002-2021.pdf")
f.show()
input()
