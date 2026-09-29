---
Template: Symbol
Name: InfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPoint
Keywords: [point, vertex, scene token, density]
SeeAlso: [FindInfraPoint, RandomInfraPoint, InfraCenter, InfraDensity, InfraScene]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraPoint]()[*v*]</code> inside an [InfraScene]() is the point token at vertex *v*.

<code>[InfraPoint]()[]</code> inside an [InfraScene]() names a point to be solved for, drawn from every vertex.

<code>[InfraPoint]()["Center"]</code> and <code>[InfraPoint]()["Periphery"]</code> draw it from the centre or the periphery of the graph.

<code>[InfraPoint]()[*origin*, *d*]</code> draws it from the vertices at distance *d* from *origin*.

<code>[InfraPoint]()[*n*, "Distance" -> *spec*]</code> is an *n*-tuple of points under a mutual-distance condition, as in [FindInfraPoint]().

## Details & Options

Definition: an infra-point is one vertex of the substrate, carried by its label verbatim.

A point is a vertex. The head is a token of the scene language, [FindInfraPoint]() without the graph, and holds no value of its own. A construction on a graph rarely has one answer, but the multiplicity does not live in this head: a family of candidate points is a vertex `List`, and a measure on vertices is a density `<|v -> m|>`.

| you have | use |
|---|---|
| one vertex | *v* |
| several candidate points | `{a, b, …}` — a plain list |
| a measure on vertices | `<\|v -> m, …\|>`, see [InfraDensity]() |

The vertex label is carried verbatim, including a list label such as `{i, j}` on a grid or tessellation.

Invariants are functions of the graph and a vertex, not accessors: `BallVolumes[g, v, {rmin, rmax}]` gives the bare numbers for one vertex, and one row per vertex for a vertex list.

## Basic Examples

A point is a vertex, and several candidate points are a vertex list. The centre of a grid and three random points at distance 4 from it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {centre = InfraCenter[g]},
  {picks = FindInfraPoint[g, 3, "From" -> centre -> 4]},
  InfraHighlightGraph[g, {centre, picks}, ImageSize -> 250]]
```

A point finder returns vertices — one, or a list.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {FindInfraPoint[g, All, "From" -> "Center"], Length @ FindInfraPoint[g, 3]}]
```

A vertex answers invariants with bare numbers; a list of vertices answers with one row each.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {BallVolumes[g, c, {0, 3}], BallVolumes[g, {c, First @ GraphPeriphery[g]}, {0, 3}]}]
```

In a scene the token is solved on the graph. Here *a* is the centre of a 5 × 5 grid, *b* any of the 8 vertices at distance 3 from it, and *c* any of the 4 corners: 32 instances.

```wl
Module[{a, b, c},
  With[
    {scene = InfraScene[{a, b, c},
       {InfraGeometricStep[{a == InfraPoint["Center"]}, "a"],
        InfraGeometricStep[{b == InfraPoint[a, 3]}, "b"],
        InfraGeometricStep[{c == InfraPoint["Periphery"]}, "c"]}]},
    {instances = FindInfraScene[scene, GridGraph[{5, 5}]]},
    {Length[instances], InfraSceneInstance[First[instances], a], InfraSceneInstance[First[instances], b]}]]
```

## Properties and Relations

A list of vertices with repeats is a counting measure.

```wl
InfraDensity[GridGraph[{3, 3}], {4, 9, 4}]
```
