---
Template: Symbol
Name: RandomInfraCircleThrough
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraCircleThrough
Keywords: [circle, circle through points, separating cycle, band]
SeeAlso: [InfraCircleThrough, InfraCircle, RandomInfraCircle, RandomInfraArc, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraCircleThrough]()[*g*, [InfraCircleThrough]()[{*p1*, …, *pk*}, [InfraCircle]()[*c*, {*r*, *s*}]]]</code> gives a random shortest circle about *c* in the band {*r*, *s*} through all the points *pᵢ*, as a cyclic vertex list.

<code>[RandomInfraCircleThrough]()[*g*, *token*, *n*]</code> gives a list of *n* distinct such circles.

<code>[RandomInfraCircleThrough]()[*g*, {*p1*, …, *pk*}, [InfraCircle]()[*c*, {*r*, *s*}], *n*]</code> is the same with the points and the circle given separately.

<code>[RandomInfraCircleThrough]()[*carrier*, *n*]</code> draws from the graph *carrier* returned by <code>[InfraMeasurement]()[*g*, *token*, "Graph"]</code>.

## Details & Options

With *W = {v : r ≤ d(c, v) ≤ s}*, a member is a simple cycle in *W* that contains every *pᵢ* and whose removal cuts *c* off from the vertices beyond *W*. Among these cycles the shortest are kept.

The points come first and the length second. So the circles through the points can be longer than the circles of <code>[InfraCircle]()[*c*, {*r*, *s*}]</code>.

A point outside the band, or one with fewer than two neighbours in it, gives `{}`.

The draw is uniform over the circles. A circle is a vertex list *v₁, …, vₖ*, the edge *vₖv₁* closing it.

The count *n* can be `n`, `UpTo[n]` or `All`. The search runs over vertex sets and can take very long on a wide band.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first circles in a fixed order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A circle through a vertex at distance 4 in the band {2, 4} of the square grid, and through a vertex of the circle of radius 3 of the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {band = If[name === "SquareGridGraph", {2, 4}, {3, 3}]},
    {p = RandomInfraPoint[g, InfraShell[c, Last[band]], RandomSeeding -> 1]},
    {circle = RandomInfraCircleThrough[g, InfraCircleThrough[{p}, InfraCircle[c, band]], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[c, band], InfraWalk[Append[circle, First @ circle]], c, p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The shortest circles of the grid band {2, 4} have length 16. None passes through that vertex; the shortest through it have length 18, and there are 32:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {Union[Length /@ RandomInfraCircle[g, InfraCircle[c, {2, 4}], All]],
   InfraMeasurement[g, InfraCircleThrough[{p}, InfraCircle[c, {2, 4}]], {"Cardinality", "Length"}]}]
```

Two of the circles through it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c, p}],
    {circle, RandomInfraCircleThrough[g, InfraCircleThrough[{p}, InfraCircle[c, {2, 4}]], 2, RandomSeeding -> 1]}]]
```

## Scope

A circle through two points 8 apart. There are 16 such circles of length 18:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {q = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 4]},
  {token = InfraCircleThrough[{p, q}, InfraCircle[c, {2, 4}]]},
  {circle = RandomInfraCircleThrough[g, token, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c, p, q},
    PlotLabel -> InfraMeasurement[g, token, {"Cardinality", "Length"}], ImageSize -> Medium]]
```

The graph of the family can be saved and drawn from again:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {carrier = InfraMeasurement[g, InfraCircleThrough[{p}, InfraCircle[c, {2, 4}]], "Graph"]},
  {Length @ RandomInfraCircleThrough[carrier, All], RandomInfraCircleThrough[carrier, RandomSeeding -> 1] ===
    RandomInfraCircleThrough[g, InfraCircleThrough[{p}, InfraCircle[c, {2, 4}]], RandomSeeding -> 1]}]
```

## Possible Issues

The centre is not in the band, so no circle passes through it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraCircleThrough[g, InfraCircleThrough[{c}, InfraCircle[c, {2, 4}]]]]
```
