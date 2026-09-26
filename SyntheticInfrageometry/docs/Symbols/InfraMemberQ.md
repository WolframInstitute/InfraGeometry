---
Template: Symbol
Name: InfraMemberQ
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraMemberQ
Keywords: [segment, ray, line, circle, arc, inert head, membership]
SeeAlso: [InfraVertexList, InfraMeasurement, InfraSegmentQ, InfraLineQ]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraMemberQ]()[*graph*, *obj*, *path*]</code> tests whether the vertex list *path* is a member of the Euclidean head *obj* on *graph*.

## Details & Options

*path* is a member exactly when it is a source-to-sink chain of *obj*'s graph — [InfraMeasurement]()`[graph, obj, "Graph"]` — for a circle, up to rotation and direction. `InfraMemberQ` agrees with `InfraVertexList` by construction: every vertex list `InfraVertexList` returns passes `InfraMemberQ`, and conversely.

Unlike [InfraSegmentQ]() or [InfraLineQ](), which test *path* against the general definition of the class on *graph*, `InfraMemberQ` tests it against one specific head — so it also distinguishes, say, one line through two points from another line through the same points on a graph where several exist.

## Basic Examples

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
