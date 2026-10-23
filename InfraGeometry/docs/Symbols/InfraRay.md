---
Template: Symbol
Name: InfraRay
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRay
Keywords: [ray, half-line, pencil, legacy, symbolic object]
SeeAlso: [InfraHalfLine, RandomInfraRay, RandomInfraHalfLine, InfraRayQ, InfraMeasurement, InfraLine]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraRay]()[*p*, *q*]</code> is the ray from *p* through *q*, the same as <code>[InfraHalfLine]()[*p*, *q*]</code>.

<code>[InfraRay]()[*p*, *p*]</code> is the pencil at *p*: every ray from *p*.

## Details & Options

[InfraRay]() is the older name of [InfraHalfLine](). New code uses [InfraHalfLine]().

A ray from *p* is a shortest path from *p* that no neighbour of its last vertex prolongs. <code>[InfraRay]()[*p*, *q*]</code> is the family of all rays from *p* through *q*.

[InfraMeasurement](), [InfraMemberQ](), [InfraSubstrateHighlight]() and [RandomInfraHalfLine]() read <code>[InfraRay]()[…]</code> as <code>[InfraHalfLine]()[…]</code>. [RandomInfraRay]() and [InfraRayQ]() are the older names of [RandomInfraHalfLine]() and [InfraHalfLineQ]().

## Basic Examples

The ray from the centre through a vertex at distance 2, on the square grid and on the square mesh. Past that vertex it fans out to the rim:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {ray = InfraRay[p, q]},
    InfraSubstrateHighlight[g, {ray, p, q}, PlotLabel -> InfraMeasurement[g, ray, "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The pencil at the centre, every ray from it at once:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]}, {pencil = InfraRay[p, p]},
    InfraSubstrateHighlight[g, {pencil, p}, PlotLabel -> InfraMeasurement[g, pencil, "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

[InfraRay]() and [InfraHalfLine]() have the same measurements:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {props = {"Cardinality", "Length", "CountingMeasure"}},
  InfraMeasurement[g, InfraRay[p, q], props] === InfraMeasurement[g, InfraHalfLine[p, q], props]]
```

Every member drawn by [RandomInfraRay]() is a ray:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  AllTrue[RandomInfraRay[g, InfraRay[p, q], 10, RandomSeeding -> 1], InfraHalfLineQ[g, #] &]]
```
