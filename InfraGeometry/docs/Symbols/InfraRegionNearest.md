---
Template: Symbol
Name: InfraRegionNearest
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegionNearest
Keywords: [nearest point, metric projection, closest point, region, distance]
SeeAlso: [RandomInfraRegionNearest, InfraMeasurement, InfraDistance, InfraBall, InfraPoint, RegionNearest]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRegionNearest]()[*reg*, *p*]</code> is the set of vertices of the region *reg* nearest to the vertex *p*, with all ties.

## Details & Options

With *S* the support of *reg*, the set is *{v ∈ S : d(p, v) = d(p, S)}*, where *d(p, S) = min d(p, u)* over the *u* in *S* reachable from *p*. It is the graph analogue of [RegionNearest](), the metric projection of *p* onto *reg*.

In the plane the nearest point of a convex region is unique. On a graph it is not: on the square grid a whole side of a ball can be nearest.

If *p* lies in *reg*, the set is {*p*}. An empty or unreachable region gives the empty set.

The region can be a symbolic region ([InfraBall](), [InfraShell](), [InfraSegment](), …), a vertex, a vertex list or an association of masses. The masses fix the support and do not weight the distance.

[InfraRegionNearest]() is a symbolic object. [InfraMeasurement]() reads its `"VertexDensity"`, 1 on every nearest vertex, its `"Cardinality"` and `"CountingMeasure"`, the number of nearest vertices, `"Subgraph"` and `"RiemannianMeasure"`. [RandomInfraRegionNearest]() draws a nearest vertex, and <code>[InfraMemberQ]()[*g*, *nearest*, *v*]</code> tests one.

## Basic Examples

The vertices of the ball of radius 2 about the centre nearest to a vertex at distance 5:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {p = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 3]},
    InfraSubstrateHighlight[g, {InfraBall[c, 2], InfraRegionNearest[InfraBall[c, 2], p], p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the nearest set depends on the direction. Straight out from a corner of the ball one vertex is nearest; facing a side, the whole side, three vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  GraphicsRow @ Table[
    With[{p = First @ Keys @ Select[xy, # - xy[c] == offset &]},
      InfraSubstrateHighlight[g, {InfraBall[c, 2], InfraRegionNearest[InfraBall[c, 2], p], p},
        PlotLabel -> InfraMeasurement[g, InfraRegionNearest[InfraBall[c, 2], p], "Cardinality"]]],
    {offset, {{4, 0}, {3, 2}}}]]
```

## Scope

Every vertex of a shell is nearest to its centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraMeasurement[g, InfraRegionNearest[InfraShell[c, 3], c], "CountingMeasure"] == InfraMeasurement[g, InfraShell[c, 3], "CountingMeasure"]]
```

The vertices of a segment nearest to a vertex off it. Four of them tie:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  {p = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 4]},
  InfraSubstrateHighlight[g, {seg, InfraRegionNearest[seg, p], p}, PlotLabel -> InfraMeasurement[g, InfraRegionNearest[seg, p], "Cardinality"],
    ImageSize -> Medium]]
```

[RandomInfraRegionNearest]() draws one nearest vertex:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]}, {p = First @ Keys @ Select[xy, # - xy[c] == {3, 2} &]},
  {RandomInfraRegionNearest[g, InfraRegionNearest[InfraBall[c, 2], p], RandomSeeding -> 1],
   RandomInfraRegionNearest[g, InfraRegionNearest[InfraBall[c, 2], p], All]}]
```

## Properties and Relations

A vertex of the region is its own nearest vertex:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraBall[c, 2], RandomSeeding -> 1]},
  Keys @ InfraMeasurement[g, InfraRegionNearest[InfraBall[c, 2], p], "VertexDensity"] == {p}]
```

The nearest vertices lie at the distance [InfraDistance]() gives:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
  {nearest = Keys @ InfraMeasurement[g, InfraRegionNearest[InfraBall[c, 2], p], "VertexDensity"]},
  Union[GraphDistance[g, p, #] & /@ nearest] == {InfraDistance[g, InfraBall[c, 2], p]}]
```
