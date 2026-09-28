---
Template: Symbol
Name: InfraSubgraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubgraph
Keywords: [segment, ray, line, circle, arc, support, neighborhood]
SeeAlso: [InfraMeasurement, InfraVertexList]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraSubgraph]()[*graph*, *obj*]</code> gives the subgraph of *graph* induced on the support of the Euclidean head *obj*.

<code>[InfraSubgraph]()[*graph*, *obj* -> *t*]</code> thickens the support by *t* steps before inducing — the subgraph on `VertexList @ NeighborhoodGraph[graph, support, t]`.

## Details & Options

Same as `InfraMeasurement[graph, obj, "Subgraph"]`; the support itself is `Keys @ InfraMeasurement[graph, obj, "VertexDensity"]`. Works on [InfraIntersection]() and [InfraUnion]() as well as on the five Euclidean heads, since every one of them carries a `"VertexDensity"`.

## Basic Examples

The metric interval of a segment, and the same interval widened by one step on every side.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  VertexCount @ InfraSubgraph[g, seg]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  VertexCount @ InfraSubgraph[g, seg -> 1]
]
```
