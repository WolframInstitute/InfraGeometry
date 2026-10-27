---
Template: Symbol
Name: InfraForwardDeformation
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraForwardDeformation
Keywords: [forward walk, shortest path, deformation, tube, excess length, transverse step, path count]
SeeAlso: [FindInfraForwardDeformation, InfraMeasurement, InfraMemberQ, InfraDeformationSize, SprayGraph, InfraHomotopy]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraForwardDeformation]()[*reference*, *excess*]</code> represents forward walks near the shortest path *reference*, with the specified excess length.

## Details & Options

The object is inert. [FindInfraForwardDeformation]() finds its walks on a substrate; [InfraMeasurement]() reads its graph, cardinality, lengths and visit densities. [InfraMemberQ]() tests whether a complete vertex-list walk belongs to the family.

The substrate must be a simple undirected unweighted graph, and *reference* a vertex list forming a shortest path from *a* to *b*. Write *L = d(a,b)*. A forward walk never decreases its distance from *a*. It stays within the graph-distance tube about the vertex set of *reference* and ends at *b*.

Each forward walk has exactly *L* steps between successive distance shells. Its remaining steps stay in one shell, so their number is its excess length over *L*. Vertices and edges may repeat.

| Excess specification | Allowed excess |
|---|---|
| `{k}` | exactly *k* |
| `{lo, hi}` | each integer from *lo* through *hi* |
| `UpTo[k]` | 0 through *k* |

The bounds are nonnegative integers.

| Option | Default | Meaning |
|---|---|---|
| `"TubeRadius"` | `1` | nonnegative integer distance from the reference vertex set, or `Infinity` |
| `"FirstArrival"` | `True` | stop at the first visit to the target; `False` permits departures and returns within its distance shell |

With tube radius 0 the only member is the reference, when excess 0 is allowed. With a wider tube, excess 0 may contain other shortest paths. Thus zero excess alone does not specify the reference.

This is a geometric family of walks, not a homotopy class. Tube radius and excess are distinct from the edit width measured by [InfraDeformationSize]().

On a bipartite substrate every edge changes distance from the source by one. Consequently every forward member is a shortest path: positive exact excess gives an empty family, and increasing an upper excess bound adds nothing. This includes square grids. The object therefore does not describe general length-increasing detours of a shortest path.

Closeness to the reference also does not certify a local deformation. On a six-cycle the two opposite shortest routes can belong to the same radius-1 tube although no triangle or square move connects them. Use [FindInfraHomotopy]() when a certificate in a specified face relation is required.

The `"Graph"` reading is a list of pruned directed acyclic graphs on states {*step*, *vertex*}, one for each attainable allowed excess. Paths in these graphs correspond exactly to the walks. `"Cardinality"` counts them without enumerating them. `"Length"` gives the attainable edge lengths, as a scalar when there is only one.

The `"VertexDensity"` is the number of visits to each substrate vertex summed over all members. Repeated visits count repeatedly. `"EdgeDensity"` counts directed edge traversals, with keys `DirectedEdge[u,v]`. Both readings project the position graphs back to substrate vertices and edges without enumerating members.

`All` reads `"Graph"`, `"Cardinality"`, `"Length"`, `"VertexDensity"`, `"EdgeDensity"`, `"Subgraph"`, `"CountingMeasure"` and `"RiemannianMeasure"`. The last three use the support of the family, with the usual region-measure conventions of [InfraMeasurement]().

For a finite excess bound, counting uses a finite layered graph and is polynomial in its size. Listing all members can still require exponential output.

## Basic Examples

The two shortest routes around a square lie in the radius-1 tube:

```wl
With[{g = CycleGraph[4]}, {family = InfraForwardDeformation[{1, 2, 3}, {0}]},
  InfraMeasurement[g, family, {"Cardinality", "Length"}]]
```

A radius-0 tube singles out the reference:

```wl
With[{g = CycleGraph[4]},
  FindInfraForwardDeformation[g, InfraForwardDeformation[{1, 2, 3}, UpTo[2], "TubeRadius" -> 0], All]]
```

One transverse step replaces an edge of a triangle by its other two edges:

```wl
With[{g = CycleGraph[3]},
  FindInfraForwardDeformation[g, InfraForwardDeformation[{1, 2}, {1}], All]]
```

## Properties and Relations

Count visits over the two routes around a square, and test membership:

```wl
With[{g = CycleGraph[4]}, {family = InfraForwardDeformation[{1, 2, 3}, {0}]},
  {InfraMeasurement[g, family, "VertexDensity"], InfraMemberQ[g, family, {1, 4, 3}]}]
```
