---
Template: Symbol
Name: RandomInfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSphere
Keywords: [sphere, separating set, minimal, peel, search]
SeeAlso: [InfraSphere, FindInfraShell, InfraShell, RandomInfraRepresentative, FindInfraOsculatingShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSphere]()[*g*, *c*, *r*, *n*]</code> gives a `List` of exactly *n* inclusion-minimal connected subsets of the shell of radius *r* about *c* that separate the side of *c* from the far side.

<code>[RandomInfraSphere]()[*g*, *c*, {*r*, *s*}, *n*]</code> takes the band from *r* to *s*.

<code>[RandomInfraSphere]()[*g*, *c*, *r*]</code> gives one such subset, the first by the default method.

## Details & Options

The count *n* may be `UpTo[n]`, which gives up to *n*, or `All`.

Option `Properties` takes `{"Separating", "Connected"}` (default), `{"Separating"}` for the inclusion-minimal separating subsets that need not be connected, or `{}` for the level set as the one member.

Option `"NextVertexFunction"` sees the vertices that can be peeled next and gives the ones to try, in order. `Identity` (default) is the canonical peel, so the count-less call is one minimal subset, deterministic; `RandomSample` peels in random order, seeded by an ambient `SeedRandom`; `RandomSample[#, UpTo[n]] &` keeps at most *n* branches per node, and the result is then minimal among the survivors.

The search peels the shell vertex by vertex while it keeps separating. It is the specialised search behind [InfraSphere](), whose [RandomInfraRepresentative]() clause calls it. The family can be large: all members on a medium tiling take long.

When the shell does not separate, as on a torus band that wraps, the result is `{}`.

## Basic Examples

All four minimal connected separating subsets of the band 1 to 2 about the centre of a 5 by 5 grid.

```wl
RandomInfraSphere[GridGraph[{5, 5}], 13, {1, 2}, All]
```

Three separating subsets of the shell of radius 3, each drawn in its own colour on the hexagonal tiling.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, RandomInfraSphere[g, c, 3, UpTo[3]]]]
```

## Options

With `Properties -> {"Separating"}` the subsets need not be connected, so they can be smaller.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {Length /@ RandomInfraSphere[g, 25, {2, 3}, UpTo[3], Properties -> {"Separating"}],
   Length /@ RandomInfraSphere[g, 25, {2, 3}, UpTo[3]]}]
```

A pruning function caps the branches tried per node.

```wl
RandomInfraSphere[GridGraph[{5, 5}], 13, {1, 2}, All, "NextVertexFunction" -> (RandomSample[#, UpTo[1]] &)]
```

## Properties and Relations

Every subset separates the centre from a corner.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {members = RandomInfraSphere[g, 25, 2, All]},
  {AllTrue[members, GraphDistance[VertexDelete[g, #], 25, 1] === Infinity &], Length @ members}]
```
