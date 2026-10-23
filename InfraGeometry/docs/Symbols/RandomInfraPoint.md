---
Template: Symbol
Name: RandomInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraPoint
Keywords: [point, random point, region, ball, shell, pairwise distance, centre, periphery]
SeeAlso: [InfraPoint, InfraBall, InfraShell, InfraMeasurement, FindClosestInfraPoint, GraphCenter]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraPoint]()[*g*]</code> gives a random vertex of the graph *g*.

<code>[RandomInfraPoint]()[*g*, *n*]</code> gives a list of *n* distinct random vertices of *g*.

<code>[RandomInfraPoint]()[*g*, *reg*]</code> gives a random vertex of the region *reg*.

<code>[RandomInfraPoint]()[*g*, *reg*, *n*]</code> gives a list of *n* distinct random vertices of *reg*.

## Details & Options

[RandomInfraPoint]() is the graph analogue of [RandomPoint](). Its points are vertices, drawn uniformly from the region when no condition is given.

A region is a set of vertices, given as:

| Region | Vertices |
|---|---|
| `{v1, v2, …}` | the listed vertices |
| `<\|v -> m, …\|>` | the support of the density |
| <code>[InfraBall]()[*c*, *r*]</code>, <code>[InfraShell]()[*c*, *r*]</code>, <code>[InfraSegment]()[*a*, *b*]</code>, … | the vertices of the object |
| <code>[InfraUnion]()[*reg1*, *reg2*]</code>, <code>[InfraIntersection]()[*reg1*, *reg2*]</code> | the union, the intersection |
| <code>[InfraPoint]()[*v*]</code>, <code>[InfraPoint]()[]</code> | the vertex *v*; every vertex |

A single vertex is the region `{v}`. A bare integer is a count.

The count *n* can be `n`, `UpTo[n]` or `All`. An empty region, or a region with fewer than *n* vertices, gives `{}`.

`"PairwiseDistance"` is a condition on the whole tuple, not on one point:

| Value | The *n* points are |
|---|---|
| *d* | pairwise at distance *d* |
| {*dMin*, *dMax*} | pairwise at distance between *dMin* and *dMax* |
| `"Max"` | pairwise as far apart as the region allows |
| `"Spread"` | pairwise at distances as equal as possible |

When no tuple meets the condition, the result is `{}`.

Options:

| Option | Default | Values |
|---|---|---|
| `"PairwiseDistance"` | `None` | *d*, {*dMin*, *dMax*}, `"Max"`, `"Spread"` |
| `"MaxCliques"` | `All` | the number of candidate tuples searched under `"PairwiseDistance"` |
| `"NextVertexFunction"` | `Automatic` | `Identity` takes the first vertices of the region instead of random ones |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` or `None` to draw from the current random state |

With the default `RandomSeeding -> Automatic` every call draws afresh, and [SeedRandom]() does not fix the result.

## Basic Examples

Five random points on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {RandomInfraPoint[g, 5, RandomSeeding -> 1]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A region says where the points may lie. Three points at distance 4 from the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 4], RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three points on the circle of radius 4, pairwise as far apart as possible. On the grid they are 8 apart, twice the radius; in the plane the side of such a triangle is √3 times the radius:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {corners = RandomInfraPoint[g, InfraShell[c, 4], 3, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraShell[c, 4], corners}, PlotLabel -> (GraphDistance[g, ##] & @@@ Subsets[corners, {2}]), ImageSize -> Medium]]
```

## Scope

Points from a ball, a band and a segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {region, RandomInfraPoint[g, region, 4, RandomSeeding -> 1]}],
    {region, {InfraBall[c, 2], InfraShell[c, {3, 4}], InfraSegment[c, b]}}]]
```

The points at distance 4 from both *a* and *b*, the intersection of two circles. They are the apexes of the equilateral triangles on *ab*, as in Euclid I.1:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    {apex = RandomInfraPoint[g, InfraIntersection[InfraShell[a, 4], InfraShell[b, 4]], All]},
    InfraSubstrateHighlight[g, {InfraShell[a, 4], InfraShell[b, 4], apex}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A vertex list is a region. Points outside the ball of radius 4:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {outside = Complement[VertexList[g], Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]]},
  InfraSubstrateHighlight[g, {outside, RandomInfraPoint[g, outside, 5, RandomSeeding -> 1]}, ImageSize -> Medium]]
```

## Options

### PairwiseDistance

Three points pairwise at distance 4, joined by segments into an equilateral triangle:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {triple = RandomInfraPoint[g, 3, "PairwiseDistance" -> 4, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraSegment @@ Append[triple, First @ triple], triple}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

`"Spread"` makes the pairwise distances as equal as possible. Three points of the circle of radius 3 on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {triple = RandomInfraPoint[g, InfraShell[c, 3], 3, "PairwiseDistance" -> "Spread", RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraShell[c, 3], triple}, PlotLabel -> (GraphDistance[g, ##] & @@@ Subsets[triple, {2}]), ImageSize -> Medium]]
```

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[SeedRandom[k]; RandomInfraPoint[g, 3, RandomSeeding -> 7], {k, 3}]]
```

## Properties and Relations

<code>[RandomInfraPoint]()[*g*, *reg*, All]</code> is the vertex set of the region:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraPoint[g, InfraShell[c, 3], All] === Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]]
```

## Possible Issues

A bare integer is a count, not a vertex. The vertex 5 is the region `{5}`:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {RandomInfraPoint[g, 5, RandomSeeding -> 1], RandomInfraPoint[g, {5}]}]
```

Without a fixed seed every call draws afresh, even after [SeedRandom]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[SeedRandom[1]; RandomInfraPoint[g, 3], {2}]]
```

A region with fewer vertices than the count gives `{}`; `UpTo` gives what there is:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {RandomInfraPoint[g, {}], RandomInfraPoint[g, {2, 3}, 3], RandomInfraPoint[g, {2, 3}, UpTo[3]]}]
```
