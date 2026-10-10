---
Template: Symbol
Name: RayGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RayGraph
Keywords: [construction graph, shortest path, directed acyclic graph, carrier]
SeeAlso: [InfraMeasurement, IntervalGraph, BeamGraph, ArcGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`RayGraph[graph, p, q]` gives the directed acyclic graph of maximal shortest paths starting at p and passing through q.

## Details & Options

The result is `InfraMeasurement[graph, InfraHalfLine[p, q], "Graph"]`.

When p equals q, the carrier is the spray at p.

## Basic Examples

```wl
With[{graph = CycleGraph[6]}, RayGraph[graph, 1, 2]]
```
