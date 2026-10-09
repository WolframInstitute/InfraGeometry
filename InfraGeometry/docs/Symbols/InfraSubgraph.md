---
Template: Symbol
Name: InfraSubgraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubgraph
Keywords: [segment, ray, line, circle, arc, support, neighborhood]
SeeAlso: [InfraMeasurement, RandomInfraRepresentative]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraSubgraph]()[*graph*, *obj*]</code> gives the subgraph of *graph* induced on the support of the Euclidean head *obj*.

<code>[InfraSubgraph]()[*graph*, *obj* -> *t*]</code> thickens the support by *t* steps before inducing — the subgraph on `VertexList @ NeighborhoodGraph[graph, support, t]`.

## Details & Options

Same as <code>[InfraMeasurement]()[*graph*, *obj*, "Subgraph"]</code>; the support itself is <code>Keys @ [InfraMeasurement]()[*graph*, *obj*, "VertexDensity"]</code>. Works on [InfraIntersection]() and [InfraUnion]() as well as on the five Euclidean heads, since every one of them carries a `"VertexDensity"`.

## Basic Examples

A segment on a grid and its support thickened by one step: 9 vertices, then 21.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {InfraSubstrateHighlight[g, {VertexList @ InfraSubgraph[g, seg -> 1], seg}, ImageSize -> 250],
   VertexCount @ InfraSubgraph[g, seg], VertexCount @ InfraSubgraph[g, seg -> 1]}]
```

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

## Properties and Relations

The subgraph is the one [InfraMeasurement]() gives.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {circle = InfraCircle[41, {2, 4}]},
  InfraSubgraph[g, circle] === InfraMeasurement[g, circle, "Subgraph"]]
```
