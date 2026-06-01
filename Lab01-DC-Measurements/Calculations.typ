#show raw.where(lang: "MATLAB"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set heading(numbering: "1.A.1.a")
= Lab 1 Calculations
#image("Exp1-1.png", height: 60%)
== Equivalent Resistance Calculation
=== Figure 1-6(a)
====
The equivalent resistance between nodes A & B, $R_"AB"$

You can find $R_"EQ"_"AB"$ using parallel/series reduction.
$
  R_"EQ"_"AB" &= R_"AB" ||[R_"AD" + (R_"DC" + R_"CB")||R_"DB"]\
  &= 10k Omega || [10k Omega + (10k Omega+10k Omega)||10k Omega]\
  &= 10k Omega || [10k Omega + (20k Omega)||10k Omega]\
  &= 10k Omega || [10k Omega + 20/3 k Omega]\
  &= 10k Omega || [50/3 k Omega]\
  R_"EQ"_"AB" &= 25/4 k Omega = 6.25 k Omega
$

====
The equivalent resistance between nodes B & D, $R_"BD"$

You can find $R_"EQ"_"BD"$ using parallel/series reduction.
$
  R_"EQ"_"BD" &= R_"BD" || (R_"BA" + R_"AD") || (R_"BC" + R_"CD") \
  &= 10 k Omega || (10 k Omega + 10 k Omega) || (10 k Omega + 10 k Omega) \
  &= 10 k Omega || (20k Omega) || (20k Omega) \
  &= 10 k Omega || 10 k Omega \
  R_"EQ"_"BD" &= 5 k Omega

$

====
The equivalent resistance between nodes A & C, $R_"AC"$
$
  R_"EQ"_"AC" &= 10k Omega???
$

#pagebreak()
== Voltage and Current Calculation
=== Figure 1-6(b)
====
Calculate V1, V2, V3 and IS WITHOUT using the voltage division rule.
#columns(3,
[
*Known/Chosen Values*\
$
  V_s = 9v \
  R_1 = 10 k Omega \
  R_2 = 20 k Omega \
  R_3 = 30 k Omega
$
#colbreak()

*KVL@$I_s$*
$
V_1+V_3+V_s = V_2
$

#colbreak()
*Ohm's Law@$R_1$*
$
  V_1 = I_s times R_1
$

*Ohm's Law@$R_2$*
$
  -V_2 = I_s times R_2
$

*Ohm's Law@$R_3$*
$
  V_3 = I_s times R_3
$]
)

```MATLAB
% Define symbolic variables
syms is v1 v2 v3

% Define equations
eq1 = v1 + v3 + 9 == v2;
eq2 = v1 == is * 10000;
eq3 = v2 == -is * 20000;
eq4 = v3 == is * 30000;

% Solve equations
sol = solve([eq1, eq2, eq3, eq4], [is, v1, v2, v3])
```

```MATLAB
sol = 
    is: -3/20000
    v1: -3/2
    v2: 3
    v3: -9/2
```

$
  i_s &= -150 mu A\
  v_1 &= -1.5v \
  v_2 &= 3v \
  v_3 &= -4.5v
$

====
Calculate $V_1$, $V_2$ and $V_3$ again using the voltage division rule and compare the values with those determined in Part a.
$
  V_1 = V_S times R_1/(R_1 + R_2 + R_3)\
  = V_S times 1/-6\
$
$
  V_2 = V_S times R_2/(R_1 + R_2 + R_3)\
  = V_S times 1\3
$
$
  V_3 = V_S times R_3/(R_1 + R_2 + R_3)\
  = V_S times -1\2
$

====
Is the addition of $V_S$, $V_1$ and $V_3$ equal to the value of $V_2$? Why? Explain your reasoning in detail.

#text(fill: green)[Yes, $V_S + V_1 + V_3 = V_2$. You can discover this by doing the calculation by hand or you can recognize that a KVL about current $I_S$ produces that equation.]

=== Figure 1-6(c)
====
Calculate $V_O$ for $R=10 k Omega$
$
  (9 - V_o)/2R = V_o/R + V_o/(1 M Omega)\
  (9 - V_o)/(20 k Omega) = V_o/(1 k Omega) + V_o/(1 M Omega)\
$

```MATLAB
% Define symbolic variables
syms vo

% Define equations
eq1 = (9 - vo)/20000 == (vo/10000) + (vo/10000000);

% Solve equations
sol = solve([eq1], [vo])
```

```MATLAB
sol =
   4500/1501
```

$
  V_o = //TODO
$

====
Calculate $V_O$ for $R=10 M Omega$
$
  (9 - V_o)/2R = V_o/R + V_o/(1 M Omega)
  (9 - V_o)/(20 M Omega) = V_o/(1 M Omega) + V_o/(1 M Omega)\
$

```MATLAB
% Define symbolic variables
syms vo

% Define equations
eq1 = (9 - vo)/20000000 == (vo/10000000) + (vo/10000000);

% Solve equations
sol = solve([eq1], [vo])
```

```MATLAB
sol =
  9/5
```

$ V_o = 4.5v $

=== Figure 1-6(d)
====
Calculate I1, I2, and I3 WITHOUT using the current division rule.

*KCL@$V_2$*
$
  (9-V_2)/R_1 + (-V_2 / R_3) = V_2/R_2 \
  (9-V_2)/(10 k Omega) + (-V_2 / (30 k Omega)) = V_2/(20 k Omega) \
  
$

```MATLAB
% Define symbolic variables
syms i1 i2 i3 v2

% Define equations
eq3 = i1 + i3 == i2;
eq4 = i1 == 9-v2 / 10000;
eq5 = i2 == v2 / 20000;
eq6 = i3 == -v2 / 30000;

% Solve equations
sol = solve([eq3, eq4, eq5, eq6], [v2, i1, i2, i3])
```

```MATLAB
sol = 
    v2: 540000/11
    i1: 45/11
    i2: 27/11
    i3: -18/11
```

$
  v_2 &= 49.overline(09) v\
  i_1 &= 4.overline(09) A\
  i_2 &= 2.overline(45) A\
  i_3 &= -1.overline(63) A\
$

====
Calculate I2 and I3 again using the current division rule and compare the values with those determined in Part a.
$
  I_1 = I_S times (R_2 + R_3)/(R_1 + R_2 + R_3)\
  I_1 = I_S times -1\2
$
====
Is the addition of I1 and I3 equal to the value of I2? Why? Explain your reasoning in detail.

#text(fill: green)[Yes, $I_1 + I_3 = I_2$ you can verify this by doing the calculation by hand or realizing that a KCL@$V_2$ produces that equation.]
