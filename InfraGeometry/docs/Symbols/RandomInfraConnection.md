---
Template: Symbol
Name: RandomInfraConnection
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraConnection
Keywords: [random connection, perfect matching, sampling, enumeration]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHorizontalLift, InfraHolonomy, RandomInfraFiberedGraph, RandomInfraSection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[RandomInfraConnection]()[*fib*]</code> gives a random complete [InfraConnection]() of *fib*.

<code>[RandomInfraConnection]()[*fib*, *n*]</code> gives a list of *n* distinct complete connections.

## Details & Options

A complete connection chooses, over every base edge *pq*, a perfect matching between the fibers *Fₚ* and *F_q* made of transverse edges. It moves every vertex of a fiber to a neighbouring fiber in exactly one way, so every base walk has one horizontal lift from each start.

A connection exists iff every such matching exists: neighbouring fibers have equal size and, by Hall's theorem, every set of vertices of *Fₚ* has at least as many neighbours in *F_q*.

When the fibers over *pq* are joined completely and have *k* vertices, there are *k!* matchings over *pq*. A covering has exactly one connection, all its transverse edges.

The count *n* can be `n`, `UpTo[n]` or `All`. When no connection exists, or fewer than *n*, the result is `{}`. On an empty base the one connection is `InfraConnection[{}]`.

The draws are not uniform over the connections.

Options:

| Option | Default | Values |
|---|---|---|
| `"NextVertexFunction"` | `Automatic` | random order; `Identity` the vertex order; `RandomChoice` one random route; a function ordering the candidates |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

Fibers of two vertices over the 4 × 4 grid, neighbouring fibers joined completely. A random connection keeps one of the two matchings over each edge:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {conn}, PlotLabel -> InfraConnectionQ[fib, conn], ImageSize -> Medium]]
```

Over the 2 × 3 grid, with 7 edges, there are 2⁷ connections:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {Length @ RandomInfraConnection[fib, All], 2^7}]
```

## Scope

Three distinct connections:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  GraphicsRow[InfraFiberedGraphHighlight[fib, {#}] & /@ RandomInfraConnection[fib, 3, RandomSeeding -> 1]]]
```

## Options

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  SameQ @@ Table[SeedRandom[k]; RandomInfraConnection[fib, RandomSeeding -> 7], {k, 3}]]
```

## Properties and Relations

A covering has one connection: its transverse edges, two over each of the 24 edges of the grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {Length @ RandomInfraConnection[fib, All], Length @ First @ RandomInfraConnection[fib, RandomSeeding -> 1],
   2 EdgeCount[GridGraph[{4, 4}]]}]
```

Different connections on the same fibered graph have different holonomies. The holonomy around the square 6, 7, 11, 10 for six random connections:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  Table[InfraHolonomy[fib, RandomInfraConnection[fib, RandomSeeding -> k], {6, 7, 11, 10, 6}], {k, 6}]]
```

## Possible Issues

Equal fiber sizes and transverse edges at every vertex do not give a perfect matching. Two vertices of the fiber over `"p"` share their only neighbour:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[6], UndirectedEdge @@@ {{1, 4}, {2, 4}, {3, 5}, {3, 6}}],
    <|1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q"|>]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> RandomInfraConnection[fib, All], ImageSize -> Medium]]
```

Neighbouring fibers of different sizes have no perfect matching:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Fibration"}, "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  RandomInfraConnection[fib, RandomSeeding -> 1]]
```
