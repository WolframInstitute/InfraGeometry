---
Template: Symbol
Name: InfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegment
Keywords: [segment, shortest path, interval DAG, polyline, inert head]
SeeAlso: [FindInfraSegment, InfraMeasurement, InfraVertexList, ExtendInfraSegment, InfraLine, MetricInterval]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSegment]()[*p*, *q*]</code> is the segment from *p* to *q*: every shortest path from *p* to *q* at once. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraSegment]()[*p1*, *p2*, …, *pk*]</code> is the polyline of the segments [*p1*, *p2*], …, [*p(k-1)*, *pk*].

<code>[InfraSegment]()[*p*, *q*]</code> inside an [InfraScene]() is the segment construction token; [FindInfraSegment]() is the search.

## Details & Options

Definition: an infra-segment between *p* and *q* is the set of all shortest paths from *p* to *q*.

It carries no weights. The shortest paths are equally admissible, so nothing distinguishes them.

The head holds its two points and computes nothing. Its graph — <code>[InfraMeasurement]()[*g*, *seg*, "Graph"]</code> — is the interval of shortest paths: the vertices *v* with *d(p, v) + d(v, q) = d(p, q)*, with arrows of rising distance from *p*. Its source-to-sink chains are exactly the shortest paths, each once, so `"Faithful"` is `True`.

Every count is read off that graph by dynamic programming, never by enumeration. The graph stays small where the family is large: two vertices at distance 5 on a square grid have 10 shortest paths and a 12-vertex graph.

A polyline is the one head whose `List` of graphs is not a family of alternatives. Its members are concatenations of one shortest path per piece, so its `"Cardinality"` is the product over the pieces and its `"Length"` the sum. Its `"VertexDensity"` stays the sum of the piece densities.

A member is a vertex list; [InfraVertexList]() reads one, several or all of them, and [InfraMemberQ]() tests one.

## Basic Examples

The segment from the centre to a vertex six steps away, on the square, hexagonal and triangular tilings. Every shortest path is drawn at once, an edge as strongly as the number of shortest paths through it.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {a = InfraCenter[g]},
    {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
    {seg = InfraSegment[a, b]},
    InfraSubstrateHighlight[g, {seg, Directive[$InfraPointColor], a, b}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The graph of a segment on the square tiling. Every shortest path is a directed path through it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  InfraMeasurement[g, InfraSegment[a, b], "Graph"]]
```

The graph is small where the family is large. Ten steps out on the medium square tiling: the number of shortest paths beside the number of vertices of the graph.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[2]; RandomInfraPoint[g, a, 10])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {seg, Directive[$InfraPointColor], a, b}],
   InfraMeasurement[g, seg, "Cardinality"], VertexCount @ InfraMeasurement[g, seg, "Graph"]}]
```

The members are vertex lists. Three of them, each drawn as a walk.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  {members = InfraVertexList[g, InfraSegment[a, b], 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[member], Directive[$InfraPointColor], a, b}], {member, members}]]
```

A polyline through the centre: one shortest path in, one out. Its cardinality is the product of the two pieces' cardinalities.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {a = (SeedRandom[2]; RandomInfraPoint[g, c, 4])},
  {b = (SeedRandom[5]; RandomInfraPoint[g, c, 4])},
  {poly = InfraSegment[a, c, b]},
  {InfraSubstrateHighlight[g, {poly, Directive[$InfraPointColor], a, c, b}],
   InfraMeasurement[g, poly, "Cardinality"] == InfraMeasurement[g, InfraSegment[a, c], "Cardinality"] InfraMeasurement[g, InfraSegment[c, b], "Cardinality"]}]
```

## Properties and Relations

The support of the segment is the metric interval between its endpoints, drawn here beneath it.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  {seg = InfraSegment[a, b]},
  {InfraSubstrateHighlight[g, {MetricInterval[g, a, b], seg}],
   Sort @ Keys @ InfraMeasurement[g, seg, "VertexDensity"] === Sort @ MetricInterval[g, a, b]}]
```

The cardinality is the number of members, and every member has the graph distance as its length.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  {seg = InfraSegment[a, b]},
  {members = InfraVertexList[g, seg, All]},
  {InfraSubstrateHighlight[g, {members, Directive[$InfraPointColor], a, b}],
   Length @ members === InfraMeasurement[g, seg, "Cardinality"],
   Union[Length[#] - 1 & /@ members] === {GraphDistance[g, a, b]}}]
```
