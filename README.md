CsvImporter
===========

Ziel der Übung ist zu prüfen, wie in Elixir massiv große CSV Datenbestände parallel und zügig importiert werden können.

## Testdaten generieren

Mix Task `generate` mit 2 Parametern:

    mix generate test.csv 1000

Lesestoff:
  * [Faker Framework](https://github.com/igas/faker/)
  * Elixir Getting Started: [IO and the file system](http://elixir-lang.org/getting-started/io-and-the-file-system.html)


## CSV einlesen

Nutzt Paket `csv`:
  * Github: https://github.com/beatrichartz/csv
  * Hex Doc: http://hexdocs.pm/csv/
  * `CSV.decode` nutzt standardmäßig 8 Prozess-Pipes bei File-Stream-Verarbeitung


## Lesestoff

  * bessere Testdaten mit Blacksmith http://icanmakeitbetter.com/elixir-testing-blacksmith/
