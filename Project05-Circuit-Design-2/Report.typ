#let coverpage(title: str, author, class, due_date: datetime, last_modified: datetime) = [
  #align(center, [
  #v(6em)
  #text(14pt, weight: "bold", title)
  #v(2em)
  #text(12pt, style: "italic", author.join(" & "))
  #v(1em)
  #text(style: "italic", class)
  #v(1em)
  #grid(
    columns: 2,
    gutter: 8pt,
    "Due Date:", due_date.display(),
    "Last modified:", last_modified.display(),
  )
])
#pagebreak()
]

#set text(font: "Liberation Sans", size: 10pt)
#set par(justify: false)
#show raw.where(lang: "python"): it => rect(text(size: 6pt,it), width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set math.equation(numbering: "Eq 1")
#set figure(kind: image)
#set heading(numbering: "1.A.1.a")
#let mathHeading(content) = text(
  size: 15pt,
  fill: blue.darken(40%),
  content,
)

#set page(height: auto)
#let Hz = "Hz"

// Footer with "Page X of Y"
#show: page.with(
  footer: align(center)[#context[
    Page #counter(page).display() of #counter(page).final().first()
  ]],
)

#let author = (
  "Malachy Crossan",
  "Jacob Rosen",
  )
#let class = "EEL3123-C0013: Linear Circuits II"
#let title = "Project 5: Circuit Design 2"
#let description = ""
#set document(author: author, title: title, description: description)

#coverpage(
  title: title,
  author,
  class,
  due_date: datetime(year: 2026, month: 7, day: 28),
  last_modified: datetime.today(),
)

#counter(heading).update(4)

#outline()
#pagebreak()
== Objective
#figure(
  image("Circuit-Model.png", width: 60%),
  caption: [Circuit Model],
)

#figure(table(columns:2, align: (left,center),
  $R_"min"$, $600 Omega$,
  $R_"max"$, $30k Omega$,
  $1 Hz <= f <= 200 Hz$, $abs(V_O) <= 0.7 times abs(V_"IS")$,
  $200 Hz < f < 3k Hz$, $?$, //TODO: write inferred condition
  $3k Hz <= f < 5k Hz$, $abs(V_O) >= 0.7 times abs(V_"IS")$,
  $5k Hz < f$, $abs(V_O) >= 0.8 times abs(V_"IS")$,
), caption: [Design Specs (Section 13) \ #text(size: 7pt)[$f$: Frequency\ $abs(V_"IS")$: Input Signal Voltage Amplitude \ $abs(V_O)$: Output Voltage Amplitude]]
)

#columns(2)[
#text(size: 6pt)[
```python

import matplotlib.pyplot as plt
import numpy as np
frequencies = np.logspace(0, 4, 200)
plt.semilogx(frequencies, frequencies/ frequencies)
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain')
plt.title('Gain vs Frequency')
plt.grid(True)
plt.fill_between(frequencies, 0, 0.7, where=(frequencies < 200), color='red',)
plt.fill_between(frequencies, 0, 1.0, where=(frequencies >= 200) & (frequencies <= 3000), color='yellow',)
plt.fill_between(frequencies, 0.7, 1.0, where=(frequencies >= 3000) & (frequencies <= 5000), color='green',)
plt.fill_between(frequencies, 0.8, 1.0, where=(frequencies >= 5000), color='green',)
plt.savefig("Bounds.svg")

```]#colbreak() #image("Bounds.svg")
]
== Plan
// Using an initial design of a series Capacitor, cutoff freq moved around too much
// Placed a resistor in parallel with load to stabilize the frequency
// Show circuit without values
$
  abs(V_O/V_"IS") = R_P/sqrt((R_S + R_P)^2+(1/(2pi s C))^2)
$
where
$
  R_P &= R_2 || R_L
  \
  R_P_"Min" &= R_2 || 600 Omega
  \
  R_P_"Max" &= R_2 || 3k Omega
$

#columns(2)[
```python

import sympy as sp
import matplotlib.pyplot as pt
f, RL, C = sp.symbols('f RL C', positive=True)
Rs = 50
# freq, RL, threshold, sense
conditions = [(200, 30000, 0.7, '<='), (3000, 600, 0.7, '>='), (5000, 600, 0.8, '>=')]
print(f"{'R2(ohm)':>8} {'C_min(uF)':>12} {'C_max(uF)':>12}  works?")
for R2 in range(0, 1000, 20):
    Rp = R2 * RL / (R2 + RL)
    g = Rp / sp.sqrt((Rs + Rp)**2 + (1 / (2*sp.pi*f*C))**2)
    lo, hi, ok = [], [], True
    for fv, RLv, thr, sense in conditions:
        sols = [s for s in sp.solve(sp.Eq(g.subs({f: fv, RL: RLv}), thr), C) if s.is_real and s > 0]
        if sols:
            (hi if sense == '<=' else lo).append(float(sols[0]))
        else:
            ok = False
    if not ok or not lo or not hi:
        print(f"{R2:8d} {'--':>12} {'--':>12}  no")
        continue
    C_min, C_max = max(lo), min(hi)
    print(f"{R2:8d} {C_min*1e6:12.3f} {C_max*1e6:12.3f}  {'yes' if C_min < C_max else 'no'}")

```
Analyzing these results subjectively, we felt that the $620 Omega$ resistor would work best for this application. The $620 Omega$ resistor was supposedly available in the lab according to Appendix II of the lab manual.

This gave us a range between $.229mu F$ and $1.405mu F$ assuming that all components were manufactured exactly to their value. However, in the real world, this is never the case. To minimize the chance for component tolerances to deviate the circuit behavior from the design specifications, we chose a value as close to the median as possible: $.47mu F$

#colbreak() #figure(raw(lang: "python", read("calc.txt")), caption: [Possible values for $R_2$ and $C$])
]

//TODO: Make look better
```python

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
    plt.savefig("Verify-620R-470nF.svg")
verify(R2=620, C=0.47e-6)
# verify(R2=680, C=0.3e-6)

Output:
R2=620 ohm, C=0.470 uF
  Stopband 200Hz   gain=0.3344  need <= 0.7  -> PASS
  Passband 3kHz    gain=0.8187  need >= 0.7  -> PASS
  Passband 5kHz    gain=0.8439  need >= 0.8  -> PASS
Overall: PASS
```
#image("Verify-620R-470nF.svg")
#lorem(20) //TODO: as you can see all intermediate values of RL pass

== Results
#lorem(20) //TODO: The first issue was that neither 620R or 470nF were available. We used 3 .1uF caps in parallel instead. using python results from figure BLANK

```python
R2=680 ohm, C=0.300 uF
  Stopband 200Hz   gain=0.2420  need <= 0.7  -> PASS
  Passband 3kHz    gain=0.7794  need >= 0.7  -> PASS
  Passband 5kHz    gain=0.8307  need >= 0.8  -> PASS
Overall: PASS
```
#image("Verify-680R-300nF.svg")
#lorem(20) //TODO: as you can see all intermediate values of RL pass although cutting it a little closer.

#lorem(10) //TODO: we moved on to simulating it
//TODO: Full schematic design for sim
//TODO: Simulation results

#lorem(20) //TODO: after verifying it in the sim, we built the circuit in the lab.

//TODO: better caption name
#figure(grid(columns:2, gutter: .5em,
    image("Wav-600R-100Hz.PNG"),
    image("Wav-30kR-100Hz.PNG"),
    image("Wav-600R-4kHz.PNG"),
    image("Wav-30kR-4kHz.PNG"),
    image("Wav-600R-5100Hz.PNG"),
    image("Wav-30kR-5100Hz.PNG"),
  ),caption: "Gain"+grid(columns:2, gutter: 3pt,
    strong("Left:"),strong("Right:"),
    [$600 Omega$],[$30k Omega$],
    $100 Hz$,$100 Hz$,
    $4k Hz$,$4k Hz$,
    $5.1k Hz$,$5.1k Hz$,
)
)

#lorem(30) //TODO: Explain results

//TODO: better caption name
#figure(image("Bode-600R.PNG"),caption: [Something])
#figure(image("Bode-30kR.PNG"),caption: [Something])

== Conclusion
#lorem(60) //TODO: Explain results
