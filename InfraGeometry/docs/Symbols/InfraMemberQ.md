---
Template: Symbol
Name: InfraMemberQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMemberQ
Keywords: [segment, ray, line, circle, arc, inert head, membership]
SeeAlso: [InfraVertexList, InfraMeasurement, InfraSegmentQ, InfraLineQ]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraMemberQ]()[*graph*, *obj*, *path*]</code> tests whether the vertex list *path* is a member of the Euclidean head *obj* on *graph*.

## Details & Options

*path* is a member exactly when it is a source-to-sink chain of *obj*'s graph — <code>[InfraMeasurement]()[*graph*, *obj*, "Graph"]</code> — for a circle, up to rotation and direction. [InfraMemberQ]() agrees with [InfraVertexList]() by construction: every vertex list `InfraVertexList` returns passes `InfraMemberQ`, and conversely.

Unlike [InfraSegmentQ]() or [InfraLineQ](), which test *path* against the general definition of the class on *graph*, `InfraMemberQ` tests it against one specific head — so it also distinguishes, say, one line through two points from another line through the same points on a graph where several exist.

## Basic Examples

Two walks from the centre of a grid to a vertex two steps up and two across: a geodesic, which is a member of the segment, and a detour of length 6, which is not.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {seg = InfraSegment[41, 61]},
  {member = {41, 42, 51, 52, 61}, detour = {41, 42, 43, 44, 53, 62, 61}},
  {InfraSubstrateHighlight[g, {InfraWalk[member], InfraWalk[detour], Directive[$InfraPointColor], 41, 61}, ImageSize -> 250],
   InfraMemberQ[g, seg, member], InfraMemberQ[g, seg, detour]}]
```

A geodesic found independently by `FindInfraSegment` is a member of the matching segment head; an arbitrary longer walk between the same endpoints is not.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraMemberQ[g, seg, FindInfraSegment[g, 7, 19]]
]
```

```wl
With[
  {g = GridGraph[{5, 5}]},
  {seg = InfraSegment[7, 19]},
  InfraMemberQ[g, seg, {7, 2, 3, 8, 13, 18, 19}]
]
```

A circle's member is recognised up to rotation and direction.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {circle = InfraCircle[41, "Radius" -> {2, 4}]},
  InfraMemberQ[g, circle, RotateLeft[Reverse @ InfraVertexList[g, circle], 3]]]
```

## Properties and Relations

A geodesic between other points is a segment, but not a member of this one.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {InfraSegmentQ[g, {41, 42, 43}], InfraMemberQ[g, InfraSegment[41, 61], {41, 42, 43}]}]
```
