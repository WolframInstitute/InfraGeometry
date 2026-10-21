---
Template: Symbol
Name: FindInfraEquidistantSet
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraEquidistantSet
SeeAlso: [InfraEquidistantSet, FindInfraBisectingHyperplane, InfraPerpendicularBisector, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraEquidistantSet]()[*g*, {*p1*, …, *pn*}]</code> gives the sorted list of the vertices at equal distance from all the points *pᵢ*.

<code>[FindInfraEquidistantSet]()[*g*, {*p1*, …, *pn*}, {*lo*, *hi*}]</code> gives the vertices *v* with *lo ≤ d(pᵢ, v) − d(pᵢ₊₁, v) ≤ hi* for each *i*.

## Details & Options

The equidistant set is *E(p₁, …, pₙ) = {v : d(p₁, v) = … = d(pₙ, v)}*, the intersection of the bisectors of consecutive points. For two points it is their bisector. For three points it is the set of the circumcentres: the centres of the circles through all three.

In the plane three points not on a line have one circumcentre. On a graph there can be none or several, at different radii.

On a bipartite graph, such as the square grid, the set is empty when two of the points are at odd distance. The slab form thickens each bisector and catches the vertices next to the missing one.

[InfraEquidistantSet]() is the same set as a symbolic object.

## Basic Examples

The equidistant set of three points of the circle of radius 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {FindInfraEquidistantSet[g, pts], pts}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the only circumcentre is the centre. On the mesh there are three, at the radii 4, 3 and 5:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
    AssociationMap[v |-> GraphDistance[g, v, #] & /@ pts, FindInfraEquidistantSet[g, pts]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

For two points it is the bisector:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  FindInfraEquidistantSet[g, {a, b}] === FindInfraBisectingHyperplane[g, a, b]]
```

Three points of the grid at the distances 11, 9 and 6 have no circumcentre. The slab {−1, 1} has two vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {pts = RandomInfraPoint[g, 3, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {FindInfraEquidistantSet[g, pts, {-1, 1}], pts},
    PlotLabel -> {GraphDistance[g, ##] & @@@ Subsets[pts, {2}], FindInfraEquidistantSet[g, pts]}, ImageSize -> Medium]]
```

## Properties and Relations

It is the support of [InfraEquidistantSet]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  FindInfraEquidistantSet[g, pts] === Keys @ InfraMeasurement[g, InfraEquidistantSet[pts], "VertexDensity"]]
```
