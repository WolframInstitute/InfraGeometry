---
Template: Symbol
Name: FindInfraHomotopy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopy
---

## Usage

`FindInfraHomotopy[graph, a, b]` gives one chain of elementary moves as a List of walk Graphs, or {} when none exists. A bounded count or All gives a List of chains. Both walks must be open or both closed.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Exhaustive" (default), "Greedy" |
| `"FreeHomotopy"` | -- |
| `"NullHomotopicCycles"` | -- |
| `"MaxLength"` | -- |
| `"MaxMoves"` | -- |
