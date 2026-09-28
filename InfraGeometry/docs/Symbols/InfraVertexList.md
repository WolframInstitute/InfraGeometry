---
Template: Symbol
Name: InfraVertexList
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraVertexList
Keywords: [segment, ray, line, circle, arc, inert head, member, enumeration, random]
SeeAlso: [InfraMeasurement, InfraMemberQ, FindInfraSegment, FindInfraRay, FindInfraLine, FindInfraCircle, FindInfraArc]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraVertexList]()[*graph*, *obj*]</code> gives one member of the Euclidean head *obj* as a vertex list.

<code>[InfraVertexList]()[*graph*, *obj*, *n* | UpTo[*n*] | All]</code> gives a `List` of *n*, at most *n*, or every member.

## Details & Options

A member is a source-to-sink chain of the head's graph — <code>[InfraMeasurement]()[*graph*, *obj*, "Graph"]</code> — read off in lexicographic order. A circle's graph is a `List` of necklaces, each opened at its closing arrow *u* -> *s1*, so each is an acyclic DAG with one source and one sink; a circle's member is the open chain *s1* … *u*, a cyclic vertex list whose first vertex is not repeated. A closed count under a non-negative integer *n* that exceeds the number of members gives `$Failed`, matching every `Find*` count contract.

Two modifiers, given after the count:

- `"RandomChoice"` walks the graph choosing the next arrow *v* -> *w* with probability proportional to the backward count at *w*, so every member of the family is drawn with probability `1 / Cardinality`; `SeedRandom` in front reproduces the draw.
- `"Pruning" -> q` discards a random fraction *q* of the candidates at each step of an otherwise exhaustive enumeration.

`InfraVertexList[graph, obj]` (no count) is the same as `InfraVertexList[graph, obj, Automatic]`, the first member in canonical order.

## Basic Examples

A uniformly random geodesic of a segment, drawn over the whole family. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  SeedRandom[3];
  With[{picks = InfraVertexList[g, seg, 1, "RandomChoice"]},
    {InfraHighlightGraph[g, {seg, InfraWalk[First @ picks]}, ImageSize -> 250], picks}]]
```

One geodesic, then every geodesic, of a segment on a grid.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraVertexList[g, seg]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  Length @ InfraVertexList[g, seg, All]
]
```

A uniformly random geodesic, reproducible by seed.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  SeedRandom[1];
  InfraVertexList[g, seg, 1, "RandomChoice"]
]
```

A closed count that cannot be met is `$Failed`; `UpTo` takes what there is.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {InfraVertexList[g, seg, 7], Length @ InfraVertexList[g, seg, UpTo[7]]}]
```

A member of a circle is a cyclic vertex list: the closing edge is implicit.

```wl
InfraVertexList[GridGraph[{9, 9}], InfraCircle[41, "Radius" -> {2, 4}]]
```

## Properties and Relations

Every member is a member, and there are as many as the head counts.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  With[{picks = InfraVertexList[g, seg, All]},
    {AllTrue[picks, InfraMemberQ[g, seg, #] &], Length @ picks === InfraMeasurement[g, seg, "Cardinality"]}]]
```
