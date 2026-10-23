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

<code>[DisplacementBracket]()[*g*, *d1*, *d2*]</code> is the metric bracket of the displacements *d1* and *d2*: the loop of *d1*, *d2* and their metric negatives.

<code>[DisplacementBracket]()[*g*, *d1*, *d2*, *v*]</code> gives its value at the vertex *v*.

## Details & Options

The bracket is the loop *[D₁, D₂] = (−D₂) ∘ (−D₁) ∘ D₂ ∘ D₁*, each negative *−D* that of [DisplacementNegative]() for the step at the vertex the loop has reached. It is <code>[DisplacementCommutator]()[*g*, *d1*, *d2*, [Method]() -> "Negative"]</code>.

For the flows of two vector fields *X*, *Y* at scale *r* the loop moves each point by *r²[X, Y] + O(r³)*. Where the bracket vanishes the loop closes; where it does not, the loop is a short step along the bracket.

The loop needs no inverse, so it applies to any displacement, single-valued or not.

Near the rim a negative can turn sideways, and the loop need not close there: *[D, D]* need not be the identity.

## Basic Examples

The bracket of the steps right and up, on the square grid and on the square mesh, with the number of vertices where the loop closes. On the grid it closes away from the rim; on the mesh the two steps do not commute:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {bracket = DisplacementBracket[g, TranslationDisplacement[g, {s, 0}], TranslationDisplacement[g, {0, s}]]},
    DisplacementPlot[g, bracket, PlotLabel -> Count[VertexList[g], v_ /; bracket[v] === {v}]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

A shear: the step right in blue, and the step up switched on right of the middle in red. In the plane *[∂ₓ, H(x − a) ∂ᵧ] = δ(x − a) ∂ᵧ*. The bracket moves the column at the jump one step up; the other moves are at the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]},
  {x = AssociationThread[VertexList[g], First /@ GraphEmbedding[g]]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[x[v] > 8, up[v], {v}], VertexList[g]]},
  GraphicsRow[{DisplacementPlot[g, {right, shear}], DisplacementPlot[g, DisplacementBracket[g, right, shear]]}]]
```

## Scope

The value at one vertex. The centre of the small grid lies in the column just left of the jump of the shear, and moves one step up:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = AssociationThread[VertexList[g], First /@ GraphEmbedding[g]]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[x[v] > 5, up[v], {v}], VertexList[g]]},
  {DisplacementBracket[g, right, shear, c], up[c]}]
```

## Properties and Relations

The bracket is the commutator loop with the metric negatives:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  DisplacementBracket[g, right, up] === DisplacementCommutator[g, right, up, Method -> "Negative"]]
```

Exchanging the two displacements reverses the step at the jump, the step up becoming the step down:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = AssociationThread[VertexList[g], First /@ GraphEmbedding[g]]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {shear = AssociationMap[v |-> If[x[v] > 5, up[v], {v}], VertexList[g]]},
  {DisplacementBracket[g, right, shear, c], DisplacementBracket[g, shear, right, c],
   up[c], TranslationDisplacement[g, {0, -1}][c]}]
```

## Possible Issues

The bracket of a displacement with itself need not be the identity. For the step right of the grid the loop does not close at the 52 vertices drawn, all near the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {bracket = DisplacementBracket[g, right, right]},
  {open = Select[VertexList[g], bracket[#] =!= {#} &]},
  InfraSubstrateHighlight[g, {open}, PlotLabel -> Length[open], ImageSize -> Medium]]
```
