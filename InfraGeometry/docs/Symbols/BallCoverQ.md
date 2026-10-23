---
Template: Symbol
Name: BallCoverQ
Context: WolframInstitute`InfraGeometry`
ContextPath: []
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallCoverQ
Keywords: [ball cover, dominating set, r-domination, covering]
SeeAlso: [FindBallCover, RandomBallCover, BallCoverNumber, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallCoverQ]()[*g*, *r*, *s*]</code> gives `True` if the balls of radius *r* about the vertices of *s* cover the vertices of *g*.

<code>[BallCoverQ]()[*g*, *r*, *s*, *target*]</code> gives `True` if they cover the vertices of *target*.

## Details & Options

The centres *s* cover *T* at radius *r* when every *t* in *T* has a centre *c* with *d(t, c) ≤ r*, that is *T ⊆ ⋃ Bᵣ(c)*. For *T* the whole graph, *s* is an *r*-dominating set.

The target can be a vertex, a vertex list, a density or a region such as [InfraBall](). Only its vertices count. It defaults to [All](). Distances are those of *g*.

A cover stays a cover at a larger radius and with more centres. A single vertex *c* covers *g* exactly when its eccentricity is at most *r*.

The test says nothing about size. The least size of a cover is [BallCoverNumber](), and [FindBallCover]() finds one.

The graph is undirected and unweighted, the radius a nonnegative integer.

## Basic Examples

A smallest cover by balls of radius 3 covers; without its first centre it does not. The ball of that centre is drawn, and on top the vertices that no other ball covers:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {cover = FindBallCover[g, 3]},
    {missed = Select[VertexList[g], ! BallCoverQ[g, 3, Rest[cover], #] &]},
    InfraSubstrateHighlight[g, {InfraBall[First @ cover, 3], missed},
      PlotLabel -> {BallCoverQ[g, 3, cover], BallCoverQ[g, 3, Rest[cover]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The centre of the grid has eccentricity 9. Its ball covers the grid from radius 9 on:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[BallCoverQ[g, r, {c}], {r, 6, 10}]]
```

## Scope

With a target only the target needs covering. The centre covers its own ball of radius 2, not the whole grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {BallCoverQ[g, 2, {c}, InfraBall[c, 2]], BallCoverQ[g, 2, {c}]}]
```

A vertex as the target. The ball of radius 3 about the centre holds a vertex at distance 3, not one at distance 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[BallCoverQ[g, 3, {c}, RandomInfraPoint[g, InfraShell[c, d], RandomSeeding -> 1]], {d, {3, 4}}]]
```

## Properties and Relations

A cover stays a cover at a larger radius, and with more centres. A smallest cover at radius 2, tested at the radii 1 to 4, then without its first centre, then with the centre of the grid added:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]}, {cover = FindBallCover[g, 2]},
  {Table[BallCoverQ[g, r, cover], {r, 1, 4}], BallCoverQ[g, 2, Rest[cover]], BallCoverQ[g, 2, Append[cover, c]]}]
```
