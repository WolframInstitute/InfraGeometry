---
Template: Symbol
Name: BeamGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BeamGraph
Keywords: [construction graph, shortest path, directed acyclic graph, carrier]
SeeAlso: [InfraMeasurement, IntervalGraph, RayGraph, ArcGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`BeamGraph[graph, p, q]` gives a list of directed acyclic graphs whose chains are the lines through p and q.

## Details & Options

The result is `InfraMeasurement[graph, InfraLine[p, q], "Graph"]`.

Each DAG has one compatible pair of maximal endpoints. The list must not be merged: its union can introduce paths that are not lines. BeamGraph[graph, germ] instead keeps a specified shortest-path germ.

## Basic Examples

```wl
With[{graph = CycleGraph[6]}, BeamGraph[graph, 1, 2]]
```
