---
Template: Symbol
Name: FindInfraHomotopyRepresentative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopyRepresentative
---

## Usage

`FindInfraHomotopyRepresentative[graph, obj]` gives length-shortest walk Graphs in the homotopy class of obj. An open walk keeps its endpoints fixed; a cycle keeps its base point fixed. "FreeHomotopy" -> True frees either.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Exhaustive" (default), "Greedy" |
| `"FreeHomotopy"` | -- |
| `"NullHomotopicCycles"` | -- |
| `"MaxLength"` | -- |
| `"MaxMoves"` | -- |
