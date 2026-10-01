---
Template: Symbol
Name: SegmentGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SegmentGraph
Keywords: [metric interval, shortest-path DAG, shortest paths, shortest-path count, segment]
SeeAlso: [MetricInterval, FindInfraSegment, InfraSegment, SprayGraph, GeodesicExtensionGraph, TubeVolumes]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[SegmentGraph]()[*g*, *u*, *v*]</code> gives the metric interval between *u* and *v* as a directed acyclic graph whose directed paths from *u* to *v* are exactly the shortest paths from *u* to *v*.

## Details & Options

Definition: the metric interval is *I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)}*, the vertices on some shortest path from *u* to *v*. The graph has these vertices, and an edge *w → x* for every edge of *g* between two of them with *d(u, x) = d(u, w) + 1*.

Every shortest path from *u* to *v* is a directed path of the graph, and every directed path from *u* to *v* is a shortest path, each exactly once. So the graph holds the whole family without listing it.

It is built from the two distance fields *d(u, ·)* and *d(v, ·)* and never enumerates a path. Its size is at most that of *g*, while the number of shortest paths can be exponential in *d(u, v)*.

On a square grid the interval is the rectangle spanned by *u* and *v*, and the shortest paths are the lattice paths through it. Where *g* is disconnected between *u* and *v* the graph is empty.

The graph of the head [InfraSegment]()`[u, v]` is this graph.

## Basic Examples

The interval between the centre and a vertex four steps away, drawn on the substrate by the shortest paths through each edge, and the DAG itself.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {intervalDag = SegmentGraph[g, a, b]},
  GraphicsRow[{InfraSubstrateHighlight[g, {intervalDag, Directive[$InfraPointColor], a, b}], intervalDag}]]
```

Its size and its number of paths from source to sink, beside the DAG.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {intervalDag = SegmentGraph[g, a, b]},
  {intervalDag, VertexCount[intervalDag], EdgeCount[intervalDag], Length @ FindPath[intervalDag, a, b, Infinity, All]}]
```

From the centre to the rim of the medium square tiling: a large family on a small graph, counted by [InfraMeasurement]() off the same graph.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; First @ FindInfraPoint[g, 1, "From" -> "Periphery"])},
  {intervalDag = SegmentGraph[g, a, b]},
  {InfraSubstrateHighlight[g, {intervalDag, Directive[$InfraPointColor], a, b}],
   VertexCount[intervalDag], EdgeCount[intervalDag], InfraMeasurement[g, InfraSegment[a, b], "Cardinality"]}]
```

## Properties and Relations

The vertices are the [MetricInterval](), the paths are the shortest paths that [FindInfraSegment]() finds, and the graph is that of the segment head.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  {intervalDag = SegmentGraph[g, a, b]},
  {InfraSubstrateHighlight[g, {intervalDag, Directive[$InfraPointColor], a, b}],
   Sort @ VertexList[intervalDag] === Sort @ MetricInterval[g, a, b],
   Sort @ FindPath[intervalDag, a, b, Infinity, All] === Sort @ FindInfraSegment[g, a, b, All],
   Sort @ EdgeList[intervalDag] === Sort @ EdgeList @ InfraMeasurement[g, InfraSegment[a, b], "Graph"]}]
```

Two vertices in different components have an empty interval.

```wl
With[
  {g = Graph[{1 <-> 2, 3 <-> 4}]},
  {g, VertexCount @ SegmentGraph[g, 1, 4]}]
```
