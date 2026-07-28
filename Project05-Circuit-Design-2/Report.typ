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

//#set page(height: auto)
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
)<Circuit-Model>

Design, Analyze, Simulate, Build and Test a two port circuit. @Circuit-Model shows the desired circuit with a voltage input ($V_"IF"$) to the left and a voltage output ($V_O$) to the right.

The voltage input is driven by a function generator. More specifically, an AC voltage source with an internal resistance of $50 Omega$).
The voltage output is caused by a variable load, $600 Omega$ to $30k Omega$ and the resulting current.

Our objective is to design a circuit that will attenuate a signal less than $200 Hz$ and pass a signal above $3k Hz$. More detailed specifications below (@Specs)

#figure(table(columns:2, align: (left,center),
  $R_"min"$, $600 Omega$,
  $R_"max"$, $30k Omega$,
  $1 Hz <= f <= 200 Hz$, $abs(V_O) <= 0.7 times abs(V_"IS")$,
  $200 Hz < f < 3k Hz$, $0 <= abs(V_O) <= 1.0 times abs(V_"IS")$,
  $3k Hz <= f < 5k Hz$, $abs(V_O) >= 0.7 times abs(V_"IS")$,
  $5k Hz < f$, $abs(V_O) >= 0.8 times abs(V_"IS")$,
), caption: [Design Specs (Section 13) \ #text(size: 7pt)[$f$: Frequency\ $abs(V_"IS")$: Input Signal Voltage Amplitude \ $abs(V_O)$: Output Voltage Amplitude]]
)<Specs>

@visual-specs is a bode plot of the frequency bands and their accepted gains for each range. Essentially, if the frequency response graph for all resistances lies entirely in these zones then it is an acceptable circuit.

#figure(grid(columns: 2,
text(size: 6pt)[
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

```
],
image("Bounds.svg"),
)
)<visual-specs>

== Plan
Using an initial design of just a series Capacitor, the cutoff frequency changes too much with the load resistance. To stabilize the frequency, we placed a resistor in parallel with the load. This resistor is labeled $R_2$ in @circuit-design.



/*$
  abs(V_O/V_"IS") = R_P/sqrt((R_S + R_P)^2+(1/(2pi s C))^2)
$
where*/

$
  R_P &= R_2 || R_L
  \
  R_P_"Min" &= R_2 || 600 Omega
  \
  R_P_"Max" &= R_2 || 30k Omega
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

However, neither the $620 Omega$ resistor nor the $470n F$ capacitor was available in the lab. We used a $680 Omega$ resistor and three $0.1 mu F$ capacitors in parallel instead.

#figure(
  image("Project05-KiCad/Circuit.PNG", width: 60%),
  caption: [Circuit Design],
) <circuit-design>

The following code was used to verify if a Resistor and Capacitor pair would meet the design specifications.
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
#figure(image("Verify-620R-470nF.svg"), caption: [Verify 620R & 470nF]) <620R-470nF>
@620R-470nF above is the verification of the $620 Omega$ resistor and $470n F$ capacitor. The gain for all three conditions is within the design specifications.

== Results
After modifying our design in the experiment phase, we first verified the $680 Omega$ resistor and $300n F$ capacitor in the same manner as the original design.

```python
R2=680 ohm, C=0.300 uF
  Stopband 200Hz   gain=0.2420  need <= 0.7  -> PASS
  Passband 3kHz    gain=0.7794  need >= 0.7  -> PASS
  Passband 5kHz    gain=0.8307  need >= 0.8  -> PASS
Overall: PASS
```
#figure(image("Verify-680R-300nF.svg"), caption: [Verify 680R & 300nF])
All intermediate values of $R_L$ pass although cutting it a little closer. The gain for all three conditions is within the design specifications.

We simulated the circuit shown in @circuit-design. The resulting bode plot is shown below (@Bode-600 & @Bode-30k). The bode plot shows the gain of the circuit for all values of $R_L$ from $600 Omega$ to $30k Omega$. The gain is within the design specifications for all values of $R_L$.
#figure(image("Project05-KiCad/Bode-600.png"), caption: [Bode Plot of Simulated Circuit with $R_L = 600 Omega$]) <Bode-600>
#figure(image("Project05-KiCad/Bode-30k.png"), caption: [Bode Plot of Simulated Circuit with $R_L = 30k Omega$]) <Bode-30k>

After building the circuit in the lab, we measured the gain at $100 Hz$, $4k Hz$, and $5.1k Hz$ for both $600 Omega$ and $30k Omega$. The results are shown below (@Gain-Results). 

#figure(grid(columns:2, gutter: .5em,
    image("Wav-600R-100Hz.PNG"),
    image("Wav-30kR-100Hz.PNG"),
    image("Wav-600R-4kHz.PNG"),
    image("Wav-30kR-4kHz.PNG"),
    image("Wav-600R-5100Hz.PNG"),
    image("Wav-30kR-5100Hz.PNG"),
  ),caption: "Oscilloscope Gain Results"+grid(columns:2, gutter: 3pt,
    strong("Left:"),strong("Right:"),
    [$600 Omega$],[$30k Omega$],
    $100 Hz$,$100 Hz$,
    $4k Hz$,$4k Hz$,
    $5.1k Hz$,$5.1k Hz$,
)
) <Gain-Results>

The results of the lab measurements are consistent with the simulation results. The gain at $100 Hz$ is below $0.7$, while the gain at $4k Hz$ and $5.1k Hz$ is above $0.7$ and $0.8$ respectively, for both worst case loads. This demonstrates that the circuit meets the design specifications across the specified frequency ranges.

The bode plots of the entire frequency range for both $600 Omega$ and $30k Omega$ loads are shown below.
#figure(image("Bode-600R.PNG"),caption: [Bode Plot with $R_L = 600 Omega$])
#figure(image("Bode-30kR.PNG"),caption: [Bode Plot with $R_L = 30k Omega$])

== Conclusion
The circuit design meets the spec-ed requirements for frequency attenuation and gain across the defined frequency ranges. The combination of a series capacitor and a parallel resistor allowed us to have a relatively stable cutoff frequency throughout the load range. Calculations, simulations and experimental results confirm that the circuit performs as intended.
