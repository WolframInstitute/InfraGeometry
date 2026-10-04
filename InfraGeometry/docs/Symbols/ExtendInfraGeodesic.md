---
Template: Symbol
Name: ExtendInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ExtendInfraGeodesic
Keywords: [geodesic, extension, infra-scale, continuation, Euclid Postulate 2]
SeeAlso: [FindInfraGeodesic, InfraGeodesicQ, ExtendInfraWalk, GeodesicExtensionGraph, ExtendInfraSegment]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[ExtendInfraGeodesic]()[*g*, *seed*, *s*, *kspec*]</code> continues the walk *seed* at both ends as a geodesic at infra-scale *s*, by a budget of *kspec* edges.

<code>[ExtendInfraGeodesic]()[*g*, *seed*, *s*, *kspec*, *n*]</code> gives a `List` of exactly *n* extensions or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

Definition: an extension of *seed* at infra-scale *s* is a geodesic at infra-scale *s* that contains *seed* as a consecutive stretch: every window of *s* consecutive vertices together with the next one is a shortest path, the windows inside the seed included.

This is the continuation of a geodesic as a Riemannian observer sees it. A geodesic on a manifold continues uniquely from its velocity; on a graph the continuation branches, and the scale says how much of the past the next step must respect. At scale `Infinity` the whole walk stays a shortest path, which is Euclid's second postulate read on a graph.

The seed is a vertex list, a walk graph, or a list of either. A seed that is not itself a geodesic at infra-scale *s* has no extension. Grown at both ends, the walk is checked across the seed, so the two sides cannot meet in a window that is not a shortest path.

*kspec* is the budget of added edges: `UpTo[k]`, `{k}`, `{lo, hi}` or `Infinity`, as for [FindInfraGeodesic](). At both ends it counts the edges added on the longer side. At a finite scale the class is infinite, so a finite budget is required.

An extension is a walk graph: `Last /@ VertexList[w]` is its vertex sequence. The count-less call returns one extension, found greedily.

`ExtendInfraGeodesic` is [ExtendInfraWalk]() at `"InfraScale" -> s` with `"Minimizing"` added to the rules. The options:

| Option | Default | Values |
|---|---|---|
| `"Direction"` | `"BothSides"` | `"Forward"` (past the last vertex), `"Backward"` (before the first), `"BothSides"` |
| `Properties` | `{}` | further walk rules, as for [FindInfraWalk]() |
| `"StoppingCondition"` | `None` | as for [FindInfraWalk](); needs `"Forward"` or `"Backward"`, since it reads a single growing tip |
| `"NextVertexFunction"` | `Identity` | a function of the candidate windows -- the window with one admissible candidate appended -- giving the ones to pursue, in the order to try: `Identity` the canonical order, `RandomSample` a random order, `RandomChoice` the random walk, `MinimalBy[f]` the candidates least by `f[window]`, `RandomSample[#, UpTo[n]] &` a pruning to *n* branches per node |

## Basic Examples

Every forward extension of an edge at the centre of the square tiling by three edges, at infra-scales 2, 3 and `Infinity`. The fan narrows as the observer sees further back.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {seed = {1, 2}},
  Row @ Table[
    With[{extList = ExtendInfraGeodesic[g, seed, sc, {3}, All, "Direction" -> "Forward"]},
      Labeled[
        InfraSubstrateHighlight[g, {extList, Directive[$InfraPointColor], InfraWalk[seed]}],
        Row[{"scale ", sc, ": ", Length @ extList}]]],
    {sc, {2, 3, Infinity}}]]
```

One extension at both ends, two edges on the longer side, beside its vertex sequence.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {seed = {1, 2}},
  {ext = ExtendInfraGeodesic[g, seed, Infinity, {2}]},
  {InfraSubstrateHighlight[g, {ext, Directive[$InfraPointColor], InfraWalk[seed]}], Last /@ VertexList[ext]}]
```

A shortest path found by [FindInfraGeodesic](), continued forward by four edges.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, a, 4])},
  {geo = FindInfraGeodesic[g, a, b, Infinity, Infinity]},
  {ext = ExtendInfraGeodesic[g, geo, Infinity, {4}, "Direction" -> "Forward"]},
  InfraSubstrateHighlight[g, {ext, geo, Directive[$InfraPointColor], a, b}]]
```

## Options

### Direction

The extensions of an edge by two edges forward, backward and at both ends, at infra-scale `Infinity`.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {seed = {1, 2}},
  Row @ Table[
    Labeled[
      InfraSubstrateHighlight[g, {ExtendInfraGeodesic[g, seed, Infinity, {2}, All, "Direction" -> dir], Directive[$InfraPointColor], InfraWalk[seed]}],
      dir],
    {dir, {"Forward", "Backward", "BothSides"}}]]
```

## Properties and Relations

At scale `Infinity` the forward extensions are the paths from the seed's end in [GeodesicExtensionGraph](), drawn beneath them.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {seed = {1, 2}},
  {extDag = GeodesicExtensionGraph[g, seed]},
  {extList = ExtendInfraGeodesic[g, seed, Infinity, {3}, All, "Direction" -> "Forward"]},
  {InfraSubstrateHighlight[g, {extDag, extList}],
   Sort[Rest[Last /@ VertexList[#]] & /@ extList] ===
     Sort @ Select[Catenate[FindPath[extDag, 2, #, {3}, All] & /@ VertexList[extDag]], Length[#] == 4 &]}]
```

## Possible Issues

A seed that steps back is a geodesic at scale 1 and not at scale 2, so it has extensions at scale 1 and none at scale 2.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {backStep = {1, 2, 1}},
  {InfraSubstrateHighlight[g, {ExtendInfraGeodesic[g, backStep, 1, {2}], Directive[$InfraPointColor], InfraWalk[backStep]}],
   ExtendInfraGeodesic[g, backStep, 2, {2}]}]
```
