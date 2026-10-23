---
Template: Symbol
Name: InfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraArc
Keywords: [arc, circle, band, minor arc, closed arc, symbolic object]
SeeAlso: [ArcGraph, InfraAngle, InfraCircle, InfraSegment, InfraMeasurement, RandomInfraArc, InfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraArc]()[*c*, {*p*, *q*}]</code> is the arc around *c* from *p* to *q*: the shortest paths from *p* to *q* inside the band of the circle through *p*.

<code>[InfraArc]()[*c*, {*p1*, …, *pk*}]</code> is the polyline of the arcs from each point to the next.

<code>[InfraArc]()[*c*, {*p*, *p*}]</code> or <code>[InfraArc]()[*c*, {*p*}]</code> is the closed arc: the circles around *c* through *p*.

## Details & Options

With *r = d(c, p)* the band is *W = {v : r − δᵢₙ ≤ d(c, v) ≤ r + δₒᵤₜ}*. An arc from *p* to *q* is a shortest path from *p* to *q* in the subgraph induced on *W*. It is empty when *q* is not in *W* or *W* does not connect *p* to *q*.

On a bipartite graph, such as the square grid, no two vertices of one shell are adjacent, so the bare shell carries no arc. Widen the band.

The closed arc is the family of the circles of the band through *p*: the shortest cycles of *W* through *p* whose removal cuts *c* off from everything beyond the band. These are the members of [InfraCircle]() through *p*. <code>[InfraArc]()[*c*, {*p*, *q*, *p*}]</code> keeps the circles through *q* as well.

Arcs are not unique. On the square grid with the band {*r*, *r* + 1}, away from the rim, the circle through a vertex at distance *r* is unique and has length *8r*: the circle of the ℓ¹ norm, whose circumference is 8 times its radius, not 2π.

[InfraArc]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [RandomInfraArc]() draws members. A member is a vertex list; a closed member does not repeat its first vertex, and its length counts the closing edge.

| Property | Value |
|---|---|
| `"Graph"` | the DAG of the arcs, as [ArcGraph]() |
| `"Cardinality"` | the number of arcs |
| `"Length"` | their common length; `{}` when there is none |
| `"VertexDensity"` | the number of arcs through each vertex |

The cardinality of a polyline is the product over its pieces. Each piece uses the band of its own first point.

Options:

| Option | Default | Values |
|---|---|---|
| `"RadiusDelta"` | `0` | *δ* for the band {*r*, *r* + *δ*}; {*δᵢₙ*, *δₒᵤₜ*} for {*r* − *δᵢₙ*, *r* + *δₒᵤₜ*} |

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To describe a circle with any centre and distance; the closed arc is the circle drawn by a compass opened to *p*. |

## Basic Examples

An arc of the circle of radius 3 between two of its points that are farthest apart, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraArc[c, pq, "RadiusDelta" -> 1], c, pq}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The closed arc through a point at distance 3. On the grid it is one circle, on the mesh many:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]}, {circle = InfraArc[c, {p}, "RadiusDelta" -> 1]},
    InfraSubstrateHighlight[g, {circle, c, p}, PlotLabel -> InfraMeasurement[g, circle, {"Cardinality", "Length"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of arcs and their length on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> 1], {"Cardinality", "Length"}]]
```

## Scope

A polyline through an intermediate vertex *m* at distance 3 keeps the arcs that pass through *m*. Its cardinality is the number of arcs through *m*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {density = InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> 1], "VertexDensity"]},
  {m = First @ MinimalBy[Select[Keys[density], GraphDistance[g, c, #] == 3 &], density]},
  {polyline = InfraArc[c, {First[pq], m, Last[pq]}, "RadiusDelta" -> 1]},
  InfraSubstrateHighlight[g, {polyline, c, pq, m}, PlotLabel -> {InfraMeasurement[g, polyline, "Cardinality"], density[m]},
    ImageSize -> Medium]]
```

## Options

### RadiusDelta

The bare shell of the grid carries no arc. The band {3, 4} carries one, the band {2, 4} a shorter family that cuts inside:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraArc[c, pq, "RadiusDelta" -> delta], InfraShell[c, 3], pq},
      PlotLabel -> InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> delta], {"Cardinality", "Length"}]],
    {delta, {0, 1, {1, 1}}}]]
```

## Properties and Relations

On the square grid the closed arc through a vertex at distance *r*, with the band {*r*, *r* + 1}, is one circle of length *8r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  Table[InfraMeasurement[g, InfraArc[c, {RandomInfraPoint[g, InfraShell[c, r], RandomSeeding -> 1]}, "RadiusDelta" -> 1],
    {"Cardinality", "Length"}], {r, 1, 7}]]
```

The closed arc through *p* has the circles of [InfraCircle]() that pass through *p*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {closed = RandomInfraArc[g, InfraArc[c, {p}, "RadiusDelta" -> 1], All]},
  {circles = Select[RandomInfraCircle[g, InfraCircle[c, {3, 4}], All], MemberQ[#, p] &]},
  Sort[Sort /@ closed] === Sort[Sort /@ circles]]
```
