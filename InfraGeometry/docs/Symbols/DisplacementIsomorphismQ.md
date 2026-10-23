---
Template: Symbol
Name: DisplacementIsomorphismQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementIsomorphismQ
Keywords: [displacement, automorphism, isometry, Killing field, symmetry]
SeeAlso: [DisplacementBijectionQ, ContinuousDisplacementQ, FindKillingDisplacement, KillingDisplacementMagnitude, DisplacementCommutator]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementIsomorphismQ]()[*g*, *d*]</code> gives [True]() when the displacement *d* is an automorphism of *g*, and [False]() otherwise.

## Details & Options

*D* is an automorphism when it is a bijection ([DisplacementBijectionQ]()) and the images of the ends of every edge of *g* are joined by an edge.

An automorphism is an isometry of the graph metric, *d(D(u), D(v)) = d(u, v)*: the discrete counterpart of the flow of a Killing field.

A bijection is an automorphism exactly when it is 1-continuous ([ContinuousDisplacementQ]()). It then increases no distance and permutes the pairs of vertices, so it keeps every distance.

The automorphisms form a group: composites, inverses and commutators of automorphisms are automorphisms. [FindKillingDisplacement]() gives those of least magnitude.

## Basic Examples

The least symmetry of the square grid exchanges two pendant vertices at a corner, and it is an automorphism. The step right of the grid is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[DisplacementPlot[g, d, PlotLabel -> DisplacementIsomorphismQ[g, d]],
    {d, {FindKillingDisplacement[g], TranslationDisplacement[g, {1, 0}]}}]]
```

Exchanging two neighbours of the grid is a bijection of magnitude 1, but not an automorphism:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {c + 1}, c + 1 -> {c}|>]},
  DisplacementPlot[g, swap,
    PlotLabel -> {DisplacementBijectionQ[swap], DisplacementMagnitude[g, swap], DisplacementIsomorphismQ[g, swap]}]]
```

## Scope

The translation of the square torus by one step is an automorphism. The torus has no rim:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small"]}, DisplacementIsomorphismQ[g, FindKillingDisplacement[g]]]
```

## Properties and Relations

The magnitudes of the 128 automorphisms of the grid, with their counts. Besides the identity and the 15 exchanges of pendant vertices at the corners, every symmetry moves some vertex 9 or 16 steps:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {elements = GroupElements[GraphAutomorphismGroup[g]]},
  {automorphisms = AssociationThread[VertexList[g], List /@ Permute[VertexList[g], #]] & /@ elements},
  {AllTrue[automorphisms, DisplacementIsomorphismQ[g, #] &],
   KeySort @ Counts[DisplacementMagnitude[g, #] & /@ automorphisms]}]
```

An automorphism is 1-continuous; the exchange of two neighbours is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {c + 1}, c + 1 -> {c}|>]},
  {ContinuousDisplacementQ[g, FindKillingDisplacement[g]], ContinuousDisplacementQ[g, swap]}]
```

The composite of two automorphisms is an automorphism:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {least = FindKillingDisplacement[g, All]},
  DisplacementIsomorphismQ[g, DisplacementCompose[First @ least, Last @ least]]]
```
