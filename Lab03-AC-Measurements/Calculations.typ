#show raw.where(lang: "MATLAB"): it => rect(it, width: 100%, radius: .5em, inset: 1em,)
#show math.equation.where(block: true):  it => rect(it,radius: 1em, inset: 1em, fill: silver)
#set heading(numbering: "1.A.1.a")
#counter(heading).update(3)
#heading(numbering: none, "Lab 3 Calculations")
Malachy Crossan 5522964\
Jacob Rosen 5534974
== RMS Voltage calculation
=== Sine wave
$
  V_"magnitude"
  =
  V_"peak-to-peak" times 1/2
  &=
  V_"RMS" times sqrt(2)
  \
  10 V times 1/2 &= V_"RMS" times sqrt(2)
  \
  V_"RMS" = 5/sqrt(2) V approx 3.54 V
$
=== Square wave
$
  V_"magnitude"
  =
  V_"peak-to-peak" times 1/2
  &=
  V_"RMS"
  \
  10 V times 1/2 &= V_"RMS"
  \
  V_"RMS" = 5 V
$
=== Triangle wave
$
  V_"magnitude"
  =
  V_"peak-to-peak" times 1/2
  &=
  V_"RMS" times sqrt(3)
  \
  10 V times 1/2 &= V_"RMS" times sqrt(3)
  \
  V_"RMS" = 5/sqrt(3) V approx 2.89 V
$
== Period calculation
=== $100 "Hz"$
$
  "frequency" &= 1/"period"
  \
  100 "Hz" &= 1/"period"
  \
  "period" &= 1/(100 "Hz") = 0.01 s = 10 m s
  

$
=== $1 "kHz"$
$
  "frequency" &= 1/"period"
  \
  1 "kHz" = 1000 "Hz" &= 1/"period"
  \
  "period" &= 1/(1000 "Hz") = 0.001 s = 1 m s
$
=== $100 "kHz"$
$
  "frequency" &= 1/"period"
  \
  100 "kHz" = 100000 "Hz" &= 1/"period"
  \
  "period" &= 1/(100000 "Hz") = 0.00001 s = 10 mu s
$
