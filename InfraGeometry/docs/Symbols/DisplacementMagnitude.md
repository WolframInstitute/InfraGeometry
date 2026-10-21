---
Template: Symbol
Name: DisplacementMagnitude
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementMagnitude
Keywords: [displacement, magnitude, norm, longest step, scale]
SeeAlso: [KillingDisplacementMagnitude, DisplacementScale, DisplacementCompose, RandomDisplacement, InfraDisplacementBundle]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementMagnitude]()[*g*, *d*]</code> is the magnitude of the displacement *d*: the length of its longest step in *g*.

## Details & Options

The magnitude is *‖D‖ = max {d(v, w) : w ∈ D(v)}*, the maximum over all vertices *v*.

It is the scale of the displacement, the time *r* of a flow of a unit vector field. The identity has magnitude 0.

It is subadditive under composition, *‖D₂ ∘ D₁‖ ≤ ‖D₁‖ + ‖D₂‖*.

The longest step decides, so a single step at the rim can set the magnitude.

The least magnitude of a symmetry of *g* is [KillingDisplacementMagnitude]().

## Basic Examples

The magnitude of the step right, on the square grid and on the square mesh. On the grid a pendant vertex of the top or the bottom row steps to the next pendant vertex, three steps away:

```wl
GraphicsRow @ KeyValueMap[
  {name, s} |-> With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {t = TranslationDisplacement[g, {s, 0}]},
    DisplacementPlot[g, t, PlotLabel -> DisplacementMagnitude[g, t]]],
  <|"SquareGridGraph" -> 1, "SquareMeshGraph" -> 1/8|>]
```

The steps from the centre scaled by 0, 1, …, 6 have magnitude 0, 1, …, 6, on the grid and on the mesh:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    Table[DisplacementMagnitude[g, DisplacementScale[g, <|c -> AdjacencyList[g, c]|>, t]], {t, 0, 6}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The magnitude is subadditive. Two random displacements of the mesh, of magnitudes 1 and 2, and their composite:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d1 = RandomDisplacement[g, 1, RandomSeeding -> 1], d2 = RandomDisplacement[g, 2, RandomSeeding -> 2]},
  DisplacementMagnitude[g, #] & /@ {d1, d2, DisplacementCompose[d1, d2]}]
```

The least magnitude of a symmetry is the magnitude of the symmetry [FindKillingDisplacement]() gives:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {DisplacementMagnitude[g, FindKillingDisplacement[g]], KillingDisplacementMagnitude[g]}]
```
