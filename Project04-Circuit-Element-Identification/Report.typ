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
//#set page(height: auto)

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
  last_modified: datetime.today()
)

#counter(heading).update(4)

#outline()
#pagebreak()
== Objective
#figure(image("Identification.png"))

The objective of Project 4 was to determine. The unknown load could be a purely resistive, RL, or RC network. 
*We were given Box \#4*

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
  - If $"phs"_Q < 0 degree$ Element Q is a capacitor and $cal(Z)_Q = 1/(j omega C_Q)$


#pagebreak()
== Results

With $V_"IN" = 2V_"PP" @ 1k"Hz"$, we measured the following RMS voltages with our DMM:
#grid(columns:2, gutter: 1em,
image("SCR0008.png"),image("SCR0012.png"),image("SCR0013.png"),image("SCR0006.png"))
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

This gives us an RMS current of:
$
  "Irms" &= V_R / R_R
  \
  &= (0.233V) / (980.2 Omega)
  \
  &= 238mu A
$

#pagebreak()
Next, we determine that the phase difference between $V_X$ and $V_R$ is $0 degree$.\
And, the phase difference between $V_Y$ and $V_R$ is $15.48 degree$ leading.
#figure(grid(columns:2, image("P03.PNG"),image("P07.PNG")),caption: [\ Left: Phase difference between $V_X$ and $V_R$ \ Right: Phase difference between $V_Y$ and $V_R$])

This leads us to our conclusion for the internal layout of the box (@circuit).

We can now calculate the resistance of Element P (X) and the complex impedance of Element Q (Y).
#columns(2)[
$
  R_P &= V_P / "Irms"
  \
  &= (1.02V) / (238mu A)
  \
  &= 4.29k Omega
$
#colbreak()
$
  
  cal(Z)_Q &= V_Q / "Irms"
  \
  &= (0.104V) / (238mu A)
  \
  &= 2.119k Omega
$ <impedenceQ>
]
Finally we use the impedance of Element Q (@impedenceQ) to determine the value of Element Q which we have already identified as a capacitor.
$
  cal(Z)_Q &= 1/(j omega C_Q)
  \
  C_Q &= 1/(j omega cal(Z)_Q)
  \
  &= 1/(j times 2 pi times 1k "Hz" times 2.119k Omega)
  \
  &= 80n F
$
This gives us our final results for the concealed box:
$
  "Element X", "Resistor", 4.29k Omega
  \
  "Element Y", "Capacitor", 80n F
$

== Conclusion
After crossreferencing our results with the available components in the lab, we determined that the concealed box contained a $4.6k Omega$ resistor and a $100n F$ capacitor. The discrepancy between our calculated values and the actual values can be attributed to measurement error and component tolerances. The final circuit is shown below (@circuit).

#figure(image("Circuit.PNG"),caption: [The internal circuit of the concealed box]) <circuit>