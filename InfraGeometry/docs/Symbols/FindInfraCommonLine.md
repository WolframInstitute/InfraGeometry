---
Template: Symbol
Name: FindInfraCommonLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraCommonLine
---

## Usage

`FindInfraCommonLine[graph, vertices]` returns the canonical lines containing every listed vertex, as a List of directed path graphs; a single line comes back as its one path graph.

## Details & Options

Entries may be bare vertices, vertex lists, densities or walk graphs; their vertices are pooled.

A canonical line is the lexicographic minimum of a line and its reversal, so each line appears once.

The count argument n / UpTo[n] / All (default) picks lines, exact n failing with $Failed.
