---
Template: Symbol
Name: InfraAntiderivative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraAntiderivative
Keywords: [antiderivative, integral, incidence algebra, zeta function, kernel, past, causal set, directed acyclic graph, spray order, random walk]
SeeAlso: [InfraDerivative, InfraIntegral, InfraDifferential, InfraMeasurement, SprayGraph, InfraSegment]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraAntiderivative]()[*f*]</code> is the antiderivative of the vertex function *f*: the sum of *f* over the past of each vertex.

<code>[InfraAntiderivative]()[*f*, [Method]() -> *m*]</code> sums *f* over the past with the kernel of the method *m*.

## Details & Options

The antiderivative with kernel *K* is *F(v) = Σ f(u) K(u, v)*, the sum over the *u ⪯ v*, with *K(v, v) = 1*. [InfraDerivative]() is its exact inverse.

| Substrate | Order *u ⪯ v* | Links *u ⋖ v* |
|---|---|---|
| directed acyclic graph | *v* is reachable from *u* | the edges of [TransitiveReductionGraph]() |
| undirected graph, `"Origin" -> c` | *u* lies on a shortest path from *c* to *v* | the edges of <code>[SprayGraph]()[*g*, *c*]</code> |

From an origin the intervals of the order are the supports of the segments. On a directed acyclic graph an implied edge changes nothing.

*f* is an [Association]() *v* -> *x*, a missing vertex counting as 0, or a function applied to each vertex.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Zeta"` | the kernel, below |
| `"Origin"` | `Automatic` | a vertex *c*, required on an undirected graph |
| `"Direction"` | `"Past"` | `"Future"` reverses the order |

Every method but `"Zeta"` is a path kernel *K = (1 − W)⁻¹*, a weight *W* on the links multiplied along the chains from *u* to *v*. Then *F(v) = f(v) + Σ W(u, v) F(u)*, the sum over the links *u ⋖ v*.

| [Method]() | *K(u, v)* | *W(u, v)* |
|---|---|---|
| `"Zeta"` | 1, the zeta function of the order | — |
| `"PathCount"` | the number of chains from *u* to *v* | 1 |
| `"BackwardRandomWalk"` | the probability that the walk back from *v* to uniformly random predecessors visits *u* | 1 / indeg(*v*) |
| `"ForwardRandomWalk"` | the probability that the walk forward from *u* to uniformly random successors visits *v* | 1 / outdeg(*u*) |
| `"UniformChain"` | the probability that a uniformly random maximal chain to *v* passes through *u* | *N(u) / N(v)*, *N* the number of maximal chains |
| `{"Weights", w}` | the sum over the chains from *u* to *v* of the product of *w* | *w* |

| Reading | Value |
|---|---|
| `"Function"` | the antiderivative, an [Association]() *v* -> *F(v)* |
| `"Kernel"` | the [Association]() `{u, v} -> K(u, v)` of the nonzero values |

`All` gives both. An unknown method, an undirected graph without an origin or a directed graph with a cycle leaves the reading unevaluated.

## Basic Examples

The antiderivative of 1 from the centre: at each vertex *v*, the number of vertices of the segment from the centre to *v*. On the grid, away from the pendant vertices of the rim, it is *(a + 1)(b + 1)*, with *a* and *b* the steps along the two axes:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraMeasurement[g, InfraAntiderivative[1 &, "Origin" -> c], "Function"], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the diamond *1 < 2, 3 < 4* the zeta and the path-count antiderivative differ at the top, which two chains join to the bottom:

```wl
With[{diamond = Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}]}, {f = <|1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7|>},
  Table[InfraMeasurement[diamond, InfraAntiderivative[f, Method -> m], "Function"], {m, {"Zeta", "PathCount"}}]]
```

## Scope

Every method on the function 1 at the vertex (7, 7) of the grid, centre (5, 5). The segment to it is a 3 × 3 square. `"Zeta"` counts its 9 vertices, `"PathCount"` each vertex once per chain from it, `"BackwardRandomWalk"` and `"UniformChain"` the 5 vertices of a shortest path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = First @ Nearest[GraphEmbedding[g] -> VertexList[g], {7, 7}]},
  Table[m -> InfraMeasurement[g, InfraAntiderivative[1 &, Method -> m, "Origin" -> c], "Function"][q],
    {m, {"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"}}]]
```

## Options

### Direction

`"Future"` sums over the future, the antiderivative on the reversed graph:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = <|1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4|>},
  {InfraMeasurement[dag, InfraAntiderivative[f, "Direction" -> "Future"], "Function"],
   InfraMeasurement[dag, InfraAntiderivative[f, "Direction" -> "Future"], "Function"] ===
     InfraMeasurement[ReverseGraph[dag], InfraAntiderivative[f], "Function"]}]
```

## Properties and Relations

[InfraDerivative]() with the same method inverts the antiderivative, in both orders:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = <|1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4|>},
  Table[m -> {
     InfraMeasurement[dag, InfraDerivative[InfraAntiderivative[f, Method -> m], Method -> m], "Function"] === f,
     InfraMeasurement[dag, InfraAntiderivative[InfraDerivative[f, Method -> m], Method -> m], "Function"] === f},
    {m, {"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"}}]]
```

The forward random walk carries all the mass to the maximal elements. Here the only maximal element is 6:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = <|1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4|>},
  {InfraMeasurement[dag, InfraAntiderivative[f, Method -> "ForwardRandomWalk"], "Function"][6], Total[f]}]
```

From an origin *c*, the zeta antiderivative at *v* is the sum of *f* over the segment from *c* to *v*, and the uniform-chain antiderivative the mean of the integral of *f* along it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g], f = Mod[#^2, 11] &},
  {zeta = InfraMeasurement[g, InfraAntiderivative[f, "Origin" -> c], "Function"],
   uniform = InfraMeasurement[g, InfraAntiderivative[f, Method -> "UniformChain", "Origin" -> c], "Function"]},
  {AllTrue[VertexList[g],
     zeta[#] == Total[f /@ Keys @ InfraMeasurement[g, InfraSegment[c, #], "VertexDensity"]] &],
   AllTrue[VertexList[g], uniform[#] == InfraMeasurement[g, InfraIntegral[f, InfraSegment[c, #]], "Mean"] &]}]
```

Blow each vertex of the diamond up into two copies and each link into the four links between the copies, spread *f* evenly and add the copies back. The random walks and, on this graded order, `"UniformChain"` commute with the blow-up; `"Zeta"` and `"PathCount"` count the new chains and do not:

```wl
With[{diamond = Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], f = <|1 -> 2, 2 -> -1, 3 -> 5, 4 -> 3|>},
  {big = Graph[Flatten @ Table[DirectedEdge[{First[e], i}, {Last[e], j}], {e, EdgeList[diamond]}, {i, 2}, {j, 2}]],
   spread = Association @ Flatten @ Table[{v, i} -> f[v] / 2, {v, 4}, {i, 2}]},
  Table[m -> (Values @ InfraMeasurement[diamond, InfraAntiderivative[f, Method -> m], "Function"] ===
      Total /@ Partition[Values @ KeySort @
        InfraMeasurement[big, InfraAntiderivative[spread, Method -> m], "Function"], 2]),
    {m, {"Zeta", "PathCount", "BackwardRandomWalk", "UniformChain", "ForwardRandomWalk"}}]]
```
