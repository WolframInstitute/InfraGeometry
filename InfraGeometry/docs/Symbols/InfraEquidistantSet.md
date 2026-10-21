---
Template: Symbol
Name: InfraEquidistantSet
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEquidistantSet
Keywords: [equidistant locus, bisector, circumcentre, symbolic object]
SeeAlso: [InfraPerpendicularBisector, FindInfraEquidistantSet, InfraMeasurement, InfraMemberQ, InfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraEquidistantSet]()[{*p1*, …, *pn*}]</code> is the set of the vertices at equal finite distance from all the points *pᵢ*.

## Details & Options

The set is *E(p₁, …, pₙ) = {v : d(p₁, v) = … = d(pₙ, v) < ∞}*, the intersection of the bisectors of consecutive points. For two points it is [InfraPerpendicularBisector](). For three points it is the set of the circumcentres, which on a graph can be empty or have several vertices.

One point gives its connected component, no point the whole graph. Repeated points do not change the set.

[InfraEquidistantSet]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph, and [FindInfraEquidistantSet]() gives the same set as a list. It has one member, the set itself.

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on each vertex of the set |
| `"Cardinality"` | 1, also when the set is empty |
| `"CountingMeasure"` | the number of vertices |
| `"RiemannianMeasure"` | the number of vertices all of whose neighbours lie in the set |
| `"Subgraph"` | the subgraph induced on the set |

<code>[RandomInfraPoint]()[*g*, [InfraPoint]()[*set*]]</code> draws a vertex of the set.

## Basic Examples

The circumcentres of three points of the circle of radius 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraEquidistantSet[pts], pts}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The set is one object; on the mesh it has three vertices, none of them interior:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  InfraMeasurement[g, InfraEquidistantSet[pts], {"Cardinality", "CountingMeasure", "RiemannianMeasure"}]]
```

## Scope

For two points it is the perpendicular bisector:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraEquidistantSet[{a, b}], {a, b}},
    PlotLabel -> (InfraMeasurement[g, InfraEquidistantSet[{a, b}], "VertexDensity"] ===
      InfraMeasurement[g, InfraPerpendicularBisector[a, b], "VertexDensity"]),
    ImageSize -> Medium]]
```

A random circumcentre:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  RandomInfraPoint[g, InfraPoint[InfraEquidistantSet[pts]], RandomSeeding -> 1]]
```

## Properties and Relations

[InfraMemberQ]() is true only for the whole set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  {set = FindInfraEquidistantSet[g, pts]},
  {InfraMemberQ[g, InfraEquidistantSet[pts], set], InfraMemberQ[g, InfraEquidistantSet[pts], Rest[set]]}]
```

## Possible Issues

An empty set still counts as one object. Three points of the grid at the distances 11, 9 and 6 have no circumcentre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {pts = RandomInfraPoint[g, 3, RandomSeeding -> 1]},
  InfraMeasurement[g, InfraEquidistantSet[pts], {"Cardinality", "CountingMeasure"}]]
```
