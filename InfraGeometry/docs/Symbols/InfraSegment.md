---
Template: Symbol
Name: InfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegment
Keywords: [segment, shortest path, interval DAG, polyline, symbolic object, counting measure, Riemannian measure]
SeeAlso: [IntervalGraph, RandomInfraSegment, InfraMeasurement, RandomInfraGeodesic, InfraInfiniteLine, MetricInterval, InfraTube]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSegment]()[*p*, *q*]</code> is the segment from *p* to *q*: the family of all shortest paths from *p* to *q*.

<code>[InfraSegment]()[*p1*, *p2*, …, *pk*]</code> is the polyline through *p1*, …, *pk*: a shortest path from each point to the next, joined.

## Details & Options

A member of <code>[InfraSegment]()[*p*, *q*]</code> is a shortest path from *p* to *q*. All members have length *d(p, q)*, and none is preferred.

The vertices on the members form the metric interval *I(p, q) = {v : d(p, v) + d(v, q) = d(p, q)}*, the support of the segment.

A segment can have many members. On the square grid, with *a* steps from *p* to *q* along one axis and *b* along the other, there are *C(a + b, a)* shortest paths, and the interval is the (*a* + 1) × (*b* + 1) rectangle with corners *p* and *q*.

[InfraSegment]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph, [RandomInfraSegment]() draws members and [InfraMemberQ]() tests one. [InfraSubstrateHighlight]() draws all members at once, an edge the stronger the more members use it.

[InfraMeasurement]() reads:

| Property | Value |
|---|---|
| `"Graph"` | the directed graph whose source-to-sink paths are the members, as [IntervalGraph]() |
| `"Cardinality"` | the number of shortest paths |
| `"Length"` | *d(p, q)* |
| `"VertexDensity"` | the number of shortest paths through each vertex of the interval |
| `"CountingMeasure"` | the number of vertices of the interval |
| `"RiemannianMeasure"` | the number of vertices of the interval all of whose neighbours lie in it |

A member of a polyline is one member of each piece, joined. So the cardinality of a polyline is the product of the cardinalities of its pieces, and its length is the sum of their lengths.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 1 | To draw a straight line from any point to any point. |
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. Here the segment is a family. |
| Tarski | Betweenness | The points *x* between *p* and *q*; here *d(p, x) + d(x, q) = d(p, q)*. |

## Basic Examples

The segment from the centre to a vertex at distance 5, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraSegment[a, b], a, b}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of shortest paths from the centre to each vertex at distance 4, drawn as the size of the vertex. On the grid these are the binomial coefficients 1, 4, 6, 4, 1:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {shell = Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"]},
    {counts = AssociationMap[v |-> InfraMeasurement[g, InfraSegment[c, v], "Cardinality"], shell]},
    InfraSubstrateHighlight[g, {counts, c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three members of a segment on the grid, each a shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {members = RandomInfraSegment[g, a, b, 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[path], a, b}], {path, members}]]
```

## Scope

A polyline through the centre. Its cardinality is the product of the cardinalities of its two pieces:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 2]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 4]},
  {poly = InfraSegment[a, c, b]},
  InfraSubstrateHighlight[g, {poly, a, c, b},
    PlotLabel -> {InfraMeasurement[g, poly, "Cardinality"], InfraMeasurement[g, {InfraSegment[a, c], InfraSegment[c, b]}, "Cardinality"]},
    ImageSize -> Medium]]
```

## Properties and Relations

The support of a segment is the metric interval of its endpoints. On the grid it is a rectangle; its interior, drawn over it, is what the Riemannian measure counts:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
    {interval = Keys @ InfraMeasurement[g, seg, "VertexDensity"]},
    InfraSubstrateHighlight[g, {interval, InfraInterior[g, interval]},
      PlotLabel -> InfraMeasurement[g, seg, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A segment and its graph. Every member is a directed path from the source to the sink:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {seg}], InfraMeasurement[g, seg, "Graph"]}]]
```

It is the [IntervalGraph]() of the endpoints:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  InfraMeasurement[g, InfraSegment[a, b], "Graph"] === IntervalGraph[g, a, b]]
```

The members are as many as the cardinality, and each has length *d(p, q)*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 8], RandomSeeding -> 1]},
  {members = RandomInfraSegment[g, a, b, All]},
  {Length[members] == InfraMeasurement[g, InfraSegment[a, b], "Cardinality"],
   Union[Length /@ members] - 1 == {GraphDistance[g, a, b]}}]
```
