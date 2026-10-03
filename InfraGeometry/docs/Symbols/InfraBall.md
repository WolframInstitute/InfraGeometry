---
Template: Symbol
Name: InfraBall
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBall
Keywords: [ball, disk, neighbourhood, region, inert head, volume]
SeeAlso: [InfraShell, InfraTube, InfraSphere, FindInfraRepresentative, InfraMeasurement, InfraBallQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBall]()[*c*, *r*]</code> is the closed ball of radius *r* about *c*: the vertices at distance at most *r*. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraBall]()[*c*, {*r*, *s*}]</code> is the shell: the vertices at distance between *r* and *s*.

<code>[InfraBall]()[*c*, *r*]</code> inside an [InfraScene]() is the ball construction token.

## Details & Options

Definition: the closed ball of radius *r* about *c* is *B_r(c) = {v : d(c, v) ≤ r}*. *c* is a vertex or a vertex list, and then *d(v, C) = min d(v, c)* and the ball is the *r*-neighbourhood of *C*.

The head holds the centre and the radius and computes nothing. A ball has one member, the vertex set, so [FindInfraRepresentative]() gives it as a sorted vertex list and `"Faithful"` is `True`.

[InfraMeasurement]() reads seven properties: `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"`, `"Subgraph"` and the two measures `"CountingMeasure"`, the number of vertices of the ball, and `"RiemannianMeasure"`, the number of vertices all of whose neighbours lie in the ball. A ball has no `"Graph"` and no `"Length"`; asking for them leaves the call unevaluated.

A radius past the eccentricity gives the whole graph; a band with *r > s* gives the empty set.

The profile of the ball against its radius is the `Table` of its measures over *r*; the Riemannian measure of the ball of radius *r* in the bulk of a lattice is the counting measure of radius *r − 1*.

## Basic Examples

The ball of radius 4 about the centre of the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    InfraSubstrateHighlight[g, {InfraBall[c, 4] -> $InfraBallColor, Directive[$InfraPointColor], c}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The volume of the ball against its radius on the square grid. It is *2 r^2 + 2 r + 1*.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  ListLinePlot[Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 6}], DataRange -> {0, 6}, PlotMarkers -> Automatic]]
```

## Scope

A ball about a vertex list is the neighbourhood of the list: here of a segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {core = FindInfraRepresentative[g, InfraSegment[c, p]]},
  InfraSubstrateHighlight[g, {InfraBall[core, 1] -> $InfraBallColor, core -> $InfraSegmentColor}]]
```

All the properties of a ball at once.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraBall[13, 1], All]
```

## Properties and Relations

The ball is the union of the shells up to its radius, so the counting profile is the partial sums of the shell areas.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  {volumes = Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 5}]},
  {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 0, 5}]},
  volumes === Accumulate[areas]]
```

The Riemannian measure of the ball on the square grid is *2 r^2 − 2 r + 1*, the counting measure of radius *r − 1*.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = InfraCenter[g]},
  Table[InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"], {r, 1, 5}] === Table[2 r^2 - 2 r + 1, {r, 1, 5}]]
```

Inside a scene the token names the ball about a point, and [FindInfraScene]() binds it to the same vertex set.

```wl
ClearAll[pA, ballA];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {constr = InfraScene[{pA, ballA}, {pA == InfraPoint[c], ballA == InfraBall[pA, 2]}]},
  {ball = InfraSceneInstance[First @ FindInfraScene[constr, g], ballA]},
  {InfraSubstrateHighlight[g, {ball -> $InfraBallColor, Directive[$InfraPointColor], c}],
   ball === FindInfraRepresentative[g, InfraBall[c, 2]]}]
```
