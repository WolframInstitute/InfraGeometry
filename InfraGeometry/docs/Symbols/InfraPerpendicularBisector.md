---
Template: Symbol
Name: InfraPerpendicularBisector
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPerpendicularBisector
Keywords: [perpendicular bisector, equidistant locus, bisector, midpoint]
SeeAlso: [InfraEquidistantSet, FindInfraEquidistantSet, InfraMidpoint, InfraMeasurement, InfraRegionNearest, InfraPlane]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraPerpendicularBisector]()[*p*, *q*]</code> is the perpendicular bisector of *p* and *q*: the vertices at equal distance from *p* and *q*.

## Details & Options

The bisector is *{v : d(p, v) = d(q, v) < ∞}*.

In the plane it is a line. On a graph it can be a line, a thick region or empty:

- In a bipartite graph, such as the square grid, *d(p, v) − d(q, v)* has the parity of *d(p, q)*, so at odd distance the bisector is empty.
- On the square grid, for *q* = *p* + (2, 0) it is the line *x* = 1 relative to *p*. For *q* = *p* + (*a*, *a*) it contains two whole quadrants, the bisector of the ℓ¹ norm.

The bisector need not separate *p* from *q*. [InfraPlane]() is the family of separating sets.

[InfraPerpendicularBisector]() is a symbolic object. [InfraMeasurement]() reads its `"VertexDensity"`, 1 on every vertex of the bisector, its `"CountingMeasure"`, `"RiemannianMeasure"` and `"Subgraph"`. Its `"Cardinality"` is 1: the bisector is one vertex set, even when empty. <code>[InfraMemberQ]()[*g*, *bisector*, *vs*]</code> tests whether *vs* is the whole bisector.

Equal anchors give their connected component. [InfraEquidistantSet]() is the bisector of several points.

## Basic Examples

The bisector of the centre and a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 2]},
    InfraSubstrateHighlight[g, {InfraPerpendicularBisector[p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the square grid the shape depends on the direction from *p* to *q*: a straight line, a staircase, two quadrants:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  GraphicsRow @ Table[
    With[{q = First @ Keys @ Select[xy, # - xy[p] == offset &]},
      InfraSubstrateHighlight[g, {InfraPerpendicularBisector[p, q], p, q},
        PlotLabel -> InfraMeasurement[g, InfraPerpendicularBisector[p, q], "CountingMeasure"]]],
    {offset, {{2, 0}, {3, 1}, {2, 2}}}]]
```

## Scope

At odd distance on the square grid the bisector is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  Table[InfraMeasurement[g, InfraPerpendicularBisector[p, RandomInfraPoint[g, InfraShell[p, r], RandomSeeding -> 1]], "CountingMeasure"],
    {r, 1, 4}]]
```

A random point of the bisector:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]},
  {x = RandomInfraPoint[g, InfraPerpendicularBisector[p, q], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraPerpendicularBisector[p, q], p, q, x}, PlotLabel -> {GraphDistance[g, p, x], GraphDistance[g, q, x]},
    ImageSize -> Medium]]
```

## Properties and Relations

At even distance the [InfraMidpoint]() is the part of the bisector inside the interval:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 6], RandomSeeding -> 1]},
  {interval = Keys @ InfraMeasurement[g, InfraSegment[p, q], "VertexDensity"]},
  Intersection[Keys @ InfraMeasurement[g, InfraPerpendicularBisector[p, q], "VertexDensity"], interval] ==
    Keys @ InfraMeasurement[g, InfraMidpoint[p, q], "VertexDensity"]]
```

The equidistant set of three points is the intersection of two bisectors:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 1]}, {r = RandomInfraPoint[g, InfraShell[p, 4], RandomSeeding -> 3]},
  Keys @ InfraMeasurement[g, InfraEquidistantSet[{p, q, r}], "VertexDensity"] ==
    Keys @ InfraMeasurement[g, InfraIntersection[InfraPerpendicularBisector[p, q], InfraPerpendicularBisector[q, r]], "VertexDensity"]]
```

## Possible Issues

A list of properties is not supported; ask for each property on its own:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {bisector = InfraPerpendicularBisector[p, RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]]},
  {AssociationQ @ InfraMeasurement[g, bisector, {"Cardinality", "CountingMeasure"}],
   InfraMeasurement[g, bisector, #] & /@ {"Cardinality", "CountingMeasure"}}]
```
