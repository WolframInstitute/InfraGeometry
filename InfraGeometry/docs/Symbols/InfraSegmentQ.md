---
Template: Symbol
Name: InfraSegmentQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegmentQ
Keywords: [segment, shortest path, predicate]
SeeAlso: [InfraSegment, RandomInfraSegment, InfraWalkQ, InfraGeodesicQ, InfraInfiniteLineQ, InfraHalfLineQ, InfraMemberQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraSegmentQ]()[*g*, *walk*]</code> tests whether the vertex list *walk* is a shortest path of *g*.

<code>[InfraSegmentQ]()[*g*, {*walk1*, *walk2*, …}]</code> tests whether every walk of the list is a shortest path.

<code>[InfraSegmentQ]()[*g*, *dag*]</code> tests whether every source-to-sink path of the directed acyclic graph *dag* is a shortest path.

## Details & Options

A walk *(v₀, …, vₖ)* is a shortest path when consecutive vertices are adjacent and *k = d(v₀, vₖ)*.

A walk of one vertex gives `False`.

The predicate takes walks, not objects: <code>[InfraSegmentQ]()[*g*, [InfraSegment]()[*a*, *b*]]</code> stays unevaluated. To test whether a walk is a member of a given segment, use [InfraMemberQ]().

A walk can be given as a path graph, and the graph of a segment, <code>[InfraMeasurement]()[*g*, *seg*, "Graph"]</code>, is a DAG whose source-to-sink paths are its members.

Inside an [InfraScene](), <code>[InfraSegmentQ]()[*s*]</code> asserts that the object *s* is a shortest path of the scene's graph.

[InfraGeodesicQ]() is the local version: every window of a given number of steps is a shortest path.

## Basic Examples

A shortest path from the centre to a vertex at distance 4, and a walk between the same two vertices through a vertex off the segment:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    {x = RandomInfraPoint[g, InfraIntersection[InfraShell[a, 3], InfraShell[b, 3]], RandomSeeding -> 1]},
    {path = FindShortestPath[g, a, b], detour = Join[FindShortestPath[g, a, x], Rest @ FindShortestPath[g, x, b]]},
    InfraSubstrateHighlight[g, {InfraWalk[path], InfraWalk[detour], a, b},
      PlotLabel -> {InfraSegmentQ[g, path], InfraSegmentQ[g, detour]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

All members of a segment, as a list of walks and as the graph of the segment:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {InfraSegmentQ[g, RandomInfraSegment[g, a, b, All]], InfraSegmentQ[g, InfraMeasurement[g, InfraSegment[a, b], "Graph"]]}]
```

## Properties and Relations

A walk that turns twice around a square on the grid is a geodesic at scale 2, every two steps being a shortest path, but it is not a shortest path between its ends:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {vertexAt = AssociationThread[Round @ GraphEmbedding[g], VertexList[g]]},
  {walk = vertexAt /@ {{5, 5}, {6, 5}, {7, 5}, {8, 5}, {8, 6}, {8, 7}, {8, 8}, {7, 8}, {6, 8}, {5, 8}}},
  InfraSubstrateHighlight[g, {InfraWalk[walk]}, PlotLabel -> {InfraGeodesicQ[g, walk, 2], InfraSegmentQ[g, walk]},
    ImageSize -> Medium]]
```

On the 6-cycle the walk halfway round is a shortest path; one step more is not:

```wl
{InfraSegmentQ[CycleGraph[6], {1, 2, 3, 4}], InfraSegmentQ[CycleGraph[6], {1, 2, 3, 4, 5}]}
```

## Possible Issues

A segment object is not a walk, and the call stays unevaluated. A single vertex is not a shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {InfraSegmentQ[g, InfraSegment[a, 46]], InfraSegmentQ[g, {a}]}]
```
