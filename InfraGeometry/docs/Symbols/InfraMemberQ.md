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
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {x = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 7]},
  {seg = InfraSegment[a, b]},
  {member = Replace[ seg, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> 1 ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> 1 ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> 1 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> 1 ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> 1 ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> 1 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> 1 ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> 1 ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> 1 ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> 1 ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> 1 ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> 1 ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> 2 ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> 2 ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> 2 ] } ]},
  {detour = RandomInfraSegment[ g, InfraSegment[a, x, b], RandomSeeding -> 1 ]},
  {InfraSubstrateHighlight[g, {InfraWalk[member], InfraWalk[detour], a, b}],
   InfraMemberQ[g, seg, member], InfraMemberQ[g, seg, detour]}]
```

A shortest path found independently by [RandomInfraSegment]() is a member of the matching segment head.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {onePath = RandomInfraSegment[g, a, b, RandomSeeding -> 1]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[onePath]}], InfraMemberQ[g, InfraSegment[a, b], onePath]}]
```

A circle's member is recognised up to rotation and direction.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {circle = InfraCircle[c, {2, 4}]},
  {turned = RotateLeft[Reverse @ Replace[ circle, { token_InfraPoint :> RandomInfraPoint[ g, token, RandomSeeding -> 1 ], token_InfraSegment :> RandomInfraSegment[ g, token, RandomSeeding -> 1 ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, RandomSeeding -> 1 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> 1 ], token_InfraCircle :> RandomInfraCircle[ g, token, RandomSeeding -> 1 ], token_InfraArc :> RandomInfraArc[ g, token, RandomSeeding -> 1 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> 1 ], token_InfraPlane :> RandomInfraPlane[ g, token, RandomSeeding -> 1 ], token_InfraBall :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraShell :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSphere :> RandomInfraSphere[ g, token, RandomSeeding -> 1 ], token_InfraTube :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCylinder :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraCone :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraSolidOfRevolution :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraBallHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraConvexHull :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraQuadric :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraWalk :> RandomInfraWalk[ g, token, RandomSeeding -> 1 ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, RandomSeeding -> 1 ], token_InfraEllipse :> RandomInfraEllipse[ g, token, RandomSeeding -> 1 ], token_InfraIntersection :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraUnion :> Keys @ InfraMeasurement[ g, token, "VertexDensity" ], token_InfraRay :> RandomInfraHalfLine[ g, token, RandomSeeding -> 2 ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, RandomSeeding -> 2 ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, RandomSeeding -> 2 ] } ], 3]},
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
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {other = RandomInfraSegment[ g, InfraSegment[a, First @ AdjacencyList[g, a]], RandomSeeding -> 1 ]},
  {InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[other]}],
   InfraSegmentQ[g, other], InfraMemberQ[g, InfraSegment[a, b], other]}]
```
