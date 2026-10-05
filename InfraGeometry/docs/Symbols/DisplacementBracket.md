---
Template: Symbol
Name: DisplacementBracket
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementBracket
Keywords: [displacement, Lie bracket, commutator, metric negative, shear, vector field]
SeeAlso: [DisplacementCommutator, DisplacementNegative, DisplacementSum, DisplacementCompose, TranslationDisplacement, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementBracket]()[*g*, *d1*, *d2*]</code> is the metric bracket of the displacements *d1* and *d2*: the loop of *d1*, *d2* and their metric negatives, <code>[DisplacementCommutator]()[*g*, *d1*, *d2*, [Method]() -> "Negative"]</code>.

<code>[DisplacementBracket]()[*g*, *d1*, *d2*, *v*]</code> gives its value at the vertex *v*.

## Details & Options

Definition: *[D1, D2] = (−D2) ∘ (−D1) ∘ D2 ∘ D1*, where *−D* is the metric negative given by [DisplacementNegative](), taken at the vertex the loop has reached.

For the flows of two vector fields at scale *r* the loop moves each point by *r²* times the Lie bracket, up to *O(r³)*: where the bracket vanishes the loop closes, and where it does not, the loop is a short step in the direction of the bracket. The metric loop needs no inverse, so it applies to any displacement, single-valued or not.

On a graph the bracket depends on the scale of the displacements, and it need not be antisymmetric: *[D2, D1]* need not be the negative of *[D1, D2]*, and *[D, D]* need not be the identity. Near the rim the negative of a clamped step is the vertex itself, and the loop does not close.

## Basic Examples

The steps right and up of the 6 × 6 grid have a vanishing bracket: the loop closes on 25 of the 36 vertices. The other 11 lie next to the top row and the right column, where the step is clamped and its negative is the vertex itself.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {bracket = DisplacementBracket[g, right, up]},
  {DisplacementPlot[g, bracket], Count[Keys[bracket], v_ /; bracket[v] === {v}]}]
```

A shear: the step up, switched on from the fourth column, orange, beside the step right, blue. Their bracket moves the third column one step up, the jump of the coefficient of the step up; the vertices next to the top row and the right column move as for the coordinate steps.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[v > 18, up[v], {v}], VertexList[g]]},
  GraphicsRow[{DisplacementPlot[g, {right, shear}], DisplacementPlot[g, DisplacementBracket[g, right, shear]]}]]
```

## Scope

The value at one vertex of the third column.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[v > 18, up[v], {v}], VertexList[g]]},
  {DisplacementPlot[g, <|15 -> DisplacementBracket[g, right, shear, 15]|>], DisplacementBracket[g, right, shear, 15]}]
```

## Properties and Relations

Exchanging the two displacements reverses the step on the third column, as for the Lie bracket, but not the steps at the rim.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[v > 18, up[v], {v}], VertexList[g]]},
  GraphicsRow[{DisplacementPlot[g, DisplacementBracket[g, right, shear]], DisplacementPlot[g, DisplacementBracket[g, shear, right]]}]]
```

On the 12-cycle the bracket of the rotation with itself is the identity.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, DisplacementBracket[g, rotation, rotation]], DisplacementBracket[g, rotation, rotation] === AssociationMap[List, VertexList[g]]}]
```

## Possible Issues

The bracket of a displacement with itself need not be the identity. On a path, the step left stops at the end 1, and its bracket with itself moves 2 and 3 to 1: at the end the negative of the step is the end itself, and the loop does not come back.

```wl
With[
  {g = PathGraph[Range[5]]},
  {left = <|1 -> {1}, 2 -> {1}, 3 -> {2}, 4 -> {3}, 5 -> {4}|>},
  {DisplacementPlot[g, DisplacementBracket[g, left, left]], Normal @ DisplacementBracket[g, left, left]}]
```
