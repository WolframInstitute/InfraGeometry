---
Template: Symbol
Name: DisplacementMagnitude
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementMagnitude
Keywords: [displacement, magnitude, scale, step length, norm]
SeeAlso: [KillingDisplacementMagnitude, RandomDisplacement, DisplacementScale, DisplacementCompose, InfraDisplacementBundle]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementMagnitude]()[*g*, *d*]</code> is the magnitude of the displacement *d*: the longest step, the largest distance in *g* from a vertex to a vertex of its value.

## Details & Options

Definition: *‖D‖ = max { d(v, w) : v a vertex, w ∈ D(v) }*.

The magnitude is the scale of the displacement, the *r* of a flow for time *r*. A single-valued displacement whose steps all have length *r* is a section of the displacement bundle <code>[InfraDisplacementBundle]()[*g*, *r*]</code>, the step *v* → *w* being the total vertex {*v*, *w*}.

It is subadditive under composition, *‖D2 ∘ D1‖ ≤ ‖D1‖ + ‖D2‖*, and the identity has magnitude 0. The least magnitude of a symmetry of *g* is [KillingDisplacementMagnitude]().

## Basic Examples

A random displacement of magnitude at most 2 on the discretized plane, the square tiling and the hexagonal tiling, and its magnitude.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {fields = (SeedRandom[1]; RandomDisplacement[#, 2]) & /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, fields}]], MapThread[DisplacementMagnitude, {graphs, fields}]}]
```

## Scope

The longest step decides. The translation of the square tiling by one step has magnitude 2: at the rim the translated position lies outside the patch, and the nearest vertices are two steps away.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {translation = TranslationDisplacement[g, {1, 1}]},
  {DisplacementPlot[g, translation], DisplacementMagnitude[g, translation]}]
```

## Properties and Relations

The magnitude grows with the scaling factor on the 12-cycle, up to the distance 6 of opposite vertices.

```wl
With[
  {g = CycleGraph[12]},
  {rotation = FindKillingDisplacement[g]},
  {DisplacementPlot[g, Table[DisplacementScale[g, rotation, t], {t, 3}]], Table[DisplacementMagnitude[g, DisplacementScale[g, rotation, t]], {t, 8}]}]
```

The magnitude of a composite is at most the sum of the magnitudes.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {first = (SeedRandom[1]; RandomDisplacement[g, 2]), second = (SeedRandom[2]; RandomDisplacement[g, 1])},
  {DisplacementPlot[g, DisplacementCompose[first, second]],
   DisplacementMagnitude[g, DisplacementCompose[first, second]] <= DisplacementMagnitude[g, first] + DisplacementMagnitude[g, second]}]
```

The least magnitude of a symmetry of the cycle is 1, the rotation by one step.

```wl
With[
  {g = CycleGraph[12]},
  {DisplacementPlot[g, FindKillingDisplacement[g]], DisplacementMagnitude[g, FindKillingDisplacement[g]], KillingDisplacementMagnitude[g]}]
```
