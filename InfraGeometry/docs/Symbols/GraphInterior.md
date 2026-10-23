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

The interior of a vertex set *S* is *int S = {v ∈ S : every neighbour of v lies in S}*, the vertices whose ball of radius 1 lies in *S*. It is *S* less its [GraphBoundary]().

The interior of an intersection is the intersection of the interiors. The interior of the ball of radius *r* contains the ball of radius *r* − 1, and is equal to it where the graph goes on beyond the ball.

Taking the interior again shrinks the set again: it is the interior of a closure space, not of a topology. The [TopologicalInterior]() of the ball topology does not move.

A subgraph *h* is read with its own edges. For an induced subgraph this is the interior of its vertex set; a sparser subgraph has a smaller interior.

[InfraInterior]() with its default method gives the interior of the vertex set, sorted.

## Basic Examples

The ball of radius 3 and its interior, taken again and again. The interiors are the balls of radius 2, 1 and 0:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {interiors = NestList[GraphInterior[g, #] &, Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"], 3]},
    InfraSubstrateHighlight[g, interiors, PlotLabel -> Length /@ interiors]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The interior of the ring of the vertices at distance 2 to 4 is the thinner ring at distance 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ring = Keys @ InfraMeasurement[g, InfraBall[c, {2, 4}], "VertexDensity"]},
    InfraSubstrateHighlight[g, {ring, GraphInterior[g, ring]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A subgraph counts only its own edges. The spray of radius 2 about the centre of the mesh lacks the edges inside a shell, so its interior is the centre alone. The ball of radius 2 has the 8 vertices of the ball of radius 1 inside:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {spray = SprayGraph[g, c, "AxisLength" -> 2]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {h, GraphInterior[g, h]}, PlotLabel -> Length @ GraphInterior[g, h]],
    {h, {spray, VertexList[spray]}}]]
```

## Properties and Relations

The interior and the boundary split the set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]},
  {DisjointQ[GraphInterior[g, ball], GraphBoundary[g, ball]],
   Sort @ Join[GraphInterior[g, ball], GraphBoundary[g, ball]] === Sort[ball]}]
```

[InfraInterior]() gives the same vertices, sorted:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]},
  InfraInterior[g, ball] === Sort @ GraphInterior[g, ball]]
```

## Possible Issues

Where the graph ends, the interior of a ball is more than the smaller ball. The ball of radius 4 about the centre of the grid reaches the rim in two vertices, drawn, which have no neighbour outside the ball. Its interior has 27 vertices, the ball of radius 3 has 25:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {interior = GraphInterior[g, Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]],
   smaller = Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]},
  InfraSubstrateHighlight[g, {smaller, Complement[interior, smaller]}, PlotLabel -> Length /@ {interior, smaller},
    ImageSize -> Medium]]
```

The whole vertex set is its own interior: the rim of the substrate is not a boundary.

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Sort @ GraphInterior[g, VertexList[g]] === Sort @ VertexList[g]]
```
