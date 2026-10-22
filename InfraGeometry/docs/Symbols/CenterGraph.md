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

<code>[CenterGraph]()[*g*, −*k*]</code> gives the ball of radius *e − k*, where *e* is the largest distance from the centre; it drops the *k* outermost layers.

<code>[CenterGraph]()[*g*, [Scaled]()[*q*]]</code> gives the ball of radius *⌊q e⌋*.

<code>[CenterGraph]()[*g*]</code> gives the centre of *g*.

## Details & Options

The result is the induced subgraph on *Bₖ(C) = {v : d(v, C) ≤ k}*, where *C* = [GraphCenter]()[*g*] is the set of vertices of least eccentricity. It is [NeighborhoodGraph]()[*g*, *C*, *k*]. The negative and the scaled radii count from *e = maxᵥ d(v, C)*, the eccentricity of the centre set, so *B_e(C)* is the whole graph.

A negative radius never goes below 0, and in [Scaled]()[*q*] the fraction *q* is clipped to [0, 1]. A radius of *e* or more gives the whole graph, 0 gives the centre. When the centre is one vertex, *e* is the radius [GraphRadius]()[*g*]; a larger centre reaches every vertex sooner.

[Scaled]()[*q*] takes the same fraction of *e* on every size of a substrate.

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

On the grid the centre is four vertices. They reach every vertex in 7 hops, two fewer than the radius 9, and −1 drops the 8 vertices at distance 7:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {core = CenterGraph[g, -1]},
  InfraSubstrateHighlight[g, {VertexList @ core}, PlotLabel -> VertexCount[g] - VertexCount[core], ImageSize -> Medium]]
```

## Properties and Relations

The number of vertices against the radius *k*, from −*e* to *e*, on the mesh. The negative half repeats the positive one:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {r = GraphRadius[g]},
  ListStepPlot[Table[{k, VertexCount @ CenterGraph[g, k]}, {k, -r, r}], AxesLabel -> {"k", "vertices"}]]
```

## Possible Issues

On a vertex-transitive graph every vertex is a centre, so every cut is the whole graph:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small"]}, {VertexCount[g], VertexCount @ CenterGraph[g, 1]}]
```

A bare fraction is not a radius, and the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Head @ CenterGraph[g, 0.5]]
```
