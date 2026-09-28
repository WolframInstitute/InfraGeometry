---
Template: Symbol
Name: InfraInterior
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraInterior
---

## Usage

`InfraInterior[g, s]` is the interior of the vertex set s (a vertex list, a density or a walk graph) in g, returned as a sorted vertex list.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Method` | "Combinatorial" (default), s minus its inner boundary via GraphInterior; {"Alexandrov", "Radius" -> r}, the topological interior in the closed-r-ball topology, default r = 1 |
