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

<code>[RandomInfraFibration]()[*base*, *options*]</code> gives a random [InfraFibration]() whose reconstructed base has the vertices and edges of *base*.

## Details & Options

- The supported base is a finite simple undirected unweighted graph, including isolated vertices and the empty graph.
- Every fiber is nonempty. Its vertices are pairs {*p*, *k*}, where *p* is a base vertex.
- Integer count ranges use [RandomInteger](). Real density ranges use [RandomReal](). Excess requested vertical edges are capped at the complete graph's edge count.
- With isomorphic fibers, one size and one vertical graph are shared by all fibers. Otherwise sizes and vertical graphs are drawn separately.
- For adjacent fibers of sizes *n* and *m*, positive numeric density *d* retains pairs (*i*, *j*) satisfying Mod[*i m* - *j n*, *n m*] < *d* Max[*n*, *m*]. This preserves the earlier diagonal-width convention; it is not an independent edge probability.
- Density [All]() joins adjacent fibers completely. Positive numeric density always retains an edge over each base edge, but need not give every total vertex a lift.
- Drawing coordinates are computed by [InfraFiberedGraphHighlight](), separately from construction.
- Random draws use the ambient stream controlled by external [SeedRandom](). No per-call seed option is provided.

| Option | Default | Values |
|---|---|---|
| `"VerticalVertices"` | 1 | positive integer, or ordered pair of positive integer bounds |
| `"VerticalEdges"` | 0 | nonnegative integer, or ordered pair of nonnegative integer bounds |
| `"HorizontalEdgesRadius"` | 1 | only 1 is supported by the over-base constructor |
| `"HorizontalEdgesDensity"` | 1 | positive numeric width, ordered positive real range, or `All` |
| `"IsomorphicFibers"` | `False` | whether all vertical fiber graphs are copies of one draw |

## Basic Examples

A random fibered graph over a grid, with its central fiber highlighted.

```wl
SeedRandom[ 1 ];
With[
  { fib = RandomInfraFibration[ GridGraph[ { 3, 3 } ],
      "VerticalVertices" -> 3, "VerticalEdges" -> 1 ] },
  InfraFiberedGraphHighlight[ fib, { InfraFiber[ fib, 5 ] } ] ]
```

The default total graph is a copy of the base.

```wl
SeedRandom[ 1 ];
With[ { fib = RandomInfraFibration[ CycleGraph[ 6 ] ] },
  { InfraFiberedGraphHighlight[ fib ], IsomorphicGraphQ[ InfraTotalGraph[ fib ], CycleGraph[ 6 ] ] } ]
```

## Options

### VerticalVertices

A range gives fibers of different sizes.

```wl
SeedRandom[ 2 ];
With[ { fib = RandomInfraFibration[ CycleGraph[ 6 ], "VerticalVertices" -> { 1, 4 } ] },
  InfraFiberedGraphHighlight[ fib ] ]
```

### HorizontalEdgesDensity

Complete joins support every section choice and every matching between equal-sized fibers.

```wl
SeedRandom[ 3 ];
With[ { fib = RandomInfraFibration[ CycleGraph[ 6 ], "VerticalVertices" -> 3,
      "IsomorphicFibers" -> True, "HorizontalEdgesDensity" -> All ] },
  { section = RandomInfraSection[ fib, Properties -> { "Continuous" } ] },
  InfraFiberedGraphHighlight[ fib, { section } ] ]
```

## Possible Issues

Zero density and a horizontal radius other than one change the intended reconstructed base and are unsupported.

```wl
RandomInfraFibration[ CycleGraph[ 4 ], "HorizontalEdgesDensity" -> 0 ]
```

```wl
RandomInfraFibration[ CycleGraph[ 4 ], "HorizontalEdgesRadius" -> 2 ]
```
