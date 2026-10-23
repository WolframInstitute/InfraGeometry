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

*D* is *k*-continuous when *δ(D(u), D(v)) ≤ k* for every edge *uv* of *g*, with *δ* a distance between sets of vertices.

A single-valued displacement is 1-continuous exactly when it increases no distance, *d(D(u), D(v)) ≤ d(u, v)*: the condition on edges carries along shortest paths. It is the discrete counterpart of a 1-Lipschitz map.

Composites of 1-continuous displacements are 1-continuous. A 1-continuous bijection is an automorphism ([DisplacementIsomorphismQ]()).

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Weak"` | `"Weak"`: *δ(A, B)* the least distance between a vertex of *A* and one of *B*; `"Hausdorff"`: the Hausdorff distance; `"Strong"`: the largest distance |

For single-valued displacements the three methods agree.

## Basic Examples

The outward radial displacement about the centre is 1-continuous on the square grid, but not on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
    DisplacementPlot[g, radial, PlotLabel -> ContinuousDisplacementQ[g, radial]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Exchanging two neighbours of the grid is not 1-continuous: a third neighbour of one stays, two steps from the other. It is 2-continuous:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {swap = Join[AssociationMap[List, VertexList[g]], <|c -> {c + 1}, c + 1 -> {c}|>]},
  {ContinuousDisplacementQ[g, swap], ContinuousDisplacementQ[g, swap, 2]}]
```

## Scope

The angular displacement about the centre of the mesh is 2-continuous, not 1-continuous:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {angular = Last @ PolarDisplacements[g, First @ GraphCenter[g]]},
  Table[ContinuousDisplacementQ[g, angular, k], {k, 3}]]
```

## Options

### Method

The radial displacement of the grid has several values at most vertices. It is weakly 1-continuous, but in the Hausdorff and the strong sense only 3-continuous; the rows are the methods, the columns *k* = 1, 2, 3:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  Table[ContinuousDisplacementQ[g, radial, k, Method -> method], {method, {"Weak", "Hausdorff", "Strong"}}, {k, 3}]]
```

## Properties and Relations

A single-valued 1-continuous displacement increases no distance. A random displacement of the mesh, over all pairs of vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d = RandomDisplacement[g, 2, RandomSeeding -> 1]}, {f = First /@ d},
  {ContinuousDisplacementQ[g, d],
   AllTrue[Subsets[VertexList[g], {2}], GraphDistance[g, f[#[[1]]], f[#[[2]]]] <= GraphDistance[g, #[[1]], #[[2]]] &]}]
```

A composite of 1-continuous displacements is 1-continuous:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d1 = RandomDisplacement[g, 1, RandomSeeding -> 1], d2 = RandomDisplacement[g, 2, RandomSeeding -> 2]},
  ContinuousDisplacementQ[g, #] & /@ {d1, d2, DisplacementCompose[d1, d2]}]
```
