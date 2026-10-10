---
Template: Symbol
Name: InfraDistance
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDistance
---

## Usage

`InfraDistance[graph, p, q]` gives ambient graph distance between valid vertices, or aggregates pair distances between nonzero supported object supports.

`InfraDistance[p, q]` is a deferred query inside an InfraScene.

## Details & Options

The default "Aggregation" is Min. Empty or disconnected supports have minimum distance Infinity.
Supported inputs include vertices, raw vertex Lists, densities, Graph carriers and construction objects with supported vertex densities.
Literal graph-vertex membership takes precedence over interpreting a List as a collection.
Readers do not sample. Unsupported support queries remain unevaluated.

## Basic Examples

The nearest support point is one edge away.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  InfraDistance[ graph, { 1, 3 }, 2 ] ]
```
