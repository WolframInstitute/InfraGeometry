---
Template: Symbol
Name: FindInfraCycle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraCycle
---

## Usage

`FindInfraCycle[graph, n]` returns the n shortest simple cycles of graph, sorted by length, as a List of directed cycle graphs; UpTo[n] returns up to n; All returns all.

`FindInfraCycle[graph, {k}, n]` and `FindInfraCycle[graph, {kMin, kMax}, n]` restrict cycle length.
