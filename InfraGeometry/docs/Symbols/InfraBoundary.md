---
Template: Symbol
Name: InfraBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBoundary
---

## Usage

`InfraBoundary[g, s]` is the boundary of the vertex set s (a vertex list, a density or a walk graph) in g, returned as a sorted vertex list.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Combinatorial" (default), the inner vertex boundary via GraphBoundary; {"Alexandrov", "Radius" -> r}, the two-sided cl(s)\int(s) in the closed-r-ball topology, default r = 1 |
