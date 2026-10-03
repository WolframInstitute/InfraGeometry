---
Template: Symbol
Name: InfraTube
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTube
Keywords: [tube, neighbourhood, region, inert head, volume]
SeeAlso: [InfraCylinder, InfraCone, InfraBall, InfraMeasurement, FindInfraRepresentative, InfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraTube]()[*core*, *s*]</code> is the tube of radius *s* about *core*: the vertices at distance at most *s* from it. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraTube]()[*core*, {*s*, *t*}]</code> is the mantle: the vertices at distance between *s* and *t*.

## Details & Options

Definition: the tube of radius *s* about *core* is *{v : d(v, core) ≤ s}*.

*core* is a vertex, a vertex list, a density, a walk graph, or a Euclidean head such as [InfraSegment](), read through the keys of its `"VertexDensity"`. The tube of a vertex is the ball, and the tube of a segment is the tube of the interval.

The head computes nothing. A tube has one member, the vertex set, and owns the same seven properties as [InfraBall]().

The tube is the primitive behind [InfraCylinder]() and [InfraCone]().

A tube of an empty core is empty.

## Basic Examples

The tube of radius 2 about a segment on the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
    {seg = InfraSegment[c, p]},
    InfraSubstrateHighlight[g, {InfraTube[seg, 2] -> $InfraBallColor, seg -> $InfraSegmentColor}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The mantle of a tube is the vertices at distance 2 and 3 from the segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {seg = InfraSegment[c, p]},
  InfraSubstrateHighlight[g, {InfraTube[seg, {2, 3}] -> $InfraShellColor, seg -> $InfraSegmentColor}]]
```

## Properties and Relations

The tube of a vertex is the ball.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  FindInfraRepresentative[g, InfraTube[c, 3]] === FindInfraRepresentative[g, InfraBall[c, 3]]]
```

The tube about a segment holds the ball of every vertex of the interval, so its counting measure at slack 0 is the number of vertices of the interval.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  InfraMeasurement[g, InfraTube[InfraSegment[c, p], 0], "CountingMeasure"] === InfraMeasurement[g, InfraSegment[c, p], "CountingMeasure"]]
```
