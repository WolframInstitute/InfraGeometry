---
Template: Symbol
Name: DisplacementInverse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementInverse
Keywords: [displacement, inverse, relation, converse, bijection]
SeeAlso: [DisplacementNegative, DisplacementBijectionQ, DisplacementCompose, DisplacementCommutator, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementInverse]()[*d*]</code> is the inverse relation of the displacement *d*: its value at *v* is the set of vertices whose value contains *v*.

## Details & Options

The inverse is *D⁻¹(v) = {u : v ∈ D(u)}*, for *u* and *v* among the keys of *d*.

When *D* is a bijection ([DisplacementBijectionQ]()), *D⁻¹* is the inverse map, and both composites with *D* are the identity. Otherwise a vertex that nothing moves to has the empty value {}, and a vertex that several vertices move to has several values.

The inverse needs no graph. The inverse of the inverse is *D*.

The inverse is not the negative. [DisplacementNegative]() reflects each step through its base vertex and needs the metric.

## Basic Examples

The inverse of the step right, on the square grid and on the square mesh. The label counts the vertices by their number of values; 0 is a vertex nothing moves to:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {inverse = DisplacementInverse[TranslationDisplacement[g, {s, 0}]]},
    DisplacementPlot[g, inverse, PlotLabel -> KeySort @ Counts[Length /@ inverse]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

A step that is not injective, followed by its inverse, is not the identity: a vertex goes back to every vertex with the same image. On the grid this happens at the right rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  DisplacementPlot[g, DisplacementCompose[right, DisplacementInverse[right]], ImageSize -> Medium]]
```

## Properties and Relations

The inverse of the inverse is the displacement:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {t = TranslationDisplacement[g, {1/8, 0}]},
  DisplacementInverse[DisplacementInverse[t]] === t]
```

For a bijection the inverse is the inverse map. The rotation of a 12-cycle by one step and its inverse compose to the identity in both orders:

```wl
With[{g = CycleGraph[12]}, {rotation = FindKillingDisplacement[g]},
  {inverse = DisplacementInverse[rotation]}, {identity = AssociationMap[List, VertexList[g]]},
  {rotation[1], inverse[1],
   DisplacementCompose[rotation, inverse] === identity, DisplacementCompose[inverse, rotation] === identity}]
```

The inverse is not the negative. At the centre of the grid the inverse of the outward radial displacement is empty, while the negative has the four neighbours:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {radial = First @ PolarDisplacements[g, c]},
  {DisplacementInverse[radial][c], DisplacementNegative[g, radial][c]}]
```
