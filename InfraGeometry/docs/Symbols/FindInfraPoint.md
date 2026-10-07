---
Template: Symbol
Name: FindInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPoint
Keywords: [point, random point, region, ball, shell, pairwise distance, centre, periphery]
SeeAlso: [InfraPoint, InfraBall, InfraShell, InfraDensity, FindInfraMidpoint, FindClosestInfraPoint, GraphCenter]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraPoint]()[*g*]</code> gives one random vertex of *g*.

<code>[FindInfraPoint]()[*g*, *n*]</code> gives a list of *n* distinct vertices of *g*.

<code>[FindInfraPoint]()[*g*, *reg*]</code> gives one random vertex of the region *reg*.

<code>[FindInfraPoint]()[*g*, *reg*, *n*]</code> gives a list of *n* distinct vertices of the region *reg*.

## Details & Options

Definition: a point of *g* drawn from a region of *g*, after `RandomPoint[reg]` and `RandomPoint[reg, n]`.

The region *reg* is the place where the points may lie:

| Region | Meaning |
|---|---|
| a vertex `List`, `{v1, v2, …}` | those vertices |
| a density `<\|v -> m, …\|>` | its keys, the support |
| [InfraBall]()`[c, r]` | within distance *r* of *c* |
| [InfraShell]()`[c, r]`, [InfraShell]()`[c, {r, s}]` | at distance *r* from *c*; between *r* and *s* |
| [InfraSegment]()`[a, b]`, [InfraLine]()`[a, b]`, … | the vertices of the object |
| [InfraUnion]()`[reg1, reg2]`, [InfraIntersection]()`[reg1, reg2]` | the union, the common part |

Any inert head that <code>[InfraMeasurement]()[*g*, *reg*, "VertexDensity"]</code> reads is a region. A single vertex is `{v}`, never bare: a bare integer is a count.

The count *n* is `n`, `UpTo[n]` or `All`. The *n* points are distinct. `UpTo[n]` gives at most *n*, `All` gives every vertex of the region. Without *n* the result is one vertex, not a list.

An empty region gives `{}`. So does a region with fewer than *n* vertices.

The distance from a vertex to a set *C* is *d(v, C) = min d(v, c)* over *c* in *C*. So <code>[InfraBall]()[{c1, c2}, r]</code> is the union of the two balls, and <code>[InfraShell]()[{c1, c2}, r]</code> is the outer layer of that union.

Options:

| Option | Values |
|---|---|
| `"PairwiseDistance"` | `None` (default), *d*, `{dMin, dMax}`, `"Max"`, `"Spread"` |
| `"MaxCliques"` | bound on the clique search behind `"PairwiseDistance"` |

`"PairwiseDistance"` is a condition on the drawn tuple, not on a single point: the *n* points are pairwise at distance *d*, or in `[dMin, dMax]`. `"Max"` takes the largest *dMin* that still admits a tuple. `"Spread"` takes the tuple whose pairwise distances vary least. The condition makes the result one jointly constrained tuple, and `{}` when none exists. `UpTo[n]` and `All` under it ask for a tuple of `Min[n, Length of the region]` points.

To keep a whole construction interior, not just its anchors, cut the substrate with `CenterGraph[g, k]` and work on that graph: it is the ball of `k` hops about `GraphCenter[g]`, a negative `k` counting back from the radius and `Scaled[q]` taking the fraction `q` of it, and it carries the same vertex labels and coordinates, so the result draws on the original. Restricting the region alone pins only the anchors; a construction with slack spends it outward.

The draw is random: seed with `SeedRandom` before the first call if you need a reproducible figure.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Definition 1 | A point is that of which there is no part. |
| Hilbert | Group I | Points are one of the three primitive kinds of object. |
| Tarski | primitive | Variables range over points. There is no other sort. |
| Birkhoff | Ruler postulate | Points are what the reals coordinate. |

## Basic Examples

One point is a vertex. `SeedRandom` in front fixes the draw.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = (SeedRandom[1]; FindInfraPoint[g])},
  {InfraSubstrateHighlight[g, {p}], p}]
```

A count gives a list of vertices: here five of them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {points = (SeedRandom[1]; FindInfraPoint[g, 5])},
  {InfraSubstrateHighlight[g, {points}], points}]
```

A region says where the points may lie. Three points at distance 4 from the centre, drawn from a shell.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {points = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4], 3])},
  {InfraSubstrateHighlight[g, {InfraShell[c, 4], points, c}], points}]
```

Four points within distance 3 of the centre, drawn from a ball.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {points = (SeedRandom[1]; FindInfraPoint[g, InfraBall[c, 3], 4])},
  {InfraSubstrateHighlight[g, {InfraBall[c, 3], points}], points}]
```

Three points pairwise as far apart as the region allows: spread on the circle about the centre.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {corners = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4], 3, "PairwiseDistance" -> "Max"])},
  {InfraSubstrateHighlight[g, {InfraShell[c, 4], corners}], corners}]
```

## Scope

The centre is one vertex and the periphery of a patch is its rim; both are vertex lists, so both are regions.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {centre = FindInfraPoint[g, GraphCenter[g]]},
  {rim = (SeedRandom[1]; FindInfraPoint[g, GraphPeriphery[g], 4])},
  {InfraSubstrateHighlight[g, {GraphPeriphery[g], rim, centre}], centre, rim}]
```

A band of distances about a vertex.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {points = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, {2, 4}], 5])},
  {InfraSubstrateHighlight[g, {InfraShell[c, {2, 4}], points}], points}]
```

A ball about several vertices is the union of their balls.

```wl
With[
  {g = GridGraph[{10, 10}]},
  {points = (SeedRandom[1]; FindInfraPoint[g, InfraBall[{12, 89}, 3], 5])},
  {HighlightGraph[g, {InfraBall[{12, 89}, 3], points}], points}]
```

A point on a segment, a point on a line.

```wl
With[
  {g = GridGraph[{10, 10}]},
  {segment = InfraSegment[1, 100]},
  {points = (SeedRandom[1]; FindInfraPoint[g, segment, 3])},
  {HighlightGraph[g, {segment, points}], points}]
```

Points in either of two regions.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {region = InfraUnion[InfraShell[c, 2], InfraShell[c, 5]]},
  {points = (SeedRandom[1]; FindInfraPoint[g, region, 4])},
  {InfraSubstrateHighlight[g, {region, points}], points}]
```

Points outside a region: take the complement as a vertex list.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {outside = Complement[VertexList[g], FindInfraRepresentative[g, InfraBall[c, 6]]]},
  {points = (SeedRandom[1]; FindInfraPoint[g, outside, 3])},
  {InfraSubstrateHighlight[g, {outside, points}], points}]
```

Points at the same distance from two anchors: the intersection of two shells, here the anti-diagonal of a grid.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {region = InfraIntersection[InfraShell[1, 8], InfraShell[81, 8]]},
  {points = FindInfraPoint[g, region, All]},
  {HighlightGraph[g, {region, points}], points}]
```

An empty region, or a region with fewer vertices than the count, gives an empty list.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {FindInfraPoint[g, {}], FindInfraPoint[g, InfraShell[13, 100], 2], FindInfraPoint[g, {1, 2}, 3]}]
```

## Options

`"PairwiseDistance"` takes a distance: two points at distance 4 from each other.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {pair = (SeedRandom[1]; FindInfraPoint[g, 2, "PairwiseDistance" -> 4])},
  {InfraSubstrateHighlight[g, {pair}], GraphDistance[g, First @ pair, Last @ pair]}]
```

A range of distances.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {triple = (SeedRandom[1]; FindInfraPoint[g, 3, "PairwiseDistance" -> {3, 5}])},
  {InfraSubstrateHighlight[g, {triple}], triple}]
```

`"Spread"` takes the tuple whose pairwise distances are the most alike: three points about the centre.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {triple = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 3], 3, "PairwiseDistance" -> "Spread"])},
  {InfraSubstrateHighlight[g, {InfraShell[c, 3], triple}], triple}]
```

## Properties and Relations

`FindInfraPoint[g, reg, All]` is the vertex set of the region.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {c = First @ GraphCenter[g]},
  {Sort @ FindInfraPoint[g, InfraShell[c, 3], All] === FindInfraRepresentative[g, InfraShell[c, 3]]}]
```

The distance to a set is the least distance to one of its points: the shell about two vertices is the outer layer of the union of the two balls, and does not contain the vertices.

```wl
With[
  {g = GridGraph[{10, 10}]},
  {shell = FindInfraRepresentative[g, InfraShell[{45, 47}, 2]]},
  {Length @ shell, MemberQ[shell, 45]}]
```

The spellings of the earlier releases translate to a region.

| Earlier | Now |
|---|---|
| `"Distance" -> d` | `"PairwiseDistance" -> d` |
| `"From" -> "Center"` | `FindInfraPoint[g, GraphCenter[g]]` |
| `"From" -> "Periphery"` | `FindInfraPoint[g, GraphPeriphery[g]]` |
| `"From" -> {v1, …}`, `SelectInfraPoint[g, vs, n]` | `FindInfraPoint[g, vs, n]` |
| `"From" ->` a density | `FindInfraPoint[g, density]` |
| `"From" -> a -> r`, `RandomInfraPoint[g, a, r]` | `FindInfraPoint[g, InfraShell[a, r]]` |
| `"From" -> a -> {r, s}` | `FindInfraPoint[g, InfraShell[a, {r, s}]]` |
| `"From" -> a -> {0, r}` | `FindInfraPoint[g, InfraBall[a, r]]` |
| `"From" -> a -> "Max"` | `FindInfraPoint[g, InfraShell[a, VertexEccentricity[g, a]]]` |
| `"From" -> {a, b} -> r` | `FindInfraPoint[g, InfraIntersection[InfraShell[a, r], InfraShell[b, r]]]` |
| `InfraCenter[g]` | `First @ GraphCenter[g]` |
| `"From" -> {"Center", k}` | removed; cut the substrate with `CenterGraph[g, k]` |
