---
Template: Symbol
Name: TopologicalInterior
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalInterior
Keywords: [interior, open set, ball topology, finite topology, specialization preorder]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalBoundary, TopologicalNeighborhood, InfraInterior]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalInterior]()[*topo*, *s*]</code> gives the interior of the vertex list *s* in the topology of the digraph *topo*: the vertices of *s* from which no directed path leaves *s*.

## Details & Options

Definition: *int(s) = V ∖ cl(V ∖ s)*, where *V* is the vertex set of *topo* and *cl* is [TopologicalClosure](). It is the largest open set inside *s*.

For <code>[BallTopology]()[*g*, *r*]</code> a vertex *p* of *s* is interior when every vertex whose ball lies inside the ball at *p* belongs to *s*.

The interior lies in *s*, the interior of the interior is the interior, and the interior of an intersection is the intersection of the interiors. A set is open when it equals its interior.

<code>[InfraInterior]()[*g*, *s*, Method -> {"Alexandrov", "Radius" -> *r*}]</code> is this interior in the ball topology of radius *r*. The default method of [InfraInterior]() is the combinatorial interior: the vertices of *s* all of whose neighbours lie in *s*.

The result is a sorted vertex list.

## Basic Examples

The interior of a ball about the centre that reaches within two steps of the rim, in the ball topology of radius 2, on the discretized plane, the square tiling and the hexagonal tiling. The interior is green. The rest of the ball is blue: the vertices whose ball contains the ball of a vertex outside.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {region = RandomInfraRepresentative[g, InfraBall[c, VertexEccentricity[g, c] - 2]]},
    {interior = TopologicalInterior[BallTopology[g, 2], region]},
    InfraSubstrateHighlight[g, {interior -> StandardGreen, Complement[region, interior] -> StandardBlue}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Away from the rim a ball is open. The ball of radius 4 about the centre of the square tiling is its own interior at radius 2, while its combinatorial interior, drawn beside it, drops the outer shell.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {ball = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
  GraphicsRow @ {
    InfraSubstrateHighlight[g, {TopologicalInterior[BallTopology[g, 2], ball] -> StandardGreen}],
    InfraSubstrateHighlight[g, {InfraInterior[g, ball] -> StandardGreen}]}]
```

## Properties and Relations

The interior is open: it is its own interior and its own smallest open neighbourhood. [InfraInterior]() with the method `"Alexandrov"` gives the same set.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  {ball = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
  {interior = TopologicalInterior[topo, ball]},
  {InfraSubstrateHighlight[g, {interior -> StandardGreen, Complement[ball, interior] -> StandardBlue}],
   TopologicalInterior[topo, interior] == interior,
   TopologicalNeighborhood[topo, interior] == interior,
   interior == InfraInterior[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```
