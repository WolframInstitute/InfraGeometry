---
Template: Symbol
Name: DisplacementSingleValuedQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementSingleValuedQ
Keywords: [displacement, single-valued, vertex map, multivalued]
SeeAlso: [DisplacementBijectionQ, DisplacementIsomorphismQ, DisplacementReduce, RandomDisplacement, PolarDisplacements]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementSingleValuedQ]()[*d*]</code> gives [True]() when every value of the displacement *d* is a single vertex, and [False]() otherwise.

## Details & Options

Definition: *D* is single-valued when *|D(v)| = 1* for every vertex *v*. It is then a map of the vertices.

A displacement is set-valued by design: where the metric does not decide between several vertices, all are kept. Composition preserves single values; the inverse, the negative, scaling and the sum do not in general. [DisplacementReduce]() contracts the ties the metric breaks.

An empty value is not a single vertex, so the inverse of a map that is not onto is not single-valued.

## Basic Examples

On the square tiling a random displacement is single-valued; the outward radial displacement is not, since a vertex off the axes has two neighbours further out.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {field = (SeedRandom[1]; RandomDisplacement[g, 2]), radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {GraphicsRow[{DisplacementPlot[g, field], DisplacementPlot[g, radial]}], DisplacementSingleValuedQ[field], DisplacementSingleValuedQ[radial]}]
```

## Scope

A translation of the hexagonal tiling by a vector of its lattice is single-valued. Half of a step of the square tiling lands between two vertices, and both are kept.

```wl
With[
  {hexagonal = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True], square = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {whole = TranslationDisplacement[hexagonal, {3/2, Sqrt[3]/2}], half = TranslationDisplacement[square, {1/2, 1/2}]},
  {GraphicsRow[{DisplacementPlot[hexagonal, whole], DisplacementPlot[square, half]}], DisplacementSingleValuedQ[whole], DisplacementSingleValuedQ[half]}]
```

## Properties and Relations

The inverse of the step right of the grid is not single-valued: the left column has empty values, and the right column has two.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {DisplacementPlot[g, DisplacementInverse[right]], DisplacementSingleValuedQ[right], DisplacementSingleValuedQ[DisplacementInverse[right]]}]
```

A symmetry of a graph, as [FindKillingDisplacement]() gives it, is single-valued.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {killing = FindKillingDisplacement[g]},
  {DisplacementPlot[g, killing], DisplacementSingleValuedQ[killing]}]
```
