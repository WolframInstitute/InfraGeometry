---
Template: Symbol
Name: InfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPoint
Keywords: [point, vertex, scene token, density]
SeeAlso: [RandomInfraPoint, InfraDensity, InfraScene, InfraDistance]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraPoint]()[*v*]</code> inside an [InfraScene]() is the point token at vertex *v*.

<code>[InfraPoint]()[]</code> inside an [InfraScene]() names a point to be solved for, drawn from every vertex.

## Details & Options

Definition: an infra-point is one vertex of the substrate, carried by its label verbatim.

A point is a vertex. The head is a token of the scene language and holds no value of its own. A condition on a point, such as its distance to another point, is an assertion of the scene. A construction on a graph rarely has one answer, but the multiplicity does not live in this head: a family of candidate points is a vertex `List`, and a measure on vertices is a density `<|v -> m|>`.

| you have | use |
|---|---|
| one vertex | *v* |
| several candidate points | `{a, b, …}` — a plain list |
| a measure on vertices | `<\|v -> m, …\|>`, see [InfraDensity]() |

The vertex label is carried verbatim, including a list label such as `{i, j}` on a grid or tessellation.

Invariants are functions of the graph and a vertex, not accessors: `InfraMeasurement[g, InfraBall[v, r], "CountingMeasure"]` gives the bare number for one vertex, and the list of regions one number per vertex.

## Basic Examples

A point is a vertex, and several candidate points are a vertex list. The centre of a grid and three random points at distance 4 from it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {centre = First @ GraphCenter[g]},
  {picks = RandomInfraPoint[g, InfraShell[centre, 4], 3]},
  InfraSubstrateHighlight[g, {centre, picks}, ImageSize -> 250]]
```

A point finder returns vertices — one, or a list.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {RandomInfraPoint[g, GraphCenter[g], All], Length @ RandomInfraPoint[g, 3]}]
```

A vertex answers invariants with bare numbers; a list of regions answers with one number each.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {InfraMeasurement[g, InfraBall[c, 3], "CountingMeasure"], InfraMeasurement[g, {InfraBall[c, 3], InfraBall[First @ GraphPeriphery[g], 3]}, "CountingMeasure"]}]
```

In a scene the token is solved on the graph. Here *a* is the centre of a 5 × 5 grid, *b* any of the 8 vertices at distance 3 from it, and *c* any of the 4 vertices at distance 4 from it, the corners: 32 instances.

```wl
Module[{a, b, c},
  With[
    {scene = InfraScene[{a, b, c},
       {InfraStep[{a == InfraPoint[13]}, "a"],
        InfraStep[{b == InfraPoint[], InfraDistance[a, b] == 3}, "b"],
        InfraStep[{c == InfraPoint[], InfraDistance[a, c] == 4}, "c"]}]},
    {instances = RandomInfraInstance[scene, GridGraph[{5, 5}]]},
    {Length[instances], InfraSceneInstance[First[instances], a], InfraSceneInstance[First[instances], b]}]]
```

## Properties and Relations

A list of vertices with repeats is a counting measure.

```wl
InfraDensity[GridGraph[{3, 3}], {4, 9, 4}]
```
