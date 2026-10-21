---
Template: Symbol
Name: RandomInfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraCircle
Keywords: [circle, cycle, separating cycle, band, circumference]
SeeAlso: [InfraCircle, InfraCircleQ, InfraShell, RandomInfraArc, RandomInfraCircleThrough]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraCircle]()[*g*, [InfraCircle]()[*c*, *r*]]</code> gives a random circle of radius *r* about *c* in *g*, as a cyclic vertex list.

<code>[RandomInfraCircle]()[*g*, [InfraCircle]()[*c*, {*r*, *s*}]]</code> gives a random circle in the band of radii *r* to *s*.

<code>[RandomInfraCircle]()[*g*, [InfraCircle]()[*c*, *r*], *n*]</code> gives a list of *n* distinct circles.

<code>[RandomInfraCircle]()[*g*, *c*, *r*]</code> and <code>[RandomInfraCircle]()[*g*, *c*, *r*, *n*]</code> are the same with the centre and the radius given directly.

## Details & Options

A circle in the band *W = {v : r ≤ d(c, v) ≤ s}* is a shortest cycle of the subgraph induced on *W* that separates *c* from the vertices beyond *s*. The radius *r* is the band {*r*, *r*}.

A shell can have no edges. On the square grid, which is bipartite, a circle of one radius does not exist. The band {*r*, *r* + 1} has exactly one circle, of length *8r*. In the plane the circumference is *2πr*; *8* is the perimeter of the ℓ¹ unit circle.

A circle is returned as a vertex list *v₁, …, vₖ*, the edge *vₖv₁* closing it. The draw is uniform over the circles of the band.

The count *n* can be `n`, `UpTo[n]` or `All`. A count above the number of circles gives `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first circles in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A circle in the band of radii 3 to 4 about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {circle = RandomInfraCircle[g, InfraCircle[c, {3, 4}], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[c, {3, 4}], InfraWalk[Append[circle, First @ circle]], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the circle of the band {*r*, *r* + 1} is unique and has length *8r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  Table[Length /@ RandomInfraCircle[g, InfraCircle[c, {r, r + 1}], All], {r, 1, 5}]]
```

The mesh has circles of one radius. The circle of radius 3 has 21 vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {circle = RandomInfraCircle[g, c, 3, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c}, PlotLabel -> Length[circle],
    ImageSize -> Medium]]
```

## Scope

The band {3, 4} of the mesh has 14 circles, all of length 21. Three of them:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c}],
    {circle, RandomInfraCircle[g, InfraCircle[c, {3, 4}], 3, RandomSeeding -> 1]}]]
```

## Properties and Relations

Removing a circle cuts the centre off from the vertices beyond the band. The farthest vertex left with the centre is at distance 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {circle = RandomInfraCircle[g, InfraCircle[c, {3, 4}], RandomSeeding -> 1]},
  Max[GraphDistance[g, c, #] & /@ VertexComponent[VertexDelete[g, circle], c]]]
```

A circle of one radius is a cycle on a shell, and [InfraCircleQ]() holds:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraCircleQ[g, RandomInfraCircle[g, c, 3, RandomSeeding -> 1]]]
```

## Possible Issues

The grid has no circle of one radius: the shell has no edges.

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {RandomInfraCircle[g, c, 3], EdgeCount @ Subgraph[g, RandomInfraPoint[g, InfraShell[c, 3], All]]}]
```
