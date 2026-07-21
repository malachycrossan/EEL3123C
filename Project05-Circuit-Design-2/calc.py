import sympy as sp
import matplotlib.pyplot as pt

f, RL, C = sp.symbols('f RL C', positive=True)
Rs = 50

# (freq, RL, threshold, sense) — worst-case corner per spec band
conditions = [(200, 30000, 0.7, '<='), (3000, 600, 0.7, '>='), (5000, 600, 0.8, '>=')]

inR2, threshLow, threshHigh, threshDiff = [], [], [], []
print(f"{'R2(ohm)':>8} {'C_min(uF)':>12} {'C_max(uF)':>12}  feasible")
for R2 in range(0, 1000, 20):
    Rp = R2 * RL / (R2 + RL)
    g = Rp / sp.sqrt((Rs + Rp)**2 + (1 / (2*sp.pi*f*C))**2)
    lo, hi, ok = [], [], True
    for fv, RLv, thr, sense in conditions:
        sols = [s for s in sp.solve(sp.Eq(g.subs({f: fv, RL: RLv}), thr), C) if s.is_real and s > 0]
        if sols:
            (hi if sense == '<=' else lo).append(float(sols[0]))
        else:
            ok = False  # asymptotic gain can't reach threshold at this R2
    if not ok or not lo or not hi:
        print(f"{R2:8d} {'--':>12} {'--':>12}  no")
        continue
    C_min, C_max = max(lo), min(hi)
    inR2.append(R2)
    threshLow.append(C_min)
    threshHigh.append(C_max)
    threshDiff.append(C_max - C_min)
    print(f"{R2:8d} {C_min*1e6:12.3f} {C_max*1e6:12.3f}  {'YES' if C_min < C_max else 'no'}")

pt.plot(inR2, [c*1e6 for c in threshLow], label='C_min', color='blue')
pt.plot(inR2, [c*1e6 for c in threshHigh], label='C_max', color='red')
pt.plot(inR2, [c*1e6 for c in threshDiff], label='C_diff', color='green')
pt.title('R2 vs C_min/C_max')
pt.show()