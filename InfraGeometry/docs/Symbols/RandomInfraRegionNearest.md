---
Template: Symbol
Name: RandomInfraRegionNearest
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraRegionNearest
Keywords: [nearest point, projection, distance to a region, foot of perpendicular]
SeeAlso: [InfraRegionNearest, FindClosestInfraPoint, InfraProjection, InfraBall, RandomInfraPoint]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraRegionNearest]()[*g*, *reg*, *p*]</code> gives a random vertex of the region *reg* nearest to *p* in *g*.

<code>[RandomInfraRegionNearest]()[*g*, *reg*, *p*, *n*]</code> gives a list of *n* distinct nearest vertices.

<code>[RandomInfraRegionNearest]()[*g*, [InfraRegionNearest]()[*reg*, *p*]]</code> and <code>[RandomInfraRegionNearest]()[*g*, [InfraRegionNearest]()[*reg*, *p*], *n*]</code> are the same with the request given as a token.

## Details & Options

The nearest vertices are *{v ∈ R : d(p, v) = d(p, R)}*, with *d(p, R) = min d(p, w)* over the vertices *w* of the region *R*. All minimizers are kept; on a graph there are usually several.

The region is a vertex, a vertex list, a density `<|v -> m, …|>`, a [Graph]() whose vertices are taken, or an object such as [InfraBall]() or [InfraSegment](). A vertex of density 0 is not in the region.

For a ball *Bᵣ(c)* and *p* outside it, *d(p, Bᵣ(c)) = d(p, c) − r*, and the nearest vertices are the vertices at distance *r* from *c* on the shortest paths from *c* to *p*.

A point of the region is its own nearest vertex. An empty region, or one in another component, gives `{}`.

The draw is uniform over the nearest vertices. The count *n* can be `n`, `UpTo[n]` or `All`; `All` gives them in vertex order.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | `Automatic` random; `Identity` the first vertices in vertex order |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

The vertices of the ball of radius 2 about the centre nearest to a vertex at distance 6, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {p = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraBall[c, 2], RandomInfraRegionNearest[g, InfraBall[c, 2], p, All], p}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

They are all at distance *6 − 2 = 4* from *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]},
  GraphDistance[g, p, #] & /@ RandomInfraRegionNearest[g, InfraBall[c, 2], p, All]]
```

## Scope

The nearest vertices of a segment, given as a token:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]]},
  {p = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 3]},
  InfraSubstrateHighlight[g, {seg, RandomInfraRegionNearest[g, InfraRegionNearest[seg, p], All], p}, ImageSize -> Medium]]
```

## Properties and Relations

For a ball the nearest vertices are where the circle of radius *r* meets the segment from *c* to *p*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]},
  RandomInfraRegionNearest[g, InfraBall[c, 2], p, All] ===
    Sort @ RandomInfraPoint[g, InfraIntersection[InfraShell[c, 2], InfraSegment[c, p]], All]]
```

## Possible Issues

A point of the region is its own unique nearest vertex:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {c, RandomInfraRegionNearest[g, InfraBall[c, 2], c, All]}]
```
