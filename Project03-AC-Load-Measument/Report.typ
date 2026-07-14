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
== Objective
// TODO: Explaination of "I. The Challenge" from the Lab Manual
Box \#19

== Plan
//TODO: Explain our experimental plan

== Results

$
  9.92 k Omega
$

$
  (233.89m V)/(9.923k Omega)
  2.3577620967741933e-05
$
