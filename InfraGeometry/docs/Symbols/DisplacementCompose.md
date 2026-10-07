---
Template: Symbol
Name: DisplacementCompose
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementCompose
Keywords: [displacement, composition, flow, relation, vector field]
SeeAlso: [DisplacementSum, DisplacementCommutator, DisplacementInverse, DisplacementMagnitude, DisplacementPlot, TranslationDisplacement]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementCompose]()[*d1*, *d2*, ...]</code> composes the displacements as flows, *d1* acting first: the value at *v* collects the values of *d2* at every vertex of *d1*(*v*), and so on.

## Details & Options

Definition: a displacement is a map *D* from the vertices to sets of vertices, given as an [Association]() *v* -> {*w1*, *w2*, ...}. The composite of *D1* and *D2* is the relation composite *(D2 ∘ D1)(v) = ∪ { D2(u) : u ∈ D1(v) }*. More arguments compose from the left: <code>[DisplacementCompose]()[*d1*, *d2*, *d3*]</code> is *D3 ∘ D2 ∘ D1*.

Composition needs no graph. It is associative, the identity *v* -> {*v*} is its unit, and it is not commutative. A composite of single-valued displacements is single-valued.

Composition is not addition. For the flows of two vector fields the Baker–Campbell–Hausdorff formula gives *Φ_Y ∘ Φ_X = exp(X + Y + [X, Y]/2 + ⋯)*. [DisplacementSum]() removes the bracket term by taking the midpoints of the two orders, and [DisplacementCommutator]() and [DisplacementBracket]() measure it.

The magnitude is subadditive, *‖D2 ∘ D1‖ ≤ ‖D1‖ + ‖D2‖*, by the triangle inequality ([DisplacementMagnitude]()).

The keys of the composite are the keys of *d1*. Each later displacement needs a value at every vertex the earlier ones reach.

## Basic Examples

On the 6 × 6 grid the step right followed by the step up is the diagonal step. On the top row and the right column the steps stop at the rim, so the composite runs along the rim there, and the corner stays.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  DisplacementPlot[g, DisplacementCompose[right, up]]]
```

On the 12-cycle the least symmetry is the rotation by one step. Three of them compose to the rotation by three steps, blue and orange.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {composite = DisplacementCompose[rotation, rotation, rotation]},
  {DisplacementPlot[g, {rotation, composite}], composite[1]}]
```

## Scope

Values collect over every intermediate vertex. Two outward steps reach every vertex two steps further out: from the centre of the square tiling the eight vertices at distance 2, from the vertex 12, off the axes, three vertices. The composite is drawn at these two vertices only.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  {twoSteps = DisplacementCompose[radial, radial]},
  {DisplacementPlot[g, KeyTake[twoSteps, {First @ GraphCenter[g], 12}]], twoSteps[12]}]
```

## Properties and Relations

The order matters. The rotation of the 12-cycle followed by a reflection, and the reflection followed by the rotation, are reflections about different axes.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, VertexList[g]]},
  {GraphicsRow[{DisplacementPlot[g, DisplacementCompose[rotation, reflection]], DisplacementPlot[g, DisplacementCompose[reflection, rotation]]}],
   DisplacementCompose[rotation, reflection] === DisplacementCompose[reflection, rotation]}]
```

The magnitude of a composite is at most the sum of the magnitudes. Two random displacements of the square tiling, of magnitudes 2 and 1, compose to magnitude 3.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {first = (SeedRandom[1]; RandomDisplacement[g, 2]), second = (SeedRandom[2]; RandomDisplacement[g, 1])},
  {DisplacementPlot[g, DisplacementCompose[first, second]],
   DisplacementMagnitude[g, first], DisplacementMagnitude[g, second], DisplacementMagnitude[g, DisplacementCompose[first, second]]}]
```

A bijection composed with its inverse is the identity, which [DisplacementPlot]() draws as the bare graph.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {identity = DisplacementCompose[rotation, DisplacementInverse[rotation]]},
  {DisplacementPlot[g, identity], identity === AssociationMap[List, VertexList[g]]}]
```
