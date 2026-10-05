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

<code>[DisplacementSum]()[*g*, *d1*, *d2*]</code> is the sum of the displacements *d1* and *d2*: at each vertex the midpoints between the two orders of composition, *d2* after *d1* and *d1* after *d2*.

## Details & Options

Definition: *(D1 + D2)(v)* is the union, over *p ∈ (D2 ∘ D1)(v)* and *q ∈ (D1 ∘ D2)(v)*, of the midpoints of *p* and *q*: the vertices of the interval from *p* to *q* nearest its middle, the straightest kept, as <code>[DisplacementScale]()[*g*, <|*p* -> {*q*}|>, 1/2]</code> gives them.

The reason is the Baker–Campbell–Hausdorff formula. For the flows of two vector fields at scale *r* the two orders are *exp(X + Y ± [X, Y]/2 + O(r³))*, so their midpoint is *exp(X + Y)* up to *O(r³)*: the bracket terms cancel without being computed.

The sum is exactly commutative, *D1 + D2 = D2 + D1*: swapping the summands swaps the two orders, and the midpoints of *p* and *q* are those of *q* and *p*. When the two orders agree at *v*, the sum there is the composite.

Ties are kept. When *p* and *q* are an odd distance apart, the vertices on both sides of the middle are equally near it, so the sum can have several values; [DisplacementReduce]() contracts what the metric decides.

## Basic Examples

The steps right and up of the 6 × 6 grid commute, so their sum is the composite, the diagonal step.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {sum = DisplacementSum[g, right, up]},
  {DisplacementPlot[g, sum], sum === DisplacementCompose[right, up]}]
```

Two translations of the hexagonal tiling, blue and orange, their sum, and the translation by the sum of the two vectors. The sum is that translation at all but 10 of the 109 vertices, all at the rim.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {first = TranslationDisplacement[g, {3/2, Sqrt[3]/2}], second = TranslationDisplacement[g, {3/2, -Sqrt[3]/2}], both = TranslationDisplacement[g, {3, 0}]},
  {sum = DisplacementSum[g, first, second]},
  {GraphicsRow[{DisplacementPlot[g, {first, second}], DisplacementPlot[g, sum], DisplacementPlot[g, both]}],
   Count[VertexList[g], v_ /; sum[v] === both[v]]}]
```

## Scope

Where the two orders differ the sum takes their midpoints. On the 12-cycle the rotation followed by a reflection and the reflection followed by the rotation send 1 to 2 and to 12, and the sum sends 1 to the midpoint 1.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, VertexList[g]]},
  {DisplacementPlot[g, DisplacementSum[g, rotation, reflection]],
   DisplacementCompose[rotation, reflection][1], DisplacementCompose[reflection, rotation][1], DisplacementSum[g, rotation, reflection][1]}]
```

## Properties and Relations

The sum is commutative. Two random displacements of the square tiling:

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {first = (SeedRandom[1]; RandomDisplacement[g, 2]), second = (SeedRandom[2]; RandomDisplacement[g, 1])},
  {DisplacementPlot[g, DisplacementSum[g, first, second]], DisplacementSum[g, first, second] === DisplacementSum[g, second, first]}]
```

The sum of a displacement with itself is twice it where the shortest paths continue. On the cycle it is the rotation by two steps.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, DisplacementSum[g, rotation, rotation]], DisplacementSum[g, rotation, rotation] === DisplacementScale[g, rotation, 2]}]
```
