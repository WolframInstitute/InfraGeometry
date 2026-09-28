---
Template: Symbol
Name: InfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegment
Keywords: [segment, geodesic, interval DAG, polyline, inert head]
SeeAlso: [FindInfraSegment, InfraMeasurement, InfraVertexList, ExtendInfraSegment, InfraLine, MetricInterval]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraSegment]()[*p*, *q*]</code> is the segment from *p* to *q*: every geodesic from *p* to *q* at once. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraSegment]()[*p1*, *p2*, …, *pk*]</code> is the polyline of the segments [*p1*, *p2*], …, [*p(k-1)*, *pk*].

<code>[InfraSegment]()[*p*, *q*]</code> inside an [InfraScene]() is the segment construction token; [FindInfraSegment]() is the search.

## Details & Options

Definition: an infra-segment between *p* and *q* is the set of all geodesics from *p* to *q*.

It carries no weights. The geodesics are equally admissible, so nothing distinguishes them.

The head holds its two points and computes nothing. Its graph — <code>[InfraMeasurement]()[*g*, *seg*, "Graph"]</code> — is the geodesic interval: the vertices *v* with *d(p, v) + d(v, q) = d(p, q)*, with arrows of rising distance from *p*. Its source-to-sink chains are exactly the geodesics, each once, so `"Faithful"` is `True`.

Every count is read off that graph by dynamic programming, never by enumeration. The graph stays small where the family is large: two vertices at distance 5 on a square grid have 10 geodesics and a 12-vertex graph.

A polyline is the one head whose `List` of graphs is not a family of alternatives. Its members are concatenations of one geodesic per piece, so its `"Cardinality"` is the product over the pieces and its `"Length"` the sum. Its `"VertexDensity"` stays the sum of the piece densities.

A member is a vertex list; [InfraVertexList]() reads one, several or all of them, and [InfraMemberQ]() tests one.

## Basic Examples

The segment between two vertices of a grid, two steps apart in each direction: six geodesics, filling the rectangle they span. An edge is drawn as strongly as the number of geodesics through it.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {InfraHighlightGraph[g, {seg, Directive[$InfraPointColor], 41, 61}, ImageSize -> 250],
   InfraMeasurement[g, seg, "Cardinality"]}]
```

The graph of a segment on the square tiling. Every geodesic is a directed path through it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  InfraMeasurement[g, InfraSegment[a, b], "Graph"]
]
```

The graph is small where the family is large.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  {seg = InfraSegment[a, b]},
  <|"geodesics" -> InfraMeasurement[g, seg, "Cardinality"],
    "length" -> InfraMeasurement[g, seg, "Length"],
    "graph vertices" -> VertexCount @ InfraMeasurement[g, seg, "Graph"]|>
]
```

The members are vertex lists.

```wl
InfraVertexList[GridGraph[{4, 4}], InfraSegment[1, 11], All]
```

A polyline through the centre of a 5 × 5 grid: 36 members, each 8 edges long, and 12 of them — the six geodesics in, times the six out, counted once per piece — pass the centre.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {poly = InfraSegment[1, 13, 25]},
  {InfraMeasurement[g, poly, "Cardinality"], InfraMeasurement[g, poly, "Length"],
   InfraMeasurement[g, poly, "VertexDensity"][13]}
]
```

## Properties and Relations

The support of the segment is the metric interval between its endpoints.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  Sort @ Keys @ InfraMeasurement[g, InfraSegment[a, b], "VertexDensity"] === Sort @ MetricInterval[g, a, b]
]
```

The cardinality is the number of members, and every member has the graph distance as its length.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[1, 19]},
  {members = InfraVertexList[g, seg, All]},
  {Length @ members === InfraMeasurement[g, seg, "Cardinality"],
   Union[Length[#] - 1 & /@ members] === {GraphDistance[g, 1, 19]}}
]
```
