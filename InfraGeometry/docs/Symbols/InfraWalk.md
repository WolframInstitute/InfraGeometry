---
Template: Symbol
Name: InfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraWalk
Keywords: [walk, path, closed walk, curve, orientation, scene]
SeeAlso: [InfraWalkQ, RandomInfraWalk, WalkSingularities, InfraSubstrateHighlight, InfraScene, InfraSegment]
---

## Usage

<code>[InfraWalk]()[{*v1*, …, *vk*}]</code> is the walk *v1*, …, *vk*, drawn by [InfraSubstrateHighlight]() as an oriented curve.

<code>[InfraWalk]()[*p1*, …, *pk*]</code> is, in an [InfraScene](), the walk through the points *p1*, …, *pk* in this order.

## Details & Options

A walk is a vertex sequence with each vertex adjacent to the next; vertices and edges may repeat. It is closed when it ends where it starts. [InfraWalkQ]() tests the condition.

[InfraSubstrateHighlight]() draws <code>[InfraWalk]()[{*v1*, …, *vk*}]</code> along its edges, an edge run more than once the stronger. `"Arrowheads" -> True` marks its direction.

In a scene, <code>[InfraWalk]()[*p1*, …, *pk*]</code> is literal: its one realisation is the vertex list of the points, when consecutive points are adjacent, and there is none otherwise. Unlike [InfraSegment](), it does not join the points by shortest paths.

The `"VertexDensity"` of a walk in [InfraMeasurement]() is its number of visits to each vertex, in both spellings; a vertex sequence that is not a walk of the graph has none.

A walk returned by [RandomInfraWalk]() or [RandomInfraGeodesic]() is a [Graph](): a directed path on the position pairs {*i*, *v*}, a closed walk a directed cycle on them. `Last /@ VertexList[w]` gives its vertex sequence.

## Basic Examples

A closed walk round a square of side 2, with its direction:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {InfraWalk[{45, 46, 47, 57, 67, 66, 65, 55, 45}], 45},
    "Arrowheads" -> True, ImageSize -> Medium]]
```

In a scene: a point at distance 1 from the centre, a point at distance 2, and the walk through the three. Only adjacent points give a walk, so there are 12 instances on the grid, and each first step is shared by three of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {scene = InfraScene[{pA, pB, pC, w}, {pA == InfraPoint[c], pB == InfraPoint[InfraShell[pA, 1]],
     pC == InfraPoint[InfraShell[pA, 2]], w == InfraWalk[pA, pB, pC]}]},
  {walks = InfraSceneInstance[#, w] & /@ RandomInfraSceneInstance[scene, g, All]},
  InfraSubstrateHighlight[g, {InfraWalk /@ walks, c}, PlotLabel -> Length[walks], ImageSize -> Medium]]
```

## Scope

A self-avoiding walk of 6 edges on the mesh, returned as a walk graph, and its vertex sequence:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {walk = RandomInfraWalk[g, c, {6}, Properties -> {"Simple"}, RandomSeeding -> 1]},
  {seq = Last /@ VertexList[walk]},
  InfraSubstrateHighlight[g, {InfraWalk[seq], c}, PlotLabel -> seq, ImageSize -> Medium]]
```

## Possible Issues

In a scene the points must be adjacent. Two vertices at distance 2 have no walk between them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {scene = InfraScene[{pA, pB, w}, {pA == InfraPoint[45], pB == InfraPoint[47], w == InfraWalk[pA, pB]}]},
  RandomInfraSceneInstance[scene, g, All]]
```
