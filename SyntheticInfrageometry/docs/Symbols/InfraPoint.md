---
Template: Symbol
Name: InfraPoint
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraPoint
Keywords: [point, vertex, scene token, density]
SeeAlso: [FindInfraPoint, RandomInfraPoint, InfraCenter, InfraDensity, InfraScene]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraPoint]()[*v*]</code> inside an [InfraScene]() is the point token at vertex *v*.

<code>[InfraPoint]()[]</code> and <code>[InfraPoint]()["Center"]</code> inside an [InfraScene]() name a point to be solved for.

## Details & Options

Definition: an infra-point is one vertex of the substrate, carried by its label verbatim.

A point is a bare vertex, and the head is a scene-language token only, never a wrapper around a value. A construction on a graph rarely has one answer, but the multiplicity does not live in this head: a family of candidate points is a vertex `List`, and a measure on vertices is a density `<|v -> m|>`.

| you have | use |
|---|---|
| one vertex | *v* |
| several candidate points | `{a, b, …}` — a plain list |
| a measure on vertices | `<\|v -> m, …\|>`, see [InfraDensity]() |

The vertex label is carried verbatim, including a list label such as `{i, j}` on a grid or tessellation.

Invariants are functions of the graph and a vertex, not accessors: `BallVolumes[g, v, {rmin, rmax}]` gives the bare numbers for one vertex, and one row per vertex for a vertex list.

## Basic Examples

A point finder returns vertices — one, or a list.

```wl
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

## Properties and Relations

A list of vertices with repeats is a counting measure.

```wl
InfraDensity[GridGraph[{3, 3}], {4, 9, 4}]
```
