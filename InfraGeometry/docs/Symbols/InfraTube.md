---
Template: Symbol
Name: InfraTube
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTube
Keywords: [tube, neighbourhood, region, inert head, volume, counting measure, Riemannian measure]
SeeAlso: [InfraCylinder, InfraCone, InfraBall, InfraMeasurement, FindInfraRepresentative, InfraSegment, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraTube]()[*core*, *s*]</code> is the tube of radius *s* about *core*: the vertices at distance at most *s* from it. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraTube]()[*core*, {*s*, *t*}]</code> is the mantle: the vertices at distance between *s* and *t*.

## Details & Options

Definition: the tube of radius *s* about *core* is *{v : d(v, core) ≤ s}*.

*core* is a vertex, a vertex list, a density, a walk graph, or a Euclidean head such as [InfraSegment](), read through the keys of its `"VertexDensity"`. The tube of a vertex is the ball.

The tube of a segment is the tube of its whole interval, not of one shortest path. Where the segment has many shortest paths it is fatter than the tube of any of them. The tube of one path takes as its core a member that [FindInfraRepresentative]() gives.

[InfraMeasurement]() gives two measures of a tube:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the tube |
| `"RiemannianMeasure"` | the number of vertices of the tube all of whose neighbours lie in the tube: the count without the boundary |

The Riemannian measure of the tube of radius *s* always counts the tube of radius *s − 1*; on the square grid, away from the rim, it counts nothing more. The tube of radius 0 of a segment is its interval, and its Riemannian measure counts the inner vertices of the interval: `0` when the segment has one shortest path.

The head computes nothing. A tube has one member, the vertex set. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`. The tube is the primitive behind [InfraCylinder]() and [InfraCone](). A tube of an empty core is empty.

## Basic Examples

The tube of radius 2 about a segment on the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure counts the inner vertices, in green; the counting measure adds the boundary, in blue.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {tube = InfraTube[InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])], 2]},
    {support = FindInfraRepresentative[g, tube]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> $InfraBallColor, InfraBoundary[g, support] -> $InfraCircleColor}],
      InfraMeasurement[g, tube, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The two measures against the radius, about a segment of length 6 on the square grid. The Riemannian profile is the counting profile one radius later.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {seg = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 6])]},
  ListLinePlot[
    Table[InfraMeasurement[g, InfraTube[seg, s], measure], {measure, {"CountingMeasure", "RiemannianMeasure"}}, {s, 0, 5}],
    DataRange -> {0, 5}, PlotMarkers -> Automatic, PlotLegends -> {"CountingMeasure", "RiemannianMeasure"}, AxesLabel -> {"s", None}]]
```

The mantle of radii 2 and 3 about a segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {seg = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]},
  InfraSubstrateHighlight[g, {InfraTube[seg, {2, 3}] -> $InfraShellColor, seg -> $InfraSegmentColor}]]
```

## Properties and Relations

The tube of a segment against the tube of one of its shortest paths, both of radius 1: the first holds every shortest path, so it is fatter.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {seg = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 4])]},
  {tubes = {InfraTube[seg, 1], InfraTube[FindInfraRepresentative[g, seg], 1]}},
  {Row[InfraSubstrateHighlight[g, {#}] & /@ tubes], InfraMeasurement[g, tubes, "CountingMeasure"]}]
```

The tube of a vertex is the ball.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = InfraCenter[g]},
  FindInfraRepresentative[g, InfraTube[c, 3]] === FindInfraRepresentative[g, InfraBall[c, 3]]]
```
