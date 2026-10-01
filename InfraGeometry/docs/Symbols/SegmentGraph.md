---
Template: Symbol
Name: SegmentGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SegmentGraph
Keywords: [metric interval, geodesic DAG, shortest paths, geodesic count, segment]
SeeAlso: [MetricInterval, FindInfraSegment, InfraSegment, SprayGraph, GeodesicExtensionGraph, TubeVolumes]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[SegmentGraph]()[*g*, *u*, *v*]</code> gives the metric interval between *u* and *v* as a directed acyclic graph whose directed paths from *u* to *v* are exactly the geodesics from *u* to *v*.

## Details & Options

Definition: the metric interval is *I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)}*, the vertices on some geodesic from *u* to *v*. The graph has these vertices, and an edge *w → x* for every edge of *g* between two of them with *d(u, x) = d(u, w) + 1*.

Every geodesic from *u* to *v* is a directed path of the graph, and every directed path from *u* to *v* is a geodesic, each exactly once. So the graph holds the whole family without listing it.

It is built from the two distance fields *d(u, ·)* and *d(v, ·)* and never enumerates a path. Its size is at most that of *g*, while the number of geodesics can be exponential in *d(u, v)*.

On a square grid the interval is the rectangle spanned by *u* and *v*, and the geodesics are the lattice paths through it. Where *g* is disconnected between *u* and *v* the graph is empty.

The graph of the head [InfraSegment]()`[u, v]` is this graph.

## Basic Examples

The interval between two vertices of a grid, two steps apart in each direction, drawn by the geodesics through each edge, and the DAG itself.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {intervalDag = SegmentGraph[g, 41, 61]},
  Row[{
    InfraSubstrateHighlight[g, {intervalDag, Directive[$InfraPointColor], 41, 61}, ImageSize -> 180],
    Graph[intervalDag, ImageSize -> 120]}, Spacer[20]]]
```

Its size and its number of paths from source to sink.

```wl
With[
  {intervalDag = SegmentGraph[GridGraph[{9, 9}], 41, 61]},
  {VertexCount[intervalDag], EdgeCount[intervalDag], Length @ FindPath[intervalDag, 41, 61, Infinity, All]}]
```

Corner to corner on a 21 × 21 grid: the whole grid, 840 edges, and 137,846,528,820 geodesics, counted by [InfraMeasurement]() off the same graph.

```wl
With[
  {g = GridGraph[{21, 21}]},
  {intervalDag = SegmentGraph[g, 1, 441]},
  {VertexCount[intervalDag], EdgeCount[intervalDag], InfraMeasurement[g, InfraSegment[1, 441], "Cardinality"]}]
```

## Properties and Relations

The vertices are the [MetricInterval](), the paths are the geodesics that [FindInfraSegment]() finds, and the graph is that of the segment head.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {intervalDag = SegmentGraph[g, 41, 61]},
  {Sort @ VertexList[intervalDag] === Sort @ MetricInterval[g, 41, 61],
   Sort @ FindPath[intervalDag, 41, 61, Infinity, All] === Sort @ FindInfraSegment[g, 41, 61, All],
   Sort @ EdgeList[intervalDag] === Sort @ EdgeList @ InfraMeasurement[g, InfraSegment[41, 61], "Graph"]}]
```

Two vertices in different components have an empty interval.

```wl
VertexCount @ SegmentGraph[Graph[{1 <-> 2, 3 <-> 4}], 1, 4]
```
