---
Template: Symbol
Name: RandomInfraRegularPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRegularPolygon
Keywords: [regular polygon, equilateral triangle, square, hexagon, diagonal, polygon, random]
SeeAlso: [InfraRegularPolygon, InfraRegularPolygonQ, RandomInfraPoint, InfraSegment, RandomInfraCircle]
---

## Usage

<code>[RandomInfraRegularPolygon]()[*g*, {*a1*, …, *am*}, *n*]</code> gives a random regular *n*-gon of *g* whose *k*-th diagonals have length *ak*, as the list of its sides.

<code>[RandomInfraRegularPolygon]()[*g*, {*a1*, …, *am*}, *n*, *count*]</code> gives a list of *count* distinct polygons.

<code>[RandomInfraRegularPolygon]()[*g*, [InfraRegularPolygon]()[{*a1*, …, *am*}, *n*], …]</code> gives each polygon as the closed vertex sequence along its sides.

## Details & Options

A regular *n*-gon is a cyclic sequence of distinct corners *v₁*, …, *vₙ* with *d(vᵢ, vᵢ₊ₖ)* the same for every *i*, indices mod *n*. The *k*-th entry of the tuple says which value the *k*-th diagonals take; *k* = 1 is the side. At most ⌊*n*/2⌋ entries are given, the rest are free.

| Entry | The *k*-th diagonals |
|---|---|
| an integer *a* | all of length *a* |
| {*lo*, *hi*} | all of one length between *lo* and *hi* |
| [Automatic]() | all of one length |

A side is a shortest path from a corner to the next, returned as a directed path graph. Polygons on the same corners in a different cyclic order are different polygons.

In the plane the side fixes a regular polygon up to motion. On a graph it does not: on the square grid the squares of side 2 are the axis squares of side 2, with diagonals 4, and the diamonds, the four neighbours of a vertex, with all six distances 2. Their corners can be taken in any order.

The count is *n*, `UpTo[n]` or `All`; fewer polygons than *n* give `{}`.

| Option | Default | Values |
|---|---|---|
| `"From"` | `All` | *v*: polygons with a corner at *v*; *v* `->` *r*: polygons within distance *r* of *v* |
| `"NextVertexFunction"` | `Automatic` | `Identity` takes the polygons in a fixed order instead of at random |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

An equilateral triangle of side 4 with a corner at the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {poly = RandomInfraRegularPolygon[g, {4}, 3, "From" -> c, RandomSeeding -> 5]},
    InfraSubstrateHighlight[g, {poly, First @ TopologicalSort[#] & /@ poly}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The squares of side 2 with a corner at the centre of the grid, by the length of their diagonal: 12 on diamonds, 4 axis squares:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {polys = RandomInfraRegularPolygon[g, {2, Automatic}, 4, All, "From" -> 45]},
  {corners = Map[First @ TopologicalSort[#] &, polys, {2}]},
  Counts[GraphDistance[g, #[[1]], #[[3]]] & /@ corners]]
```

One of each, with its corners. A side of the diamond may run through its centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
    {poly = RandomInfraRegularPolygon[g, {2, d}, 4, "From" -> 45, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {poly, First @ TopologicalSort[#] & /@ poly}]],
  {d, {2, 4}}]
```

## Scope

The token form gives the closed vertex sequence along the sides:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {seq = RandomInfraRegularPolygon[g, InfraRegularPolygon[{2, 4}, 4], "From" -> 45, RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[seq, First @ seq]]}, PlotLabel -> seq, ImageSize -> Medium]]
```

## Options

### From

`"From" -> v -> r` keeps the polygons within distance *r* of *v*. The squares of side 2 within distance 3 of the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Length @ RandomInfraRegularPolygon[g, {2, Automatic}, 4, All, "From" -> 45 -> 3]]
```

### RandomSeeding

A fixed seed gives the same polygon whatever [SeedRandom]() has set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[SeedRandom[k]; VertexList /@ RandomInfraRegularPolygon[g, {4}, 3, "From" -> 45, RandomSeeding -> 7],
    {k, 2}]]
```

## Properties and Relations

The polygons pass [InfraRegularPolygonQ]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  InfraRegularPolygonQ[g, RandomInfraRegularPolygon[g, {2, Automatic}, 4, All, "From" -> 45], {2, Automatic}]]
```
