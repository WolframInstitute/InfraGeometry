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

<code>[InfraAntiderivative]()[*f*]</code> is the antiderivative of the vertex function *f*: *F(v) = Σ_(u ⪯ v) f(u)*, the sum of *f* over the past of each vertex. It is a symbolic object; [InfraMeasurement]() evaluates it on a graph.

<code>[InfraAntiderivative]()[*f*, [Method]() -> *m*]</code> accumulates *f* through the kernel of the method *m*: *F(v) = Σ_(u ⪯ v) f(u) K(u, v)*.

## Details & Options

Definition: the antiderivative with kernel *K* is *(I_K f)(v) = Σ_(u ⪯ v) f(u) K(u, v)*, where *K* is a function on the pairs *u ⪯ v* of the order with *K(v, v) = 1*, an element of its incidence algebra. [InfraDerivative]() is its exact inverse.

The order:

| Substrate | Order *u ⪯ v* | Links *u ⋖ v* |
|---|---|---|
| directed acyclic graph | *v* is reachable from *u* | the edges of `TransitiveReductionGraph` |
| undirected graph, `"Origin" -> c` | the spray order, *d(c, u) + d(u, v) = d(c, v)* | the edges of <code>[SprayGraph]()[*g*, *c*]</code> |

On a directed acyclic graph everything reads the links, so adding an implied edge changes nothing. From an origin the intervals of the order are the segments: *u ⪯ v* exactly when *u* lies on a shortest path from *c* to *v*. Vertices that *c* does not reach are left out.

*f* is a 0-form: an [Association]() *v* -> *x*, in which a missing vertex counts as 0, or a function applied to each vertex. A head with a `"Function"` reading is read through it.

| Option | Default | Value |
|---|---|---|
| [Method]() | `"Volume"` | the kernel, below |
| `"Origin"` | `Automatic` | `Automatic` on a directed acyclic graph; a vertex *c*, required on an undirected graph |
| `"Direction"` | `"Past"` | `"Past"`, or `"Future"`, which reverses the order |

Every method but `"Volume"` is a path kernel *K = (1 − W)^(−1)*: *K(u, v)* sums, over the chains from *u* to *v*, the product of a weight *W* on their links, and *F(v) = f(v) + Σ_(u ⋖ v) W(u, v) F(u)*.

| [Method]() | *K* or *W* | *F(v)* |
|---|---|---|
| `"Volume"` | *K = 1* on every pair, the zeta function | the sum of *f* over the past; from an origin, over the support of <code>[InfraSegment]()[*c*, *v*]</code> |
| `"Paths"` | *W = 1* | the sum of *f(u)* times the number of chains from *u* to *v* |
| `"Average"` | *W(u, v) = 1 / indeg(v)* | the expected integral of *f* along the random walk back from *v* |
| `"Uniform"` | *W(u, v) = N(u) / N(v)*, *N* the number of chains from the minimal elements | the mean integral of *f* over the chains from the minimal elements; from an origin the `"Mean"` of the integral of *f* along <code>[InfraSegment]()[*c*, *v*]</code> |
| `"Flow"` | *W(u, v) = 1 / outdeg(u)* | the mass of *f* reaching *v* when each vertex splits its mass evenly over its out-links |
| `{"Weights", w}` | *W = w*, an [Association]() on the links | |

The degrees are those of the links. Arithmetic stays exact.

| Reading | Value |
|---|---|
| `"Function"` | the antiderivative, an [Association]() *v* -> *F(v)* in the order of `VertexList` |
| `"Kernel"` | the kernel, an [Association]() `{u, v} -> K(u, v)` over the pairs *u ⪯ v* with a nonzero value |

`All` gives both. An unknown method or option, an undirected graph without an origin, or a directed graph with a cycle leaves the reading unevaluated.

## Basic Examples

The volume and the path antiderivative of a function on the diamond *1 < 2, 3 < 4*. They differ at the top, which two chains join to the bottom.

```wl
With[
  {diamond = Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], f = <|1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7|>},
  Normal /@ {InfraMeasurement[diamond, InfraAntiderivative[f], "Function"], InfraMeasurement[diamond, InfraAntiderivative[f, Method -> "Paths"], "Function"]}]
```

The volume antiderivative of 1 from the centre of the discretized plane, the square grid and the hexagonal tiling: the number of vertices of the segment from the centre to each vertex.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraMeasurement[g, InfraAntiderivative[1 &, "Origin" -> c], "Function"], c}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The kernel of the uniform method on the diamond: from the bottom, each of the two chains to the top carries half.

```wl
Normal @ InfraMeasurement[Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], InfraAntiderivative[1 &, Method -> "Uniform"], "Kernel"]
```

## Scope

Every method on the function 1, at a vertex two steps along each axis from the centre of the square grid. The segment to it is a 3 × 3 square with 6 shortest paths. `"Volume"` counts its 9 vertices, `"Paths"` counts each vertex once per shortest path from it, `"Average"` and `"Uniform"` give the 5 vertices of every shortest path, and `"Flow"` the mass it holds when every vertex starts with 1 and passes what it holds on, evenly over its out-links.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = First @ GraphCenter[g]},
  {q = First @ MaximalBy[Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"], InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] &]},
  Table[m -> InfraMeasurement[g, InfraAntiderivative[1 &, Method -> m, "Origin" -> c], "Function"][q], {m, {"Volume", "Paths", "Average", "Uniform", "Flow"}}]]
```

`"Future"` accumulates over the future instead, the antiderivative on the reversed graph.

```wl
With[
  {dag = Graph[Range[6], {1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6}], f = AssociationThread[Range[6], {5, -2, 7, 1, 3, -4}]},
  InfraMeasurement[dag, InfraAntiderivative[f, "Direction" -> "Future"], "Function"] === InfraMeasurement[ReverseGraph[dag], InfraAntiderivative[f], "Function"]]
```

## Properties and Relations

[InfraDerivative]() with the same options inverts the antiderivative, in both orders and for every method.

```wl
SeedRandom[1];
With[
  {dag = Graph[Range[8], DirectedEdge @@@ (Sort /@ RandomSample[Subsets[Range[8], {2}], 12])]},
  {f = AssociationThread[Range[8], RandomInteger[{-9, 9}, 8]]},
  Table[
    {InfraMeasurement[dag, InfraDerivative[InfraAntiderivative[f, Method -> m], Method -> m], "Function"] === f,
     InfraMeasurement[dag, InfraAntiderivative[InfraDerivative[f, Method -> m], Method -> m], "Function"] === f},
    {m, {"Volume", "Paths", "Average", "Uniform", "Flow"}}]]
```

The antiderivative reads the order, not its encoding: the transitive closure gives the same function.

```wl
With[
  {dag = Graph[Range[6], {1 -> 2, 2 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6}], f = AssociationThread[Range[6], {5, -2, 7, 1, 3, -4}]},
  Table[InfraMeasurement[dag, InfraAntiderivative[f, Method -> m], "Function"] === InfraMeasurement[TransitiveClosureGraph[dag], InfraAntiderivative[f, Method -> m], "Function"],
    {m, {"Volume", "Paths", "Average", "Uniform", "Flow"}}]]
```

The flow carries all the mass to the maximal elements.

```wl
SeedRandom[2];
With[
  {dag = Graph[Range[8], DirectedEdge @@@ (Sort /@ RandomSample[Subsets[Range[8], {2}], 12])]},
  {f = AssociationThread[Range[8], RandomInteger[{0, 9}, 8]]},
  {Total @ Lookup[InfraMeasurement[dag, InfraAntiderivative[f, Method -> "Flow"], "Function"], Pick[Range[8], VertexOutDegree[dag], 0]], Total[f]}]
```

From an origin, the uniform antiderivative is the mean of the integral of *f* along the shortest paths from the origin, and the volume antiderivative is the sum of *f* over the segment.

```wl
SeedRandom[3];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {c = First @ GraphCenter[g], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {uniform = InfraMeasurement[g, InfraAntiderivative[f, Method -> "Uniform", "Origin" -> c], "Function"],
   volume = InfraMeasurement[g, InfraAntiderivative[f, "Origin" -> c], "Function"]},
  {AllTrue[VertexList[g], uniform[#] == InfraMeasurement[g, InfraIntegral[f, InfraSegment[c, #]], "Mean"] &],
   AllTrue[VertexList[g], volume[#] == Total @ Lookup[f, Keys @ InfraMeasurement[g, InfraSegment[c, #], "VertexDensity"]] &]}]
```

Blow up each vertex into *n* copies and each link into the complete bipartite graph between them, spread *f* evenly over the copies and sum the antiderivative back. `"Average"` and `"Flow"` commute with this; `"Uniform"` does on a graded order, such as the diamond; `"Volume"` and `"Paths"` count the new chains and do not.

```wl
With[
  {diamond = Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}], f = <|1 -> 2, 2 -> -1, 3 -> 5, 4 -> 3|>},
  {big = Graph[Flatten[Table[{v, i}, {v, 4}, {i, 2}], 1], Flatten @ Table[DirectedEdge[{First[e], i}, {Last[e], j}], {e, EdgeList[diamond]}, {i, 2}, {j, 2}]]},
  {spread = Association @ Flatten @ Table[{v, i} -> f[v] / 2, {v, 4}, {i, 2}]},
  Table[
    m -> (Table[Sum[InfraMeasurement[big, InfraAntiderivative[spread, Method -> m], "Function"][{v, i}], {i, 2}], {v, 4}] === Values @ InfraMeasurement[diamond, InfraAntiderivative[f, Method -> m], "Function"]),
    {m, {"Volume", "Paths", "Average", "Uniform", "Flow"}}]]
```
