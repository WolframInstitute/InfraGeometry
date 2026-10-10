---
Template: Symbol
Name: InfraMemberQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMemberQ
Keywords: [segment, ray, line, circle, arc, symbolic object, membership]
SeeAlso: [RandomInfraSegment, InfraMeasurement, InfraSegmentQ, InfraInfiniteLineQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMemberQ]()[*graph*, *obj*, *path*]</code> tests whether the vertex list *path* is a member of the Euclidean head *obj* on *graph*.

## Details & Options

*path* is a member exactly when it is a source-to-sink chain of *obj*'s graph — <code>[InfraMeasurement]()[*graph*, *obj*, "Graph"]</code> — for a circle, up to rotation and direction. [InfraMemberQ]() agrees with [Named construction samplers](../Tutorials/NamedConstructionSamplers.md) on every head it reads off a graph: every vertex list it returns there passes `InfraMemberQ`, and conversely. A circle's, and a closed arc's, representative is found by the sweep instead, which can find a circle the graph misses: where the cut band is disconnected, the graph is the necklaces, and a necklace needs the circle to meet the seam in one run. For a circle or a closed arc a member is a chain with the copy of the source dropped, read up to rotation and direction.

Unlike [InfraSegmentQ]() or [InfraInfiniteLineQ](), which test *path* against the general definition of the class on *graph*, `InfraMemberQ` tests it against one specific head — so it also distinguishes, say, one line through two points from another line through the same points on a graph where several exist.

## Basic Examples

Two walks from the centre to a vertex four steps away: a shortest path, which is a member of the segment, and a detour through a third vertex, which is not.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {x = (SeedRandom[7]; RandomInfraPoint[g, InfraShell[a, 3]])},
  {seg = InfraSegment[a, b]},
  {member = Replace[ seg, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ]},
  {detour = RandomInfraSegment[ g, InfraSegment[a, x, b] ]},
  {InfraSubstrateHighlight[g, {InfraWalk[member], InfraWalk[detour], a, b}],
   InfraMemberQ[g, seg, member], InfraMemberQ[g, seg, detour]}]
```

A shortest path found independently by [RandomInfraSegment]() is a member of the matching segment head.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 5]])},
  {onePath = RandomInfraSegment[g, a, b]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[onePath]}], InfraMemberQ[g, InfraSegment[a, b], onePath]}]
```

A circle's member is recognised up to rotation and direction.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {turned = RotateLeft[Reverse @ Replace[ circle, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], 3]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[turned, First @ turned]], c}, "Arrowheads" -> True],
   InfraMemberQ[g, circle, turned]}]
```

## Properties and Relations

A shortest path between other points is a segment, but not a member of this one.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {other = RandomInfraSegment[ g, InfraSegment[a, First @ AdjacencyList[g, a]] ]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[other]}],
   InfraSegmentQ[g, other], InfraMemberQ[g, InfraSegment[a, b], other]}]
```
