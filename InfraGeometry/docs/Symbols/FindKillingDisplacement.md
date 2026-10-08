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

<code>[FindKillingDisplacement]()[*g*]</code> finds an automorphism of *g* other than the identity of least magnitude, as a displacement.

<code>[FindKillingDisplacement]()[*g*, [All]()]</code> gives every one of least magnitude.

## Details & Options

Definition: among the automorphisms *σ ≠ id* of *g*, those with the least magnitude *max_v d(v, σ(v))*, each as the displacement *v* -> {*σ(v)*}. They are the discrete Killing displacements ([DisplacementIsomorphismQ]()) that move the vertices least, and their magnitude is [KillingDisplacementMagnitude]().

Every automorphism is listed, from [GraphAutomorphismGroup](), so the group must be of moderate order.

On a cycle or a torus the least automorphisms are the translations by one step. On a finite patch of a tiling the only automorphisms are the symmetries of the patch, which move its rim far: by the diameter on the square and the hexagonal tilings.

## Basic Examples

The least automorphisms of the 12-cycle are the two rotations by one step.

```wl
With[
  {g = CycleGraph[12]},
  {rotations = FindKillingDisplacement[g, All]},
  {DisplacementPlot[g, rotations], DisplacementMagnitude[g, #] & /@ rotations}]
```

The least symmetry of the square, the triangular and the hexagonal tilings, and its magnitude. On the triangular tiling it is a rotation by a sixth of a turn; on the square tiling every symmetry moves a corner of the patch to another.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "TriangularTilingGraph", "HexagonalTilingGraph"}},
  {killings = FindKillingDisplacement /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, killings}]], MapThread[DisplacementMagnitude, {graphs, killings}]}]
```

## Scope

The square torus has no rim. Its least automorphisms are the four translations by one step, drawn at a planar layout of the torus.

```wl
With[
  {g = InfraSubstrate["SquareTorusGraph", "Small"]},
  {translations = FindKillingDisplacement[g, All]},
  {DisplacementPlot[g, First[translations]], Length[translations], DisplacementMagnitude[g, First[translations]]}]
```

## Properties and Relations

A least automorphism is a Killing displacement: an automorphism and a 1-continuous bijection.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  {DisplacementPlot[g, killing], DisplacementIsomorphismQ[g, killing], DisplacementBijectionQ[killing], ContinuousDisplacementQ[g, killing]}]
```

## Possible Issues

The least symmetry need not be a motion of the whole graph. On the square grid with pendant vertices at its rim, it exchanges two pendant vertices at a corner and fixes everything else.

```wl
With[
  {g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  {DisplacementPlot[g, killing], Select[Keys[killing], killing[#] =!= {#} &], DisplacementMagnitude[g, killing]}]
```

On a graph without symmetry, such as the discretized plane, there is no Killing displacement. The form with [All]() gives the empty list, and the one-argument form stays unevaluated, with no message.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {g, FindKillingDisplacement[g, All], FindKillingDisplacement[g]}]
```
