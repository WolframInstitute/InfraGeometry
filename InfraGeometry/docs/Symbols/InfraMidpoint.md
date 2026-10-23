---
Template: Symbol
Name: InfraMidpoint
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMidpoint
Keywords: [midpoint, bisection, segment, centre, shortest path]
SeeAlso: [RandomInfraMidpoint, InfraSegment, InfraPerpendicularBisector, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMidpoint]()[*p*, *q*]</code> is the midpoint of *p* and *q*: the central vertices of the shortest paths from *p* to *q*.

## Details & Options

The midpoint is *M(p, q) = {v ∈ I(p, q) : max(d(p, v), d(v, q)) = ⌈d(p, q)/2⌉}*, with *I(p, q)* the metric interval of *p* and *q*.

For even *d(p, q)* it is the middle layer of the interval, the vertices with *d(p, v) = d(v, q)*. For odd *d(p, q)* there is no such vertex, and the midpoint is the two central layers.

A midpoint is not unique. On the square grid, with *a* steps from *p* to *q* along one axis and *b* along the other and *a + b = 2k*, the middle layer is a diagonal of the rectangle between them. The number of shortest paths through its vertex *i* steps along the first axis is *C(k, i) C(k, a − i)*.

[InfraMidpoint]() is a symbolic object. [InfraMeasurement]() reads:

| Property | Value |
|---|---|
| `"VertexDensity"` | the number of shortest paths from *p* to *q* through each central vertex |
| `"Cardinality"` | the number of central vertices |
| `"CountingMeasure"` | the number of central vertices |
| `"Subgraph"` | the subgraph induced on the central vertices |
| `"RiemannianMeasure"` | the number of central vertices all of whose neighbours are central |

[RandomInfraMidpoint]() draws a central vertex, uniformly. <code>[InfraMemberQ]()[*g*, [InfraMidpoint]()[*p*, *q*], *v*]</code> tests a vertex.

Equal anchors give the anchor; disconnected anchors give the empty set.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | I.10 | To bisect a given finite straight line. Here the bisection point is a set. |

## Basic Examples

The midpoint of the centre and a vertex at distance 6, drawn over the segment:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 6], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraSegment[p, q], InfraMidpoint[p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid, three steps along each axis: the midpoint is a diagonal of four vertices, with 1, 9, 9 and 1 shortest paths through them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]}, {q = First @ Keys @ Select[xy, # - xy[p] == {3, 3} &]},
  {density = InfraMeasurement[g, InfraMidpoint[p, q], "VertexDensity"]},
  InfraSubstrateHighlight[g, {InfraSegment[p, q], density, p, q}, PlotLabel -> Values[density], ImageSize -> Medium]]
```

## Scope

At odd distance the midpoint is the two central layers. Three steps along one axis and two along the other:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]}, {q = First @ Keys @ Select[xy, # - xy[p] == {3, 2} &]},
  InfraSubstrateHighlight[g, {InfraSegment[p, q], InfraMidpoint[p, q], p, q},
    PlotLabel -> InfraMeasurement[g, InfraMidpoint[p, q], "Cardinality"], ImageSize -> Medium]]
```

[RandomInfraMidpoint]() draws one central vertex; `All` gives them all:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 6], RandomSeeding -> 1]},
  {RandomInfraMidpoint[g, InfraMidpoint[p, q], RandomSeeding -> 1], RandomInfraMidpoint[g, InfraMidpoint[p, q], All]}]
```

## Properties and Relations

At even distance every shortest path passes through the midpoint once, so the density adds up to the number of shortest paths:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 8], RandomSeeding -> 1]},
  Total @ InfraMeasurement[g, InfraMidpoint[p, q], "VertexDensity"] == InfraMeasurement[g, InfraSegment[p, q], "Cardinality"]]
```

At even distance the midpoint lies on the [InfraPerpendicularBisector](), and is the part of it inside the interval:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 2]},
    InfraSubstrateHighlight[g, {InfraPerpendicularBisector[p, q], InfraMidpoint[p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Possible Issues

`"Cardinality"` counts central vertices, not shortest paths:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
  {InfraMeasurement[g, InfraMidpoint[p, q], "Cardinality"], InfraMeasurement[g, InfraSegment[p, q], "Cardinality"]}]
```
