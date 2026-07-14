import numpy as np
import matplotlib.pyplot as pt
import scipy.signal as signal
import sympy as sp

R = 9.92e3
# Vs_pp = 2 @ 2kHz
# Dmm:
Vs_rms = 0.70336
# Dmm:
V2_rms = 233.89e-3

I_rms = V2_rms/R
print(I_rms)

V1_rms = Vs_rms - V2_rms
print(V1_rms)

Z1 = V1_rms / I_rms
print(Z1)

P1 = V1_rms * I_rms
print(P1)

print("Components:")
R1 = P1 / (I_rms**2)
print(R1)

X1 = np.sqrt(Z1**2 - R1**2)
print(X1)

# Vs_pp = 2 @ 100hZ
# Scope -> Vs_rms = 693.97mV
# Scope (Calc) -> V1_rms = 203.59mV
# Scope -> V2_rms = 527.49mV

print(360*100*3.9803*(10**-3))
