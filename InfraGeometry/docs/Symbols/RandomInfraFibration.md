---
Template: Symbol
Name: RandomInfraFibration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraFibration
Keywords: [random fibration, random fibered graph, fiber]
SeeAlso: [InfraFibration, InfraFibrationQ, InfraFiberBundleQ, InfraFiberedSubstrate, RandomInfraSection, RandomInfraConnection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[RandomInfraFibration]()[*base*]</code> gives a random [InfraFibration]() over the graph *base*, each fiber drawn around its base vertex.

## Details & Options

- The total vertices over a base vertex *p* are the pairs {*p*, *k*}. The fiber vertex *i* over *p* meets the fiber vertex *j* over *q* iff *i*/*n1* and *j*/*n2* nearly agree, for *p* and *q* within the horizontal radius; the density widens this diagonal matching.
- An option value given as a range {*min*, *max*} is drawn at random for every fiber.
- [SeedRandom]() in front of the call gives the same fibration again.

Options:

| Option | Default | Values |
|---|---|---|
| `"VerticalVertices"` | 1 | the number of vertices of a fiber, or a range |
| `"VerticalEdges"` | 0 | the number of edges inside a fiber, or a range |
| `"HorizontalEdgesRadius"` | 1 | base vertices within this distance get edges between their fibers |
| `"HorizontalEdgesDensity"` | 1 | how wide the matching between two fibers is |
| `"IsomorphicFibers"` | `False` | `True` gives every fiber the same size and the same edges |

## Basic Examples

A random fibration over a 3 x 3 grid with three vertices and one edge in each fiber. The fiber over the centre is drawn.

```wl
With[
  {fib = (SeedRandom[1]; RandomInfraFibration[GridGraph[{3, 3}], "VerticalVertices" -> 3, "VerticalEdges" -> 1])},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, {InfraDensity[total, VertexList @ InfraFiber[fib, 5]]}]]
```

With the default options each fiber is one vertex, and the total graph is a copy of the base.

```wl
With[
  {fib = (SeedRandom[1]; RandomInfraFibration[CycleGraph[6]])},
  {InfraTotalGraph[fib], IsomorphicGraphQ[InfraTotalGraph[fib], CycleGraph[6]]}]
```

## Options

### VerticalVertices

A range gives fibers of different sizes.

```wl
With[
  {fib = (SeedRandom[2]; RandomInfraFibration[CycleGraph[6], "VerticalVertices" -> {1, 4}])},
  {total = InfraTotalGraph[fib]},
  InfraSubstrateHighlight[total, InfraDensity[total, VertexList @ #] & /@ Values @ InfraFibers[fib]]]
```

### HorizontalEdgesDensity

Two vertices in every fiber, every pair of adjacent fibers joined completely.

```wl
With[
  {fib = (SeedRandom[3]; RandomInfraFibration[CycleGraph[6], "VerticalVertices" -> 2, "IsomorphicFibers" -> True, "HorizontalEdgesDensity" -> 2])},
  {InfraTotalGraph[fib], InfraFibrationQ[fib]}]
```
