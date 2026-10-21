---
Template: Symbol
Name: RandomInfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraGeodesic
Keywords: [geodesic, infra-scale, locally shortest, walk, Riemannian geodesic]
SeeAlso: [InfraGeodesic, InfraGeodesicQ, RandomInfraWalk, RandomInfraSegment, RandomInfraInfiniteLine, InfraMeasurement]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[RandomInfraGeodesic]()[*g*, *germ*, *s*, *kspec*]</code> gives a random geodesic at infra-scale *s* that extends *germ* by a number of edges within *kspec*.

<code>[RandomInfraGeodesic]()[*g*, *germ*, *s*, *kspec*, *n*]</code> gives a list of *n* such geodesics.

<code>[RandomInfraGeodesic]()[*g*, *germ*, [Infinity]()]</code> gives a random shortest path that extends *germ* until it cannot be extended.

<code>[RandomInfraGeodesic]()[*g*, [InfraGeodesic]()[*germ*, *s*]]</code> gives a random member of the family [InfraGeodesic](), as a vertex list.

<code>[RandomInfraGeodesic]()[*g*, [InfraGeodesic]()[*germ*, *s*], *n*]</code> gives a list of *n* members.

## Details & Options

A walk is a geodesic at infra-scale *s* when every *s* + 1 consecutive vertices form a shortest path, as [InfraGeodesicQ]() tests. At scale 1 every walk is a geodesic; at scale 2 a geodesic never steps back; at scale [Infinity]() it is a shortest path.

A geodesic at a finite scale is locally shortest and may be long overall: it can go round a square and come back to where it started.

The germ is a vertex or a vertex list, and must itself be a geodesic at scale *s*. The walk continues it past its last vertex.

*kspec* is the number of edges added: `UpTo[k]`, `{k}`, `{kmin, kmax}`, or [Infinity](). At a finite scale the geodesics can be arbitrarily long, so [Infinity]() needs scale [Infinity]().

The count *n* can be `n`, `UpTo[n]` or `All`. Fewer than *n* geodesics give `{}`.

A geodesic from the germ form is a walk graph: a directed path graph on the pairs {*i*, *v*} of position and vertex. `Last /@ VertexList[w]` is its vertex sequence.

Options:

| Option | Default | Values |
|---|---|---|
| `"Direction"` | `"Forward"` | `"Forward"`, `"Backward"` (before the first vertex), `"BothSides"` |
| `"StoppingCondition"` | `None` | a predicate on the walk so far; the walk stops when it holds |
| `"NextVertexFunction"` | `Automatic` | `Automatic` (random order, backtracking), `Identity` (fixed order), `RandomChoice` (one random step at a time, no backtracking) |
| [Properties]() | `{}` | further walk rules, as in [RandomInfraWalk]() |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw |

## Basic Examples

A geodesic at infra-scale 4 of 12 edges from the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {RandomInfraGeodesic[g, c, 4, {12}, RandomSeeding -> 1], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

All geodesics of 4 edges from the centre of the grid at scales 1, 2 and [Infinity](): every walk, the walks that never step back, and the shortest paths:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {geodesics = RandomInfraGeodesic[g, c, s, {4}, All]},
    InfraSubstrateHighlight[g, {geodesics, c}, PlotLabel -> Length[geodesics]]],
  {s, {1, 2, Infinity}}]
```

A member of [InfraGeodesic]() at scale 3 through an edge at the centre: a simple geodesic that cannot be extended at either end:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  InfraSubstrateHighlight[g, {InfraWalk[RandomInfraGeodesic[g, InfraGeodesic[germ, 3], RandomSeeding -> 1]], germ},
    ImageSize -> Medium]]
```

## Scope

The geodesics of at most 8 edges from the centre that end at a vertex 4 away, at scales 2, 3 and [Infinity](). At scale [Infinity]() they are the 4 shortest paths; at smaller scales some go round:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
    {grown = RandomInfraGeodesic[g, a, s, UpTo[8], All, "StoppingCondition" -> (Last[#] === b &)]},
    {ending = Select[grown, Last @ Last @ VertexList @ # === b &]},
    InfraSubstrateHighlight[g, {ending, a, b}, PlotLabel -> Length[ending]]],
  {s, {2, 3, Infinity}}]
```

A shortest path from the centre, extended until it cannot be:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, {RandomInfraGeodesic[g, c, Infinity, RandomSeeding -> 1], c}, ImageSize -> Medium]]
```

## Options

### Direction

The shortest paths that contain an edge at the centre and extend it by at most 2 edges at each end:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  {geodesics = RandomInfraGeodesic[g, germ, Infinity, UpTo[2], All, "Direction" -> "BothSides"]},
  InfraSubstrateHighlight[g, {geodesics, germ}, PlotLabel -> Length[geodesics], ImageSize -> Medium]]
```

### NextVertexFunction

Under `RandomChoice` each step is drawn uniformly among the admissible ones. Three geodesics at scale 2 of 12 edges from the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {walk = RandomInfraGeodesic[g, c, 2, {12}, "NextVertexFunction" -> RandomChoice, RandomSeeding -> k]},
    InfraSubstrateHighlight[g, {walk, c}]],
  {k, 3}]
```

### RandomSeeding

A fixed seed gives the same geodesic whatever [SeedRandom]() has set:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[SeedRandom[k]; Last /@ VertexList @ RandomInfraGeodesic[g, 45, 3, {5}, RandomSeeding -> 7], {k, 2}]]
```

## Properties and Relations

At scale [Infinity]() the geodesics that end at *b* are the members of the segment from the germ to *b*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 5], RandomSeeding -> 1]},
  {grown = RandomInfraGeodesic[g, a, Infinity, Infinity, All, "StoppingCondition" -> (Last[#] === b &)]},
  Sort[Select[Last /@ VertexList[#] & /@ grown, Last[#] === b &]] === Sort @ RandomInfraSegment[g, a, b, All]]
```

Every geodesic found passes [InfraGeodesicQ]() at its scale:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraGeodesicQ[g, RandomInfraGeodesic[g, c, 3, {5}, All], 3]]
```

## Possible Issues

At a finite scale a budget is needed; without one the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, Head @ RandomInfraGeodesic[g, 45, 3]]
```
