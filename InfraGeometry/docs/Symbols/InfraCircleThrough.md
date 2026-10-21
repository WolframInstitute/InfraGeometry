---
Template: Symbol
Name: InfraCircleThrough
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircleThrough
Keywords: [circle, prescribed points, separating cycle, band]
SeeAlso: [InfraCircle, InfraArc, RandomInfraCircleThrough, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircleThrough]()[{*p1*, …, *pk*}, [InfraCircle]()[*c*, {*r*, *s*}]]</code> is the family of the shortest circles around *c* in the band {*r*, *s*} that pass through every point *pᵢ*.

## Details & Options

Let *W = {v : r ≤ d(c, v) ≤ s}*. A member is a simple cycle in *W* that contains every *pᵢ* and whose removal cuts *c* off from every vertex beyond *W*. Among those cycles the shortest are kept, all of them.

The points come first and the length second. So the circles through the points can be longer than the circles of <code>[InfraCircle]()[*c*, {*r*, *s*}]</code>, and when none of those passes through the points, filtering them gives nothing while [InfraCircleThrough]() still has members.

The order and repetition of the points do not matter. The radii satisfy *1 ≤ r ≤ s*. A point outside the band gives the empty family: cardinality 0 and length `Infinity`.

[InfraCircleThrough]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [RandomInfraCircleThrough]() draws members. A member is a cyclic vertex list; its first vertex is not repeated.

| Property | Value |
|---|---|
| `"Graph"` | a DAG whose source-to-sink paths are the circles |
| `"Faithful"` | `True` |
| `"Cardinality"` | the number of circles |
| `"Length"` | their common length |
| `"VertexDensity"` | the number of circles through each vertex |
| `"EdgeDensity"` | the number of circles through each edge |

The family is found by a search over vertex sets, which can take exponential time on a wide band.

## Basic Examples

The shortest circles of the band {1, 3} through a vertex at distance 3, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraCircleThrough[{p}, InfraCircle[c, {1, 3}]], c, p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

They are longer than the shortest circles of the band:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    InfraMeasurement[g, #, {"Cardinality", "Length"}] & /@ {InfraCircleThrough[{p}, InfraCircle[c, {1, 3}]], InfraCircle[c, {1, 3}]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The two circles through the point on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c, p}],
    {circle, RandomInfraCircleThrough[g, InfraCircleThrough[{p}, InfraCircle[c, {1, 3}]], All]}]]
```

## Scope

Circles through two farthest points of the shell of radius 2 on the mesh, in the band {1, 2}:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 2], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {circle = InfraCircleThrough[pq, InfraCircle[c, {1, 2}]]},
  InfraSubstrateHighlight[g, {circle, c, pq}, PlotLabel -> InfraMeasurement[g, circle, {"Cardinality", "Length"}], ImageSize -> Medium]]
```

A point outside the band gives the empty family:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]},
  InfraMeasurement[g, InfraCircleThrough[{p}, InfraCircle[c, {1, 3}]], {"Cardinality", "Length"}]]
```

## Properties and Relations

No shortest circle of the band passes through the point, so filtering [InfraCircle]() gives nothing:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {Select[RandomInfraCircle[g, InfraCircle[c, {1, 3}], All], MemberQ[#, p] &],
   InfraMeasurement[g, InfraCircleThrough[{p}, InfraCircle[c, {1, 3}]], "Cardinality"]}]
```

## Possible Issues

A point with only one neighbour in the band lies on no cycle. Of two farthest points of the shell of radius 3 on the grid, the first has one neighbour in the band {1, 3} and no circle, the second two neighbours and two circles:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {band = Subgraph[g, Keys @ InfraMeasurement[g, InfraShell[c, {1, 3}], "VertexDensity"]]},
  {VertexDegree[band, #] & /@ pq, InfraMeasurement[g, InfraCircleThrough[{#}, InfraCircle[c, {1, 3}]], "Cardinality"] & /@ pq}]
```
