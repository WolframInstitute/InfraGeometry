---
Template: Symbol
Name: InfraMemberQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraMemberQ
Keywords: [membership, member, segment, ray, line, circle, arc, region]
SeeAlso: [InfraMeasurement, RandomInfraSegment, InfraSegment, InfraSegmentQ, InfraInfiniteLineQ, InfraCircle]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraMemberQ]()[*g*, *obj*, *path*]</code> gives `True` if the vertex list *path* is a member of the family *obj* on the graph *g*.

<code>[InfraMemberQ]()[*g*, *reg*, *vs*]</code> gives `True` if the vertex list *vs* is the vertex set of the region *reg*.

<code>[InfraMemberQ]()[*g*, *pt*, *v*]</code> gives `True` if the vertex *v* belongs to the point family *pt*.

## Details & Options

A family — [InfraSegment](), [InfraHalfLine](), [InfraInfiniteLine](), [InfraCircle](), [InfraArc]() — has many members. *path* is a member exactly when it is a source-to-sink path of <code>[InfraMeasurement]()[*g*, *obj*, "Graph"]</code>.

Members are oriented: a member of <code>[InfraSegment]()[*p*, *q*]</code> runs from *p* to *q*. A member of a circle is a cyclic vertex list, its first vertex not repeated, and is recognised up to rotation and direction.

A region — [InfraTube](), [InfraCylinder](), [InfraCone](), [InfraQuadric](), [InfraPerpendicularBisector](), [InfraEquidistantSet]() — has one member, its vertex set. The order and repetition of *vs* do not matter.

A point family — [InfraMidpoint](), [InfraRegionNearest]() — has vertices as members.

[InfraSegmentQ]() and [InfraInfiniteLineQ]() test a path against a class: is it some shortest path, some line. [InfraMemberQ]() tests it against one object.

## Basic Examples

A shortest path from the centre to a vertex at distance 4 is a member of the segment; a detour through a third vertex is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]}, {x = RandomInfraPoint[g, InfraShell[a, 2], RandomSeeding -> 4]},
  {paths = {RandomInfraSegment[g, a, b, RandomSeeding -> 1], RandomInfraSegment[g, InfraSegment[a, x, b], RandomSeeding -> 1]}},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraSegment[a, b], InfraWalk[path], a, b}, PlotLabel -> InfraMemberQ[g, InfraSegment[a, b], path]],
    {path, paths}]]
```

Members are oriented. The reversed path is a member of the segment from *b* to *a*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {path = RandomInfraSegment[g, a, b, RandomSeeding -> 1]},
  {InfraMemberQ[g, InfraSegment[a, b], Reverse @ path], InfraMemberQ[g, InfraSegment[b, a], Reverse @ path]}]
```

## Scope

A circle in the band of radii 3 and 4, and the same circle reversed and rotated, are both members:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {circle = RandomInfraCircle[g, InfraCircle[c, {3, 4}], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c},
    PlotLabel -> (InfraMemberQ[g, InfraCircle[c, {3, 4}], #] & /@ {circle, RotateLeft[Reverse @ circle, 3]}), ImageSize -> Medium]]
```

A half-line and a line drawn by their samplers are members:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 1]},
  {InfraMemberQ[g, InfraHalfLine[a, b], RandomInfraHalfLine[g, a, b, RandomSeeding -> 1]],
   InfraMemberQ[g, InfraInfiniteLine[a, b], RandomInfraInfiniteLine[g, a, b, RandomSeeding -> 1]]}]
```

A region has one member, its vertex set in any order. The tube of radius 1 about a vertex is the vertex and its neighbours:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraMemberQ[g, InfraTube[c, 1], Reverse @ Prepend[AdjacencyList[g, c], c]]]
```

## Properties and Relations

A shortest path is a segment, and a member of the segment between its ends, but not a member of the line through them: it can be prolonged:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {path = RandomInfraSegment[g, a, b, RandomSeeding -> 1]},
  {InfraSegmentQ[g, path], InfraMemberQ[g, InfraSegment[a, b], path], InfraMemberQ[g, InfraInfiniteLine[a, b], path]}]
```

Every member listed by [RandomInfraSegment]() passes the test:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 7], RandomSeeding -> 1]},
  AllTrue[RandomInfraSegment[g, a, b, All], InfraMemberQ[g, InfraSegment[a, b], #] &]]
```

## Possible Issues

A ball and a shell have no membership test, and [InfraMemberQ]() stays unevaluated. The tube about the centre is the same region and has one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 2], "VertexDensity"]},
  BooleanQ /@ {InfraMemberQ[g, InfraBall[c, 2], ball], InfraMemberQ[g, InfraTube[c, 2], ball]}]
```
