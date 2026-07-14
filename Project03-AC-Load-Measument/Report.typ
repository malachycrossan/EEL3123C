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
#show raw.where(lang: "MATLAB"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set math.equation(numbering: "Eq 1")
#set heading(numbering: "1.A.1.a")
#let mathHeading(content) = text(
  size: 15pt,
  fill: blue.darken(40%),
  content,
)
//#set page(height: auto)
// 
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
#let title = "Project 3: AC Load Measurement"
#let description = ""
#set document(author: author, title: title, description: description)

#coverpage(
  title: title,
  author,
  class,
  due_date: datetime(year: 2026, month: 7, day: 14),
  last_modified: datetime(year: 2026, month: 7, day: 14)
)

#counter(heading).update(3)

#outline()
#pagebreak()
== Objective
Box \#1

The objective of Project 3 was to determine the impedance and power factor of a concealed AC load without opening the box or directly measuring its internal resistance, capacitance, or inductance. The unknown load could be a purely resistive, RL, or RC network. 

Equipment:
- Hantek 3-in-1 digital equipment
- Digital multimeter (DMM)
- Powered breadboard and leads
- Reference resistor
- Concealed AC load box (Unknown RR, RL, or RC network)
- Oscilloscope
- USB storage (USB screenshots required by the lab guidelines)
== Plan
A known reference resistor was connected in series with the concealed box so that the circuit current could be calculated from a voltage measurement.

- Construct a safe series test circuit containing the source, a selected reference resistor, and the concealed load.
- Measure the RMS voltages across the source, reference resistor, and concealed load.
- Use the reference-resistor voltage to calculate circuit current. ($"Irms" = "Vrms"/R$)
- Measure the phase difference between the load voltage and reference-resistor voltage with the oscilloscope.
- Calculate load impedance, rectangular components, and power factor. then classify the load as RR, RL, or RC.

== Results

#figure(grid(columns: 2, gutter: 1em,
image("assets/ACIC0001.png"),
image("assets/ACIC0002.png"),
), caption: [DMM measurements. $V_s$ (left) and $V_2$ (right) RMS voltages.])

With $V_s$ peak to peak set to $2V$ at $2k"Hz"$, we measured the following RMS voltages with our DMM:
$  
  V_s = 703m V  \
  V_2 = 234m V
$

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

The oscilloscope measurements in @Scope1 show $467.79m V$ RMS across the box and $230.52m V$ RMS across the resistor. These measurements produced an impedance of approximately $20.1k Omega$, which closely agreed with the DMM calculation.

#figure(image("assets/CE01.PNG"), caption: align(left)[
  C1 probe: $V_s$ (Positive terminal of box to Reference ground)
  \ C2 probe: $V_2$ (Negative terminal of box to Reference ground)
  \ M1 calc: $V_1$ (Positive terminal to negative terminal of box)
])<Scope1>

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

The $Delta t$ was then measured with the oscilloscope by comparing the time the reference resistor voltage and the load box voltage crossed $0V$. The oscilloscope measurements in @Scope2 show a $Delta t$ of $3.90m s$.

#figure(image("assets/CE03.PNG"), caption: align(left)[
  C2 probe: $V_2$ (Load box voltage)
  \ M1 calc: $V_1$ (Positive terminal to negative terminal of box)
])<Scope2>

$
  Delta t = 3.90m s \
  "f" = 100 "Hz"  \
  "T" = 1/f = 10m s \
  "Phase Angle" bold(@ 100 "Hz") = (Delta t )/ T times 360 degree = (3.90m s) / (10m s) times 360 degree = 140.4 degree
$

*Importantly*, this phase angle was measured at $100 "Hz"$, but the load box was designed to operate at $2k "Hz"$ so this only helped us determine that the load is in fact inductive.

==== Measured Approach
#figure(image("assets/CE04.PNG"), caption: align(left)[
  C2 probe: $V_2$ (Load box voltage)
  \ M1 calc: $V_1$ (Positive terminal to negative terminal of box)
])<Scope3>

The measured phase angle (@Scope3) was only $1.19 degree$ giving a power factor of:

$
  "PF" = cos(1.19 degree) = 0.9998
$

== Conclusion

The objective of this experiment was to determine the impedance and type of an unknown AC load by measuring RMS voltages and the phase difference between voltage and current. The load-box impedance was found to be approximately $20k Omega$, and the phase angle was measured as about $1.19 degree$.

Since the phase difference was lagging, the unknown box was classified as an RL load.

This experiment demonstrated how a known series resistor can be used to calculate AC current and unknown impedance. It also showed how oscilloscope phase measurements can distinguish between resistive, inductive, and capacitive loads. These methods will be useful in future AC circuit analysis and troubleshooting.