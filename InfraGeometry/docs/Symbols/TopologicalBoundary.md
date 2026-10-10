---
Template: Symbol
Name: TopologicalBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalBoundary
Keywords: [boundary, frontier, ball topology, finite topology, closure, interior]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalInterior, TopologicalNeighborhood, InfraBoundary]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalBoundary]()[*topo*, *s*]</code> gives the boundary of the vertex list *s* in the topology of the digraph *topo*: its closure minus its interior.

## Details & Options

Definition: *bd(s) = cl(s) ∖ int(s) = cl(s) ∩ cl(V ∖ s)*, where *V* is the vertex set of *topo*, *cl* is [TopologicalClosure]() and *int* is [TopologicalInterior]().

The boundary is two-sided: it may hold vertices outside *s*, and *s* and its complement have the same boundary. It is empty exactly when *s* is open and closed.

In the ball topology of a patch of a tiling, a vertex far from the rim is open and closed, so no boundary reaches it.

<code>[InfraBoundary]()[*g*, *s*, Method -> {"Alexandrov", "Radius" -> *r*}]</code> is this boundary in the ball topology of radius *r*. The default method of [InfraBoundary]() is the combinatorial boundary: the vertices of *s* with a neighbour outside *s*.

The result is a sorted vertex list.

## Basic Examples

The ring outside a ball about the centre, in the ball topology of radius 2, on the discretized plane, the square tiling and the hexagonal tiling. The ring is green; its boundary, blue, lies outside it.

```wl
SeedRandom[1];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {ring = Complement[VertexList[g], RandomInfraBall[ g, InfraBall[c, VertexEccentricity[g, c] - 2] ]]},
    InfraSubstrateHighlight[g, {ring -> StandardGreen, TopologicalBoundary[BallTopology[g, 2], ring] -> StandardBlue}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The balls of radius 4, 5 and 6 about the centre of the square tiling, at radius 2. The boundary is empty while the ball stays more than two steps from the rim. Closer, it is the set of vertices of the ball whose ball contains the ball of a vertex outside.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  GraphicsRow @ Table[
    With[{ball = RandomInfraBall[ g, InfraBall[First @ GraphCenter[g], radius] ]},
      InfraSubstrateHighlight[g, {Complement[ball, TopologicalBoundary[topo, ball]] -> StandardGreen, TopologicalBoundary[topo, ball] -> StandardBlue}]],
    {radius, 4, 6}]]
```

## Properties and Relations

A set and its complement have one boundary, the intersection of their closures. [InfraBoundary]() with the method `"Alexandrov"` gives the same set.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  {ball = RandomInfraBall[ g, InfraBall[First @ GraphCenter[g], 6] ]},
  {ring = Complement[VertexList[g], ball]},
  {boundary = TopologicalBoundary[topo, ball]},
  {InfraSubstrateHighlight[g, {boundary -> StandardBlue}],
   boundary == TopologicalBoundary[topo, ring],
   boundary == Intersection[TopologicalClosure[topo, ball], TopologicalClosure[topo, ring]],
   boundary == InfraBoundary[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```

The combinatorial boundary of a ball is its outer shell at every radius. The ball of radius 4 about the centre of the square tiling has that shell, drawn blue on the right, and no topological boundary at radius 2.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {ball = RandomInfraBall[ g, InfraBall[First @ GraphCenter[g], 4] ]},
  {TopologicalBoundary[BallTopology[g, 2], ball],
   InfraSubstrateHighlight[g, {Complement[ball, InfraBoundary[g, ball]] -> StandardGreen, InfraBoundary[g, ball] -> StandardBlue}]}]
```
