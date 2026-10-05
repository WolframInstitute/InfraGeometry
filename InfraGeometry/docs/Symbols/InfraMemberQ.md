---
Template: Symbol
Name: InfraMemberQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMemberQ
Keywords: [segment, ray, line, circle, arc, inert head, membership]
SeeAlso: [FindInfraRepresentative, InfraMeasurement, InfraSegmentQ, InfraLineQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMemberQ]()[*graph*, *obj*, *path*]</code> tests whether the vertex list *path* is a member of the Euclidean head *obj* on *graph*.

## Details & Options

*path* is a member exactly when it is a source-to-sink chain of *obj*'s graph — <code>[InfraMeasurement]()[*graph*, *obj*, "Graph"]</code> — for a circle, up to rotation and direction. [InfraMemberQ]() agrees with [FindInfraRepresentative]() on every head it reads off a graph: every vertex list it returns there passes `InfraMemberQ`, and conversely. A circle's, and a closed arc's, representative is found by the sweep instead, which can find a circle the graph misses: where the cut band is disconnected, the graph is the necklaces, and a necklace needs the circle to meet the seam in one run. For a circle or a closed arc a member is a chain with the copy of the source dropped, read up to rotation and direction.

Unlike [InfraSegmentQ]() or [InfraLineQ](), which test *path* against the general definition of the class on *graph*, `InfraMemberQ` tests it against one specific head — so it also distinguishes, say, one line through two points from another line through the same points on a graph where several exist.

## Basic Examples

Two walks from the centre to a vertex four steps away: a shortest path, which is a member of the segment, and a detour through a third vertex, which is not.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {x = (SeedRandom[7]; RandomInfraPoint[g, a, 3])},
  {seg = InfraSegment[a, b]},
  {member = FindInfraRepresentative[g, seg]},
  {detour = FindInfraRepresentative[g, InfraSegment[a, x, b]]},
  {InfraSubstrateHighlight[g, {InfraWalk[member], InfraWalk[detour], a, b}],
   InfraMemberQ[g, seg, member], InfraMemberQ[g, seg, detour]}]
```

A shortest path found independently by [FindInfraSegment]() is a member of the matching segment head.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 5])},
  {onePath = FindInfraSegment[g, a, b]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[onePath]}], InfraMemberQ[g, InfraSegment[a, b], onePath]}]
```

A circle's member is recognised up to rotation and direction.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {turned = RotateLeft[Reverse @ FindInfraRepresentative[g, circle], 3]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[turned, First @ turned]], c}, "Arrowheads" -> True],
   InfraMemberQ[g, circle, turned]}]
```

## Properties and Relations

A shortest path between other points is a segment, but not a member of this one.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {other = FindInfraRepresentative[g, InfraSegment[a, First @ AdjacencyList[g, a]]]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[other]}],
   InfraSegmentQ[g, other], InfraMemberQ[g, InfraSegment[a, b], other]}]
```
