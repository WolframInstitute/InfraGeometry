---
Template: Symbol
Name: InfraCone
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCone
Keywords: [cone, solid of revolution, region, inert head, volume]
SeeAlso: [InfraTube, InfraCylinder, InfraBall, InfraMeasurement, FindInfraRepresentative, FindInfraRevolution]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCone]()[*axis*, *slope*]</code> is the cone along *axis* with apex *axis*[[1]]: the vertices within *slope* (*i* - 1) of the *i*-th vertex of the axis, for some *i*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

## Details & Options

Definition: with the axis *a_1, …, a_n*, the cone of slope *m* is *{v : d(v, a_i) ≤ m (i - 1) for some i}*, the union of the balls whose radius grows linearly from the apex.

*axis* is a vertex list, for example one representative of a segment or a ray. Reverse it for the other apex. The slope may be a rational number; slope 0 gives the axis.

The head computes nothing. A cone has one member, the vertex set, and owns the same seven properties as [InfraBall]().

## Basic Examples

The cone of slope 1/2 along a ray on the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
    {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
    InfraSubstrateHighlight[g, {InfraCone[axis, 1/2] -> $InfraBallColor, axis -> $InfraSegmentColor}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The same axis read from the other end gives the other apex.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCone[axis, 1] -> $InfraBallColor, axis -> $InfraSegmentColor}],
    InfraSubstrateHighlight[g, {InfraCone[Reverse @ axis, 1] -> $InfraBallColor, axis -> $InfraSegmentColor}]}]]
```

## Properties and Relations

The cone of slope 0 is the axis.

```wl
FindInfraRepresentative[GridGraph[{5, 5}], InfraCone[{1, 2, 3, 4, 5}, 0]]
```

The cone is contained in the cylinder of radius *slope* (*n* - 1).

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {axis = FindInfraRepresentative[g, InfraSegment[c, p]]},
  SubsetQ[FindInfraRepresentative[g, InfraCylinder[axis, Length[axis] - 1]], FindInfraRepresentative[g, InfraCone[axis, 1]]]]
```
