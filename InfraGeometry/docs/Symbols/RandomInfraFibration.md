---
Template: Symbol
Name: RandomInfraFibration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraFibration
Keywords: [random fibration, random fibered graph, fiber]
SeeAlso: [RandomInfraFiberedGraph, InfraFiberedGraph, InfraFibration, InfraFibrationQ, InfraFiberBundleQ, InfraFiberedSubstrate, RandomInfraSection, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles, Experimental]
RelatedTutorials: [ExperimentalInfraBundles]
---

## Usage

<code>[RandomInfraFibration]()[*base*]</code> gives a random [InfraFibration]() whose base is the graph *base*.

## Details & Options

The fiber over *p* has the vertices {*p*, 1}, …, {*p*, *n*} and random vertical edges. Over every base edge the transverse edges form a band: with fibers of sizes *n*, *m* and density *d*, the vertices {*p*, *i*} and {*q*, *j*} are joined iff *(i m − j n) mod nm < d max(n, m)*.

For fibers of equal size *n* the band is cyclic: {*p*, *i*} is joined to the {*q*, *j*} with *(i − j) mod n < d*. So every vertex has exactly *d* neighbours over each base neighbour, for *d = 1, …, n*. Density 1 then joins {*p*, *i*} to {*q*, *i*}.

The default, one vertex per fiber, gives a copy of the base.

[RandomInfraFiberedGraph]() is the general sampler; this one is Experimental and keeps its own options.

Options:

| Option | Default | Values |
|---|---|---|
| `"VerticalVertices"` | 1 | the fiber size *n*, or {*lo*, *hi*} for a random size per fiber |
| `"VerticalEdges"` | 0 | the number of edges in a fiber, or {*lo*, *hi*}; capped at *n(n − 1)/2* |
| `"HorizontalEdgesDensity"` | 1 | the band width *d* > 0, a range {*lo*, *hi*} of reals, or `All` for the complete join |
| `"HorizontalEdgesRadius"` | 1 | only 1 |
| `"IsomorphicFibers"` | [False]() | [True]() for copies of one random fiber graph |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

Fibers of 3 vertices with one vertical edge over the 4 × 4 grid:

```wl
With[{fib = RandomInfraFibration[GridGraph[{4, 4}], "VerticalVertices" -> 3, "VerticalEdges" -> 1,
    RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, ImageSize -> Medium]]
```

With the default options the total graph is a copy of the base:

```wl
With[{fib = RandomInfraFibration[GridGraph[{4, 4}], RandomSeeding -> 1]},
  {IsomorphicGraphQ[InfraTotalSpace[fib], GridGraph[{4, 4}]], InfraCoveringQ[fib]}]
```

## Options

### VerticalVertices

A range gives fibers of different sizes:

```wl
With[{fib = RandomInfraFibration[GridGraph[{4, 4}], "VerticalVertices" -> {1, 3}, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> Union @ Values[VertexCount /@ InfraFibers[fib]],
    ImageSize -> Medium]]
```

### HorizontalEdgesDensity

With fibers of 3 vertices, density *d* gives every vertex *d* neighbours over each base neighbour:

```wl
Table[
  With[{fib = RandomInfraFibration[GridGraph[{4, 4}], "VerticalVertices" -> 3, "HorizontalEdgesDensity" -> d,
      RandomSeeding -> 1]},
    Union @ Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]]],
  {d, 3}]
```

### IsomorphicFibers

One random fiber graph, copied to every fiber:

```wl
With[{fib = RandomInfraFibration[GridGraph[{4, 4}], "VerticalVertices" -> 3, "VerticalEdges" -> {1, 3},
    "IsomorphicFibers" -> True, RandomSeeding -> 1]},
  InfraIsomorphicFibersQ[fib]]
```

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
SameQ @@ Table[
  SeedRandom[k]; RandomInfraFibration[GridGraph[{4, 4}], "VerticalVertices" -> {1, 3}, RandomSeeding -> 7],
  {k, 3}]
```

## Possible Issues

Density 0 would leave base edges without a lift, and a radius other than 1 is not supported. Both calls stay unevaluated:

```wl
{Head @ RandomInfraFibration[GridGraph[{4, 4}], "HorizontalEdgesDensity" -> 0],
 Head @ RandomInfraFibration[GridGraph[{4, 4}], "HorizontalEdgesRadius" -> 2]}
```
