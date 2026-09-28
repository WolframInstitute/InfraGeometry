---
Template: Symbol
Name: FindInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraGeodesic
Keywords: [geodesic, infra-scale, locally shortest, walk, Riemannian geodesic]
SeeAlso: [InfraGeodesicQ, ExtendInfraGeodesic, FindInfraWalk, FindInfraSegment, GeodesicIntervalGraph, GeodesicSprayGraph]
RelatedGuides: [RiemannianGeometryGuide]
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
| `Properties` | `{}` | further walk rules, each read on the window: `"Simple"`, `"Immersed"`, `"Generic"`, `"Exclude" -> species`, `"Straightest"`, `{"Minimal", f}`, `{"Maximal", f}`, or a predicate |
| `"StoppingCondition"` | `None` | *n* (stop at the *n*-th return to a visited vertex), a predicate on the walk so far, or `{spec, "Delay" -> k}` |
| `Method` | `Automatic` | `"Exhaustive"`, `{"Exhaustive", "Pruning" -> spec}`, `"Greedy"`, `"RandomGreedy"`; `Automatic` is `"Exhaustive"` for `All` and `"Greedy"` otherwise |

## Basic Examples

The geodesics from 41 to 61 on a grid of at most 8 edges, at infra-scales 2, 3 and `Infinity`. At scale `Infinity` they are the six shortest paths; at the smaller scales, locally shortest walks that go round.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Row[Table[
    With[{geos = FindInfraGeodesic[g, 41, 61, sc, UpTo[8], All]},
      Labeled[
        InfraHighlightGraph[g, {geos, Directive[$InfraPointColor], 41, 61}, ImageSize -> 180],
        Row[{"scale ", sc, ": ", Length @ geos}]]],
    {sc, {2, 3, Infinity}}]]]
```

One geodesic at infra-scale 3 of exactly 6 edges from the centre of the grid, as a vertex sequence.

```wl
Last /@ VertexList @ FindInfraGeodesic[GridGraph[{9, 9}], 41, 3, {6}]
```

The number of geodesics of 4 edges from the centre, as the scale grows: every walk at scale 1, the walks that never step back at scale 2, the shortest paths at scale `Infinity`.

```wl
Table[Length @ FindInfraGeodesic[GridGraph[{9, 9}], 41, sc, {4}, All], {sc, {1, 2, 3, Infinity}}]
```

## Properties and Relations

At scale `Infinity` the two-point geodesics are the members of the segment.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Sort[Last /@ VertexList[#] & /@ FindInfraGeodesic[g, 41, 61, Infinity, Infinity, All]] ===
    Sort @ FindInfraSegment[g, 41, 61, All]]
```

Every walk found passes [InfraGeodesicQ]() at its scale.

```wl
With[
  {g = GridGraph[{9, 9}]},
  InfraGeodesicQ[g, FindInfraGeodesic[g, 41, 61, 3, UpTo[8], All], 3]]
```

## Possible Issues

On a substrate labelled by integers the third argument is read as the scale whenever the rest parses as a budget and a count. So `FindInfraGeodesic[g, 41, 61, Infinity]` asks for geodesics from 41 at scale 61, with no budget, and is refused with a `FindInfraWalk::unbounded` message. Give the budget explicitly in the two-point form.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {Quiet @ FindInfraGeodesic[g, 41, 61, Infinity], Last /@ VertexList @ FindInfraGeodesic[g, 41, 61, Infinity, Infinity]}]
```
