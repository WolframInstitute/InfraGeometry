---
Template: Symbol
Name: DisplacementInverse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementInverse
Keywords: [displacement, inverse relation, preimage, fiber, bijection]
SeeAlso: [DisplacementNegative, DisplacementCompose, DisplacementBijectionQ, DisplacementCommutator, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementInverse]()[*d*]</code> reverses the displacement *d* as a relation: its value at *v* is the set of vertices whose value contains *v*.

## Details & Options

Definition: *D⁻¹(v) = {u : v ∈ D(u)}*, for *u* and *v* among the keys of *d*.

When *D* is a bijection ([DisplacementBijectionQ]()), *D⁻¹* is the inverse map: both composites with *D* are the identity. Otherwise a vertex that no vertex moves to has the empty value {}, and a vertex that several vertices move to has several values.

The inverse needs no graph and no metric. [DisplacementNegative]() is the metric counterpart: it reflects each step through its base vertex. The two agree for the rotations of a cycle and differ at the rim of a patch.

The inverse of the inverse is *D* itself.

## Basic Examples

The inverse of a translation on the discretized plane, the square tiling and the hexagonal tiling: every step reversed. At the trailing rim, where no vertex arrives, the values are empty; at the leading rim, where several arrive, they have several vertices. The number of empty values is given.

```wl
With[
  {pairs = {{"SquareMeshGraph", {0.1, 0}}, {"SquareTilingGraph", {1, 1}}, {"HexagonalTilingGraph", {1.5, Sqrt[3]/2}}}},
  {graphs = InfraSubstrate[First[#], "Small", "KeepCoordinates" -> True] & /@ pairs},
  {inverses = MapThread[DisplacementInverse[TranslationDisplacement[#1, #2]] &, {graphs, Last /@ pairs}]},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, inverses}]], Count[Values[#], {}] & /@ inverses}]
```

The inverse of the rotation of the 12-cycle is the opposite rotation.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, {rotation, DisplacementInverse[rotation]}], DisplacementInverse[rotation][1]}]
```

## Scope

On the 6 × 6 grid the inverse of the step right has empty values in the left column and two values in the right column, which the clamped step reaches from itself and from its left neighbour.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {inverse = DisplacementInverse[right]},
  {DisplacementPlot[g, inverse], Keys @ Select[inverse, # === {} &], inverse[36]}]
```

## Properties and Relations

A bijection composed with its inverse, in either order, is the identity.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, DisplacementCompose[rotation, DisplacementInverse[rotation]]],
   DisplacementCompose[rotation, DisplacementInverse[rotation]] === DisplacementCompose[DisplacementInverse[rotation], rotation] === AssociationMap[List, VertexList[g]]}]
```

For a displacement that is not injective the composite with the inverse is not the identity: a vertex goes back to every vertex that shares its image.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {loop = DisplacementCompose[right, DisplacementInverse[right]]},
  {DisplacementPlot[g, loop], loop[30], loop[36]}]
```

The inverse of the inverse is the displacement.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, InfraCenter[g]]},
  {DisplacementPlot[g, DisplacementInverse[radial]], DisplacementInverse[DisplacementInverse[radial]] === radial}]
```

The inverse is not the negative. The inverse of the outward radial field of the square tiling has the empty value at the centre, where the negative has the four neighbours.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {radial = First @ PolarDisplacements[g, c]},
  {GraphicsRow[{DisplacementPlot[g, DisplacementInverse[radial]], DisplacementPlot[g, DisplacementNegative[g, radial]]}],
   DisplacementInverse[radial][c], DisplacementNegative[g, radial][c]}]
```
