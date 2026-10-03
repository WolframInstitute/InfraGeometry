---
Template: Symbol
Name: InfraCylinder
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCylinder
Keywords: [cylinder, solid of revolution, region, inert head, volume]
SeeAlso: [InfraTube, InfraCone, InfraBall, InfraMeasurement, FindInfraRepresentative, FindInfraRevolution]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCylinder]()[*axis*, *r*]</code> is the cylinder of radius *r* about *axis*: the vertices at distance at most *r* from it. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCylinder]()[*axis*, {*r*, *s*}]</code> is the mantle: the vertices at distance between *r* and *s*.

## Details & Options

Definition: the cylinder of radius *r* about *axis* is *{v : d(v, axis) ≤ r}*, the solid of revolution of the constant radius profile.

It is the blog's word for [InfraTube]() with an axis for a core, and has its own definition. *axis* is a vertex list, or a Euclidean head.

The head computes nothing. A cylinder has one member, the vertex set, and owns the same seven properties as [InfraBall]().

## Basic Examples

The cylinder of radius 1 about a segment on the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
    {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
    InfraSubstrateHighlight[g, {InfraCylinder[axis, 1] -> $InfraBallColor, axis -> $InfraSegmentColor}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

## Properties and Relations

The cylinder is the tube about the axis.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
  FindInfraRepresentative[g, InfraCylinder[axis, 2]] === FindInfraRepresentative[g, InfraTube[axis, 2]]]
```

The cylinder is the solid of revolution of [FindInfraRevolution]() for the constant profile.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
  FindInfraRepresentative[g, InfraCylinder[axis, 1]] === FindInfraRevolution[g, axis, ConstantArray[1, Length @ axis], Method -> "Balls"]]
```
