---
Template: Symbol
Name: InfraUnion
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraUnion
Keywords: [union, region, vertex set, density, inclusion-exclusion]
SeeAlso: [InfraIntersection, InfraMeasurement, InfraBall, RandomInfraPoint, InfraScene]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraUnion]()[*obj1*, *obj2*, …]</code> is the union of the regions *obj1*, *obj2*, ….

<code>[InfraUnion]()[*g*, *s1*, *s2*, …]</code> gives the sorted union of the vertex sets *s1*, *s2*, … of *g*.

## Details & Options

The union of the regions *A* and *B* is *A ∪ B = {v : v ∈ A or v ∈ B}*.

[InfraUnion]() of objects such as [InfraBall]() or [InfraSegment]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph, [InfraSubstrateHighlight]() draws it and [RandomInfraPoint]() draws points from it.

[InfraMeasurement]() reads:

| Property | Value |
|---|---|
| `"VertexDensity"` | the sum of the vertex densities of the parts |
| `"EdgeDensity"` | the sum of the edge densities of the parts |
| `"Subgraph"` | the subgraph induced on the union |
| `"CountingMeasure"` | the number of vertices of the union |
| `"RiemannianMeasure"` | the number of vertices of the union all of whose neighbours lie in it |

The counting measure obeys inclusion–exclusion, *|A ∪ B| = |A| + |B| − |A ∩ B|*. The density of a union of balls is 2 on their intersection.

In <code>[InfraUnion]()[*g*, *s1*, *s2*, …]</code> each *si* is a vertex list, a density `<|v -> m, …|>` or a [Graph]() whose vertices are taken.

In an [InfraScene](), <code>[InfraPoint]()[[InfraUnion]()[*a*, *b*]]</code> is a point of either object.

## Basic Examples

The union of two balls of radius 3 whose centres are 4 apart, on the square grid and on the square mesh. The vertices the balls share are drawn larger:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraUnion[InfraBall[a, 3], InfraBall[b, 3]], a, b}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Inclusion–exclusion on the grid: the union has 41 = 25 + 24 − 8 vertices. The second ball meets the rim and has 24:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {ballA = InfraBall[a, 3], ballB = InfraBall[b, 3]},
  InfraMeasurement[g, #, "CountingMeasure"] & /@
    {InfraUnion[ballA, ballB], ballA, ballB, InfraIntersection[ballA, ballB]}]
```

The union of vertex lists:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, InfraUnion[g, {2, 3, 4}, {4, 5}, <|12 -> 1|>]]
```

## Scope

The density of the union is the sum of the densities. It is 2 on the 8 vertices the balls share, drawn larger:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  {density = InfraMeasurement[g, InfraUnion[InfraBall[a, 3], InfraBall[b, 3]], "VertexDensity"]},
  InfraSubstrateHighlight[g, {density}, PlotLabel -> Counts[Values[density]], ImageSize -> Medium]]
```

In a scene, a point of the union of two unit balls takes every vertex of either ball:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 2], RandomSeeding -> 1]},
  {scene = InfraScene[{ballA, ballB, p},
    {ballA == InfraBall[a, 1], ballB == InfraBall[b, 1], p == InfraPoint[InfraUnion[ballA, ballB]]}]},
  Sort[InfraSceneInstance[#, p] & /@ RandomInfraSceneInstance[scene, g, All]]]
```

## Properties and Relations

The points of a union are the vertices of its parts:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  Sort @ RandomInfraPoint[g, InfraUnion[InfraShell[a, 2], InfraShell[b, 2]], All] ===
    InfraUnion[g, RandomInfraPoint[g, InfraShell[a, 2], All], RandomInfraPoint[g, InfraShell[b, 2], All]]]
```
