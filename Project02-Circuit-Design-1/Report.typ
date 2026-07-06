// mip$python<ret>
#show raw.where(lang: "MATLAB"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set math.equation(numbering: "Eq 1")
#set heading(numbering: "1.A.1.a")
#set page(height: auto)

#counter(heading).update(2)
#heading("Project 2 Circuit Design 1", numbering: none)
#let mathHeading(content) = text(
  size: 15pt,
  fill: blue.darken(40%),
  content,
)

#outline()
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
  #figure("placeholder",caption: "Circuit A") <Circuit-A-PartA>
  #colbreak()
  #figure("placeholder",caption: "Circuit B") <Circuit-B-PartA>
]

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
=== Experimental Results
=== Results Comparison
=== Conclusion
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
- $R_"A2" = 50k Omega$
- $R_"B1" = 10k Omega$
- $R_"B2" = 90k Omega$

=== Simulation Results
=== Experimental Results
=== Results Comparison
=== Conclusion
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
=== Experimental Results
=== Results Comparison
=== Conclusion

//TODO:Objectives and Tasks – define and outline explicitly the objectives and tasks
//TODO:Dissection of Design – present your circuit design in a detailed, part-by-part analysis
//TODO:– explain the reasonings behind your circuit design using circuit theory
//TODO:– provide detailed circuit analysis and calculation to justify the circuit topology, component type and component value used in your design Simulation Results
//TODO:– include screenshots of simulated circuits, results, etc.
//TODO:Experimental Results – present your experimental results with clarity
//TODO:– include oscilloscope figures, screenshots of DMM measurements, etc.
//TODO:Results Comparison – compare simulation and experimental results
//TODO:– explain discrepancies pertaining to concepts
//TODO:Conclusions
