---
Template: Symbol
Name: BallCoverNumber
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallCoverNumber
Keywords: [ball cover number, covering number, domination number, r-domination number, ball cover, covering dimension]
SeeAlso: [FindBallCover, BallCoverQ, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallCoverNumber]()[*g*, *r*]</code> gives the number *N(r)* of closed balls of radius *r* in the cover of *g* that [FindBallCover]() finds.

<code>[BallCoverNumber]()[*g*, *r*, *targets*]</code> gives the number of such balls in the cover of the vertices of *targets*.

## Details & Options

Definition: *N(r)* is the length of <code>[FindBallCover]()[*g*, *r*, *targets*]</code> under the same [Method](). With the default `"Exhaustive"` it is the least number of balls of radius *r* that cover: the size of a smallest *r*-dominating set, which graph theory calls the *r*-domination number of *g*, the domination number at *r* = 1. The radius defaults to 1 and the targets to [All]().

Option [Method]() chooses the cover that is counted, as in [FindBallCover]():

| Value | Count |
|---|---|
| `"Exhaustive"` (default) | the least number, by an integer linear program |
| `"Greedy"` | the size of the greedy cover: an upper bound, fast on graphs where the program is slow |
| `"Symmetric"` | the size of the smallest cover that is a union of orbits of single automorphisms: the least number when a smallest cover has that shape, an upper bound otherwise |

*N(0)* is the number of vertices. The least *N(r)* does not increase with *r*, and it is 1 from the radius of the graph, the least eccentricity, on.

How fast *N(r)* falls as *r* grows is a measure of dimension.

## Basic Examples

*N(r)* against the radius on the discretized plane, the square tiling and the hexagonal tiling, from the number of vertices down to 1.

```wl
ListLogPlot[
  Table[
    With[
      {g = InfraSubstrate[name, "Small"]},
      Table[{r, BallCoverNumber[g, r]}, {r, 0, GraphRadius[g]}]],
    {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}],
  Joined -> True,
  PlotLegends -> {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"},
  AxesLabel -> {"r", "N(r)"}]
```

## Scope

With targets: the number of balls of radius 2 that cover the ball of radius 4 about the centre.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {target = FindInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
  {InfraSubstrateHighlight[g, {target -> StandardGray, FindBallCover[g, 2, target] -> StandardRed}], BallCoverNumber[g, 2, target]}]
```

## Options

### Method

The three counts on the hexagonal tiling at radius 2. Only the exhaustive count is the least number.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  Table[BallCoverNumber[g, 2, Method -> method], {method, {"Exhaustive", "Greedy", "Symmetric"}}]]
```

The greedy count is at hand where the exact program is slow. The greedy *N(r)* against the radius on the discretized plane of medium size.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium"]},
  ListLogPlot[Table[{r, BallCoverNumber[g, r, Method -> "Greedy"]}, {r, 1, GraphRadius[g]}], Joined -> True, AxesLabel -> {"r", "N(r)"}]]
```

## Properties and Relations

On a cycle and on a path with *n* vertices, *N(r)* is *⌈n/(2r + 1)⌉*: each ball holds at most *2r + 1* vertices.

```wl
{InfraSubstrateHighlight[CycleGraph[12], InfraBall[#, 1] & /@ FindBallCover[CycleGraph[12], 1]],
 And @@ Flatten @ Table[BallCoverNumber[CycleGraph[n], r] == Ceiling[n/(2 r + 1)], {n, 3, 20}, {r, 1, 3}],
 And @@ Flatten @ Table[BallCoverNumber[PathGraph[Range[n]], r] == Ceiling[n/(2 r + 1)], {n, 2, 20}, {r, 1, 3}]}
```
