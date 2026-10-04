---
Template: Symbol
Name: FindInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraGeodesic
Keywords: [geodesic, infra-scale, locally shortest, walk, Riemannian geodesic]
SeeAlso: [InfraGeodesicQ, ExtendInfraGeodesic, FindInfraWalk, FindInfraSegment, InfraMeasurement, SprayGraph]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraGeodesic]()[*g*, *p*, *s*, *kspec*]</code> gives one geodesic at infra-scale *s* starting at *p*, with a length inside the budget *kspec*.

<code>[FindInfraGeodesic]()[*g*, *p*, *q*, *s*, *kspec*]</code> gives one geodesic at infra-scale *s* from *p* to *q*.

<code>[FindInfraGeodesic]()[*g*, …, *kspec*, *n*]</code> gives a `List` of exactly *n* geodesics or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

Definition: a walk *v0*, *v1*, …, *vk* is a geodesic at infra-scale *s* when every window of *s* consecutive vertices together with the next one is a shortest path: *d(v(i−s), vi) = s* for every *i ≥ s*, and *d(v0, vi) = i* for *i < s*.

The scale is how far back the observer sees. At scale `1` the condition asks only for adjacency, so every walk is a geodesic. At scale `2` it forbids stepping back, and on a graph with triangles also cutting a triangle's corner. At scale `Infinity` the whole walk is a shortest path, a segment. In between, a geodesic is locally shortest and may be globally long: it can wind round a square at scale `2`, and round a larger loop at scale `3`.

This is the Riemannian geodesic read by an observer with a horizon. On a manifold a geodesic minimises length between nearby points only, and it need not be the shortest path between its ends. At infra-scale *s* the same holds with "nearby" meaning "fewer than *s* steps apart".

*kspec* is the length budget in edges: `UpTo[k]` (at most *k*), `{k}` (exactly *k*), `{lo, hi}`, or `Infinity`. At a finite scale the class is infinite, so a finite budget is required; only scale `Infinity` accepts `Infinity`.

A geodesic is a walk graph: a directed path graph on the pairs `{i, v}`, the position and the vertex. `Last /@ VertexList[w]` is its vertex sequence, and `EdgeCount[w]` its length. The count-less call returns one walk graph, or `{}` when there is none.

The search reads only the window, never the target. At a finite scale the two-point form keeps the walks that happen to end at *q*, so a walk can pass *q* and come back. [FindInfraSegment]() is the target-aware search at scale `Infinity`.

`FindInfraGeodesic` is [FindInfraWalk]() at `"InfraScale" -> s` with `"Minimizing"` added to the rules. The options are those of [FindInfraWalk]():

| Option | Default | Values |
|---|---|---|
| `Properties` | `{}` | further walk rules, each read on the window: `"Simple"`, `"Immersed"`, `"Generic"`, `"Exclude" -> species`, or a predicate on the window |
| `"StoppingCondition"` | `None` | *n* (stop at the *n*-th return to a visited vertex), a predicate on the walk so far, or `{spec, "Delay" -> k}` |
| `"NextVertexFunction"` | `Identity` | a function of the candidate windows -- the window with one admissible candidate appended -- giving the ones to pursue, in the order to try: `Identity` the canonical order, `RandomSample` a random order, `RandomChoice` the random walk, `MinimalBy[f]` the candidates least by `f[window]`, `RandomSample[#, UpTo[n]] &` a pruning to *n* branches per node |

## Basic Examples

The geodesics of at most 8 edges from the centre of the square tiling to a vertex four steps away, at infra-scales 2, 3 and `Infinity`. At scale `Infinity` they are the six shortest paths; at the smaller scales they include locally shortest walks that go round.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  Row @ Table[
    With[{geos = FindInfraGeodesic[g, a, b, sc, UpTo[8], All]},
      Labeled[InfraSubstrateHighlight[g, {geos, Directive[$InfraPointColor], a, b}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {2, 3, Infinity}}]]
```

One geodesic at infra-scale 3 of exactly 6 edges from the centre, beside its vertex sequence.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {geo = FindInfraGeodesic[g, a, 3, {6}]},
  {InfraSubstrateHighlight[g, {geo, Directive[$InfraPointColor], a}], Last /@ VertexList[geo]}]
```

All geodesics of 4 edges from the centre, as the scale grows: every walk at scale 1, the walks that never step back at scale 2, the shortest paths at scale `Infinity`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  Row @ Table[
    With[{geos = FindInfraGeodesic[g, a, sc, {4}, All]},
      Labeled[InfraSubstrateHighlight[g, {geos, Directive[$InfraPointColor], a}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {1, 2, Infinity}}]]
```

## Options

### NextVertexFunction

Under `RandomChoice` the geodesic is a random one, one uniform admissible step at a time. Three geodesics at infra-scale 2 of 12 edges from the centre, one per seed.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {(SeedRandom[seed]; FindInfraGeodesic[g, a, 2, {12}, "NextVertexFunction" -> RandomChoice]), Directive[$InfraPointColor], a}],
    {seed, 3}]]
```

## Properties and Relations

At scale `Infinity` the two-point geodesics are the members of the segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {geos = FindInfraGeodesic[g, a, b, Infinity, Infinity, All]},
  {InfraSubstrateHighlight[g, {geos, Directive[$InfraPointColor], a, b}],
   Sort[Last /@ VertexList[#] & /@ geos] === Sort @ FindInfraSegment[g, a, b, All]}]
```

Every walk found passes [InfraGeodesicQ]() at its scale.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {geos = FindInfraGeodesic[g, a, b, 3, UpTo[8], All]},
  {InfraSubstrateHighlight[g, {geos, Directive[$InfraPointColor], a, b}], InfraGeodesicQ[g, geos, 3]}]
```

## Possible Issues

On a substrate labelled by integers, `FindInfraGeodesic[g, 1, 3, Infinity]` fits two readings: the geodesics from 1 at scale 3 with no budget, and the geodesics from 1 to 3 at scale `Infinity`. The first is an infinite class, so the call is the second. A rule in `Properties` that bounds the class, such as `"Simple"`, makes the first reading finite, and then it wins: the simple geodesic at scale 3 runs on until it is stuck.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {twoPoint = FindInfraGeodesic[g, 1, 3, Infinity]},
  {pointed = FindInfraGeodesic[g, 1, 3, Infinity, Properties -> {"Simple"}]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {twoPoint, Directive[$InfraPointColor], 1, 3}],
    InfraSubstrateHighlight[g, {pointed, Directive[$InfraPointColor], 1}]}]]
```
