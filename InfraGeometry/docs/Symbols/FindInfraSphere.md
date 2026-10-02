---
Template: Symbol
Name: FindInfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSphere
Keywords: [sphere, separating set, minimal, peel, search]
SeeAlso: [InfraSphere, FindInfraShell, InfraShell, FindInfraRepresentative, SeparatesQ, FindInfraOsculatingShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[FindInfraSphere]()[*g*, *c*, *r*, *n*]</code> gives a `List` of exactly *n* inclusion-minimal connected subsets of the shell of radius *r* about *c* that separate the side of *c* from the far side.

<code>[FindInfraSphere]()[*g*, *c*, {*r*, *s*}, *n*]</code> takes the band from *r* to *s*.

<code>[FindInfraSphere]()[*g*, *c*, *r*]</code> gives one such subset, the first by the default method.

## Details & Options

The count *n* may be `UpTo[n]`, which gives up to *n*, or `All`.

Option `Properties` takes `{"Separating", "Connected"}` (default), `{"Separating"}` for the inclusion-minimal separating subsets that need not be connected, or `{}` for the level set as the one member.

Option `Method` takes `Automatic` (default), `"Exhaustive"`, `{"Exhaustive", "Pruning" -> spec}`, `"Greedy"` or `"RandomGreedy"`. `Automatic` resolves by the count: `All` to `"Exhaustive"`, a bounded or absent count to `"Greedy"`, the lazy peel. `"RandomGreedy"` peels in random order, seeded by an ambient `SeedRandom`. `"Pruning"` caps the removable vertices tried per layer, and the result is then minimal among the survivors.

The search peels the shell vertex by vertex while it keeps separating. It is the specialised search behind [InfraSphere](), whose [FindInfraRepresentative]() clause calls it. The family can be large: all members on a medium tiling take long.

When the shell does not separate, as on a torus band that wraps, the result is `{}`.

## Basic Examples

All four minimal connected separating subsets of the band 1 to 2 about the centre of a 5 by 5 grid.

```wl
FindInfraSphere[GridGraph[{5, 5}], 13, {1, 2}, All]
```

Three separating subsets of the shell of radius 3, each drawn in its own colour on the hexagonal tiling.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  InfraSubstrateHighlight[g, FindInfraSphere[g, c, 3, UpTo[3]]]]
```

## Options

With `Properties -> {"Separating"}` the subsets need not be connected, so they can be smaller.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {Length /@ FindInfraSphere[g, 25, {2, 3}, UpTo[3], Properties -> {"Separating"}],
   Length /@ FindInfraSphere[g, 25, {2, 3}, UpTo[3]]}]
```

`"Pruning"` caps the vertices tried per layer.

```wl
FindInfraSphere[GridGraph[{5, 5}], 13, {1, 2}, All, Method -> {"Exhaustive", "Pruning" -> 0.5}]
```

## Properties and Relations

Every subset separates the centre from a corner.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {members = FindInfraSphere[g, 25, 2, All]},
  {AllTrue[members, SeparatesQ[g, #, 25, 1] &], Length @ members}]
```
