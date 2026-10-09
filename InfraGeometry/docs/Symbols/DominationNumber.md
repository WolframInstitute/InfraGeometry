---
Template: Symbol
Name: DominationNumber
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DominationNumber
Keywords: [domination number, r-domination number, covering number, ball cover, covering dimension]
SeeAlso: [FindBallCover, BallCoverQ, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[DominationNumber]()[*g*, *r*]</code> gives the least number *N(r)* of closed balls of radius *r* that cover every vertex of *g*.

<code>[DominationNumber]()[*g*, *r*, *targets*]</code> gives the least number of such balls that cover the vertices of *targets*.

## Details & Options

Definition: *N(r)* is the size of a smallest *r*-dominating set, the length of <code>[FindBallCover]()[*g*, *r*]</code>, computed by its exact integer program. At *r* = 1 it is the domination number of graph theory. The radius defaults to 1.

*N(0)* is the number of vertices. *N(r)* does not increase with *r*, and it is 1 from the radius of the graph, the least eccentricity, on.

How fast *N(r)* falls as *r* grows is a measure of dimension.

## Basic Examples

*N(r)* against the radius on the discretized plane, the square tiling and the hexagonal tiling, from the number of vertices down to 1.

```wl
ListLogPlot[
  Table[
    With[
      {g = InfraSubstrate[name, "Small"]},
      Table[{r, DominationNumber[g, r]}, {r, 0, GraphRadius[g]}]],
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
  {target = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
  {InfraSubstrateHighlight[g, {target -> StandardGray, FindBallCover[g, 2, target] -> StandardRed}], DominationNumber[g, 2, target]}]
```

## Properties and Relations

On a cycle and on a path with *n* vertices, *N(r)* is *⌈n/(2r + 1)⌉*: each ball holds at most *2r + 1* vertices.

```wl
{InfraSubstrateHighlight[CycleGraph[12], InfraBall[#, 1] & /@ FindBallCover[CycleGraph[12], 1]],
 And @@ Flatten @ Table[DominationNumber[CycleGraph[n], r] == Ceiling[n/(2 r + 1)], {n, 3, 20}, {r, 1, 3}],
 And @@ Flatten @ Table[DominationNumber[PathGraph[Range[n]], r] == Ceiling[n/(2 r + 1)], {n, 2, 20}, {r, 1, 3}]}
```
