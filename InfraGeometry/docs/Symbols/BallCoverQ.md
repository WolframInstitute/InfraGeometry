---
Template: Symbol
Name: BallCoverQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallCoverQ
Keywords: [ball cover, dominating set, r-domination, covering]
SeeAlso: [FindBallCover, BallCoverNumber, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallCoverQ]()[*g*, *r*, *s*]</code> tests whether the closed balls of radius *r* about the vertices of *s* cover every vertex of *g*.

<code>[BallCoverQ]()[*g*, *r*, *s*, *target*]</code> tests whether they cover the vertices of *target*, using distances in *g*.

## Details & Options

Definition: *s* covers a set *T* at radius *r* when every *t ∈ T* has some *c ∈ s* with *d(t, c) ≤ r*; for *T* the whole vertex set, *s* is an *r*-dominating set.

The graph is finite, undirected and unweighted, and the radius is a nonnegative integer. The target defaults to [All](). It can be a vertex, a vertex list, a density association, a graph carrier or an abstract region such as [InfraBall](). Only vertex support matters; a literal vertex takes precedence over list interpretation.

Centres may lie anywhere in *g*, and all distances are read on *g*. Taking a target's induced graph can change both available centres and shortest paths.

The predicate tests coverage, not minimum size. A cover remains one at every larger radius, and adding centres preserves coverage. [BallCoverNumber]() gives the minimum size, attained by the default [FindBallCover]().

## Basic Examples

A radius-one ball centred at a vertex of a triangle covers the graph:

```wl
BallCoverQ[ CycleGraph[ 3 ], 1, { 1 } ]
```

---

A smallest cover of the hexagonal tiling by balls of radius 3 covers; without its first centre it does not. The remaining balls are blue and the vertices they leave uncovered are red.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cover = FindBallCover[g, 3]},
  {balls = RandomInfraBall[ g, InfraBall[#, 3] ] & /@ Rest[cover]},
  {InfraSubstrateHighlight[g, {balls -> StandardBlue, Complement[VertexList[g], Union @@ balls] -> StandardRed}],
   BallCoverQ[g, 3, cover], BallCoverQ[g, 3, Rest[cover]]}]
```

## Scope

With targets, only the targets need covering. The centre covers its own ball of radius 2, not the whole tiling.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {InfraSubstrateHighlight[g, {InfraBall[c, 2], c}],
	 BallCoverQ[ g, 2, { c }, InfraBall[ c, 2 ] ], BallCoverQ[g, 2, {c}]}]
```

## Properties and Relations

A single vertex covers the whole graph exactly when its eccentricity is at most *r*. The ball of radius 6 about the centre of the square tiling misses the rim; from radius 7, the eccentricity of the centre, the one ball covers.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {InfraSubstrateHighlight[g, {InfraBall[c, VertexEccentricity[g, c] - 1], c}],
   VertexEccentricity[g, c], Table[BallCoverQ[g, r, {c}], {r, 5, 8}]}]
```
