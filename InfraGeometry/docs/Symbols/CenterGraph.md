---
Template: Symbol
Name: CenterGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CenterGraph
Keywords: [centre, center, ball, interior, rim, cut, substrate preparation]
SeeAlso: [InfraSubstrate, RandomInfraPoint, InfraSubstrateHighlight, GraphCenter, NeighborhoodGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[CenterGraph]()[*g*, *k*]</code> gives the subgraph of *g* induced on the ball of radius *k* about its centre.

<code>[CenterGraph]()[*g*, −*k*]</code> gives the ball of radius *ρ − k*, where *ρ* is the radius of *g*.

<code>[CenterGraph]()[*g*, [Scaled]()[*q*]]</code> gives the ball of radius *⌊q ρ⌋*.

<code>[CenterGraph]()[*g*]</code> gives the centre of *g*.

## Details & Options

The result is the induced subgraph on *Bₖ(C) = {v : d(v, C) ≤ k}*, where *C* = [GraphCenter]()[*g*] is the set of vertices of least eccentricity and *ρ* = [GraphRadius]()[*g*] is that eccentricity. It is [NeighborhoodGraph]()[*g*, *C*, *k*].

A negative radius never goes below 0, and in [Scaled]()[*q*] the fraction *q* is clipped to [0, 1]. A radius of *ρ* or more gives the whole graph, 0 gives the centre.

[Scaled]()[*q*] takes the same fraction of the radius on every size of a substrate.

The cut keeps the vertex names and coordinates of *g*, so a construction made on it draws on *g*.

A disconnected graph is returned whole.

## Basic Examples

The ball of radius 3 about the centre of the square grid and of the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, 3]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Half the radius, on the square mesh at two sizes:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareMeshGraph", size, "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g, Scaled[1/2]]}]],
  {size, {"Small", "Medium"}}]
```

## Scope

The centre alone. On the grid it is four vertices, on the mesh one:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, InfraSubstrateHighlight[g, {VertexList @ CenterGraph[g]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A negative radius counts from the rim. Three points drawn from the mesh two hops short of the radius stay off the rim:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {core = CenterGraph[g, -2]},
  InfraSubstrateHighlight[g, {VertexList @ core, RandomInfraPoint[core, 3, RandomSeeding -> 1]}, ImageSize -> Medium]]
```

## Properties and Relations

The number of vertices against the radius *k*, from −*ρ* to *ρ*, on the mesh. The negative half repeats the positive one:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {r = GraphRadius[g]},
  ListStepPlot[Table[{k, VertexCount @ CenterGraph[g, k]}, {k, -r, r}], AxesLabel -> {"k", "vertices"}]]
```

## Possible Issues

The radius *ρ* is the eccentricity of one centre vertex, not the distance from the whole centre. On the grid the four centre vertices reach every vertex in 7 hops, two fewer than *ρ* = 9, so −1 and −2 give the whole grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Table[VertexCount @ CenterGraph[g, k], {k, -4, 0}]]
```

On a vertex-transitive graph every vertex is a centre, so every cut is the whole graph:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small"]}, {VertexCount[g], VertexCount @ CenterGraph[g, 1]}]
```

A bare fraction is not a radius, and the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Head @ CenterGraph[g, 0.5]]
```
