---
Template: Symbol
Name: DisplacementSum
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementSum
Keywords: [displacement, sum, vector field, midpoint, bisector, Baker-Campbell-Hausdorff]
SeeAlso: [DisplacementCompose, DisplacementScale, DisplacementCommutator, DisplacementBracket, DisplacementReduce, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementSum]()[*g*, *d1*, *d2*]</code> is the sum of the displacements *d1* and *d2*: at each vertex the midpoints of the two orders of composition.

## Details & Options

The sum *(D₁ + D₂)(v)* is the union of the midpoints of *p* and *q*, over *p ∈ (D₂ ∘ D₁)(v)* and *q ∈ (D₁ ∘ D₂)(v)*. The midpoints are the vertices of the interval from *p* to *q* nearest its middle, the straightest kept, as <code>[DisplacementScale]()[*g*, <|*p* -> {*q*}|>, 1/2]</code> gives them.

For two flows at scale *r* the two orders are *exp(X + Y ± [X, Y]/2 + O(r³))* by the Baker–Campbell–Hausdorff formula. Their midpoint is *exp(X + Y)* up to *O(r³)*: the bracket cancels.

The sum is commutative. Where the two orders agree in a single vertex, the sum is that vertex.

Ties are kept. Two vertices at odd distance have two midpoints, so the sum is often multivalued; [DisplacementReduce]() contracts what the metric decides.

## Basic Examples

The sum of the steps right and up, on the square grid and on the square mesh:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, DisplacementSum[g, TranslationDisplacement[g, {s, 0}], TranslationDisplacement[g, {0, s}]]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

Where the two orders differ the sum takes their midpoint. At the vertex 94 of the mesh, right then up in blue, up then right in red, and the sum in green:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1/8, 0}], up = TranslationDisplacement[g, {0, 1/8}]},
  DisplacementPlot[g, KeyTake[#, {94}] & /@
    {DisplacementCompose[right, up], DisplacementCompose[up, right], DisplacementSum[g, right, up]}]]
```

## Properties and Relations

The sum is commutative:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1/8, 0}], up = TranslationDisplacement[g, {0, 1/8}]},
  DisplacementSum[g, right, up] === DisplacementSum[g, up, right]]
```

On the grid the two orders agree except at the rim, and the sum of the steps right and up is the diagonal step at 91 of the 96 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {sum = DisplacementSum[g, TranslationDisplacement[g, {1, 0}], TranslationDisplacement[g, {0, 1}]]},
  {diagonal = TranslationDisplacement[g, {1, 1}]},
  Count[VertexList[g], v_ /; sum[v] === diagonal[v]]]
```

## Possible Issues

The sum is often multivalued. The numbers of values of the sum of the steps right and up on the mesh, with their counts:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1/8, 0}], up = TranslationDisplacement[g, {0, 1/8}]},
  KeySort @ Counts[Length /@ DisplacementSum[g, right, up]]]
```
