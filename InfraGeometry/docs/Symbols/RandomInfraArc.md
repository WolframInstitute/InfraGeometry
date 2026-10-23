---
Template: Symbol
Name: RandomInfraArc
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraArc
Keywords: [arc, circle, band, shortest path in a band]
SeeAlso: [InfraArc, ArcGraph, RandomInfraCircle, InfraCircle, InfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraArc]()[*g*, [InfraArc]()[*c*, {*p*, *q*}]]</code> gives a random arc about *c* from *p* to *q* in *g*, as a vertex list.

<code>[RandomInfraArc]()[*g*, [InfraArc]()[*c*, {*p*}]]</code> gives a random circle about *c* through *p*.

<code>[RandomInfraArc]()[*g*, [InfraArc]()[*c*, {*p1*, …, *pk*}]]</code> gives a random member of the polyline of arcs from each point to the next.

<code>[RandomInfraArc]()[*g*, *arc*, *n*]</code> gives a list of *n* distinct members of *arc*.

<code>[RandomInfraArc]()[*g*, *c*, {*p*, *q*}]</code> and <code>[RandomInfraArc]()[*g*, *c*, {*p*, *q*}, *n*]</code> are the same with the centre and the points given directly.

## Details & Options

With *r = d(c, p)*, an arc from *p* to *q* is a shortest path from *p* to *q* in the subgraph induced on the band *W = {v : r ≤ d(c, v) ≤ r + δ}*. The closed arc <code>[InfraArc]()[*c*, {*p*}]</code> is the family of the circles of the band through *p*, as in [RandomInfraCircle]().

On the square grid no two vertices of one shell are adjacent, so δ = 0 gives no arc. With δ = 1 the arc between opposite points of the circle of radius *r* has length *4r*, half the circle.

There is no arc when *q* is not in the band or the band does not connect *p* to *q*. Then the result is `{}`.

The draw is uniform over the arcs.

Options:

| Option | Default | Values |
|---|---|---|
| `"RadiusDelta"` | `0` | *δ* for the band {*r*, *r* + *δ*}; {*δᵢₙ*, *δₒᵤₜ*} for {*r* − *δᵢₙ*, *r* + *δₒᵤₜ*} |
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first arcs in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

`"RadiusDelta"` goes inside the [InfraArc]() token, or after the points in the direct form.

## Basic Examples

An arc between two points of the circle of radius 3, in the band {3, 4}, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 3]},
    {arc = RandomInfraArc[g, InfraArc[c, pq, "RadiusDelta" -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[c, {3, 4}], InfraWalk[arc], c, Sequence @@ pq}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the two points are opposite. The two arcs go round either side, each of length 12, half of the circle of length 24:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[arc], c, Sequence @@ pq}, PlotLabel -> Length[arc] - 1],
    {arc, RandomInfraArc[g, InfraArc[c, pq, "RadiusDelta" -> 1], All]}]]
```

The closed arc through a point of the mesh is the circle of radius 3 through it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {circle = RandomInfraArc[g, InfraArc[c, {p}], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c, p}, ImageSize -> Medium]]
```

## Options

### RadiusDelta

A wider band allows more arcs of the same length. The number of arcs and their length on the mesh, for *δ* = 0 and 1:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 1]},
  Table[δ -> {Length @ RandomInfraArc[g, InfraArc[c, pq, "RadiusDelta" -> δ], All],
    InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> δ], "Length"]}, {δ, {0, 1}}]]
```

## Properties and Relations

The arcs are as many as the cardinality of the arc, and none is shorter than the distance of its ends:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 1]},
  {arcs = RandomInfraArc[g, InfraArc[c, pq, "RadiusDelta" -> 1], All]},
  {Length[arcs] == InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> 1], "Cardinality"],
   Union[Length /@ arcs] - 1, GraphDistance[g, Sequence @@ pq]}]
```

## Possible Issues

On the grid the bare shell has no edges, and the arc of `"RadiusDelta" -> 0` is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> 6, RandomSeeding -> 3]},
  RandomInfraArc[g, InfraArc[c, pq], RandomSeeding -> 1]]
```
