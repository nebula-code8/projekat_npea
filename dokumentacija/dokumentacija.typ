#set page(
  margin: 1in,
)
#set text(
  font: "New Computer Modern"
)
#set heading(
  numbering: "1."
)
#show heading: set block(below: 1em)

#align(center)[
  #grid(
    columns: (1fr, auto, 1fr),
    align: (left, center, right),
    gutter: 1cm,
    image("images/FTN.svg", height: 2.5cm),
    [
    #text(
      size: 20pt,
    )[Univerzitet u Novom Sadu]

    #text(
      size: 20pt,
    )[Fakultet tehničkih nauka]
    ],
    image("images/UNS.svg", height: 2.5cm)
  )
  #v(4cm)

  #text(size: 20pt)[
    Dokumentacija za projektni zadatak
  ]
]
#align(bottom)[
  #grid(
    columns: (auto, auto),
    align: (right, left),
    gutter: 0.4cm,
    [
      *Studenti:* \ \ \ \
      #v(0.1em)
      *Predmet:* \
      #v(0.1em)
      *Broj projektnog zadatka:* \
      #v(0.1em)
      *Tema projektnog zadatka:* \
    ],
    [
      Jorgaćević Lazar SV16/2024 \
      Koprivica Aleksandar SV24/2024 \
      Milojević Stefan SV9/2024 \
      Popović Ognjen SV64/2024 \
      #v(0.1em)
      Nelinearno programiranje i evolutivni algoritmi \
      #v(0.1em)
      4. \
      #v(0.1em)
      Genetski algoritam, job shop problem (JSP) \
    ]
  )
]

#pagebreak()
/*
#outline(title: "Sadrzaj")
#pagebreak()
*/

#let curr_title() = context {
  let headings = query(heading.where(level: 1).before(here()))
  if headings == () { return }
  headings.last().body
}

#set page(
  numbering: "1",
  header: context {
    set text(10pt)
    [Genetski algoritam, job shop problem (JSP)]
    line(length: 100%)
  }
)
#counter(page).update(1)

#set par(first-line-indent: (
  amount: 2.5em,
  all: true,
))

= Opis problema
Job shop problem (JSP) je problem optimizacije koji se javlja u proizvodnim procesima, gde se određeni broj poslova (jobova) mora obraditi na određenom broju mašina. Cilj je pronaći optimalan raspored obrade poslova na mašinama kako bi se minimizirao ukupno vreme završetka (makespan) ili neki drugi kriterijum performansi. Svaki posao se sastoji od niza operacija koje moraju biti obrađene na određenim mašinama, a svaka operacija ima svoje trajanje.

// TODO: Garey, M. R., Johnson, D. S., & Sethi, R. (1976). The Complexity of Flowshop and Jobshop Scheduling. Mathematics of Operations Research, 1(2), 117–129. http://www.jstor.org/stable/3689278
Problem je poznat po svojoj složenosti i NP-težini, što znači da nije poznat efikasan algoritam koji može rešiti sve instance problema u polinomijalnom vremenu. Zbog toga, često se koriste heuristički i metaheuristički algoritmi, poput genetskih algoritama, kako bi se pronašla dobra rešenja u razumnom vremenskom okviru.

Precizna formulacija problema koji je ovde rešen je sledeća: Neka je $J = {J_i : i in {1, dots, n}}$ skup poslova, a $M = {M_j : j in {1, dots, m}}$ skup mašina. Svaki posao $J_i$ se sastoji od niza od $n_i$ operacija $O_i = (O_(i 1), O_(i 2), ..., O_(i n_i))$, a svaka operacija je određena parom $(M_j, t_(i j))$, gde $M_j$ predstavlja mašinu na kojoj se operacija obrađuje, a $t_(i j)$ je vreme trajanja operacije. Za $O = {O_i : i in {1, dots, n}}$ skup svih operacija, neka je funkcija $s: O -> NN_0$ funkcija koja dodeljuje početno vreme svakoj operaciji, tako da su zadovoljeni sledeći uslovi:
1. Sve mašine su dostupne od početka, tj. $s(O_(i 1)) >= 0 quad forall i in {1, dots, n}$.
2. U određenom trenutku, svaka mašina može obrađivati najviše jednu operaciju, tj.
$
M(O_(i j)) = M(O_(i' j')) => s(O_(i j)) + t_(i j) <= s(O_(i' j')) or s(O_(i' j')) + t_(i' j') <= s(O_(i j))
$
3. Operacije jednog posla se moraju redom izvršavati, tj. 
$
s(O_(i k)) + t_(i k) <= s(O_(i (k+1))) quad forall i in {1, dots, n}, k in {1, dots, n_i - 1}
$
Cilj je naći $s_min$ koji minimizira kriterijum optimalnosti (u ovom slučaju, ukupno vreme završetka, tj. makespan) definisan kao
$
C_max = max {s(O_(i n_i)) + t_(i n_i) : i in {1, dots, n}}
$
= Rešenje problema
== Struktura programa
== Genetski algoritam
 - Kriterijum optimalnosti
 - Selekcija
 - Mutacija
 - Ukrštanje
 - Elitizam
 - Parametri algoritma
= Zaključak
 - Rezultati algoritma
