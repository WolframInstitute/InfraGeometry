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

<code>[DisplacementCommutator]()[*g*, *d1*, *d2*]</code> is the commutator loop of the displacements: *d1*, then *d2*, then the inverse of *d1*, then the inverse of *d2*.

<code>[DisplacementCommutator]()[*g*, *d1*, *d2*, *v*]</code> gives its value at the vertex *v*.

## Details & Options

Definition: with [Method]() -> `"Inverse"`, the default, the loop is *D2⁻¹ ∘ D1⁻¹ ∘ D2 ∘ D1*, the inverses those of [DisplacementInverse](). For two bijections it is their group commutator, and the identity exactly when they commute.

With [Method]() -> `"Negative"` the inverses are replaced by the metric negatives of [DisplacementNegative](): the loop is *(−D2) ∘ (−D1) ∘ D2 ∘ D1*, each negative taken at the vertex the loop has reached. This loop needs neither bijections nor relation inverses, and it is [DisplacementBracket]().

| Method | the loop |
|---|---|
| `"Inverse"` (default) | *D1*, *D2*, the inverse relation of *D1*, the inverse relation of *D2* |
| `"Negative"` | *D1*, *D2*, the metric negative of *D1*, the metric negative of *D2* |

For the flows of two vector fields at scale *r* the loop moves each point by *r²* times the Lie bracket *[X, Y]*, up to *O(r³)* and the sign convention of the bracket, so a loop that closes reads a vanishing bracket. On a graph the loop is a displacement, multivalued where an inverse or a negative is.

The commutator of two automorphisms is an automorphism, and exchanging the two displacements inverts it.

## Basic Examples

On the 12-cycle the commutator of the rotation by one step and a reflection is the rotation by two steps, an automorphism of magnitude 2.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, VertexList[g]]},
  {loop = DisplacementCommutator[g, rotation, reflection]},
  {DisplacementPlot[g, loop], loop[1], DisplacementIsomorphismQ[g, loop], DisplacementMagnitude[g, loop]}]
```

On the 6 × 6 grid the steps right and up commute away from the rim: the loop is the identity on the 16 vertices of the lower left 4 × 4 block. Near the top row and the right column the clamped steps are not injective, and the inverses carry a vertex back to every vertex with the same image.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {loop = DisplacementCommutator[g, right, up]},
  {DisplacementPlot[g, loop], Count[Keys[loop], v_ /; loop[v] === {v}]}]
```

## Scope

The value at one vertex.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {DisplacementPlot[g, <|30 -> DisplacementCommutator[g, right, up, 30]|>], DisplacementCommutator[g, right, up, 30]}]
```

## Options

### Method

The two loops of the steps right and up of the grid. Both close away from the rim. At the rim the inverse loop spreads over the vertices with a common image, and the loop of the metric negatives takes a single step towards the rim.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  GraphicsRow[Table[DisplacementPlot[g, DisplacementCommutator[g, right, up, Method -> method]], {method, {"Inverse", "Negative"}}]]]
```

## Properties and Relations

Exchanging the two automorphisms inverts their commutator.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g], reflection = AssociationMap[{Mod[2 - #, 12, 1]} &, VertexList[g]]},
  {loop = DisplacementCommutator[g, rotation, reflection], swapped = DisplacementCommutator[g, reflection, rotation]},
  {DisplacementPlot[g, {loop, swapped}], swapped === DisplacementInverse[loop]}]
```

`"Negative"` gives [DisplacementBracket]().

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}], up = TranslationDisplacement[g, {0, 1}]},
  {DisplacementPlot[g, DisplacementBracket[g, right, up]], DisplacementCommutator[g, right, up, Method -> "Negative"] === DisplacementBracket[g, right, up]}]
```
