---
Template: Symbol
Name: FindBallCover
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindBallCover
Keywords: [ball cover, dominating set, r-domination, covering number, set cover, integer program]
SeeAlso: [BallCoverQ, DominationNumber, CechComplex, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindBallCover]()[*g*, *r*]</code> gives a smallest list of centres whose closed balls of radius *r* cover every vertex of *g*.

<code>[FindBallCover]()[*g*, *r*, *targets*]</code> covers only the vertices of *targets*; the centres may be any vertices of *g*.

<code>[FindBallCover]()[*g*, *r*, *targets*, *n*]</code> gives up to *n* smallest covers, and [All]() gives every one.

## Details & Options

Definition: a list *C* of vertices covers a set *T* at radius *r* when every *t ∈ T* has some *c ∈ C* with *d(t, c) ≤ r*. A smallest such *C* is a minimum *r*-dominating set, and its size is <code>[DominationNumber]()[*g*, *r*]</code>. The radius defaults to 1 and the targets to [All]().

Finding a smallest cover is NP-hard in general. Option [Method]() chooses how:

| Value | Cover |
|---|---|
| `"Exhaustive"` (default) | an integer linear program: a smallest cover |
| `"Greedy"` | the centre covering the most uncovered targets, again and again: fast, often larger |
| `"Symmetric"` | a union of orbits of single automorphisms of *g*, a vertex fixed by all of them its own orbit: smallest when a smallest cover has that shape, larger otherwise; on a graph without symmetry every vertex is an orbit and the cover is the exhaustive one |

With a count *n* the result is a list of up to *n* covers, and [All]() gives every one. `"Exhaustive"` finds the smallest covers by testing every list of centres of the smallest size, which is feasible only on small graphs. `"Greedy"` and `"Symmetric"` have one cover each, so their list holds that one.

## Basic Examples

A smallest cover by balls of radius 3 of the discretized plane, the square tiling and the hexagonal tiling, each ball in its own colour.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ FindBallCover[g, 3]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The ball of radius 4 about the centre, gray, and the centres of a smallest cover of it by balls of radius 2, red. A centre may lie outside the target.

```wl
SeedRandom[1];
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {target = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 4]]},
    InfraSubstrateHighlight[g, {target -> StandardGray, FindBallCover[g, 2, target] -> StandardRed}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Scope

The hexagon has three smallest covers by balls of radius 1.

```wl
With[
  {g = CycleGraph[6]},
  {covers = FindBallCover[g, 1, All, All]},
  {GraphicsRow[InfraSubstrateHighlight[g, InfraBall[#, 1] & /@ #] & /@ covers], covers}]
```

With a count the methods that have one cover give a list of it. The greedy cover of the hexagon, as a list.

```wl
With[
  {g = CycleGraph[6]},
  {covers = FindBallCover[g, 1, All, All, Method -> "Greedy"]},
  {GraphicsRow[InfraSubstrateHighlight[g, InfraBall[#, 1] & /@ #] & /@ covers], covers}]
```

## Options

### Method

The three methods on the hexagonal tiling at radius 2. Only the exhaustive cover is smallest.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {covers = Table[FindBallCover[g, 2, Method -> method], {method, {"Exhaustive", "Greedy", "Symmetric"}}]},
  {GraphicsRow[InfraSubstrateHighlight[g, InfraBall[#, 2] & /@ #] & /@ covers], Length /@ covers}]
```

The discretized plane has no symmetry, so every vertex is an orbit and the symmetric cover is the exhaustive one.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {covers = Table[FindBallCover[g, 2, Method -> method], {method, {"Exhaustive", "Symmetric"}}]},
  {GraphicsRow[InfraSubstrateHighlight[g, InfraBall[#, 2] & /@ #] & /@ covers], Length /@ covers}]
```

## Properties and Relations

A cover passes [BallCoverQ](), and its length is the [DominationNumber]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cover = FindBallCover[g, 3]},
  {InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ cover],
   BallCoverQ[g, 3, cover], Length[cover] == DominationNumber[g, 3]}]
```
