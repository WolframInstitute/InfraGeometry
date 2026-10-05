---
Template: Symbol
Name: ContinuousDisplacementQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ContinuousDisplacementQ
Keywords: [displacement, continuity, k-continuous, Lipschitz, nonexpansive, Hausdorff distance]
SeeAlso: [RandomDisplacement, DisplacementIsomorphismQ, DisplacementBijectionQ, PolarDisplacements, InfraContinuousSectionQ]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[ContinuousDisplacementQ]()[*g*, *d*]</code> gives [True]() when the displacement *d* is 1-continuous: the values at the two ends of every edge of *g* are at most one step apart.

<code>[ContinuousDisplacementQ]()[*g*, *d*, *k*]</code> tests *k*-continuity: at most *k* steps apart.

## Details & Options

Definition: *D* is *k*-continuous when *δ(D(u), D(v)) ≤ k* for every edge *uv* of *g*, where *δ* is a distance between finite sets of vertices chosen by [Method]():

| Method | *δ(A, B)* |
|---|---|
| `"Weak"` (default) | the least distance *d(a, b)*, *a ∈ A*, *b ∈ B*: one close pair |
| `"Hausdorff"` | the Hausdorff distance: every vertex of each set close to the other set |
| `"Strong"` | the largest distance *d(a, b)*: every pair close |

For single-valued displacements the three agree.

A single-valued displacement is 1-continuous exactly when it does not increase distances, *d(D(u), D(v)) ≤ d(u, v)*: the condition on edges carries along shortest paths. Weakly 1-continuous displacements compose to weakly 1-continuous ones. A 1-continuous bijection is an automorphism ([DisplacementIsomorphismQ]()).

## Basic Examples

The outward radial displacement about the centre is 1-continuous on the square and the hexagonal tilings, but not on the irregular discretized plane.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {radials = First @ PolarDisplacements[#, InfraCenter[#]] & /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, radials}]], MapThread[ContinuousDisplacementQ, {graphs, radials}]}]
```

A random displacement is built to be 1-continuous.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {field = (SeedRandom[1]; RandomDisplacement[g, 2])},
  {DisplacementPlot[g, field], ContinuousDisplacementQ[g, field]}]
```

## Scope

Twice the outward radial displacement of the square tiling is weakly 1-continuous. Its values have up to four vertices, and in the Hausdorff and the strong sense it is not even 3-continuous.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {doubled = DisplacementScale[g, First @ PolarDisplacements[g, InfraCenter[g]], 2]},
  {DisplacementPlot[g, doubled], Table[ContinuousDisplacementQ[g, doubled, k, Method -> method], {method, {"Weak", "Hausdorff", "Strong"}}, {k, 3}]}]
```

## Options

### Method

On a path, a displacement that sends the end 1 to itself and to the other end is weakly 1-continuous, but not in the Hausdorff or the strong sense.

```wl
With[
  {g = PathGraph[Range[4]]},
  {field = <|1 -> {1, 4}, 2 -> {2}, 3 -> {3}, 4 -> {4}|>},
  {DisplacementPlot[g, field], Table[ContinuousDisplacementQ[g, field, Method -> method], {method, {"Weak", "Hausdorff", "Strong"}}]}]
```

## Properties and Relations

The angular displacement about the centre of the triangular tiling is not 1-continuous, but it is 2-continuous. The six pendant vertices at the corners of the patch have no neighbour at their own distance and stay, while their neighbours move along their own distance sphere, two steps from them.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {angular = Last @ PolarDisplacements[g, InfraCenter[g]]},
  {DisplacementPlot[g, angular], ContinuousDisplacementQ[g, angular], ContinuousDisplacementQ[g, angular, 2]}]
```

Composites of 1-continuous displacements are 1-continuous.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {first = (SeedRandom[1]; RandomDisplacement[g, 2]), second = (SeedRandom[2]; RandomDisplacement[g, 1])},
  {DisplacementPlot[g, DisplacementCompose[first, second]], ContinuousDisplacementQ[g, #] & /@ {first, second, DisplacementCompose[first, second]}}]
```
