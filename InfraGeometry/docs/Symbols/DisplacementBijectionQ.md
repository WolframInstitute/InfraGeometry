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

Definition: *D* is a bijection when it is single-valued ([DisplacementSingleValuedQ]()) and its values, taken together, are its keys, each exactly once.

A bijection has an inverse map, [DisplacementInverse](), and composing the two in either order gives the identity. The test needs no graph: a bijection need not respect the edges. [DisplacementIsomorphismQ]() asks for that too, and a bijection that is 1-continuous ([ContinuousDisplacementQ]()) is already an automorphism.

## Basic Examples

The rotation of the 12-cycle is a bijection. The step right of the 6 × 6 grid is not: the right column moves to itself, and nothing moves to the left column.

```wl
With[
  {cycle = CycleGraph[12], grid = GridGraph[{6, 6}]},
  {rotation = FindKillingDisplacement[cycle], right = TranslationDisplacement[grid, {1, 0}]},
  {GraphicsRow[{DisplacementPlot[cycle, rotation], DisplacementPlot[grid, right]}], DisplacementBijectionQ[rotation], DisplacementBijectionQ[right]}]
```

## Scope

Exchanging the two ends of one edge of the cycle is a bijection of magnitude 1, but not a symmetry of the cycle.

```wl
With[
  {g = CycleGraph[12]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|1 -> {2}, 2 -> {1}|>]},
  {DisplacementPlot[g, swap], DisplacementBijectionQ[swap], DisplacementMagnitude[g, swap], DisplacementIsomorphismQ[g, swap]}]
```

## Properties and Relations

A bijection composed with its inverse is the identity.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, {rotation, DisplacementInverse[rotation]}], DisplacementCompose[rotation, DisplacementInverse[rotation]] === AssociationMap[List, VertexList[g]]}]
```

Of the 720 bijections of the hexagon, 20 move no vertex more than one step, and the 12 that are 1-continuous, drawn here, are exactly its 12 symmetries. A small magnitude does not make a symmetry; continuity does.

```wl
With[
  {g = CycleGraph[6]},
  {bijections = AssociationThread[Range[6], List /@ #] & /@ Permutations[Range[6]]},
  {continuous = Select[bijections, ContinuousDisplacementQ[g, #] &]},
  {GraphicsGrid[Partition[DisplacementPlot[g, #] & /@ continuous, 6]],
   Count[bijections, b_ /; DisplacementMagnitude[g, b] <= 1], Length[continuous], Count[continuous, b_ /; DisplacementIsomorphismQ[g, b]]}]
```
