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
```
usage: job_shop.py [-h] [--jobs_file JOBS_FILE] [--population_size POPULATION_SIZE] [--generations GENERATIONS] [--mutation_count MUTATION_COUNT]
                   [--tournament_size TOURNAMENT_SIZE] [--keep_perc KEEP_PERC]

Genetic Algorithm for Job Shop Scheduling

options:
  -h, --help            show this help message and exit
  --jobs_file JOBS_FILE
                        Path to the jobs file (default: jobs.txt)
  --population_size POPULATION_SIZE
                        Population size (default: 150)
  --generations GENERATIONS
                        Number of generations (default: 2000)
  --mutation_count MUTATION_COUNT
                        Mutation count (default: 20)
  --tournament_size TOURNAMENT_SIZE
                        Tournament size for selection (default: 5)
  --keep_perc KEEP_PERC
                        Percentage of best individuals to keep (elitism) (default: 10)
```
Program `job_shop.py` rešava problem job shop scheduling koristeći genetski algoritam. Ulaz programa je tekstualni fajl formata:
```
n m
t_11 M_11 t_12 M_12 ... t_1n_1 M_1n
t_21 M_21 t_22 M_22 ... t_2n_2 M_2n
...
t_n1 M_n1 t_n2 M_n2 ... t_nn_n M_nn
```
gde su `n` i `m` redom broj poslova i mašina, a `t_ij` i `M_ij` su vreme trajanja i mašina na kojoj se obrađuje `j`-ta operacija `i`-tog posla. Program zatim koristi genetski algoritam da pronađe optimalan raspored obrade poslova na mašinama, minimizirajući ukupno vreme završetka (makespan). Rezultat programa je optimalan raspored i pripadajući makespan. Pored toga, program generiše vizualizaciju rasporeda u obliku _Ganttovog dijagrama_, što omogućava lakše razumevanje i analizu rešenja, ali i graf konvergencije genetskog algoritma, koji prikazuje kako se rešenje poboljšava tokom iteracija algoritma.
#figure(
  image("images/Gantt_ft06.png", width: 80%),
  caption: "Ganttov dijagram rasporeda poslova na mašinama za instancu ft06."
)
#figure(
  image("images/Conv_ft06.png", width: 60%),
  caption: "Graf konvergencije genetskog algoritma za instancu ft06."
)
== Genetski algoritam
 - _Hromozom_ je predstavljen kao niz indeksa poslova, gde se svaki posao pojavljuje onoliko puta koliko ima operacija. Funkcija ```python decode()``` je zadužena za dekodiranje hromozoma u konkretan raspored operacija određenih torkom ```python (job_id, machine, start, finish)```. Ona se poziva prilikom evaluacije pojedinca i dekodiranja u svrhe prikaza rezultata.
 - Za _kriterijum optimalnosti_ uzeto je ukupno vreme završetka (_makespan_), koje se računa kao maksimalno vreme završetka svih operacija.
 - _Selekcija_ se vrši _turnirskom selekcijom_, gde se nasumično bira nekoliko pojedinaca iz populacije, a najbolji među njima se bira za reprodukciju. Korisnik može da podešava veličinu turnira putem parametra `--tournament_size`. Defaultna vrednost je 5.
 - _Mutacija_ se vrši tako što se nasumično odabere nekoliko pozicija u hromozomu i zamene se sa drugim nasumično odabranim pozicijama. Broj mutacija po pojedincu se podešava putem parametra `--mutation_count`, sa defaultnom vrednošću od 20. 
 - _Ukrštanje_ se vrši _Order Crossover-om_ (OX), koji je pogodan za probleme permutacije poput job shop scheduling. Funkcioniše tako što se nasumično odabere segment hromozoma od jednog roditelja, a zatim se preostali poslovi popunjavaju redosledom iz drugog roditelja, preskačući već uključene poslove.
 - _Elitizam_ je implementiran tako da se određeni procenat najboljih pojedinaca (definisan parametrom `--keep_perc`, sa defaultnom vrednošću od 10%) direktno prenosi u sledeću generaciju, čime se osigurava da se najbolja rešenja ne gube tokom evolucije.
= Zaključak
 - Rezultati algoritma
