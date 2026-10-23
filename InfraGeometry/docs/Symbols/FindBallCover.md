---
Template: Symbol
Name: FindBallCover
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindBallCover
Keywords: [ball cover, dominating set, r-domination, covering number, set cover, integer program]
SeeAlso: [RandomBallCover, BallCoverQ, BallCoverNumber, CechComplex, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindBallCover]()[*g*, *r*]</code> gives a smallest list of centres whose balls of radius *r* cover the vertices of *g*.

<code>[FindBallCover]()[*g*, *r*, *target*]</code> gives a smallest list of centres in *g* whose balls cover the vertices of *target*.

<code>[FindBallCover]()[*g*, *r*, *target*, *n*]</code> gives *n* different smallest covers.

<code>[FindBallCover]()[*g*, *r*, *target*, [All]()]</code> gives all smallest covers.

## Details & Options

A cover of *T* at radius *r* is a set *C* of vertices with *T ⊆ ⋃ Bᵣ(c)*, *c ∈ C*. A smallest cover has [BallCoverNumber]() centres. The centres may lie anywhere in *g*, also outside the target.

A smallest cover is not unique. [FindBallCover]() gives one of them, with no preferred choice; [RandomBallCover]() draws one uniformly.

The target can be a vertex, a vertex list, a density or a region such as [InfraBall](). Only its vertices count. It defaults to [All](), and the radius defaults to 1.

The count *n* can be *n*, [UpTo]()[*n*] or [All](). With a count the result is a list of covers, `{}` when fewer than *n* exist. An empty target has one cover, the empty list.

| Option | Default | Values |
|---|---|---|
| [Method]() | [Automatic]() | [Automatic](), `"IntegerLinearProgramming"`: a smallest cover; `"Greedy"`: a cover, not always smallest |

`"Greedy"` takes, again and again, the centre whose ball covers the most uncovered vertices. It gives a single cover and takes no count.

The graph is undirected and unweighted, the radius a nonnegative integer.

## Basic Examples

A smallest cover by balls of radius 3, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ FindBallCover[g, 3]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A smallest cover of the ball of radius 4 about the centre by balls of radius 2. The target is drawn with the centres on top. On the mesh one centre lies outside the target:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {target = InfraBall[c, 4]}, {cover = FindBallCover[g, 2, target]},
    InfraSubstrateHighlight[g, {target, cover}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The ball of radius 2 on the grid has 7 smallest covers by balls of radius 1. Three of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Map[cover |-> InfraSubstrateHighlight[g, {InfraBall[c, 2], cover}],
    FindBallCover[g, 1, InfraBall[c, 2], 3]]]
```

The cycle with 9 vertices has three smallest covers by balls of radius 1, the three rotations of one:

```wl
FindBallCover[CycleGraph[9], 1, All, All]
```

A count larger than the number of smallest covers gives `{}`; [UpTo]() gives those there are:

```wl
{FindBallCover[CycleGraph[9], 1, All, 4], FindBallCover[CycleGraph[9], 1, All, UpTo[4]]}
```

## Options

### Method

A smallest cover and a greedy cover at radius 4 on the grid. The greedy one needs 7 balls instead of 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[
    With[{cover = FindBallCover[g, 4, Method -> m]},
      InfraSubstrateHighlight[g, InfraBall[#, 4] & /@ cover, PlotLabel -> Length[cover]]],
    {m, {Automatic, "Greedy"}}]]
```

## Properties and Relations

A cover found is a cover, and its length is the covering number:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  Table[With[{cover = FindBallCover[g, r]}, BallCoverQ[g, r, cover] && Length[cover] == BallCoverNumber[g, r]],
    {r, 0, 6}]]
```

## Possible Issues

An empty target has one cover, the empty list. Without a count the result is that cover, with a count a list holding it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {FindBallCover[g, 1, {}], FindBallCover[g, 1, {}, All]}]
```
