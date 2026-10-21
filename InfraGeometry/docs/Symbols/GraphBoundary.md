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

The inner boundary of a vertex set *S* is *∂S = {v ∈ S : some neighbour of v lies outside S}*. It lies in *S*, and *S* ∖ *∂S* is the [GraphInterior]().

A subgraph *h* is read with its own edges. For an induced subgraph this is the boundary of its vertex set; a sparser subgraph has more boundary.

The boundary of the ball of radius *r* is the shell of radius *r*. The outer boundary of *S*, the vertices outside *S* next to it, is the boundary of the complement.

The boundary is one-sided. The [TopologicalBoundary]() of the ball topology lies on both sides of a set. [InfraBoundary]() with its default method gives the boundary of the vertex set, sorted.

## Basic Examples

The ball of radius 3 about the centre, its boundary drawn over it. The boundary is the shell of radius 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]},
    {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
    InfraSubstrateHighlight[g, {ball, GraphBoundary[g, ball]},
      PlotLabel -> (Sort @ GraphBoundary[g, ball] === Sort[shell])]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A set with a hole has a boundary on both sides. The ring of the vertices at distance 2 to 4:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ring = Keys @ InfraMeasurement[g, InfraBall[c, {2, 4}], "VertexDensity"]},
    InfraSubstrateHighlight[g, {ring, GraphBoundary[g, ring]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A subgraph counts only its own edges. The spray of radius 2 about the centre of the mesh has the vertices of the ball of radius 2 but none of the edges inside a shell. It has 19 boundary vertices, the ball 12:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {spray = SprayGraph[g, c, "AxisLength" -> 2]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {h, GraphBoundary[g, h]}, PlotLabel -> Length @ GraphBoundary[g, h]],
    {h, {spray, VertexList[spray]}}]]
```

## Properties and Relations

The outer boundary of a set is the boundary of its complement. For the ball of radius 3 it is the shell of radius 4, drawn outside the inner boundary:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]},
    InfraSubstrateHighlight[g, {GraphBoundary[g, ball], GraphBoundary[g, Complement[VertexList[g], ball]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

[InfraBoundary]() gives the same vertices, sorted:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]},
  InfraBoundary[g, ball] === Sort @ GraphBoundary[g, ball]]
```

## Possible Issues

The whole vertex set has no boundary: no vertex has a neighbour outside the graph. The rim of the substrate is [GraphExteriorBoundary]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, {GraphExteriorBoundary[g]}, PlotLabel -> GraphBoundary[g, VertexList[g]],
    ImageSize -> Medium]]
```
