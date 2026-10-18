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

<code>[RandomInfraFiberedGraph]()[*base*, *options*]</code> gives a random [InfraFiberedGraph]() with the prescribed reconstructed base and selected properties.

## Details & Options

- The base is a finite simple undirected unweighted untagged graph, including isolated vertices and the empty graph.
- Every base vertex has a nonempty fiber. Total vertices are pairs {*p*, *k*}, with *p* a literal base vertex.
- Transverse edges occur only over base edges. At least one transverse edge is retained over every base edge, so the reconstructed base has exactly the supplied vertices and edges.
- `Properties` is a flat list interpreted by conjunction. The allowed strings are `"EqualFiberSizes"`, `"IsomorphicFibers"`, `"Fibration"`, `"AtMostOneEdgeLift"`, `"UniqueEdgeLifting"`, `"FiberBundle"` and `"Covering"`. Order and repetition do not change the constraints.
- The empty property list requests a general fibered graph. It does not require lift existence or equal fiber sizes.
- A scalar count *n* is an upper bound. A singleton {*n*} requests exactly *n*. A pair {*lo*, *hi*} requests a discrete uniform integer in the inclusive range.
- Fiber vertex counts have minimum one. Vertical edge counts have minimum zero.
- Scalar edge caps are intersected with the property-feasible count interval. Exact and range edge specifications must be feasible for every permitted fiber size; they are never clipped or silently conditioned on the draw.
- Counts are discrete uniform on their admissible interval. The constructive graph distribution is not asserted to be uniform over all graphs with those counts.
- The ambient random stream is controlled by external [SeedRandom](). There is no per-call seed option.
- Unsupported options, property names, graph domains and jointly infeasible specifications leave the call unevaluated.
- Drawing coordinates are computed separately by [InfraFiberedGraphHighlight]().

| Option | Default | Meaning |
|---|---|---|
| [Properties]() | `{}` | Conjunction of the requested structural properties. |
| `"VerticalVertexCount"` | `{1}` | Fiber vertex count: upper bound, exact singleton or inclusive range. |
| `"VerticalEdgeCount"` | `{0}` | Vertical edge count: upper bound, exact singleton or inclusive range. |
| `"HorizontalEdgeCount"` | [Automatic]() | Count over each base edge: upper bound, exact singleton, inclusive range, `Automatic` or `All`. |

### Joint size constraints

Ordinarily each fiber size is drawn independently.
`"EqualFiberSizes"`, `"IsomorphicFibers"` and `"FiberBundle"` use one size draw over the whole base.
`"UniqueEdgeLifting"` and `"Covering"` use one size draw per connected base component, unless a global equal-size property is also requested.
`"IsomorphicFibers"` and `"FiberBundle"` share one vertical graph template across all fibers.
A graph bundle uses fiber isomorphisms for its transverse matchings; it can have nontrivial monodromy.

For a fiber of size *n*, the vertical count ranges from zero to *n* (*n* - 1) / 2.
`"Covering"` forces the count to zero.
A scalar vertical cap permits this restriction; an exact positive count or a range containing positive counts is incompatible with `"Covering"`.

### Horizontal count constraints

For adjacent fiber sizes *n* and *m*, the requested properties give these feasible counts.
Combined properties impose all their constraints.

| Property | Feasible transverse edge counts |
|---|---|
| No lifting constraint | 1 through n m |
| `"Fibration"` | Max[n,m] through n m; every vertex has a transverse neighbour |
| `"AtMostOneEdgeLift"` | 1 through Min[n,m]; the edges form a matching |
| `"UniqueEdgeLifting"`, or both `"Fibration"` and `"AtMostOneEdgeLift"` | n, with n = m; a perfect matching |
| `"FiberBundle"` | n, with n = m; the matching preserves fiber adjacency |
| `"Covering"` | n, with n = m and no vertical edges |

`Automatic` draws a feasible count and constructs edges satisfying the properties.
`All` uses the complete join of adjacent fibers; it is accepted only when this satisfies every requested property.
In particular, a complete join with unique lifting requires both adjacent fibers to be singletons.

## Basic Examples

A general fibered graph with independently drawn fiber sizes.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ GridGraph[ { 3, 3 } ],
    "VerticalVertexCount" -> { 2, 4 }, "VerticalEdgeCount" -> 2 ] },
  InfraFiberedGraphHighlight[ fib, { InfraFiber[ fib, 5 ] } ] ]
```

A graph bundle with a shared fiber graph and adjacency-preserving transverse matchings.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 6 ], Properties -> { "FiberBundle" },
    "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 2 } ] },
  InfraFiberedGraphHighlight[ fib ] ]
```

## Options

### Properties

Lift existence allows several choices above a base edge.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "Fibration" },
    "VerticalVertexCount" -> { 2, 3 }, "HorizontalEdgeCount" -> All ] },
  InfraFiberedGraphHighlight[ fib ] ]
```

### VerticalVertexCount

A scalar permits smaller fibers. A singleton fixes the size.

```wl
SeedRandom[ 7 ];
GraphicsRow[ Map[ specification |-> InfraFiberedGraphHighlight[
  RandomInfraFiberedGraph[ CycleGraph[ 6 ], "VerticalVertexCount" -> specification ] ],
  { 3, { 3 }, { 2, 3 } } ] ]
```

### HorizontalEdgeCount

A complete join between equal fibers supports every section choice and every fiber matching.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 6 ], "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> All ] },
  { section = RandomInfraSection[ fib, Properties -> { "Continuous" } ] },
  InfraFiberedGraphHighlight[ fib, section ] ]
```

## Possible Issues

An exact vertical edge is incompatible with a vertex-count cap that permits singleton fibers.
The call remains unevaluated even if some size draws could support that edge.

```wl
RandomInfraFiberedGraph[ CycleGraph[ 4 ], "VerticalVertexCount" -> 3, "VerticalEdgeCount" -> { 1 } ]
```

Complete joins of two-point fibers do not have unique edge lifting.

```wl
RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "UniqueEdgeLifting" },
  "VerticalVertexCount" -> { 2 }, "HorizontalEdgeCount" -> All ]
```

The Experimental compatibility sampler [RandomInfraFibration]() keeps its earlier options and cyclic-width interpretation.
Its numeric options are not the count grammar of this function.
