---
Template: Symbol
Name: InfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegment
Keywords: [segment, shortest path, interval DAG, polyline, symbolic object, counting measure, Riemannian measure]
SeeAlso: [IntervalGraph, RandomInfraSegment, InfraMeasurement, RandomInfraRepresentative, RandomInfraGeodesic, InfraLine, MetricInterval, InfraTube]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSegment]()[*p*, *q*]</code> is the segment from *p* to *q*: every shortest path from *p* to *q* at once. It is a symbolic object; [InfraMeasurement]() and [RandomInfraRepresentative]() evaluate it on a graph.

<code>[InfraSegment]()[*p1*, *p2*, …, *pk*]</code> is the polyline of the segments [*p1*, *p2*], …, [*p(k-1)*, *pk*].

<code>[InfraSegment]()[*p*, *q*]</code> inside an [InfraScene]() is the segment construction token; [RandomInfraSegment]() is the search.

## Details & Options

Definition: an infra-segment between *p* and *q* is the set of all shortest paths from *p* to *q*.

It carries no weights. The shortest paths are equally admissible, so nothing distinguishes them.

The head holds its two points and computes nothing. Its graph — <code>[InfraMeasurement]()[*g*, *seg*, "Graph"]</code> — is the interval of shortest paths: the vertices *v* with *d(p, v) + d(v, q) = d(p, q)*, with arrows of rising distance from *p*. Its source-to-sink chains are exactly the shortest paths, each once, so `"Faithful"` is `True`.

Every count is read off that graph by dynamic programming, never by enumeration. The graph stays small where the family is large: two vertices at distance 5 on a square grid have 10 shortest paths and a 12-vertex graph.

A polyline is the one head whose `List` of graphs is not a family of alternatives. Its members are concatenations of one shortest path per piece, so its `"Cardinality"` is the product over the pieces and its `"Length"` the sum. Its `"VertexDensity"` stays the sum of the piece densities.

The support of the segment, the keys of its `"VertexDensity"`, is the interval itself. [InfraMeasurement]() gives two measures of it:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the interval |
| `"RiemannianMeasure"` | the number of vertices of the interval all of whose neighbours lie in it |

On the square grid two vertices *a* steps apart along one axis and *b* along the other span an (*a* + 1) × (*b* + 1) rectangle, so for *a*, *b* ≥ 1 the measures are (*a* + 1)(*b* + 1) and (*a* − 1)(*b* − 1). A segment with a single shortest path is all boundary, and its Riemannian measure is `0`. The rim of the graph is not boundary: a segment whose interval is the whole graph has both measures equal to the number of vertices.

A member is a vertex list; [RandomInfraRepresentative]() reads one, several or all of them, and [InfraMemberQ]() tests one.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 1 | To draw a straight-line from any point to any point. |
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. |
| Tarski | Betweenness | The points *x* with *B(pxq)*, from the three-place betweenness relation. |
| Birkhoff | Ruler postulate | The points of a line correspond to the reals, and the segment is a closed coordinate interval. |

## Basic Examples

The segment from the centre to a vertex five steps away, on the discretized plane, the square grid and the hexagonal tiling. Every shortest path is drawn at once, an edge as strongly as the number of shortest paths through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {a = First @ GraphCenter[g]},
    {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
    {seg = InfraSegment[a, b]},
    InfraSubstrateHighlight[g, {seg, a, b}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The interval of the same segments, its inner vertices in green and its boundary in blue. The Riemannian measure counts the green ones, the counting measure both. On the square grid the interval is a 3 × 4 rectangle with 2 inner vertices. On the discretized plane the two shortest paths differ in a single vertex, and nothing is inside.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {seg = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 5]])]},
    {support = Keys @ InfraMeasurement[g, seg, "VertexDensity"]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}],
      InfraMeasurement[g, seg, {"Cardinality", "CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The graph of a segment on the square tiling. Every shortest path is a directed path through it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
  InfraMeasurement[g, InfraSegment[a, b], "Graph"]]
```

The graph is small where the family is large. Ten steps out on the medium square tiling: the number of shortest paths beside the number of vertices of the graph.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[2]; RandomInfraPoint[g, InfraShell[a, 10]])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {seg, a, b}],
   InfraMeasurement[g, seg, "Cardinality"], VertexCount @ InfraMeasurement[g, seg, "Graph"]}]
```

The members are vertex lists. Three of them, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
  {members = RandomInfraRepresentative[g, InfraSegment[a, b], 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], a, b}], {member, members}]]
```

A polyline through the centre: one shortest path in, one out. Its cardinality is the product of the two pieces' cardinalities.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {a = (SeedRandom[2]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {b = (SeedRandom[5]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {poly = InfraSegment[a, c, b]},
  {InfraSubstrateHighlight[g, {poly, a, c, b}],
   InfraMeasurement[g, poly, "Cardinality"] == InfraMeasurement[g, InfraSegment[a, c], "Cardinality"] InfraMeasurement[g, InfraSegment[c, b], "Cardinality"]}]
```

## Properties and Relations

The support of the segment is the metric interval between its endpoints, drawn here beneath it.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {MetricInterval[g, a, b], seg}],
   Sort @ Keys @ InfraMeasurement[g, seg, "VertexDensity"] === Sort @ MetricInterval[g, a, b]}]
```

The cardinality is the number of members, and every member has the graph distance as its length.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
  {seg = InfraSegment[a, b]},
  {members = RandomInfraRepresentative[g, seg, All]},
  {InfraSubstrateHighlight[g, {members, a, b}],
   Length @ members === InfraMeasurement[g, seg, "Cardinality"],
   Union[Length[#] - 1 & /@ members] === {GraphDistance[g, a, b]}}]
```
