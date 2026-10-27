---
Template: Symbol
Name: IntervalGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/IntervalGraph
Keywords: [construction graph, shortest path, directed acyclic graph, metric interval, segment]
SeeAlso: [InfraSegment, InfraMeasurement, RayGraph, BeamGraph, ArcGraph, SprayGraph, MetricInterval]
RelatedGuides: [EuclideanInfrageometry, InfraTopology]
---

## Usage

<code>[IntervalGraph]()[*g*, *p*, *q*]</code> gives the directed acyclic graph whose paths from *p* to *q* are exactly the shortest paths from *p* to *q* in *g*.

<code>[IntervalGraph]()[*g*, *p1*, *p2*, …, *pk*]</code> gives the list of the interval graphs of consecutive points.

## Details & Options

The vertices are the metric interval *I(p, q) = {v : d(p, v) + d(v, q) = d(p, q)}*. An edge *u → v* of *g* is kept when *u* and *v* lie in *I(p, q)* and *d(p, v) = d(p, u) + 1*.

The source is *p* and the sink is *q*. Each path from the source to the sink has length *d(p, q)*.

On the square grid, with *a* steps from *p* to *q* along one axis and *b* along the other, the interval graph is the (*a* + 1) × (*b* + 1) grid oriented from *p* to *q*. It has *C(a + b, a)* source-to-sink paths.

<code>[IntervalGraph]()[*g*, *p*, *q*]</code> is <code>[InfraMeasurement]()[*g*, [InfraSegment]()[*p*, *q*], "Graph"]</code>.

## Basic Examples

The interval graph from the centre to a vertex at distance 5, drawn on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {IntervalGraph[g, a, b], a, b}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the endpoints are 2 and 3 steps apart along the axes. The interval graph is the 3 × 4 grid with 17 edges, and it has *C(5, 2) = 10* paths from the source to the sink:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]}, {dag = IntervalGraph[g, a, b]},
  {VertexCount[dag], EdgeCount[dag], Length @ FindPath[dag, a, b, Infinity, All]}]
```

## Scope

More points give one interval graph per piece of the polyline:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 3]},
  InfraSubstrateHighlight[g, {Sequence @@ IntervalGraph[g, a, c, b], a, c, b}, ImageSize -> Medium]]
```

## Properties and Relations

The vertices form the metric interval of the endpoints:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  Sort @ VertexList @ IntervalGraph[g, a, b] ===
    Sort @ Select[VertexList[g], GraphDistance[g, a, #] + GraphDistance[g, #, b] == GraphDistance[g, a, b] &]]
```

It is the graph of the segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  IntervalGraph[g, a, b] === InfraMeasurement[g, InfraSegment[a, b], "Graph"]]
```
