import numpy as np
import h5py as h5
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.cm as cm

prefix = "/media/user/9EAEE48CAEE45DF1/cyl_temp/p-bed-data/1e4/"
prefix = "../../post/"
prefix = "../"
prefix = prefix + "test_swi_r1_"
R = 8
RR = 48
num = np.arange(0,235+1)
nu = 0.01
Dm = nu/1e3 

name = prefix + str(num[0]).zfill(4) + ".h5"
print(name)
f = h5.File(name)
PX = np.array(f['RWPposition'])
px = PX[0:-2:3]
py = PX[1:-1:3]
Nx = int(f['Nx'][0])
Ny = int(f['Ny'][0])
ppy = np.floor(np.min(py))

layer = np.array([ppy])
M0 = np.zeros((len(layer))) + np.nan
kkk = []
for i in range(len(layer)):
	kkk.append(np.where(py>=layer[i]))
	M0[i] = np.size(np.where(py>=layer[i]))
colors = cm.rainbow(np.linspace(0,1,len(kkk)))

print('initial num ',M0)

step = 10
b = np.arange(0,ppy+step,step)
sb = len(b)
sb = sb-1
nn = np.zeros(len(num)) + np.nan
M = np.zeros((len(num),len(layer))) + np.nan
ym = np.zeros(len(num)) + np.nan
yhis = np.zeros((sb,len(num))) + np.nan
for i in range(len(num)):
	nn[i] = i
	name = prefix + str(num[i]).zfill(4) + ".h5"
	print("start process ", name)
	f = h5.File(name)

	PX = np.array(f['RWPposition'])
	px = PX[0:-2:3]
	py = PX[1:-1:3]
	ym[i] = np.median(py[np.where(py>1)])

	kkk1 = np.where(py<=ppy)
	n,be = np.histogram(py[kkk1],bins=b,density=True)
	# print n
	yhis[:,i] = n

	for ii in range(len(layer)):
		M[i,ii] = float(np.size(np.where(py[kkk[ii]]>=layer[ii])))/M0[ii]
# yhis = np.array(yhis)
# print yhis
k1 = np.zeros(len(layer)) + np.nan
Vs = np.zeros(len(layer)) + np.nan
Vt = np.zeros(len(layer)) + np.nan
Vv = np.zeros(len(layer)) + np.nan
As = np.zeros(len(layer)) + np.nan
 
tt = nn*2e3
for ii,c in zip(range(len(layer)),colors):
	plt.plot(np.sqrt(tt),M[:,ii],'o',color=c,label=layer[ii])
	Z = np.polyfit(np.sqrt(tt),M[:,ii],1)
	k1[ii] = -Z[0]
	plt.plot(np.sqrt(tt),Z[0]*np.sqrt(tt)+Z[1],color=c)
# 	Vs[ii] = np.sum(np.sum(ga[1:layer[ii],:]))
# 	Vt[ii] = (layer[ii]*1.0-1.0)*Nx*1.0
# 	Vv[ii] = Vt[ii] - Vs[ii]
# 	As[ii] = Nx - np.sum(ga[layer[ii],:]) 


# plt.legend()
plt.xlabel('t^0.5')
plt.ylabel('M(t)/M_0')
plt.savefig('M.png',dpi=500)
plt.clf()

plt.plot(tt,ym)
plt.plot([tt[0],tt[-1]],[ppy, ppy],'r')
plt.xlabel('t')
plt.ylabel('Median y')
plt.savefig('ym.png',dpi=500)
plt.clf()

plt.pcolor(yhis)
plt.clim(vmin=0, vmax=1e-2)
plt.colorbar()
plt.savefig('yhis.png',dpi=500)

plt.clf()

f.close()

# with open("Deff_1e4.txt","w") as f:
# 	f.write(str(Dm)+ "\t Dm\n")
# 	for l,d in zip(layer, Deff):
# 		f.write(str(l)+" "+str(d)+"\t pos, Deff/Dm\n")
	
	
