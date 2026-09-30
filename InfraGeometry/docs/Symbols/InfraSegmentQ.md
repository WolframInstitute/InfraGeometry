---
Template: Symbol
Name: InfraSegmentQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSegmentQ
Keywords: [segment, geodesic, shortest path, predicate]
SeeAlso: [InfraSegment, FindInfraSegment, InfraWalkQ, InfraGeodesicQ, InfraLineQ, InfraRayQ, InfraMemberQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraSegmentQ]()[*g*, *walk*]</code> tests whether the vertex list *walk* is a geodesic of *g*.

<code>[InfraSegmentQ]()[*g*, {*walk1*, *walk2*, …}]</code> tests whether every walk in the list is a geodesic.

<code>[InfraSegmentQ]()[*g*, *dag*]</code> tests a walk graph or a directed acyclic graph: every source-to-sink path must be a geodesic.

## Details & Options

A walk {*v0*, …, *vk*} is a geodesic when consecutive vertices are adjacent and *k* = *d(v0, vk)*: no shorter walk joins its ends.

The predicate takes a walk, never an object. <code>[InfraSegmentQ]()[*g*, [InfraSegment]()[*a*, *b*]]</code> stays unevaluated. Test a member of the segment, or the segment's graph, or ask [InfraMemberQ]() whether a walk belongs to one particular segment.

A single vertex is not a segment, so a walk of one vertex gives `False`.

A list of walks is the shape [FindInfraSegment]() returns with a count, and the graph of a segment, <code>[InfraMeasurement]()[*g*, *seg*, "Graph"]</code>, is a DAG. So the output of either can be passed straight in.

Inside an [InfraScene](), `InfraSegmentQ[s]` with one argument is the assertion that the binding *s* is a geodesic. The scene supplies the graph.

[InfraGeodesicQ]() is the local version: every window of a given number of steps is a geodesic. At scale `Infinity` it is this predicate.

## Basic Examples

Two walks from the same start to the same end. The first is a geodesic; the second makes a detour.

```wl
With[{g = GridGraph[{5, 5}]},
  Row[Table[
    Labeled[
      InfraSubstrateHighlight[g, {InfraWalk[w], Directive[$InfraPointColor], First[w], Last[w]},
        "Arrowheads" -> True, ImageSize -> 180],
      InfraSegmentQ[g, w]],
    {w, {{1, 2, 3, 8, 13}, {1, 6, 7, 2, 3, 8, 13}}}]]]
```

A list of walks, and the graph of a segment.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {InfraSegmentQ[g, FindInfraSegment[g, 1, 13, All]],
   InfraSegmentQ[g, InfraMeasurement[g, InfraSegment[1, 13], "Graph"]]}]
```

## Properties and Relations

A detour can be geodesic at every small scale and still not be a geodesic. Every two-step window of the second walk above is a shortest path.

```wl
With[
  {g = GridGraph[{5, 5}], w = {1, 6, 7, 2, 3, 8, 13}},
  {InfraGeodesicQ[g, w, 2], InfraSegmentQ[g, w]}]
```

Every line is a geodesic.

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraSegmentQ[g, FindInfraLine[g, 6, 7, All]]]
```

On the 6-cycle the walk halfway round is a geodesic; one step more is not.

```wl
{InfraSegmentQ[CycleGraph[6], {1, 2, 3, 4}], InfraSegmentQ[CycleGraph[6], {1, 2, 3, 4, 5}]}
```
