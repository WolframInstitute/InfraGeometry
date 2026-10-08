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

<code>[BallCoverQ]()[*g*, *r*, *s*, *targets*]</code> tests whether they cover the vertices of *targets*.

## Details & Options

Definition: *s* covers a set *T* at radius *r* when every *t ∈ T* has some *c ∈ s* with *d(t, c) ≤ r*; for *T* the whole vertex set, *s* is an *r*-dominating set.

A cover of every vertex at radius *r* is one at every larger radius, and a superset of a cover is a cover. The smallest covers are found by [FindBallCover](), and their size is [BallCoverNumber]().

## Basic Examples

A smallest cover of the hexagonal tiling by balls of radius 3 covers; without its first centre it does not. The remaining balls are blue and the vertices they leave uncovered are red.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cover = FindBallCover[g, 3]},
  {balls = FindInfraRepresentative[g, InfraBall[#, 3]] & /@ Rest[cover]},
  {InfraSubstrateHighlight[g, {balls -> StandardBlue, Complement[VertexList[g], Union @@ balls] -> StandardRed}],
   BallCoverQ[g, 3, cover], BallCoverQ[g, 3, Rest[cover]]}]
```

## Scope

With targets, only the targets need covering. The centre covers its own ball of radius 2, not the whole tiling.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {InfraSubstrateHighlight[g, {InfraBall[c, 2], c}],
   BallCoverQ[g, 2, {c}, FindInfraRepresentative[g, InfraBall[c, 2]]], BallCoverQ[g, 2, {c}]}]
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
