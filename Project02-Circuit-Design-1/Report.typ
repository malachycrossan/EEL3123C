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
#let title = "Project 2: Circuit Design 1"
#let description = ""
#set document(author: author, title: title, description: description)

#coverpage(
  title: title,
  author,
  class,
  due_date: datetime(year: 2026, month: 7, day: 7),
  last_modified: datetime(year: 2026, month: 7, day: 7)
)

#counter(heading).update(2)
//#heading("Project 2 Circuit Design 1", numbering: none)


#outline()
#pagebreak()
== Part A
=== Objective
#figure(image("Fig1.png"),caption: "Circuit Design Part A")
We were expected to design circuits A and B such that their output had a specified gain proportional to their outputs. This Requirement is represented by @Design-Requirement-A1 and @Design-Requirement-A2
#columns(2)[
$
  V_"OA" = K_A times V_"IA"\
  V_"OB" = K_B times V_"IB"\
$ <Design-Requirement-A1>
#colbreak()
$
  K_A=0.5\
  K_B=0.9\
$<Design-Requirement-A2>
]
=== Design
The obvious choice to satisfy the design requirement is to use a voltage divider. Using a simple divider consisting of two resistors in the $1 k Omega$ to $10 k Omega$ range also satisfies both design constraints. The formula (@voltage-divider-formula) for this simple voltage divider (@voltage-divider-circuit) tells us that the ratio of the first resistor to the total resistance defines the gain.
#figure("Placeholder",
caption: "Simple Voltage Divider")<voltage-divider-circuit>
$
  V_"Out" = V_"In" times R_1/(R_1 + R_2)\
$<voltage-divider-formula>

In order to satisfy the design requirements, we will choose $1 k Omega$ resistors for $R_1$ in both circuits. We will then choose $1 k Omega$ and $9 k Omega$ for $R_2$ in circuits A and B respectively. The resulting circuits are shown in @Circuit-A-PartA and @Circuit-B-PartA.

#columns(2)[
  #figure(image("CircuitA-PartA.png"),caption: "Circuit A") <Circuit-A-PartA>
  #colbreak()
  #figure(image("CircuitB-PartA.png"),caption: "Circuit B") <Circuit-B-PartA>
]

#pagebreak()
=== Analysis Results
#columns(2)[
==== Circuit A
$
  #mathHeading[KCL@$V_"Out"$]\
  (V_"In" - V_"Out")/R_1 = V_"Out"/R_2\
  (V_"In" - V_"Out")/(1k Omega) = V_"Out"/(1k Omega)\
$

```python

import sympy as sp
Vi, Vo = sp.symbols('Vi Vo')
eq1 = (Vi - Vo)/1000 - Vo/1000
print(sp.solve(eq1, Vo))

>> [Vi/2]
```

$
  therefore V_"Out" = 0.5 times V_"In"
$ <Circuit-A-PartA-Solution>
#colbreak()
==== Circuit B
$
  #mathHeading[KCL@$V_"Out"$]\
  (V_"In" - V_"Out")/R_1 = V_"Out"/R_2\
  (V_"In" - V_"Out")/(1k Omega) = V_"Out"/(9k Omega)\
$

```python

import sympy as sp
Vi, Vo = sp.symbols('Vi Vo')
eq1 = (Vi - Vo)/1000 - Vo/9000
print(sp.solve(eq1, Vo))

>> [9*Vi/10]
```

$
  therefore V_"Out" = 0.9 times V_"In"
$ <Circuit-B-PartA-Solution>
]

As seen in the solutions (@Circuit-A-PartA-Solution and @Circuit-B-PartA-Solution), the design requirements were achieved.

Plotting these solutions with a $1"kHz"$ square wave at $V_"In"$ shows our expected behavior.

#grid(columns: (2fr,3fr))[
```python

import matplotlib.pyplot as pt
import scipy.signal as signal
import numpy as np
t = np.linspace(0,2, 1000)
Vi = signal.square(2*np.pi*t)
VoA = 0.5*Vi
VoB = 0.9*Vi
pt.plot(t,Vi)
pt.plot(t,VoA,'--')
pt.plot(t,VoB,'--')
pt.xlabel('Time (ms)')
pt.ylabel('Voltage (V)')
pt.title('Title')
pt.savefig('PartAWaveform.svg')

```
][
#image("PartAWaveform.svg")
]
=== Simulation Results
==== DC Simulation
I set the input voltage to $1V$ and measured the output voltage at $R_2$ for the circuits in @Circuit-A-PartA and @Circuit-B-PartA.\
#grid(columns:2,
"Circuit A:",
"Circuit B:",
image("CircuitA-PartA-DC.pdf"),
image("CircuitB-PartA-DC.pdf"),
)
==== AC Simulation
I set the input voltage to a $1V$ $1"kHz"$ square wave and measured the output voltage at $R_2$ for the circuits in@Circuit-A-PartA and @Circuit-B-PartA.\
#align(center,image("AC.PNG", width: 40%))
#grid(columns:2,
"Circuit A:",
"Circuit B:",
image("CircuitA-PartA-AC.pdf"),
image("CircuitB-PartA-AC.pdf"),
)
=== Experimental Results
As seen below, the experimental results for the circuits show that the output voltage is $plus.minus 0.5 V$ and $plus.minus 0.9 V$ for Circuit A and B respectively, which are the expected values.
#figure(grid(columns:2, gutter: 1em,
"Circuit A:",
"Circuit B:",
image("CircuitA-PartA-Exp-Wav.jpg"),
image("CircuitB-PartA-Exp-Wav.jpg"),
image("CircuitA-PartA-Exp.jpg"),
image("CircuitB-PartA-Exp.jpg"),
),caption: "Experimental Results for Circuit A and B")
=== Conclusion
In Part A, Circuit A and Circuit B were tested separately and behaved as expected. Circuit A produced 50% of its input voltage, while Circuit B produced 90% of its input voltage. For a $1 V$ input, the expected outputs were $0.5 V$ and $0.9 V$, and the simulation and experimental values were close to these results.

== Part B
=== Objective <PartBObjective>
#figure(image("Fig2.png"),caption: "Cascaded circuits from part A")<fig2>
In this configuration,
$V_"OB" != K_A times K_B times V_"IA"$. An analysis of the circuit in @fig2 is shown below.
$
  #mathHeading[KCL@$V_R_"A2"$]\
  (V_"In" - V_R_"A2")/R_"A1"
  =
  V_R_"A2"/R_"A2"
  +
  (V_R_"A2" - V_"Out")/R_"B1"
 \
$

$
  #mathHeading[KCL@$V_"Out"$]\
  (V_R_"A2" - V_"Out")/R_"B1"
  =
  V_"Out"/R_"B2"
  \
$

```python

import sympy as sp
Vi, Vra2, Vo = sp.symbols('Vi Vra2 Vo')
eq1 = (Vi - Vra2)/1000 - (Vra2/9000 + (Vra2 - Vo)/1000)
eq2 = (Vra2 - Vo)/1000 - Vo/9000
print(sp.solve([eq1, eq2], Vra2, Vo))

>> {Vo: 81*Vi/109, Vra2: 90*Vi/109}
```

$
  V_"Out" = 81/109 times V_"In"
$

As this result shows, cascading the circuits does not simply multiply the gains of each individual circuit. This is due to the loading on circuit A by circuit B. This loading affects the voltage at $V_R_"A2"$, and consequentially, the output voltage aka $V_R_"B2"$.
=== Design
In order to correct this circuit, we must make sure that 
$
  "Vo"_A = K_A times "Vi"_A\
  "Vo"_B = K_B times "Vi"_B\
  "Vo"_B = K_A times K_B times "Vi"_A\
$
where
$
  K_A = 0.5\
  K_A = 0.9\
$

and using the same circuit analysis from @PartBObjective, we find:
```python

import sympy as sp
Vi, Vra2, Vo, Ra1, Ra2, Rb1, Rb2 = sp.symbols('Vi Vra2 Vo Ra1 Ra2 Rb1 Rb2')
eq1 = (Vi - Vra2)/Ra1 - (Vra2/Ra2 + (Vra2 - Vo)/Rb1)
eq2 = (Vra2 - Vo)/Rb1 - Vo/Rb2
eq3 = Vra2 - (0.5*Vi)
eq4 = Vo - (0.9*Vra2)
eq4 = Vo - (0.5*0.9*Vi)
sol = sp.solve([eq1, eq2, eq3, eq4],Vi, Vo,Vra2, Ra2, Rb2)
print(sol[0])
print("If Ra1 = 50kOhm and Rb1 = 10kOhm...")
print("Ra2 =")
print(sol[0][3].subs(Ra1,50_000).subs(Rb1,10_000))
print("Rb2 =")
print(sol[0][4].subs(Ra1,50_000).subs(Rb1,10_000))

>> (2.0*Vra2, 0.9*Vra2, Vra2, -10.0*Ra1*Rb1/(Ra1 - 10.0*Rb1), 9.0*Rb1)
>> If Ra1 = 50kOhm and Rb1 = 10kOhm...
>> Ra2 =
>> 100000.000000000
>> Rb2 =
>> 90000.0000000000
```

This gives us the resistor values:
- $R_"A1" = 50k Omega$
- $R_"A2" = 100k Omega$
- $R_"B1" = 10k Omega$
- $R_"B2" = 90k Omega$

#figure(image("CircuitAB-PartB.png"),caption: "Updated Circuit A and B (cascaded)") <Circuit-AB-PartB>

=== Simulation Results
As seen below, the simulation results for the updated circuit show that the output voltage is $plus.minus 0.45 V$, which is the expected value.
#figure(image("content.png"), caption: "Simulation Results for updated Circuit A and B (cascaded)")
==== DC Simulation
I set the input voltage to $1V$ and measured the output voltage at $R_B_2$ for the circuit in @Circuit-AB-PartB\
#image("CircuitAB-PartB-DC.pdf")
==== AC Simulation
I set the input voltage to a $1V$ $1"kHz"$ square wave and measured the output voltage at $R_2$ for the circuit in @Circuit-AB-PartB
#align(center,image("AC.PNG", width: 40%))
#image("CircuitAB-PartB-AC.pdf")
=== Conclusion
In Part B, the original cascaded circuit did not produce the value of $K_A times K_B times V_"IA" = 0.45 V_"IA"$. This result was expected because Circuit B loaded Circuit A, changing the effective resistance of Circuit A's voltage divider. Instead of maintaining exactly $0.5 V_"IA"$, Circuit A's output dropped slightly due to the parallel resistance created by Circuit B. After redesigning the circuit with adjusted resistor values, the cascade produced the correct overall output of approximately $0.45 V_"IA"$. This confirmed that loading must be considered when connecting circuits together.

== Part C
=== Objective
#image("Fig3.png")
*Design Requirement:*
- $V_"OA" = K_A times V_"IA"$
- $V_"OB" = K_B times V_"IB"$
- $V_"OB" = K_A times K_B times K_C times V_"IA"$
- $K_A = 0.5$
- $K_B = 0.9$
- $K_C = 6$ (The cascaded circuit should be $180degree$ out-of-phase too)
=== Design
To achieve the design requirement, we used a voltage follower ($"gain"=1$) and an inverting amplifier ($"gain"=-6$). Originally we had:
$ "Circuit A"->"Voltage Follower"->"Circuit B"->"Inverting Amp" $
We then discovered that the inverting amplifier is loading Circuit B and affecting the output. So, we rearranged it as such:
$ "Circuit A"->"Voltage Follower"->"Inverting Amp"->"Circuit B" $

#figure(image("CircuitABC-PartC.png"), caption: "Updated Circuit A and B (cascaded) with voltage follower and inverting amplifier") <Circuit-ABC-PartC>

=== Analysis Results
$
  #mathHeading[KCL@$V_R_"A2"$]\
  (V_"In" - V_R_"A2")/R_"A1"
  =
  V_R_"A2"/R_"A2"
  +
  I_"V+"_1
  \
  #mathHeading[Op Amp Current Behavior]\
  I_"V+"_1 = 0V\
  #mathHeading[Op Amp Voltage Behavior]\
  "V+"_1 = "V-"_1 = "Vo"_1\
$
  
$
  #mathHeading[KCL\@$"V+"_2$]\
  ("Vo"_1 - "V-"_2)/R_"In"
  +
  ("Vo"_2 - "V-"_2)/R_"Feedback"
  =
  I_"V+"_2
  \
  #mathHeading[Op Amp Current Behavior]\
  I_"V+"_2 = 0A\
  #mathHeading[Op Amp Voltage Behavior]\
  "V+"_2 = "V-"_2 = 0V\
$

$
  #mathHeading[KCL@$V_"Out"$]\
  ("Vo"_2 - V_"Out")/R_"B1"
  =
  V_"Out"/R_"B2"
  \
$

```python

import sympy as sp
Vi, VRA2, Vo2, Vout = sp.symbols('V_i V_R_A2 Vo_2 V_out')
eq10 = (Vi - VRA2)/1000 - (VRA2/1000 + 0)
eq11 = (VRA2 - 0)/1000 + (Vo2 - 0)/6000 - (0)
eq12 = (Vo2-Vout)/1000 - (Vout/9000)
print(sp.solve([eq10, eq11, eq12],VRA2, Vo2, Vout))

>> {V_R_A2: V_i/2, V_out: -27*V_i/10, Vo_2: -3*V_i}
```

$
  V_"Out"
  &=
  -27/10 times V_"In"
  \
  &=
  0.5 times 0.9 times 6 times -1 times V_"In"
$

Plotting these solutions with a $1"kHz"$ square wave at $V_"In"$ shows our expected behavior.
#grid(columns: (2fr,3fr))[
```python

import matplotlib.pyplot as pt
import scipy.signal as signal
import numpy as np
t = np.linspace(0,2, 1000)
Vi = signal.square(2*np.pi*t)
Vout = 0.5*0.9*6*-1*Vi
pt.plot(t,Vi)
pt.plot(t,Vout,"--")
pt.xlabel('Time (ms)')
pt.ylabel('Voltage (V)')
pt.title('Title')
pt.savefig('PartCWaveform.svg')

```][#image("PartCWaveform.svg")]

=== Simulation Results
==== DC Simulation
I set the input voltage to $1V$ and measured the output voltage at $R_B_2$ for the circuit in @Circuit-ABC-PartC\
#image("CircuitABC-PartC-DC.pdf")
==== AC Simulation
I set the input voltage to a $1V$ $1"kHz"$ square wave and measured the output voltage at $R_2$ for the circuit in @Circuit-ABC-PartC
#align(center,image("AC.PNG", width: 40%))
#image("CircuitABC-PartC-AC.pdf")
=== Experimental Results
As seen below, the experimental results for the updated circuit show that the output voltage is now $plus.minus 2.7 V_"IA"$, which is the expected value.
#figure(grid(columns:2,
image("CircuitABC-PartC-Exp-Wav.jpg",width: 100%),
image("CircuitABC-PartC-Exp.jpg",width: 100%),
),caption: "Experimental Results for Circuit A and B with voltage follower and inverting amplifier")
=== Conclusion
In Part C, the final circuit used the Part A and Part B ideas along with op-amp stages to meet the full design requirement. The final desired relationship was: $V_o = -2.7 V_s$. The negative sign showed that the output was 180 degrees out of phase with the input. For the DC test with $V_s = 1 V$, the expected output was about $-2.7 V$. For the 1 kHz square-wave test, the output waveform was inverted and had a larger amplitude than the input. The simulation results matched the theoretical calculations closely, and the experimental results followed the same trend with only small differences.

#heading(numbering: none, "Conclusion")
When we finished the experiment, the results were what we anticipated. Upon completion, we saw that circuits cannot always be connected together without affecting each other. Simple voltage dividers can change behavior when loaded by another circuit. It also showed why buffers and op-amps are useful in circuit design, as they help control gain, phase, and loading. By comparing theory, simulation, and experimental results, the lab confirmed the importance of designing, testing, and troubleshooting circuits carefully. Overall, this lab demonstrated how voltage dividers, loading effects, circuit redesign, and op-amp stages affect the final output of a circuit.

The results were mostly what we expected. The only major unexpected behavior came from the original Part B cascade, but after analyzing the circuit, it made sense because of the loading effect. The redesigned circuit fixed this issue by choosing resistor values that accounted for the input resistance of the next stage. Any small differences between theory, simulation, and the physical circuit were likely caused by resistor tolerance, breadboard contact resistance, op-amp limitations, oscilloscope/function generator settings, and minor measurement error.

Some errors made during the lab included needing to carefully check resistor values, making sure all grounds were connected together, verifying the correct op-amp power supply pins, and confirming that the function generator was set to the correct amplitude, offset, and frequency. These issues were fixed by rechecking the circuit wiring, measuring resistor values, confirming the TL084 pinout, and comparing each node voltage step-by-step with the expected theoretical values. After troubleshooting, the circuit behavior matched the simulations and design requirements well.

