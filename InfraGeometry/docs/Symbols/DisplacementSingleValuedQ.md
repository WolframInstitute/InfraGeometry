---
Template: Symbol
Name: DisplacementSingleValuedQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementSingleValuedQ
Keywords: [displacement, single-valued, map, multivalued, tie]
SeeAlso: [DisplacementBijectionQ, DisplacementReduce, DisplacementInverse, RandomDisplacement, PolarDisplacements]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementSingleValuedQ]()[*d*]</code> gives [True]() when every value of the displacement *d* is a single vertex, and [False]() otherwise.

## Details & Options

*D* is single-valued when *|D(v)| = 1* for every vertex *v*. It is then a map of the vertices.

A displacement is set-valued where the metric or the coordinates do not decide between several vertices. Composition keeps single values; the inverse, the negative, scaling and the sum do not in general. [DisplacementReduce]() contracts the sets the metric decides.

An empty value is not a single vertex.

## Basic Examples

A random displacement is single-valued, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {d = RandomDisplacement[g, 1, RandomSeeding -> 1]},
    DisplacementPlot[g, d, PlotLabel -> DisplacementSingleValuedQ[d]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The outward radial displacement is not: a vertex of the grid off the axes through the centre has two neighbours further out:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {radial = First @ PolarDisplacements[g, First @ GraphCenter[g]]},
  DisplacementPlot[g, radial, PlotLabel -> DisplacementSingleValuedQ[radial]]]
```

## Scope

A translation can tie. At the pendant vertices 81 and 90, at the right end of the bottom and the top rows of the grid, the translated point is equally near two vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {right = TranslationDisplacement[g, {1, 0}]},
  {DisplacementSingleValuedQ[right], Select[right, Length[#] > 1 &]}]
```

An empty value is not single. The inverse of the step right is empty where nothing arrives:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {inverse = DisplacementInverse[TranslationDisplacement[g, {1, 0}]]},
  {DisplacementSingleValuedQ[inverse], Count[inverse, {}]}]
```

## Properties and Relations

A composite of single-valued displacements is single-valued:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d1 = RandomDisplacement[g, 1, RandomSeeding -> 1], d2 = RandomDisplacement[g, 2, RandomSeeding -> 2]},
  DisplacementSingleValuedQ[DisplacementCompose[d1, d2]]]
```

A symmetry of the graph is single-valued:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementSingleValuedQ[FindKillingDisplacement[g]]]
```
