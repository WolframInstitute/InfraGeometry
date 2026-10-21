---
Template: Symbol
Name: InfraBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBoundary
Keywords: [boundary, inner vertex boundary, vertex boundary, ball topology, rim]
SeeAlso: [InfraInterior, GraphBoundary, GraphInterior, GraphExteriorBoundary, TopologicalBoundary, BallTopology, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraBoundary]()[*g*, *s*]</code> gives the boundary of the vertex set *s* in *g*: the vertices of *s* with a neighbour outside *s*.

## Details & Options

The boundary is the inner vertex boundary *∂S = {v ∈ S : some neighbour of v is not in S}*. The rest of *S* is the [InfraInterior](), and *S* is the disjoint union of the two.

The set *s* can be a vertex list, a density, a region such as [InfraBall]() or [InfraSegment](), or a graph. Only its vertices count.

On the square grid, away from the rim, the boundary of the ball *Bᵣ(c)* is the circle *Sᵣ(c)*, with *4r* vertices. In general the boundary of a ball lies in its circle, and a vertex of the circle with no neighbour farther out is not on it. A curve is all boundary.

The rim of *g* is not a boundary: the whole graph has an empty boundary. The rim itself is [GraphExteriorBoundary]().

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Combinatorial"` | `"Combinatorial"`: the inner vertex boundary; `"Alexandrov"` or `{"Alexandrov", "Radius" -> r}`: the [TopologicalBoundary]() in <code>[BallTopology]()[*g*, *r*]</code>, with *r* = 1 by default |

The `"Alexandrov"` boundary is two-sided: it can hold vertices outside *s*.

The result is a sorted vertex list.

## Basic Examples

The boundary of the ball of radius 3, drawn over the ball, on the square grid and on the square mesh. On the grid it is the circle of 12 vertices:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
    InfraSubstrateHighlight[g, {ball, InfraBoundary[g, ball]}, PlotLabel -> Length @ InfraBoundary[g, ball]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The whole graph has no boundary. Its rim, drawn, is not a boundary:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {GraphExteriorBoundary[g]}, PlotLabel -> InfraBoundary[g, VertexList[g]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The support of a segment on the grid is a rectangle. Its boundary is the frame, 10 of its 12 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {seg = InfraSegment[a, RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]]},
  InfraSubstrateHighlight[g, {seg, InfraBoundary[g, seg]}, PlotLabel -> Length @ InfraBoundary[g, seg],
    ImageSize -> Medium]]
```

A curve is all boundary. A shortest path, as a vertex list:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {path = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraBoundary[g, path] === Sort[path]]
```

## Options

### Method

Away from the rim a ball has no boundary in the ball topology. The ball of radius 5 on the grid, combinatorially and in the topology of radius 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {ball = InfraBall[First @ GraphCenter[g], 5]},
  {Length @ InfraBoundary[g, ball], InfraBoundary[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```

## Properties and Relations

The boundary and the interior split the set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
  {bd = InfraBoundary[g, ball], int = InfraInterior[g, ball]},
  {Intersection[bd, int], Union[bd, int] === ball}]
```

On the grid the boundary of the ball of radius *r* has *4r* vertices while the ball stays off the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[Length @ InfraBoundary[g, InfraBall[c, r]], {r, 1, 7}]]
```

## Possible Issues

The boundary of a ball can be smaller than its circle. On the mesh two vertices at distance 6 from the centre have no neighbour at distance 7:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {circle = Keys @ InfraMeasurement[g, InfraShell[c, 6], "VertexDensity"]}, {bd = InfraBoundary[g, InfraBall[c, 6]]},
  InfraSubstrateHighlight[g, {InfraBall[c, 6], Complement[circle, bd]},
    PlotLabel -> {Length[circle], Length[bd]}, ImageSize -> Medium]]
```

A walk is not a set of vertices here. Give its vertex list instead of <code>[InfraWalk]()[*path*]</code>.
