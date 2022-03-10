from os import startfile
from scipy import signal
import matplotlib
from matplotlib import pyplot as plt
## use `%matplotlib notebook` for interactive figures
import numpy
import pandas as pd
from sklearn import linear_model
import sklearn
from tigramite.pcmci import PCMCI
from tigramite.models import Prediction,Models
from tigramite.independence_tests import ParCorr
from tigramite import plotting as tp
import tigramite.data_processing as pp
numpy.random.seed(7)


number_of_gridpoints = 10368
longditude = 1.25
laditude = -88.75
start = 0
months = 240
coefficients_oni = numpy.zeros(shape=(10368,15))
coefficients_nino12 = numpy.zeros(shape=(10368,15))
coefficients_nino3 = numpy.zeros(shape=(10368,15))
coefficients_nino4 = numpy.zeros(shape=(10368,15))
coefficients_tni = numpy.zeros(shape=(10368,15))

cond_ind_test = ParCorr()
var_names = [r'$Precipitation Anomaly$', r'$Niño 1+2 Index$']

for i in range(0,number_of_gridpoints):
  
  df = pd.read_csv(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\PCMCI\causal_map_wo_conditioning\pcmci_nino12_1982_2001.csv", sep=';',skiprows=start,nrows=months)
  ds = signal.detrend(df.values[:,0],type='linear')
  dg = numpy.delete(df.values,0,axis=1)
  
  df_new = numpy.append(ds.reshape(-1,1),dg,axis=1)
  #print(signal.detrend(df.values[:,0]))
  #print(df.values)
  #print(df_new)
  print(df_new)
  start+=months
  #print(start)

  # Data must be array of shape (time, variables)
  dataframe = pp.DataFrame(df_new, 
                          var_names=var_names,
                          datatime = numpy.arange(len(df)))
  #tp.plot_timeseries(dataframe); plt.show()
  pcmci = PCMCI(dataframe=dataframe, cond_ind_test=cond_ind_test)
  results = pcmci.run_pcmci(tau_max=12, pc_alpha=None)
  '''
  pcmci.print_significant_links(p_matrix=results['p_matrix'],
                                      val_matrix=results['val_matrix'],
                                      alpha_level=0.05)
  '''
  ## Significant parents at alpha = 0.05:
  q_matrix = pcmci.get_corrected_pvalues(p_matrix=results['p_matrix'], tau_max=12, fdr_method='fdr_bh')
  link_matrix = pcmci.return_significant_links(pq_matrix=q_matrix,
                          val_matrix=results['val_matrix'], alpha_level=0.05)['link_matrix']
  """ pcmci.print_significant_links(
          p_matrix = results['p_matrix'], 
          q_matrix = q_matrix,
          val_matrix = results['val_matrix'],
          alpha_level = 0.05)   """  
  ''' 
      tp.plot_graph(
      val_matrix=results['val_matrix'],
      link_matrix=link_matrix,
      var_names=var_names,
      link_colorbar_label='cross-MCI',
      node_colorbar_label='auto-MCI',
      ); plt.show()
  '''
  parents = pcmci.return_significant_links(pq_matrix=q_matrix,
                          val_matrix=results['val_matrix'], alpha_level=0.05,include_lagzero_links=True)['link_dict']

  pred = Prediction(dataframe=dataframe,cond_ind_test=ParCorr(),prediction_model=sklearn.linear_model.LinearRegression(),verbosity=1,train_indices= range(int(0.8*months)),test_indices=range(int(0.8*months),months))

  coeff= pred.fit(parents,tau_max=12,return_data=False)

  #print(coeff.get_val_matrix())
  #print(coeff.get_coefs())
  
  #Get beta (causal) coefficients for Oceanic Niño Index
  coefficients_oni[i][0]=longditude
  coefficients_oni[i][1]=laditude
  coefficients_oni[i][2]=coeff.get_val_matrix()[1][0][1]
  coefficients_oni[i][3]=coeff.get_val_matrix()[1][0][2]
  coefficients_oni[i][4]=coeff.get_val_matrix()[1][0][3]
  coefficients_oni[i][5]=coeff.get_val_matrix()[1][0][4]
  coefficients_oni[i][6]=coeff.get_val_matrix()[1][0][5]
  coefficients_oni[i][7]=coeff.get_val_matrix()[1][0][6]
  coefficients_oni[i][8]=coeff.get_val_matrix()[1][0][7]
  coefficients_oni[i][9]=coeff.get_val_matrix()[1][0][8]
  coefficients_oni[i][10]=coeff.get_val_matrix()[1][0][9]
  coefficients_oni[i][11]=coeff.get_val_matrix()[1][0][10]
  coefficients_oni[i][12]=coeff.get_val_matrix()[1][0][11]
  coefficients_oni[i][13]=coeff.get_val_matrix()[1][0][12]

  if longditude==358.75:
    longditude=1.25
    laditude+=2.5
  else:
    longditude+=2.5
  
  print(i)
  print(coefficients_oni[i])

numpy.savetxt("nino12_wo_conditioning_1982_2001.csv", coefficients_oni, delimiter=";")


