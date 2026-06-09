#show raw.where(lang: "MATLAB"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: .2em, outset: .2em, fill: silver)
#set heading(numbering: "1.A.1.a")
#set grid(gutter: 1em)

= Lab 2 Calculations
== Nodal & Mesh Analysis, Thevenin's Theorem and Superposition
For the circuit in Figure 3-1, all 7 resistors have different resistance values. For each resistor, choose any resistance value within the range of $1 k Omega$ to $56 k Omega$ unless specified otherwise.
#grid(columns: 2,
$
  R_1 = 1 k Omega,\ R_2 = 2 k Omega,\ R_3 = 3 k Omega,\ R_4 = 10 k Omega,\ R_5 = 11 k Omega,\ R_6 = 12 k Omega,\ R_7 = 13 k Omega
$,
image("figure3-1.png"),
)
===
#grid(columns: 2)[
  Short AB, as shown in Figure 3-2(a). Use mesh analysis to calculate the voltage across each resistor and the current through AB, $I_"AB"$.

  $ bold("KVL@"i_1)\ 12V = R_1 i_1 + R_3 (i_1-i_2) $
  $ bold("KVL@"i_2)\ 10V = R_3 (i_2-i_1) + R_4 (i_2-i_4) + R_5 (i_2-i_3) $
  $ bold("KVL@"i_3)\ -5V -10V = R_5 (i_3-i_2) + R_6 (i_3-i_4) + R_7 i_3 $
  $ bold("KVL@"i_4)\ 0 = R_4 (i_4-i_2) + R_2 i_4 + R_6 (i_4-i_3) $
  
][
  #image("figure3-2a.png")
  
]
#box[
*MATLAB code:*
  ```MATLAB
  % Given values
  R1 = 1e3; % Ohms
  R2 = 2e3; % Ohms
  R3 = 3e3; % Ohms
  R4 = 10e3; % Ohms
  R5 = 11e3; % Ohms
  R6 = 12e3; % Ohms
  R7 = 13e3; % Ohms

  syms i1 i2 i3 i4;
  % KVL equations
  eq1 = 12 == R1*i1 + R3*(i1 - i2);
  eq2 = 10 == R3*(i2 - i1) + R4*(i2 - i4) + R5*(i2 - i3);
  eq3 = -5 - 10 == R5*(i3 - i2) + R6*(i3 - i4) + R7*i3;
  eq4 = 0 == R4*(i4 - i2) + R2*i4 + R6*(i4 - i3);
  % Solve for currents
  currents = solve([eq1, eq2, eq3, eq4], [i1, i2, i3, i4])
  ```
$
  i_1 &= 3.912 m A\
  i_2 &= 1.215 m A\
  i_3 &= 148 mu A\
  i_4 &= 581 mu A\
  i_"AB" &= i_4 = 581 mu A\
$
]

===
#grid(columns: 2)[
Leave AB open, as shown in Figure 3-2(b). Use nodal analysis to calculate the voltage across each resistor as well as the voltage across AB, $V_"AB"$.

$ bold("KCL"@V_1)\ 0 = (12V-V_1)/R_1 + (0-V_1)/R_3 + (V_2-V_1)/R_4 $
$ bold("KCL"@V_2)\ 0 = (V_1-V_2)/R_4 + (-10-V_2)/R_5 + (V_3-V_2)/R_6 $
$ bold("KCL"@V_3)\ 0 = (V_2-V_3)/R_6 + (-5-V_3)/R_7 $

][
  #image("figure3-2b.png")
]
#box[
*MATLAB Code:*
```MATLAB
% Given values
R1 = 1e3; % Ohms
R2 = 2e3; % Ohms
R3 = 3e3; % Ohms
R4 = 10e3; % Ohms
R5 = 11e3; % Ohms
R6 = 12e3; % Ohms
R7 = 13e3; % Ohms

syms V1 V2 V3;
% KCL equations
eq1 = 0 == (12 - V1)/R1 + (0 - V1)/R3 + (V2 - V1)/R4;
eq2 = 0 == (V1 - V2)/R4 + (-10 - V2)/R5 + (V3 - V2)/R6;
eq3 = 0 == (V2 - V3)/R6 + (-5 - V3)/R7;
% Solve for node voltages
voltages = solve([eq1, eq2, eq3], [V1, V2, V3])
```
$
  V_1 &= 8.287 V\
  V_2 &= -1.214 V\
  V_3 &= -3.031 V\
  V_"AB" &= V_1 - V_3 = 11.318 V\
$
]

===
Find Thevenin's and Norton's Equivalent using the results from the previous two steps.

$
  V_"TH" &= V_"AB" = 11.318 V\
  R_"TH" &= V_"AB"/I_"AB" = 19.47 k Omega\
  I_"N" &= I_"AB" = 581 mu A\
  R_"N" &= R_"TH" = 19.47 k Omega\
$

===
Connect a resistor between nodes A and B. Use Thevenin's theorem to calculate the current through this resistor for the following 3 resistor values: $1 k Omega$, $2.2 k Omega$ and $4.7 k Omega$.

$
  I_1 &= V_"TH"/(R_"TH" + 1 k Omega) = 553 mu A\
  I_2 &= V_"TH"/(R_"TH" + 2.2 k Omega) = 522 mu A\
  I_3 &= V_"TH"/(R_"TH" + 4.7 k Omega) = 468 mu A\
$

===
Leave AB open. Find the voltage across AB, $V_"AB"$ for the following 3 cases:
#box[
*Case 1: $E_1$ is turned on while both $E_2$ and $E_3$ are turned off.*
```
eq1 = 0 == (12 - V1)/R1 + (0 - V1)/R3 + (V2 - V1)/R4;
eq2 = 0 == (V1 - V2)/R4 + (0 - V2)/R5 + (V3 - V2)/R6;
eq3 = 0 == (V2 - V3)/R6 + (0 - V3)/R7;
```

$
  V_1 &= 8.633 V\
  V_2 &= 3.739 V\
  V_3 &= 1.944 V\
  V_"AB" &= V_1 - V_3 = 6.689 V\
$
]
#box[
*Case 2: $E_2$ is turned on while both $E_1$ and $E_3$ are turned off.*
```
eq1 = 0 == (0 - V1)/R1 + (0 - V1)/R3 + (V2 - V1)/R4;
eq2 = 0 == (V1 - V2)/R4 + (-10 - V2)/R5 + (V3 - V2)/R6;
eq3 = 0 == (V2 - V3)/R6 + (0 - V3)/R7;
```
$
  V_1 &= -283 m V\
  V_2 &= -4.060 V\
  V_3 &= -2.111 V\
  V_"AB" &= V_1 - V_3 = 1.828 V
$
]
#box[
*Case 3: $E_3$ is turned on while both $E_1$ and $E_2$ are turned off.*
```
eq1 = 0 == (0 - V1)/R1 + (0 - V1)/R3 + (V2 - V1)/R4;
eq2 = 0 == (V1 - V2)/R4 + (0 - V2)/R5 + (V3 - V2)/R6;
eq3 = 0 == (V2 - V3)/R6 + (-5 - V3)/R7;
```

$
  V_1 &= -62 m V\
  V_2 &= -893 m V\
  V_3 &= -2.864 V\
  V_"AB" &= V_1 - V_3 = 2.802 V\
$
]
//TODO: Add the above three voltages. What have you discovered? Provide a detailed explanation of your discovery.

*Superposition:*\
Adding the three voltages demonstrates voltage superposition. The actual voltage can be calculated by summing the individual contributions from each voltage source. The $1 m V$ discrepancy is due to accumulated rounding errors in the calculations.
$
  Sigma V_"AB" = 6.689 V + 1.828 V + 2.802 V = 11.319 V approx 11.318 V\
$