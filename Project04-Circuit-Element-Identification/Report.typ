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
#show raw.where(lang: "python"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set math.equation(numbering: "Eq 1")
#set heading(numbering: "1.A.1.a")
#let mathHeading(content) = text(
  size: 15pt,
  fill: blue.darken(40%),
  content,
)
#set page(height: auto)

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
#let title = "Project 4: Circuit Element Identification"
#let description = ""
#set document(author: author, title: title, description: description)

#coverpage(
  title: title,
  author,
  class,
  due_date: datetime(year: 2026, month: 7, day: 21),
  last_modified: datetime(year: 2026, month: 7, day: 21)
)

#counter(heading).update(4)

#outline()
#pagebreak()
== Objective
#figure(image("Identification.png"))
Box\#4

The objective of Project 4 was to determine. The unknown load could be a purely resistive, RL, or RC network. 

Equipment:
- Concealed AC load box (Unknown RR, RL, or RC)
- Digital multimeter (DMM)
- Reference resistor
- Oscilloscope
- USB storage

== Plan
A known reference resistor is connected in series with the concealed box so that the circuit current can be calculated from a voltage measurement.

+ Measure the RMS voltages across the source, reference resistor, and each concealed load.
+ Use the reference-resistor voltage to calculate circuit RMS current. $I = I_R = V_R/R_R$
+ Measure the phase difference between $V_X$ and $V_R$ with the oscilloscope.
+ Measure the phase difference between $V_Y$ and $V_R$ with the oscilloscope.
+ Determine the types of components for Element X and Element Y.
+ Calculate the resistance of the unknown resistor $R_P = V_P/"Irms"$.\ (We will call this Element P. It could be Element X or Element Y)
+ Calculate the complex impedance of the other component $cal(Z)_Q = V_Q/"Irms"$.\ (We will call this Element Q. It could be Element X or Element Y)
+ Calculate the value of Element Q.
  - If $"phs"_Q approx 0 degree$ Element Q is a resistor and $cal(Z)_Q = R_Q$
  - If $"phs"_Q > 0 degree$ Element Q is an inductor and $cal(Z)_Q = j omega L_Q/R_L$
  - If $"phs"_Q < 0 degree$ Element Q is a capacitor and $ cal(Z)_Q = 1/(j omega C_Q)$

== Results

With $V_"IN" = 2V_"PP" @ 1k"Hz"$, we measured the following RMS voltages with our DMM:
//SCR0008.BMP: V_IN
//SCR00012.BMP: V_R
//SCR00013.BMP: V_X
//SCR0006.BMP: V_Y (Close enough. Incorrect measurement)

$  
  V_"IN" = 1.42 V  \
  V_R = 233m V  \
  V_X = 1.02 V  \
  V_Y = 104m V  \
$
```python
#error:
print(1.42 - (233e-3 + 1.02 + 104e-3))
>> 0.06299999999999972 #V
print(0.063/104e-3)
>> 0.6057692307692308 #61% error?!?!?

```


100n F
4.6k Omega

```python

import numpy as np
import sympy as sp
Vx, Vy, Vr, Vin, Ir = sp.symbols('Vx Vy Vr Vin Ir')
eq1 = Vin - (Vx + Vy + Vr)
eq2 = Vr/992 - (Ir)
eq3 = Vx/4.6e3 - (Ir)
Zc = 1/(sp.sqrt(-1)*1e3*2*np.pi*100e-9)
eq4 = Vy/Zc - (Ir)
eq5 = Vin - (1.423)
print(sp.solve([eq1,eq2,eq3,eq4,eq5,],[Ir, Vx, Vy, Vr, Vin,]))

{
  Ir: 0.000235098362087307 + 6.68500802113588e-5*I,
  Vin: 1.42300000000000, #SCR0008.BMP
  Vr: 0.235098362087307 + 0.0668500802113589*I, #SCR0012.BMP
  Vx: 1.08145246560161 + 0.307510368972251*I, #SCR0013.BMP
  Vy: 0.106449172311081 - 0.37436044918361*I, #SCR0006.BMP will work
}

```

The $10k Omega$ (measured $9.92k Omega$) resistor was used to determine the current through the unknown load box. Using the DMM measurements, the resistor RMS voltage was $234m V$, giving a current of:

$
  "Irms" = 0.234 / 992 = 0.0236m A
$

The voltage across the load box was approximately:
$
  V_1 = 0.703 - 0.234 = 0.469V
$

=== Load Impedance
Therefore, the impedance was approximately:
$
  Z_1 = (0.469 V)/ (0.0236m A) = 19.8k Omega
$

The oscilloscope measurements in  show $467.79m V$ RMS across the box and $230.52m V$ RMS across the resistor. These measurements produced an impedance of approximately $20.1k Omega$, which closely agreed with the DMM calculation.

==== Rectangular Components
The rectangular components of the load impedance were calculated as follows:
$
  Z_1 = 19.8k Omega \
  "Irms"_1 = 23.6mu A \
  "Vrms"_1 = 0.469V \
  "Real" = Z_1 cos(1.19 degree) = 19.8k Omega \
  "Imaginary" = Z_1 sin(1.19 degree) = 0.412k Omega \
$

=== Phase Angle and Power Factor
==== Analytical Approach
We noticed that the load voltage was very slightly lagging so we decreased our source frequency to $100 "Hz"$ to make the phase difference more noticeable.

The $Delta t$ was then measured with the oscilloscope by comparing the time the reference resistor voltage and the load box voltage crossed $0V$. The oscilloscope measurements in  show a $Delta t$ of $3.90m s$.

$
  Delta t = 3.90m s \
  "f" = 100 "Hz"  \
  "T" = 1/f = 10m s \
  "Phase Angle" bold(@ 100 "Hz") = (Delta t )/ T times 360 degree = (3.90m s) / (10m s) times 360 degree = 140.4 degree
$

*Importantly*, this phase angle was measured at $100 "Hz"$, but the load box was designed to operate at $2k "Hz"$ so this only helped us determine that the load is in fact inductive.

==== Measured Approach

The measured phase angle was only $1.19 degree$ giving a power factor of:

$
  "PF" = cos(1.19 degree) = 0.9998
$

== Conclusion

The objective of this experiment was to determine the impedance and type of an unknown AC load by measuring RMS voltages and the phase difference between voltage and current. The load-box impedance was found to be approximately $20k Omega$, and the phase angle was measured as about $1.19 degree$.

Since the phase difference was lagging, the unknown box was classified as an RL load.

This experiment demonstrated how a known series resistor can be used to calculate AC current and unknown impedance. It also showed how oscilloscope phase measurements can distinguish between resistive, inductive, and capacitive loads. These methods will be useful in future AC circuit analysis and troubleshooting.
