---
Template: Symbol
Name: RandomInfraFiberedGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraFiberedGraph
Keywords: [random fibered graph, fiber size, edge count, property, sampling]
SeeAlso: [InfraFiberedGraph, InfraFiberedGraphQ, InfraFibrationQ, InfraUniqueEdgeLiftingQ, InfraFiberBundleQ, InfraCoveringQ, RandomInfraSection, RandomInfraConnection, RandomInfraFibration]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[RandomInfraFiberedGraph]()[*base*]</code> gives a random [InfraFiberedGraph]() whose base is the graph *base*.

## Details & Options

The fiber over a base vertex *p* has the vertices {*p*, 1}, …, {*p*, *n*}, *n ≥ 1*, and random vertical edges. Transverse edges lie only over base edges, at least one over each, so the base of the result is exactly *base*.

`Properties` is a list of conditions, all imposed:

| Property | Condition |
|---|---|
| `"EqualFiberSizes"` | all fibers have the same size |
| `"IsomorphicFibers"` | all fibers are copies of one random graph |
| `"Fibration"` | every vertex has at least one neighbour over each base neighbour |
| `"AtMostOneEdgeLift"` | every vertex has at most one neighbour over each base neighbour |
| `"UniqueEdgeLifting"` | exactly one neighbour: a perfect matching over each base edge |
| `"FiberBundle"` | isomorphic fibers and matchings that preserve the fiber edges |
| `"Covering"` | unique edge lifting and no vertical edges |

A count is *n* (at most *n*), {*n*} (exactly *n*) or {*lo*, *hi*} (uniform between *lo* and *hi*). Over an edge with fibers of sizes *n*, *m* there are 1 to *nm* transverse edges, at least max(*n*, *m*) with `"Fibration"`, at most min(*n*, *m*) with `"AtMostOneEdgeLift"`, and *n = m* with unique edge lifting. An infeasible request stays unevaluated.

The graph is not uniform among the graphs with the drawn counts.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | a list of the properties above |
| `"VerticalVertexCount"` | `{1}` | the fiber size: *n*, {*n*} or {*lo*, *hi*} |
| `"VerticalEdgeCount"` | `{0}` | the number of edges in a fiber: *n*, {*n*} or {*lo*, *hi*} |
| `"HorizontalEdgeCount"` | `Automatic` | the number of transverse edges over a base edge: *n*, {*n*}, {*lo*, *hi*}; `Automatic` a feasible random count; `All` the complete join |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A random fibered graph over the 4 × 4 grid with fibers of 1 to 3 vertices. Its base is the grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, "VerticalEdgeCount" -> 2,
    RandomSeeding -> 1]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib], InfraBaseSpace[fib]}]]
```

A random fiber bundle with fibers a path of 3 vertices. Transport around a square can reverse the path:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], Properties -> {"FiberBundle"},
    "VerticalVertexCount" -> {3}, "VerticalEdgeCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> InfraHolonomy[fib, conn, {6, 7, 11, 10, 6}], ImageSize -> Medium]]
```

## Options

### Properties

Fibers of 3 vertices with lift existence, lift uniqueness and both. The numbers of neighbours of a vertex over a base neighbour:

```wl
GraphicsRow @ Table[
  With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], Properties -> {prop}, "VerticalVertexCount" -> {3},
      RandomSeeding -> 1]}, {counts = Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]]},
    InfraFiberedGraphHighlight[fib, PlotLabel -> Union[counts]]],
  {prop, {"Fibration", "AtMostOneEdgeLift", "UniqueEdgeLifting"}}]
```

### VerticalVertexCount

A bound, an exact size and a range. The fiber sizes that occur:

```wl
Table[
  With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> spec, RandomSeeding -> 1]},
    Union @ Values[VertexCount /@ InfraFibers[fib]]],
  {spec, {3, {3}, {2, 3}}}]
```

### HorizontalEdgeCount

One transverse edge over each base edge, and the complete join:

```wl
GraphicsRow @ Table[
  InfraFiberedGraphHighlight @ RandomInfraFiberedGraph[GridGraph[{4, 4}],
    "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> h, RandomSeeding -> 1],
  {h, {{1}, All}}]
```

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
SameQ @@ Table[
  SeedRandom[k]; RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 7],
  {k, 3}]
```

## Possible Issues

An exact vertical edge needs fibers of at least 2 vertices. A bound of 3 allows fibers of 1 vertex, so the call stays unevaluated:

```wl
Head @ RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> 3, "VerticalEdgeCount" -> {1}]
```

The complete join of two fibers of 2 vertices is not a matching, so it does not have unique edge lifting:

```wl
Head @ RandomInfraFiberedGraph[GridGraph[{4, 4}],
  Properties -> {"UniqueEdgeLifting"}, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All]
```
