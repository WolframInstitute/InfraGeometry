---
Template: Symbol
Name: ExtendInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ExtendInfraGeodesic
Keywords: [geodesic, extension, infra-scale, continuation, Euclid Postulate 2]
SeeAlso: [FindInfraGeodesic, InfraGeodesicQ, ExtendInfraWalk, GeodesicExtensionGraph, ExtendInfraSegment]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[ExtendInfraGeodesic]()[*g*, *seed*, *s*, *kspec*]</code> continues the walk *seed* at both ends as a geodesic at infra-scale *s*, by a budget of *kspec* edges.

<code>[ExtendInfraGeodesic]()[*g*, *seed*, *s*, *kspec*, *n*]</code> gives a `List` of exactly *n* extensions or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

Definition: an extension of *seed* at infra-scale *s* is a walk that contains *seed* as a consecutive stretch and whose every added step keeps its window a shortest path: the last *s* vertices before the new one, together with it, are at distance *s* apart.

This is the continuation of a geodesic as a Riemannian observer sees it. A geodesic on a manifold continues uniquely from its velocity; on a graph the continuation branches, and the scale says how much of the past the next step must respect. At scale `Infinity` the whole walk stays a shortest path, which is Euclid's second postulate read on a graph.

The seed is a vertex list, a walk graph, or a list of either. It is taken as given: the rule is checked on the steps added, not on the seed.

*kspec* is the budget of added edges: `UpTo[k]`, `{k}`, `{lo, hi}` or `Infinity`, as for [FindInfraGeodesic](). At both ends it counts the edges added on the longer side. At a finite scale the class is infinite, so a finite budget is required.

An extension is a walk graph: `Last /@ VertexList[w]` is its vertex sequence. The count-less call returns one extension, found greedily.

`ExtendInfraGeodesic` is [ExtendInfraWalk]() at `"InfraScale" -> s` with `"Minimizing"` added to the rules. The options:

| Option | Default | Values |
|---|---|---|
| `"Direction"` | `"BothSides"` | `"Forward"` (past the last vertex), `"Backward"` (before the first), `"BothSides"` |
| `Properties` | `{}` | further walk rules, as for [FindInfraWalk]() |
| `"StoppingCondition"` | `None` | as for [FindInfraWalk](); needs `"Forward"` or `"Backward"`, since it reads a single growing tip |
| `Method` | `Automatic` | `"Exhaustive"`, `{"Exhaustive", "Pruning" -> spec}`, `"Greedy"`, `"RandomGreedy"` |

## Basic Examples

Every forward extension of the edge from 41 to 42 by three edges, at infra-scales 2, 3 and `Infinity`. The fan narrows as the observer sees further back.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Row[Table[
    With[{extList = ExtendInfraGeodesic[g, {41, 42}, sc, {3}, All, "Direction" -> "Forward"]},
      Labeled[
        InfraSubstrateHighlight[g, {extList, Directive[$InfraPointColor], InfraWalk[{41, 42}]}, ImageSize -> 180],
        Row[{"scale ", sc, ": ", Length @ extList}]]],
    {sc, {2, 3, Infinity}}]]]
```

One extension at both ends, two edges on the longer side.

```wl
Last /@ VertexList @ ExtendInfraGeodesic[GridGraph[{9, 9}], {41, 42}, Infinity, {2}]
```

A geodesic found by [FindInfraGeodesic](), continued forward.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Last /@ VertexList @ ExtendInfraGeodesic[g, FindInfraGeodesic[g, 41, 61, Infinity, Infinity], Infinity, {2},
    "Direction" -> "Forward"]]
```

## Properties and Relations

At scale `Infinity` the forward extensions are the paths from the seed's end in [GeodesicExtensionGraph]().

```wl
With[
  {g = GridGraph[{9, 9}]},
  {extDag = GeodesicExtensionGraph[g, {41, 42}]},
  Sort[Rest[Last /@ VertexList[#]] & /@ ExtendInfraGeodesic[g, {41, 42}, Infinity, {3}, All, "Direction" -> "Forward"]] ===
    Sort @ Select[Catenate[FindPath[extDag, 42, #, {3}, All] & /@ VertexList[extDag]], Length[#] == 4 &]]
```

## Possible Issues

The seed is not tested. A seed that steps back is extended at scale 2, and the result is not a geodesic at that scale.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {walkSeq = Last /@ VertexList @ ExtendInfraGeodesic[g, {41, 42, 41}, 2, {2}]},
  {walkSeq, InfraGeodesicQ[g, walkSeq, 2]}]
```
