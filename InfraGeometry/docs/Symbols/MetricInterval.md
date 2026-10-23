---
Template: Symbol
Name: MetricInterval
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/MetricInterval
Keywords: [interval, betweenness, geodesic interval, shortest paths, segment support]
SeeAlso: [InfraSegment, IntervalGraph, MedianVertices, UniqueInfraSegmentQ, InfraMeasurement]
---

## Usage

<code>[MetricInterval]()[*g*, *u*, *v*]</code> gives the vertices of *g* between *u* and *v*: those on some shortest path from *u* to *v*.

## Details & Options

The interval is *I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)}*. It contains *u* and *v* and is the union of all shortest paths from *u* to *v*, the support of <code>[InfraSegment]()[*u*, *v*]</code>.

In the plane the interval is the straight segment. On the square grid it is the rectangle with corners *u* and *v*: with *a* steps along one axis and *b* along the other it has *(a + 1)(b + 1)* vertices.

*u* and *v* in different components give `{}`.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Tarski | Betweenness | *w* lies between *u* and *v*; here *d(u, w) + d(w, v) = d(u, v)*. |

## Basic Examples

The interval from the centre to a vertex at distance 5, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {u = First @ GraphCenter[g]},
    {v = RandomInfraPoint[g, InfraShell[u, 5], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {AssociationThread[MetricInterval[g, u, v], 1], u, v}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the interval is a rectangle of *(a + 1)(b + 1)* vertices. From 45 to 68 there are 2 and 3 steps:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {interval = MetricInterval[g, 45, 68]},
  {interval, Length[interval]}]
```

## Properties and Relations

The interval is the support of the segment:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 5], RandomSeeding -> 1]},
  Sort @ MetricInterval[g, u, v] === Keys @ InfraMeasurement[g, InfraSegment[u, v], "VertexDensity"]]
```

## Possible Issues

Vertices in different components have an empty interval:

```wl
MetricInterval[Graph[{1 <-> 2, 3 <-> 4}], 1, 4]
```
