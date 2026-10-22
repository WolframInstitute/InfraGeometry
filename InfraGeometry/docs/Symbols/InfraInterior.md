---
Template: Symbol
Name: InfraInterior
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraInterior
Keywords: [interior, vertex interior, Riemannian measure, ball topology, open set]
SeeAlso: [InfraBoundary, GraphInterior, GraphBoundary, TopologicalInterior, BallTopology, InfraBall, InfraMeasurement]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraInterior]()[*g*, *s*]</code> gives the interior of the vertex set *s* in *g*: the vertices of *s* all of whose neighbours lie in *s*.

## Details & Options

The interior is *int S = {v ∈ S : every neighbour of v is in S}*, the set *S* minus its [InfraBoundary]().

The set *s* can be a vertex list, a density, a region such as [InfraBall]() or [InfraSegment](), a walk <code>[InfraWalk]()[*path*]</code>, a point token [InfraPoint](), or a graph. Only its vertices count.

The interior is what the `"RiemannianMeasure"` of [InfraMeasurement]() counts. On the square grid, away from the rim, the interior of the ball *Bᵣ(c)* is the ball *Bᵣ₋₁(c)*, with *2r² − 2r + 1* vertices. A curve has an empty interior. The whole graph is its own interior.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Combinatorial"` | `"Combinatorial"`: the vertices of *s* with all neighbours in *s*; `"Alexandrov"` or `{"Alexandrov", "Radius" -> r}`: the [TopologicalInterior]() in <code>[BallTopology]()[*g*, *r*]</code>, with *r* = 1 by default |

The result is a sorted vertex list.

## Basic Examples

The interior of the ball of radius 3, drawn over the ball, on the square grid and on the square mesh. On the grid it is the ball of radius 2, 13 vertices:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
    InfraSubstrateHighlight[g, {ball, InfraInterior[g, ball]}, PlotLabel -> Length @ InfraInterior[g, ball]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of interior vertices is the Riemannian measure:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[Length @ InfraInterior[g, InfraBall[c, r]] == InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"], {r, 0, 6}]]
```

## Scope

The support of a segment on the grid is a 3 × 4 rectangle. Its interior is the 1 × 2 rectangle inside:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  InfraSubstrateHighlight[g, {seg, InfraInterior[g, seg]}, PlotLabel -> Length @ InfraInterior[g, seg],
    ImageSize -> Medium]]
```

A curve has no interior. A shortest path, as a vertex list:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraInterior[g, RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], RandomSeeding -> 1]]]
```

## Options

### Method

Away from the rim a ball is open in the ball topology. The ball of radius 5 on the grid has 61 vertices; its combinatorial interior has 41, its interior in the topology of radius 2 all 61:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {ball = InfraBall[First @ GraphCenter[g], 5]},
  {InfraMeasurement[g, ball, "CountingMeasure"], Length @ InfraInterior[g, ball],
   Length @ InfraInterior[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```

## Properties and Relations

On the grid the interior of the ball of radius *r* has *2r² − 2r + 1* vertices while the ball stays off the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[{Length @ InfraInterior[g, InfraBall[c, r]], 2 r^2 - 2 r + 1}, {r, 1, 7}]]
```

The rim of the graph is not a boundary, so the whole graph is its own interior:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, InfraInterior[g, VertexList[g]] === Sort @ VertexList[g]]
```

A walk has the interior of its vertex set. A closed walk round a square of side 2 is a curve and has none; the square it bounds has its centre 56:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {InfraInterior[g, InfraWalk[{45, 46, 47, 57, 67, 66, 65, 55, 45}]], InfraInterior[g, {45, 46, 47, 55, 56, 57, 65, 66, 67}]}]
```
