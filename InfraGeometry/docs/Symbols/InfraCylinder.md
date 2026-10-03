---
Template: Symbol
Name: InfraCylinder
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCylinder
Keywords: [cylinder, solid of revolution, region, inert head, volume, counting measure, Riemannian measure]
SeeAlso: [InfraTube, InfraCone, InfraBall, InfraMeasurement, FindInfraRepresentative, FindInfraRevolution, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCylinder]()[*axis*, *r*]</code> is the cylinder of radius *r* about *axis*: the vertices at distance at most *r* from it. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCylinder]()[*axis*, {*r*, *s*}]</code> is the mantle: the vertices at distance between *r* and *s*.

## Details & Options

Definition: the cylinder of radius *r* about *axis* is *{v : d(v, axis) ≤ r}*, the solid of revolution of the constant radius profile. *axis* is a vertex list, or a Euclidean head.

It is the blog's word for [InfraTube]() with an axis for a core, and has its own definition.

The cylinder has caps of half balls at both ends of the axis, since every vertex within *r* of an end vertex counts.

[InfraMeasurement]() gives two measures of a cylinder:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the cylinder |
| `"RiemannianMeasure"` | the number of vertices of the cylinder all of whose neighbours lie in it: the count without the mantle and the caps |

The cylinder of radius 0 is the axis, and its Riemannian measure is `0`: a path in a grid is all boundary.

The head computes nothing. A cylinder has one member, the vertex set. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`.

## Basic Examples

The cylinder of radius 1 about a shortest path on the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure counts the inner vertices, in green; the counting measure adds the boundary, in blue.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]]},
    {cylinder = InfraCylinder[axis, 1]},
    {support = FindInfraRepresentative[g, cylinder]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> $InfraBallColor, InfraBoundary[g, support] -> $InfraCircleColor}],
      InfraMeasurement[g, cylinder, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Properties and Relations

The cylinder is the tube about the axis.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]]},
  FindInfraRepresentative[g, InfraCylinder[axis, 2]] === FindInfraRepresentative[g, InfraTube[axis, 2]]]
```

The cylinder is the solid of revolution of [FindInfraRevolution]() for the constant profile.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]]},
  FindInfraRepresentative[g, InfraCylinder[axis, 1]] === FindInfraRevolution[g, axis, ConstantArray[1, Length @ axis], Method -> "Balls"]]
```
