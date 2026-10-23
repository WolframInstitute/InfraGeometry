---
Template: Symbol
Name: FindKillingDisplacement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindKillingDisplacement
Keywords: [displacement, Killing field, automorphism, symmetry, isometry, magnitude]
SeeAlso: [KillingDisplacementMagnitude, DisplacementIsomorphismQ, DisplacementMagnitude, DisplacementCommutator, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[FindKillingDisplacement]()[*g*]</code> gives an automorphism of *g* other than the identity of least magnitude, as a displacement.

<code>[FindKillingDisplacement]()[*g*, [All]()]</code> gives all of least magnitude.

## Details & Options

The result is an automorphism *σ ≠ id* of *g* minimizing *max {d(v, σ(v))}*, as the displacement *v* -> {*σ(v)*}. It is a discrete Killing displacement ([DisplacementIsomorphismQ]()) that moves the vertices least, and its magnitude is [KillingDisplacementMagnitude]().

In the plane the translations by a small vector are isometries that move every point a little. On a torus the translations by one step play this part, of magnitude 1. A graph with a rim has fewer symmetries; on the square grid the least ones exchange pendant vertices at the corners.

A graph without symmetry has none: the form with [All]() gives {}, and the form without stays unevaluated.

The whole automorphism group is listed, so its order must be moderate.

## Basic Examples

The least symmetry of the square grid exchanges two pendant vertices at a corner:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  DisplacementPlot[g, killing, PlotLabel -> DisplacementMagnitude[g, killing]]]
```

There are 15, the exchanges at any nonempty set of the four corners, all of magnitude 2. The one at all four corners:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {all = FindKillingDisplacement[g, All]},
  DisplacementPlot[g, First @ MaximalBy[all, Count[Keys[#], v_ /; #[v] =!= {v}] &],
    PlotLabel -> {Length[all], Union[DisplacementMagnitude[g, #] & /@ all]}]]
```

## Scope

The square torus has no rim. Its least automorphisms are the four translations by one step, drawn at a planar layout of the torus:

```wl
With[{g = InfraSubstrate["SquareTorusGraph", "Small"]}, {translations = FindKillingDisplacement[g, All]},
  DisplacementPlot[g, First @ translations,
    PlotLabel -> {Length[translations], DisplacementMagnitude[g, First @ translations]}]]
```

## Properties and Relations

A least automorphism is a 1-continuous bijection:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  {DisplacementIsomorphismQ[g, killing], DisplacementBijectionQ[killing], ContinuousDisplacementQ[g, killing]}]
```

## Possible Issues

The square mesh has no symmetry. The form with [All]() gives the empty list, and the form without stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {FindKillingDisplacement[g, All], Head @ FindKillingDisplacement[g]}]
```
