#let octave(script, filename) = grid(
columns:(1fr,2fr),
{
  set text(size: 10pt)
  script
},
image(filename)
)
$
  R = 1 k Omega\
  C = .1 mu F\
  L=100 m H\
  X(t)=X(oo)+[X(0)-X(oo)]times e^(-t/tau)\
  tau_"RC" = R times C\
  tau_"RL" = L/R\
$
= First Order Circuits
== Analytical expression for $V_"out"$ in lab manual figure 4-3
=== fig 4-3 (a)
$
  V_"out" &= V_"C"(t) = E(1-e^(-t/(R C)))\
  &= E(1-e^(-t/(1 k Omega times 0.1 mu F)))\
  V_"out"(t) &= E(1-e^(-t/(100 mu s)))\
$
#octave(
"
fplot(@(x) 1-exp(-x/100),[0,500])
xlabel('t','FontSize',14)
ylabel('E','FontSize',14)
set(gca,'FontSize',14)
grid on
print -dsvg fig4-3a.svg
",
"fig4-3a.svg"
)
=== fig 4-3 (b)
$
  V_"out" &= V_"R"(t) = E e^(-t/(R C))\
  &= E e^(-t/(1 k Omega times 0.1 mu F))\
  V_"out"(t) &= E e^(-t/(100 mu s))\
$
#octave(
"
fplot(@(x) exp(-x/100),[0,500])
xlabel('t','FontSize',14)
ylabel('E','FontSize',14)
set(gca,'FontSize',14)
grid on
print -dsvg fig4-3b.svg
",
"fig4-3b.svg"
)
=== fig 4-3 (c)
$
  V_"out" &= V_"L"(t) = E e^(-t/(L/R)))\
  &= E e^(-t/((100 m H)/(1 k Omega)))\
  V_"out" &= E e^(-t/(100 mu s))
$
#octave(
"
fplot(@(x) exp(-x/100),[0,500])
xlabel('t','FontSize',14)
ylabel('E','FontSize',14)
set(gca,'FontSize',14)
grid on
print -dsvg fig4-3c.svg
",
"fig4-3c.svg"
)

=== fig 4-3 (d)
$
  V_"out" &= V_"R"(t) = E (1-e^(-t/((L/R))))\
  &= E e^(-t/((100 m H)/(1 k Omega)))\
  V_"out"(t) &= E e^(-t/(100 mu s))\
$
#octave(
"
fplot(@(x) 1-exp(-x/100),[0,500])
xlabel('t','FontSize',14)
ylabel('E','FontSize',14)
set(gca,'FontSize',14)
grid on
print -dsvg fig4-3d.svg
",
"fig4-3d.svg"
)

== Square wave
=== fig 4-4 (a)
$
  V_"out" = Sigma V_"C" &= V_"C"(0s<t<10s) +  V_"C"(10s<t<20s) +  V_"C"(20s<t<30s)\
  &= E(1-e^(-t/(100 mu s))) - 2E(1-e^(-(t-5)/(100 mu s))) + 3E(1-e^(-(t-10)/(100 mu s)))\
$ 
=== fig 4-4 (b)
$
  V_"out" &= V_"R"(t) = E e^(-t/(R C))\
  &= E e^(-t/(1 k Omega times 0.1 mu F))\
  V_"out"(t) &= E e^(-t/(100 mu s))\
$
=== fig 4-4 (c)
$
  V_"out" &= V_"L"(t) = E e^(-t/(L/R)))\
  &= E e^(-t/((100 m H)/(1 k Omega)))\
  V_"out" &= E e^(-t/(100 mu s))
$
=== fig 4-4 (d)
$
  V_"out" &= V_"R"(t) = E (1-e^(-t/((L/R))))\
  &= E e^(-t/((100 m H)/(1 k Omega)))\
  V_"out"(t) &= E e^(-t/(100 mu s))\
$
== figure 4-4 voltage across inductor
//TODO


