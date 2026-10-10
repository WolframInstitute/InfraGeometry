---
Template: Symbol
Name: RandomInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraGeodesic
Keywords: [geodesic, infra-scale, locally shortest, walk, Riemannian geodesic]
SeeAlso: [InfraGeodesicQ, RandomInfraWalk, RandomInfraSegment, RandomInfraInfiniteLine, RandomInfraGeodesic, InfraMeasurement, SprayGraph]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[RandomInfraGeodesic]()[*g*, *germ*, *s*, *kspec*]</code> gives one geodesic at infra-scale *s* grown from *germ*, with a length inside the budget *kspec*.

<code>[RandomInfraGeodesic]()[*g*, *germ*, *s*, *kspec*, *n*]</code> gives a `List` of exactly *n* geodesics or `{}`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

Definition: a walk *v0*, *v1*, …, *vk* is a geodesic at infra-scale *s* when every window of *s* consecutive vertices together with the next one is a shortest path: *d(v(i−s), vi) = s* for every *i ≥ s*, and *d(v0, vi) = i* for *i < s*.

The scale is how far back the observer sees. At scale `1` the condition asks only for adjacency, so every walk is a geodesic. At scale `2` it forbids stepping back, and on a graph with triangles also cutting a triangle's corner. At scale `Infinity` the whole walk is a shortest path, a segment. In between, a geodesic is locally shortest and may be globally long: it can wind round a square at scale `2`, and round a larger loop at scale `3`.

This is the Riemannian geodesic read by an observer with a horizon. On a manifold a geodesic minimises length between nearby points only, and it need not be the shortest path between its ends. At infra-scale *s* the same holds with "nearby" meaning "fewer than *s* steps apart".

The germ is a vertex, a vertex list, a walk graph, or a list of germs; a vertex is the one-vertex germ, and the germ must itself be a geodesic at scale *s* for anything to grow. *kspec* is the budget in edges added on each growing side: `UpTo[k]` (at most *k*), `{k}` (exactly *k*), `{lo, hi}`, or `Infinity`. A bare integer is no *kspec*. At a finite scale the class is infinite, so a finite budget is required; only scale `Infinity` accepts `Infinity`.

The default `"Direction"` is `"Forward"`, as for [RandomInfraWalk](): the geodesics that continue the germ past its last vertex. `"Backward"` grows before the first vertex and `"BothSides"` at both ends; at scale `Infinity` a walk germ grown on both sides gives the geodesics that contain it.

A geodesic is a walk graph: a directed path graph on the pairs `{i, v}`, the position and the vertex. `Last /@ VertexList[w]` is its vertex sequence, and `EdgeCount[w]` its length. The count-less call returns one walk graph, or `{}` when there is none.

The search reads only the window, never a target. A target is a stopping condition: `"StoppingCondition" -> (Last[#] === q &)` stops each geodesic at its first arrival at *q*, and the geodesics that end at *q* are the ones left by `Select`. At scale `Infinity` the target-aware search is [RandomInfraSegment]().

`RandomInfraGeodesic` is [RandomInfraWalk]() with `{"Shortest", s}` first among the rules. The options are those of [RandomInfraWalk]():

| Option | Default | Values |
|---|---|---|
| `Properties` | `{}` | further rules, each `rule`, `{rule, r}` or `{rule, r, p}` with the window *r* and the weight *p*: `"Simple"`, `"Shortest"`, `"Stretched"`, or an energy function of the window |
| `"NextVertexFunction"` | `Automatic` | `Automatic` (random candidate order by the weights for bounded counts; canonical for `All`), `Identity`, `RandomSample`, `RandomChoice` (the random walk; the count is independent runs), or a function of the candidate windows giving the ones to pursue in order |
| `"Direction"` | `"Forward"` | `"Forward"`, `"Backward"` or `"BothSides"` |
| `"StoppingCondition"` | `None` | a predicate on the walk so far |

## Basic Examples

The geodesics of at most 8 edges from the centre of the square tiling to a vertex four steps away, at infra-scales 2, 3 and `Infinity`. At scale `Infinity` they are the six shortest paths; at the smaller scales they include locally shortest walks that go round.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  Row @ Table[
    With[
      {grown = RandomInfraGeodesic[g, a, sc, UpTo[8], All, "StoppingCondition" -> (Last[#] === b &)]},
      {geos = Select[grown, Last @ Last @ VertexList @ # === b &]},
      Labeled[InfraSubstrateHighlight[g, {geos, a, b}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {2, 3, Infinity}}]]
```

One geodesic at infra-scale 3 of exactly 6 edges from the centre, beside its vertex sequence.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {geo = RandomInfraGeodesic[g, a, 3, {6}]},
  {InfraSubstrateHighlight[g, {geo, a}], Last /@ VertexList[geo]}]
```

All geodesics of 4 edges from the centre, as the scale grows: every walk at scale 1, the walks that never step back at scale 2, the shortest paths at scale `Infinity`.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  Row @ Table[
    With[{geos = RandomInfraGeodesic[g, a, sc, {4}, All]},
      Labeled[InfraSubstrateHighlight[g, {geos, a}], Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {1, 2, Infinity}}]]
```

A geodesic germ of two vertices grown on both sides: the shortest paths that contain the edge and prolong it by at most 2 edges at each end.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {geos = RandomInfraGeodesic[g, germ, Infinity, UpTo[2], All, "Direction" -> "BothSides"]},
  {InfraSubstrateHighlight[g, {geos, germ}], Length @ geos}]
```

## Options

### NextVertexFunction

Under `RandomChoice` the geodesic is a random one, one uniform admissible step at a time. Three geodesics at infra-scale 2 of 12 edges from the centre, one per seed.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {(SeedRandom[seed]; RandomInfraGeodesic[g, a, 2, {12}, "NextVertexFunction" -> RandomChoice]), a}],
    {seed, 3}]]
```

## Properties and Relations

At scale `Infinity` the geodesics from the centre that end at *b* are the members of the segment.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  {grown = RandomInfraGeodesic[g, a, Infinity, Infinity, All, "StoppingCondition" -> (Last[#] === b &)]},
  {geos = Select[grown, Last @ Last @ VertexList @ # === b &]},
  {InfraSubstrateHighlight[g, {geos, a, b}],
   Sort[Last /@ VertexList[#] & /@ geos] === Sort @ RandomInfraSegment[g, a, b, All]}]
```

Every walk found passes [InfraGeodesicQ]() at its scale.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {geos = RandomInfraGeodesic[g, a, 3, {5}, All]},
  {InfraSubstrateHighlight[g, {geos, a}], InfraGeodesicQ[g, geos, 3]}]
```

A geodesic germ of scale `Infinity` grown without a budget on both sides gives the lines through it: the vertex lists of [RandomInfraInfiniteLine]().

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {germ = {a, First @ AdjacencyList[g, a]}},
  {geos = RandomInfraGeodesic[g, germ, Infinity, Infinity, All, "Direction" -> "BothSides"]},
  {InfraSubstrateHighlight[g, {geos, germ}],
   Sort[Last /@ VertexList[#] & /@ geos] === Sort @ RandomInfraInfiniteLine[g, germ, All]}]
```
