---
Template: Symbol
Name: ArcGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ArcGraph
Keywords: [construction graph, shortest path, directed acyclic graph, carrier]
SeeAlso: [InfraMeasurement, IntervalGraph, RayGraph, BeamGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`ArcGraph[graph, c, points]` gives the arc carrier around c through an ordered list of points.

## Details & Options

The result is `InfraMeasurement[graph, InfraArc[c, points], "Graph"]`.

Two distinct endpoints give the shortest-path interval DAG in the radial band. Additional points give consecutive carriers. Closed arcs use seam carriers. The option "RadiusDelta" widens the band, as for InfraArc. The arc hypotheses needed for geometric faithfulness are not certified; the object's "Faithful" reading is Undetermined.

## Basic Examples

```wl
With[{graph = CycleGraph[8]}, ArcGraph[graph, 1, {3, 7}, "RadiusDelta" -> 2]]
```
