---
Template: Symbol
Name: FindInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraGeodesic
Keywords: [geodesic, infra-scale, locally shortest, walk, Riemannian geodesic]
SeeAlso: [InfraGeodesicQ, FindInfraWalk, FindInfraSegment, FindInfraLine, FindInfraRepresentative, InfraMeasurement, SprayGraph]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraGeodesic]()[*g*, *germ*, *s*, *kspec*]</code> gives one geodesic at infra-scale *s* grown from *germ*, with a length inside the budget *kspec*.

<code>[FindInfraGeodesic]()[*g*, *germ*, *s*, *kspec*, *n*]</code> gives a `List` of exactly *n* geodesics or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

Definition: a walk *v0*, *v1*, …, *vk* is a geodesic at infra-scale *s* when every window of *s* consecutive vertices together with the next one is a shortest path: *d(v(i−s), vi) = s* for every *i ≥ s*, and *d(v0, vi) = i* for *i < s*.

The scale is how far back the observer sees. At scale `1` the condition asks only for adjacency, so every walk is a geodesic. At scale `2` it forbids stepping back, and on a graph with triangles also cutting a triangle's corner. At scale `Infinity` the whole walk is a shortest path, a segment. In between, a geodesic is locally shortest and may be globally long: it can wind round a square at scale `2`, and round a larger loop at scale `3`.

This is the Riemannian geodesic read by an observer with a horizon. On a manifold a geodesic minimises length between nearby points only, and it need not be the shortest path between its ends. At infra-scale *s* the same holds with "nearby" meaning "fewer than *s* steps apart".

The germ is a vertex, a vertex list, a walk graph, or a list of germs; a vertex is the one-vertex germ, and the germ must itself be a geodesic at scale *s* for anything to grow. *kspec* is the budget in edges added on each growing side: `UpTo[k]` (at most *k*), `{k}` (exactly *k*), `{lo, hi}`, or `Infinity`. A bare integer is no *kspec*. At a finite scale the class is infinite, so a finite budget is required; only scale `Infinity` accepts `Infinity`.

The default `"Direction"` is `"Forward"` on a one-vertex germ and `"BothSides"` on a longer one, as for [FindInfraWalk](). At scale `Infinity` a walk germ grown on both sides gives the geodesics that contain it.

A geodesic is a walk graph: a directed path graph on the pairs `{i, v}`, the position and the vertex. `Last /@ VertexList[w]` is its vertex sequence, and `EdgeCount[w]` its length. The count-less call returns one walk graph, or `{}` when there is none.

The search reads only the window, never a target. A target is a stopping condition: `"StoppingCondition" -> (Last[#] === q &)` stops each geodesic at its first arrival at *q*, and the geodesics that end at *q* are the ones left by `Select`. At scale `Infinity` the target-aware search is [FindInfraSegment]().

`FindInfraGeodesic` is [FindInfraWalk]() at `"InfraScale" -> s` with `"Minimizing"` added to the rules. The options are those of [FindInfraWalk]():

| Option | Default | Values |
|---|---|---|
| `Properties` | `{}` | further walk rules, each read on the window: `"Simple"`, `"Immersed"`, `"Generic"`, `"Exclude" -> species`, or a predicate on the window |
| `"StoppingCondition"` | `None` | *n* (stop at the *n*-th return to a visited vertex), a predicate on the walk so far, or `{spec, "Delay" -> k}` |
| `"Direction"` | `Automatic` | `"Forward"`, `"Backward"` or `"BothSides"` |
| `"NextVertexFunction"` | `Identity` | a function of the candidate windows -- the window with one admissible candidate appended -- giving the ones to pursue, in the order to try: `Identity` the canonical order, `RandomSample` a random order, `RandomChoice` the random walk, `MinimalBy[f]` the candidates least by `f[window]`, `RandomSample[#, UpTo[n]] &` a pruning to *n* branches per node |

## Basic Examples

The geodesics of at most 8 edges from the centre of the square tiling to a vertex four steps away, at infra-scales 2, 3 and `Infinity`. At scale `Infinity` they are the six shortest paths; at the smaller scales they include locally shortest walks that go round.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  Row @ Table[
    With[
      {grown = FindInfraGeodesic[g, a, sc, UpTo[8], All, "StoppingCondition" -> (Last[#] === b &)]},
      {geos = Select[grown, Last @ Last @ VertexList @ # === b &]},
      Labeled[InfraSubstrateHighlight[g, {geos, a, b}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {2, 3, Infinity}}]]
```

One geodesic at infra-scale 3 of exactly 6 edges from the centre, beside its vertex sequence.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {geo = FindInfraGeodesic[g, a, 3, {6}]},
  {InfraSubstrateHighlight[g, {geo, a}], Last /@ VertexList[geo]}]
```

All geodesics of 4 edges from the centre, as the scale grows: every walk at scale 1, the walks that never step back at scale 2, the shortest paths at scale `Infinity`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  Row @ Table[
    With[{geos = FindInfraGeodesic[g, a, sc, {4}, All]},
      Labeled[InfraSubstrateHighlight[g, {geos, a}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {1, 2, Infinity}}]]
```

A geodesic germ of two vertices grown on both sides: the shortest paths that contain the edge and prolong it by at most 2 edges at each end.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {geos = FindInfraGeodesic[g, germ, Infinity, UpTo[2], All]},
  {InfraSubstrateHighlight[g, {geos, germ}], Length @ geos}]
```

## Options

### NextVertexFunction

Under `RandomChoice` the geodesic is a random one, one uniform admissible step at a time. Three geodesics at infra-scale 2 of 12 edges from the centre, one per seed.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {(SeedRandom[seed]; FindInfraGeodesic[g, a, 2, {12}, "NextVertexFunction" -> RandomChoice]), a}],
    {seed, 3}]]
```

## Properties and Relations

At scale `Infinity` the geodesics from the centre that end at *b* are the members of the segment.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {grown = FindInfraGeodesic[g, a, Infinity, Infinity, All, "StoppingCondition" -> (Last[#] === b &)]},
  {geos = Select[grown, Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {geos, a, b}],
   Sort[Last /@ VertexList[#] & /@ geos] === Sort @ FindInfraSegment[g, a, b, All]}]
```

Every walk found passes [InfraGeodesicQ]() at its scale.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {geos = FindInfraGeodesic[g, a, 3, {5}, All]},
  {InfraSubstrateHighlight[g, {geos, a}], InfraGeodesicQ[g, geos, 3]}]
```

A geodesic germ of scale `Infinity` grown without a budget on both sides gives the lines through it: the vertex lists of [FindInfraLine]().

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {geos = FindInfraGeodesic[g, germ, Infinity, Infinity, All]},
  {InfraSubstrateHighlight[g, {geos, germ}],
   Sort[Last /@ VertexList[#] & /@ geos] === Sort @ FindInfraLine[g, germ, All]}]
```
