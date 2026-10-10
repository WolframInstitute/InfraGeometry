---
Template: Symbol
Name: GraphBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphBoundary
Keywords: [vertex boundary, inner boundary, interior, neighbourhood, closure space, shell]
SeeAlso: [GraphInterior, InfraBoundary, GraphExteriorBoundary, TopologicalBoundary]
RelatedGuides: [Experimental]
---

## Usage

<code>[GraphBoundary]()[*g*, *s*]</code> gives the vertices of the vertex list *s* that have a neighbour in *g* outside *s*.

<code>[GraphBoundary]()[*g*, *h*]</code> gives the vertices of the subgraph *h* that have an edge in *g* which is not an edge of *h*.

## Details & Options

Definition: the inner vertex boundary of a set *S* of vertices of *g* is ∂*S* = {*v* ∈ *S* : some neighbour of *v* lies outside *S*}. It lies in *S*, and *S* ∖ ∂*S* is the [GraphInterior]().

A subgraph *h* is read with its own edges: a vertex of *h* is a boundary vertex when some edge of *g* at it is not an edge of *h*. For an induced subgraph the two readings agree; a sparser subgraph has more boundary, and in a tiling every vertex of a path is a boundary vertex.

The outer boundary of *S*, the vertices outside *S* next to it, is the boundary of the complement. [InfraBoundary]() with its default method is the boundary of the vertex set, sorted; it reads a subgraph by its vertices. The boundary is one-sided, unlike the [TopologicalBoundary]() of the ball topology, which lies on both sides of a set.

## Basic Examples

The ball of radius 3 about the centre of the square, hexagonal and triangular tilings, its interior green and its boundary blue. The boundary of a ball is its outermost shell.

```wl
SeedRandom[1];
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {region = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 3]]},
       {InfraSubstrateHighlight[g, {GraphInterior[g, region] -> StandardGreen, GraphBoundary[g, region] -> StandardBlue}],
        Length[GraphBoundary[g, region]]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

A set with a hole has a boundary on both of its sides: the ball of radius 4 less the ball of radius 1.

```wl
SeedRandom[1];
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {region = Complement[RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]], RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 1]]]},
       {InfraSubstrateHighlight[g, {GraphInterior[g, region] -> StandardGreen, GraphBoundary[g, region] -> StandardBlue}],
        Length[GraphBoundary[g, region]]}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

## Scope

A subgraph counts only its own edges. The spray of radius 2 about the centre of the triangular tiling has the vertices of the ball of radius 2 but no edge within a shell, so every vertex but the centre is a boundary vertex. Read as a vertex set, the ball has 12.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {spray = SprayGraph[g, First @ GraphCenter[g], "AxisLength" -> 2]},
  {GraphicsRow[InfraSubstrateHighlight[g, {AssociationThread[GraphInterior[g, #], 1] -> StandardGreen, AssociationThread[GraphBoundary[g, #], 1] -> StandardBlue}] & /@ {spray, VertexList[spray]}],
   Length[GraphBoundary[g, #]] & /@ {spray, VertexList[spray]}}]
```

## Properties and Relations

The outer boundary of a set is the boundary of its complement. For the ball of radius 3 it is the shell of radius 4, red, outside the inner boundary, blue.

```wl
SeedRandom[1];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {region = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 3]]},
    InfraSubstrateHighlight[g, {GraphBoundary[g, region] -> StandardBlue, GraphBoundary[g, Complement[VertexList[g], region]] -> StandardRed}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

[InfraBoundary]() with its default method gives the same vertices, sorted: here for the ball of radius 4 of the triangular tiling, its interior green.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {region = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
  {InfraSubstrateHighlight[g, {GraphInterior[g, region] -> StandardGreen, InfraBoundary[g, region] -> StandardBlue}],
   InfraBoundary[g, region] === Sort[GraphBoundary[g, region]]}]
```

## Possible Issues

The whole vertex set has no boundary, since no vertex has a neighbour outside the graph. The rim of a substrate, blue, is [GraphExteriorBoundary]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {InfraSubstrateHighlight[g, {GraphExteriorBoundary[g] -> StandardBlue}], GraphBoundary[g, VertexList[g]]}]
```
