---
Template: Symbol
Name: RandomBallCover
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomBallCover
Keywords: [random ball cover, minimum cover, dominating set, uniform sampling, nonuniqueness]
SeeAlso: [FindBallCover, BallCoverNumber, BallCoverQ, InfraBall, RandomSeeding]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[RandomBallCover]()[*g*, *r*]</code> gives a smallest cover of *g* by balls of radius *r*, chosen at random.

<code>[RandomBallCover]()[*g*, *r*, *target*]</code> gives a random smallest cover of the vertices of *target*.

<code>[RandomBallCover]()[*g*, *r*, *target*, *n*]</code> gives *n* different random smallest covers.

## Details & Options

A smallest cover of *T* at radius *r* is a set *C* of [BallCoverNumber]() vertices with *T ⊆ ⋃ Bᵣ(c)*, *c ∈ C*. There are often many. [RandomBallCover]() draws one uniformly from all of them; [FindBallCover]() gives one with no preferred choice.

The target can be a vertex, a vertex list, a density or a region such as [InfraBall](). Only its vertices count. It defaults to [All](), and the radius defaults to 1.

The count *n* can be *n*, [UpTo]()[*n*] or [All](). With a count the result is a list of different covers, `{}` when fewer than *n* exist. [All]() gives every smallest cover, in a fixed order.

Every draw lists all smallest covers first. Their number can grow fast with the size of the target.

| Option | Default | Values |
|---|---|---|
| [Method]() | [Automatic]() | [Automatic](), `"IntegerLinearProgramming"` |
| [RandomSeeding]() | [Automatic]() | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

With the default `RandomSeeding -> Automatic` every call draws afresh, and [SeedRandom]() does not fix the result.

## Basic Examples

Three random smallest covers of the ball of radius 2 about the centre of the grid by balls of radius 1. There are 7 such covers:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Map[cover |-> InfraSubstrateHighlight[g, {InfraBall[c, 2], cover}],
    RandomBallCover[g, 1, InfraBall[c, 2], 3, RandomSeeding -> 1]]]
```

A random smallest cover of the cycle with 9 vertices:

```wl
RandomBallCover[CycleGraph[9], 1, RandomSeeding -> 1]
```

## Scope

The cycle with 9 vertices has three smallest covers at radius 1. Asking for four gives `{}`; [UpTo]() gives the three in random order:

```wl
Table[RandomBallCover[CycleGraph[9], 1, All, n, RandomSeeding -> 1], {n, {4, UpTo[4]}}]
```

[All]() gives every smallest cover, as [FindBallCover]() does:

```wl
RandomBallCover[CycleGraph[9], 1, All, All] === FindBallCover[CycleGraph[9], 1, All, All]
```

## Options

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
Table[SeedRandom[k]; RandomBallCover[CycleGraph[9], 1, RandomSeeding -> 7], {k, 3}]
```

## Properties and Relations

The draw is uniform. The three smallest covers of the cycle with 9 vertices come up about equally often in 300 draws:

```wl
Counts @ Table[RandomBallCover[CycleGraph[9], 1, RandomSeeding -> k], {k, 300}]
```
