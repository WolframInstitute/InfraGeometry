---
Template: Symbol
Name: DisplacementBijectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementBijectionQ
Keywords: [displacement, bijection, permutation, inverse, vertex map]
SeeAlso: [DisplacementSingleValuedQ, DisplacementIsomorphismQ, DisplacementInverse, ContinuousDisplacementQ, FindKillingDisplacement]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementBijectionQ]()[*d*]</code> gives [True]() when the displacement *d* is single-valued and permutes the vertices, and [False]() otherwise.

## Details & Options

*D* is a bijection when it is single-valued ([DisplacementSingleValuedQ]()) and its values, taken together, are its keys, each once.

A bijection has an inverse map, [DisplacementInverse](), and both composites with it are the identity.

The test needs no graph: a bijection need not respect the edges. [DisplacementIsomorphismQ]() asks for that too, and a 1-continuous bijection is already an automorphism ([ContinuousDisplacementQ]()).

On a finite graph with a rim a translation is not a bijection: nothing arrives at one side.

## Basic Examples

The step right is not a bijection, on the square grid or on the square mesh:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {t = TranslationDisplacement[g, {s, 0}]},
    DisplacementPlot[g, t, PlotLabel -> DisplacementBijectionQ[t]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

Exchanging two vertices is a bijection. The centre of the grid and the vertex 89:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {89}, 89 -> {c}|>]},
  DisplacementPlot[g, swap, PlotLabel -> DisplacementBijectionQ[swap]]]
```

## Scope

The square torus has no rim, and its translation by one step is a bijection, drawn at a planar layout of the torus:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small"]}, {translation = FindKillingDisplacement[g]},
  DisplacementPlot[g, translation, PlotLabel -> DisplacementBijectionQ[translation]]]
```

## Properties and Relations

A bijection composed with its inverse is the identity, in both orders:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {89}, 89 -> {c}|>]},
  {identity = AssociationMap[List, VertexList[g]]},
  DisplacementCompose[swap, DisplacementInverse[swap]] === identity &&
    DisplacementCompose[DisplacementInverse[swap], swap] === identity]
```

A bijection need not be a symmetry. The exchange of the centre with the vertex 89 moves 8 steps and is not an automorphism:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {89}, 89 -> {c}|>]},
  {DisplacementBijectionQ[swap], DisplacementIsomorphismQ[g, swap], DisplacementMagnitude[g, swap]}]
```
