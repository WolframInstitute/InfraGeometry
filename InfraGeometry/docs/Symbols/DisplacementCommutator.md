---
Template: Symbol
Name: DisplacementCommutator
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementCommutator
Keywords: [displacement, commutator, group commutator, Lie bracket, loop, Killing]
SeeAlso: [DisplacementBracket, DisplacementInverse, DisplacementNegative, DisplacementCompose, DisplacementIsomorphismQ, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementCommutator]()[*g*, *d1*, *d2*]</code> is the commutator loop of the displacements *d1* and *d2*: *d1*, then *d2*, then the inverse of *d1*, then the inverse of *d2*.

<code>[DisplacementCommutator]()[*g*, *d1*, *d2*, *v*]</code> gives its value at the vertex *v*.

## Details & Options

The loop is *D₂⁻¹ ∘ D₁⁻¹ ∘ D₂ ∘ D₁*, with the inverses of [DisplacementInverse](). For two bijections it is their group commutator, the identity exactly when they commute.

For the flows of two vector fields *X*, *Y* at scale *r* the loop moves each point by *r²[X, Y] + O(r³)*, so a loop that closes reads a vanishing bracket.

The inverse of a displacement that is not injective has several values, and the loop then spreads.

The commutator of two automorphisms is an automorphism, and exchanging the two inverts it.

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Inverse"` | `"Negative"` replaces the inverses by the metric negatives of [DisplacementNegative](), each taken at the vertex the loop has reached; this is [DisplacementBracket]() |

## Basic Examples

The commutator of the steps right and up, on the square grid and on the square mesh, with the number of vertices where the loop closes. On the grid it fails only at the top and the right; on the mesh it closes at 12 of the 102 vertices, and at 30 it has no value, where an inverse was empty:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {loop = DisplacementCommutator[g, TranslationDisplacement[g, {s, 0}], TranslationDisplacement[g, {0, s}]]},
    DisplacementPlot[g, loop, PlotLabel -> Count[VertexList[g], v_ /; loop[v] === {v}]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

On a 12-cycle the commutator of the rotation by one step and a reflection is the rotation by two steps:

```wl
With[{g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, Range[12]]},
  {loop = DisplacementCommutator[g, rotation, reflection]},
  DisplacementPlot[g, loop, PlotLabel -> {loop[1], DisplacementMagnitude[g, loop]}]]
```

## Scope

The value at one vertex. Near the top right corner of the grid the clamped steps are not injective, and the loop spreads:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {DisplacementCommutator[g, right, up, 45], DisplacementCommutator[g, right, up, 89]}]
```

## Options

### Method

The two loops of the steps right and up of the grid. Both close away from the rim. At the rim the inverse loop spreads over the vertices with a common image; the loop of the negatives turns along the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  GraphicsRow @ Table[
    DisplacementPlot[g, DisplacementCommutator[g, right, up, Method -> method], PlotLabel -> method],
    {method, {"Inverse", "Negative"}}]]
```

## Properties and Relations

The commutator of two automorphisms is an automorphism, and exchanging the two inverts it:

```wl
With[{g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, Range[12]]},
  {loop = DisplacementCommutator[g, rotation, reflection]},
  {DisplacementIsomorphismQ[g, loop], DisplacementCommutator[g, reflection, rotation] === DisplacementInverse[loop]}]
```

`"Negative"` gives [DisplacementBracket]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1/8, 0}], up = TranslationDisplacement[g, {0, 1/8}]},
  DisplacementCommutator[g, right, up, Method -> "Negative"] === DisplacementBracket[g, right, up]]
```
