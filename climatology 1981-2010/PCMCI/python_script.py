from os import startfile
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




number_of_gridpoints = 10368
start_longditude = 1.25
end_longditude = 358.75
start = 0
skipfooter=4882857
months = 471
coefficients = numpy.zeros(shape=(10368,3))

for i in range(1,number_of_gridpoints+1):
  
  df = pd.read_csv(r"C:\Users\Alexej\Desktop\pcmci.csv", sep=';',header=None, skiprows=[start],skipfooter=skipfooter)
  #print(df.values)
  #print(df.shape)

  # Data must be array of shape (time, variables)
  cond_ind_test = ParCorr()
  var_names = [r'$Precipitation Anomaly$', r'$Oceanic Niño Index$', r'$Niño 4$']
  dataframe = pp.DataFrame(df.values,  
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
  pcmci.print_significant_links(
          p_matrix = results['p_matrix'], 
          q_matrix = q_matrix,
          val_matrix = results['val_matrix'],
          alpha_level = 0.05)    
  '''' 
      tp.plot_graph(
      val_matrix=results['val_matrix'],
      link_matrix=link_matrix,
      var_names=var_names,
      link_colorbar_label='cross-MCI',
      node_colorbar_label='auto-MCI',
      ); plt.show()
  '''
  parents = pcmci.return_significant_links(pq_matrix=q_matrix,
                          val_matrix=results['val_matrix'], alpha_level=0.05,include_lagzero_links=False)['link_dict']

  pred = Prediction(dataframe=dataframe,cond_ind_test=ParCorr(),prediction_model=sklearn.linear_model.LinearRegression(),verbosity=1,train_indices= range(int(0.8*months)),test_indices=range(int(0.8*months)))

  coeff= pred.fit(parents,tau_max=12,return_data=False)

  print(coeff.get_val_matrix())
  print(coeff.get_coefs())
