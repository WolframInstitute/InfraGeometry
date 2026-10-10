---
Template: Symbol
Name: IntervalGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/IntervalGraph
Keywords: [construction graph, shortest path, directed acyclic graph, carrier]
SeeAlso: [InfraMeasurement, RayGraph, BeamGraph, ArcGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`IntervalGraph[graph, p, q]` gives the directed acyclic graph whose source-to-sink paths are exactly the shortest paths from p to q.

## Details & Options

The result is `InfraMeasurement[graph, InfraSegment[p, q], "Graph"]`.

More than two points give a list of consecutive interval DAGs, one for each piece of a polyline.

## Basic Examples

```wl
With[{graph = GridGraph[{3, 3}]}, IntervalGraph[graph, 1, 9]]
```
