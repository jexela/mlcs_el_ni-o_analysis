import matplotlib.pyplot as plt 
import pandas as pd

blueshapes = pd.read_csv(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\blueshapes.csv",sep=';')
redshapes = pd.read_csv(r"C:\Users\Alexej\Desktop\Bachelorarbeit\climatology 1981-2010\Benjamini_Hochberg\redshapes.csv",sep=';')
x = blueshapes['year']
y = blueshapes['area']
z = redshapes['area']
plt.figure(figsize=(18.20,10.80))
plt.plot(x,y,color = 'blue',marker='o',label="blue shape (negative correlation)")
plt.plot(x,z,color = 'red', marker='o',label="red shape (positive correlation)")
plt.rc('legend',fontsize=22)
plt.xlabel('Year', fontdict = {'fontsize' : 25})
plt.xlim([1983,2018])
plt.xticks([1984,1987,1991,1996,2000,2005,2012,2017],fontsize=20)
plt.yticks(fontsize=20)
plt.ticklabel_format(style='sci',axis='y')
plt.ylabel('Significant area in km²', fontdict = {'fontsize' : 25})
plt.title('Biggest correlation shapes', fontdict = {'fontsize' : 25})
plt.legend()
plt.savefig("redblueshapes_timeline.pdf")
plt.show()
#plt.savefig("High resoltion.png",dpi=300)
