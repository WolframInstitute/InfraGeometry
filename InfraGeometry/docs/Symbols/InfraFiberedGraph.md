---
Template: Symbol
Name: InfraFiberedGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraph
Keywords: [fibered graph, total space, base, projection, fiber, symbolic object]
SeeAlso: [InfraFiberedGraphQ, InfraTotalSpace, InfraBaseSpace, InfraProjection, InfraFiber, InfraFibers, RandomInfraFiberedGraph, InfraFibrationQ, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraph]()[*total*, *proj*]</code> is the fibered graph with total graph *total* and projection *proj*, an association or a function on the vertices of *total*.

<code>[InfraFiberedGraph]()[*model*]</code> gives the fibered graph of a construction such as <code>[InfraDisplacementBundle]()[*g*, *r*]</code>, with its total graph computed.

## Details & Options

A fibered graph is a graph *E* with a map *π* on its vertices. The fiber over *p* is the induced subgraph on *F(p) = π⁻¹(p)*.

The base *B* is reconstructed, not given. Its vertices are the values of *π*, and *p ≠ q* are adjacent when some edge of *E* joins *F(p)* and *F(q)*.

An edge inside a fiber is vertical and collapses under *π*. An edge between two fibers is transverse.

No condition is imposed: fibers may have different sizes, and a vertex over *p* may have no neighbour over a neighbour of *p*. The predicates add the conditions:

| Predicate | Condition |
|---|---|
| [InfraFibrationQ]() | every vertex over *p* has a neighbour over every neighbour of *p* |
| [InfraUniqueEdgeLiftingQ]() | exactly one such neighbour |
| [InfraCoveringQ]() | unique lifting and no vertical edges |
| [InfraFiberBundleQ]() | isomorphic fibers, unique lifting, and the matchings preserve the fibers' edges |

[InfraFiberedGraph]() is a symbolic object. The readers evaluate it:

| Reader | Value |
|---|---|
| [InfraTotalSpace]() | the total graph *E* |
| [InfraBaseSpace]() | the base *B* |
| [InfraProjection]() | *π* as an association |
| [InfraFiber]() | the fiber over one base vertex |
| [InfraFibers]() | all fibers, as an association |

The total graph is finite, simple, undirected, unweighted and without edge tags. An association projection has a key for every vertex of *total*.

## Basic Examples

The cycle of length 8 wraps twice around its base, the cycle of length 4. The fiber over 1 is drawn:

```wl
With[{fib = InfraFiberedGraph[CycleGraph[8], v |-> Mod[v, 4, 1]]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, {InfraFiber[fib, 1]}], InfraBaseSpace[fib]}]]
```

The square grid projected to its columns. The fibers are the columns and the base is a path:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {InfraFiber[fib, 5]}], InfraBaseSpace[fib]}]]
```

## Scope

A projection can give fibers of different sizes and vertices without lifts. Over `"b"` there is one vertex; the vertex 1 over `"a"` and the vertices 5 and 6 over `"c"` have no neighbour over `"b"`:

```wl
With[{fib = InfraFiberedGraph[PathGraph[Range[6]],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "c", 5 -> "c", 6 -> "c"|>]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, Method -> "HighlightFiber"], InfraBaseSpace[fib]}]]
```

A construction gives the same fibers as its fibered graph:

```wl
With[{model = InfraDisplacementBundle[GridGraph[{4, 4}], 1]}, {fib = InfraFiberedGraph[model]},
  {Head[fib], InfraFibers[fib] === InfraFibers[model]}]
```

## Properties and Relations

The fibers partition the vertices of the total graph. The vertical edges are the edges of the fibers, here 72 of the 144 edges of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = InfraFiberedGraph[g, AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]]},
  {Total[VertexCount /@ InfraFibers[fib]] == VertexCount[g], Total[EdgeCount /@ InfraFibers[fib]],
   EdgeCount[g]}]
```

## Possible Issues

An association projection that misses a vertex is not a fibered graph. The readers stay unevaluated:

```wl
InfraBaseSpace @ InfraFiberedGraph[CycleGraph[4], <|1 -> "a", 2 -> "a", 3 -> "b"|>]
```
