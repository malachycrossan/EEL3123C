import numpy as np
import matplotlib.pyplot as plt

Rs = 50

def gain(f, RL, R2, C):
    Rp = R2 * RL / (R2 + RL)
    return Rp / np.sqrt((Rs + Rp)**2 + (1/(2*np.pi*f*C))**2)

def verify(R2, C):
    checks = [("Stopband 200Hz", 200, 30000, 0.7, '<='),
              ("Passband 3kHz",  3000,  600, 0.7, '>='),
              ("Passband 5kHz",  5000,  600, 0.8, '>=')]
    print(f"R2={R2} ohm, C={C*1e6:.3f} uF")
    all_ok = True
    for name, f, RL, thr, sense in checks:
        g = gain(f, RL, R2, C)
        ok = g <= thr if sense == '<=' else g >= thr
        all_ok &= ok
        print(f"  {name:16s} gain={g:.4f}  need {sense} {thr}  -> {'PASS' if ok else 'FAIL'}")
    print("Overall:", "PASS" if all_ok else "FAIL")

    #Add shaded region for passband and stopband
    for RL in range(600, 30000, 1000):
        frequencies = np.logspace(0, 4, 200)
        gains = np.array([gain(f, RL, R2, C) for f in frequencies])
        plt.semilogx(frequencies, gains, label=f'R2={R2} ohm, C={C*1e6:.3f} uF')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Gain')
    plt.title('Gain vs Frequency')
    plt.grid(True)
    plt.fill_between(frequencies, 0, 0.7, where=(frequencies < 200), color='red', alpha=0.3, interpolate=False)
    plt.fill_between(frequencies, 0, 1.0, where=(frequencies >= 200) & (frequencies <= 3000), color='yellow', alpha=0.3, interpolate=False)
    plt.fill_between(frequencies, 0.7, 1.0, where=(frequencies >= 3000) & (frequencies <= 5000), color='green', alpha=0.3, interpolate=False)
    plt.fill_between(frequencies, 0.8, 1.0, where=(frequencies >= 5000), color='green', alpha=0.3, interpolate=False)
    plt.show()

verify(R2=620, C=0.47e-6)
#verify(R2=300, C=10.0e-6)