---
Template: Symbol
Name: GraphInterior
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphInterior
Keywords: [vertex interior, inner boundary, erosion, neighbourhood, closure space, ball]
SeeAlso: [GraphBoundary, InfraInterior, TopologicalInterior, GraphExteriorBoundary]
RelatedGuides: [Experimental]
---

## Usage

<code>[GraphInterior]()[*g*, *s*]</code> gives the vertices of the vertex list *s* whose neighbours in *g* all lie in *s*.

<code>[GraphInterior]()[*g*, *h*]</code> gives the vertices of the subgraph *h* whose edges in *g* are all edges of *h*.

## Details & Options

Definition: the interior of a set *S* of vertices of *g* is int *S* = {*v* ∈ *S* : every neighbour of *v* lies in *S*}, the vertices whose closed ball of radius 1 lies in *S*. It is *S* less its [GraphBoundary]().

The interior of an intersection is the intersection of the interiors, and a smaller set has a smaller interior. The interior of the ball of radius *r* contains the ball of radius *r* − 1, and equals it where the graph goes on beyond the ball.

A subgraph *h* is read with its own edges: a vertex of *h* is interior when every edge of *g* at it is an edge of *h*. For an induced subgraph the two readings agree; a path has no interior.

[InfraInterior]() with its default method is the interior of the vertex set, sorted; it reads a subgraph by its vertices. It is the interior of a closure space, not of a topology: taking the interior again shrinks the set again, while the [TopologicalInterior]() of the ball topology stays put.

## Basic Examples

The ball of radius 4 about the centre of the square, hexagonal and triangular tilings, and its interior taken again and again: the balls of radius 3, 2, 1 and 0. Each is drawn by its boundary, in its own colour.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {interiors = NestList[GraphInterior[g, #] &, RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]], 4]},
       {InfraSubstrateHighlight[g, AssociationThread[GraphBoundary[g, #], 1] & /@ interiors], Length /@ interiors}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

The interior of a ring, green, is a thinner ring: the ball of radius 4 less the ball of radius 1, its boundary blue.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {region = Complement[RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]], RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 1]]]},
    InfraSubstrateHighlight[g, {GraphInterior[g, region] -> StandardGreen, GraphBoundary[g, region] -> StandardBlue}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

## Scope

A subgraph counts only its own edges. The spray of radius 2 about the centre of the triangular tiling has no edge within a shell, so its interior is the centre alone, green. Read as a vertex set, the ball of radius 2 has the seven vertices of the ball of radius 1 inside.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {spray = SprayGraph[g, First @ GraphCenter[g], "AxisLength" -> 2]},
  {GraphicsRow[InfraSubstrateHighlight[g, {AssociationThread[GraphInterior[g, #], 1] -> StandardGreen, AssociationThread[GraphBoundary[g, #], 1] -> StandardBlue}] & /@ {spray, VertexList[spray]}],
   Length[GraphInterior[g, #]] & /@ {spray, VertexList[spray]}}]
```

## Properties and Relations

The interior and the boundary split the set: they are disjoint, and together they are the set.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {region = RandomInfraRepresentative[g, InfraBall[(SeedRandom[1]; RandomInfraPoint[g, InfraShell[First @ GraphCenter[g], 3]]), 4]]},
  {InfraSubstrateHighlight[g, {GraphInterior[g, region] -> StandardGreen, GraphBoundary[g, region] -> StandardBlue}],
   Intersection[GraphInterior[g, region], GraphBoundary[g, region]], Sort[Join[GraphInterior[g, region], GraphBoundary[g, region]]] === Sort[region]}]
```

The whole vertex set is its own interior: the rim of a substrate is no boundary in this sense. It is [GraphExteriorBoundary](), blue.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {InfraSubstrateHighlight[g, {GraphExteriorBoundary[g] -> StandardBlue}], Sort[GraphInterior[g, VertexList[g]]] === Sort[VertexList[g]]}]
```

## Possible Issues

Where the graph ends, the interior of a ball is more than the smaller ball. The interior of the ball of radius 6 about a neighbour of the centre of the square tiling is the ball of radius 5, green, and the 11 vertices at distance 6 that lie on the rim, orange: they have no neighbour outside the ball. The boundary, blue, lies on the far side only.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {offCentre = First @ AdjacencyList[g, First @ GraphCenter[g]]},
  {region = RandomInfraRepresentative[g, InfraBall[offCentre, 6]]},
  {extra = Complement[GraphInterior[g, region], RandomInfraRepresentative[g, InfraBall[offCentre, 5]]]},
  {InfraSubstrateHighlight[g, {AssociationThread[RandomInfraRepresentative[g, InfraBall[offCentre, 5]], 1] -> StandardGreen, AssociationThread[extra, 1] -> StandardOrange, AssociationThread[GraphBoundary[g, region], 1] -> StandardBlue}],
   Length[extra]}]
```
