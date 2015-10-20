CsvImporter
===========

Ziel der Übung ist zu prüfen, wie in Elixir massiv große CSV Datenbestände parallel und zügig importiert werden können.

## Testdaten generieren

Mix Task `generate` mit 2 Parametern:

    mix generate test.csv 10000

Lesestoff:
  * [Faker Framework](https://github.com/igas/faker/)
  * Elixir Getting Started: [IO and the file system](http://elixir-lang.org/getting-started/io-and-the-file-system.html)


## CSV einlesen

Mix Task `import` mit 1 Parameter:

    mix import test.csv

Nutzt optional Paket `csv` - derzeit zu Demozwecke nicht eingebunden:
  * Github: https://github.com/beatrichartz/csv
  * Hex Doc: http://hexdocs.pm/csv/
  * `CSV.decode` nutzt standardmäßig 8 Prozess-Pipes bei File-Stream-Verarbeitung


## Parallelität mit `parallel_stream`

Tod-einfach Parallelverarbeitung mit 2x Cores Pipes

https://github.com/beatrichartz/parallel_stream


## Testszenario Performance-Test

- Datei enthält 1000 Testdatensätze
- Je Zeile wird ein INSERT-SQL gefaket und 10ms gewartet
- Durchlauf mittels `Stream.map` -> 12 Sek.
- Durchlauf mittels `ParallelStream.map` -> 1,2 Sek.


## CSV Testdaten generieren mit Faker

CSV Testdateien mit beliebig viel Inhalt:

    mix generate test100k.csv 100000

Nutzt `faker` Paket um Inhalt zu erzeugen.

(Noch bessere Testdaten mit Blacksmith: http://icanmakeitbetter.com/elixir-testing-blacksmith/)
