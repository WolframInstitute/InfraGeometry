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

The tube of a segment is the tube of its whole interval, not of one shortest path: the *fat tube* <code>[InfraTube]()[[InfraSegment]()[*c*, *p*], *s*]</code>. Where the segment has many shortest paths it is fatter than the tube of any of them. The *thin tube* of one path takes as its core a member that [FindInfraRepresentative]() gives, <code>[InfraTube]()[[FindInfraRepresentative]()[*g*, [InfraSegment]()[*c*, *p*]], *s*]</code>.

[InfraMeasurement]() gives two measures of a tube:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the tube |
| `"RiemannianMeasure"` | the number of vertices of the tube all of whose neighbours lie in the tube: the count without the boundary |

The Riemannian measure of the tube of radius *s ≥ 1* counts the tube of radius *s − 1* and the vertices at distance *s* from the core that have no neighbour at distance *s + 1*. For the fat tube on the square and the cubic grids, away from the rim, there are none, so the Riemannian profile is the counting profile one step later. The tube of radius 0 of a segment is its interval, and its Riemannian measure counts the inner vertices of the interval: `0` when the segment has one shortest path.

On *Z^d* the fat tube has an exact count. The interval of *c* and *p* is the box with sides *a_i = |p_i − c_i|*, and the tube of radius *s* about it has *Σ_J 2^|J| C(s, |J|) Π_(i ∉ J) (a_i + 1)* vertices, the sum over the sets *J* of coordinates, with *C* the binomial coefficient. On the square grid this is

*(a_1 + 1)(a_2 + 1) + 2s(a_1 + a_2 + 2) + 2s(s − 1)*,

where *(a_1 + 1)(a_2 + 1)* is the number of vertices of the interval and *a_1 + a_2* the length of the segment. The Riemannian measure is the same count at *s − 1*, for *s ≥ 1*. A straight segment along an axis has one shortest path, and there the thin tube is the fat one, the case *a_2 = 0*. The thin tube of a staircase path has no closed form.

In the continuum two tubes are the references. Gray's expansion is for the tube of normal geodesic discs about a geodesic *γ* of length *L* with unit tangent *u* in a Riemannian manifold of dimension *n*: *ω_(n−1) s^(n−1) ∫_0^L (1 − (Scal + Ric(u, u)) s² / (6(n + 1)) + O(s⁴)) dt*, with *ω_k* the volume of the Euclidean unit *k*-ball. The set of points within *s* of a segment adds two half-balls at its ends; in Euclidean space its volume is *ω_(n−1) s^(n−1) L + ω_n s^n*, the spherocylinder. The thin tube is the graph counterpart of these, whose core is a curve. The fat tube is not: on *Z^d* its core is a box, which grows with the offset of the two ends.

How the number is measured: <code>[InfraMeasurement]()[*g*, [InfraTube]()[*core*, *s*], *measure*]</code> takes the vertices within *s* of the support of the core, the interval for a segment and one path for a representative, and counts them, or counts their [InfraInterior](). The profile is the list over *s = 0, 1, …*.

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

The fat tube about a segment of length 5 on the square grid against the box count, with *(a_1 + 1)(a_2 + 1)* the size of the interval and *a_1 + a_2 = 5*, and the thin tube about one of its shortest paths below it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {fat = InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, c, 5])]},
  {intervalSize = InfraMeasurement[g, fat, "CountingMeasure"]},
  {geodesic = FindInfraRepresentative[g, fat]},
  Show[
    Plot[intervalSize + 2 s (5 + 2) + 2 s (s - 1), {s, 0, 5}],
    ListPlot[{
      Table[InfraMeasurement[g, InfraTube[fat, s], "CountingMeasure"], {s, 0, 5}],
      Table[InfraMeasurement[g, InfraTube[geodesic, s], "CountingMeasure"], {s, 0, 5}]}, DataRange -> {0, 5}, PlotMarkers -> Automatic]]]
```

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
