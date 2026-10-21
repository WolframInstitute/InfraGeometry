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

<code>[DisplacementCompose]()[*d1*, *d2*, …]</code> is the composite of the displacements, *d1* acting first.

## Details & Options

The composite is *(D₂ ∘ D₁)(v) = ⋃ {D₂(u) : u ∈ D₁(v)}*: the values collect over every intermediate vertex. More arguments compose in turn, <code>[DisplacementCompose]()[*d1*, *d2*, *d3*]</code> = *D₃ ∘ D₂ ∘ D₁*.

Composition needs no graph. It is associative, the identity *v* -> {*v*} is its unit, and it is not commutative.

A composite of single-valued displacements is single-valued, and a composite of 1-continuous displacements is 1-continuous ([ContinuousDisplacementQ]()).

The magnitude is subadditive, *‖D₂ ∘ D₁‖ ≤ ‖D₁‖ + ‖D₂‖* ([DisplacementMagnitude]()).

Composition is not addition. For two flows the two orders differ by the bracket of the fields; [DisplacementSum]() takes the midpoints of the two orders, and [DisplacementCommutator]() measures the difference.

Each later displacement needs a value at every vertex the earlier ones reach. The keys of the composite are those of *d1*.

## Basic Examples

The step right followed by the step up, on the square grid and on the square mesh:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, DisplacementCompose[TranslationDisplacement[g, {s, 0}], TranslationDisplacement[g, {0, s}]]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

Values collect over the intermediate vertices. Two outward radial steps from the centre of the grid reach the 8 vertices at distance 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {radial = First @ PolarDisplacements[g, c]}, {twoSteps = DisplacementCompose[radial, radial]},
  DisplacementPlot[g, KeyTake[twoSteps, {c}], PlotLabel -> Length[twoSteps[c]]]]
```

## Scope

Three steps right. Each step stops at the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  DisplacementPlot[g, DisplacementCompose[right, right, right]]]
```

## Properties and Relations

The order matters. The steps right and up commute on the grid except at 2 vertices of the rim; on the mesh the two orders differ at 51 of the 102 vertices, drawn in red:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {right = TranslationDisplacement[g, {s, 0}], up = TranslationDisplacement[g, {0, s}]},
    {differ = Select[VertexList[g], DisplacementCompose[right, up][#] =!= DisplacementCompose[up, right][#] &]},
    InfraSubstrateHighlight[g, {differ}, PlotLabel -> Length[differ]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

The magnitude is subadditive. Two random displacements of the mesh, of magnitudes 1 and 2, and their composite:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d1 = RandomDisplacement[g, 1, RandomSeeding -> 1], d2 = RandomDisplacement[g, 2, RandomSeeding -> 2]},
  DisplacementMagnitude[g, #] & /@ {d1, d2, DisplacementCompose[d1, d2]}]
```

The composite of 1-continuous single-valued displacements is 1-continuous and single-valued:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d = DisplacementCompose[RandomDisplacement[g, 1, RandomSeeding -> 1], RandomDisplacement[g, 2, RandomSeeding -> 2]]},
  {ContinuousDisplacementQ[g, d], DisplacementSingleValuedQ[d]}]
```
