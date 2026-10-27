---
Template: Symbol
Name: InfraGenericQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGenericQ
Keywords: [generic curve, immersion, double point, self-intersection, self-tangency, cusp, Whitney]
SeeAlso: [WalkSingularities, InfraImmersedQ, InfraWalkQ, InfraWalkCrossingQ, FindEmbeddingClosestPath]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[InfraGenericQ]()[*g*, *walk*]</code> gives `True` if *walk* is a generic curve on *g*, and `False` otherwise.

## Details & Options

A walk is generic when it is a walk of *g* and its [WalkSingularities]() are as for a generic immersed curve in the plane:

| Singularity | On a walk | Allowed |
|---|---|---|
| cusp | a backtrack *u, v, u* | no |
| self-tangency | an edge traversed twice | no |
| self-intersection | a vertex visited twice or more | only double points, and not at the ends of an open walk |

A vertex list is an open walk. A cycle graph is a closed walk, read cyclically. A list of walk graphs gives `True` when every one is generic.

On a graph two strands that cross at a vertex must leave it along different edges. On the square grid that forces one strand horizontal and the other vertical at the crossing; a crossing snapped from a diagonal usually shares an edge, a self-tangency.

## Basic Examples

Two loops snapped to the mesh with [FindEmbeddingClosestPath](). The first crosses itself at one double point. The strands of the second share an edge:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
    {w = FindEmbeddingClosestPath[g, Line[Table[{0.5, 0.5} + {0.25 (t^2 - 1.2), b t (t^2 - 1.2)}, {t, -1.7, 1.7, 0.05}]]]},
    InfraSubstrateHighlight[g, {w}, PlotLabel -> InfraGenericQ[g, w]]],
  {b, {0.2, 0.3}}]
```

A backtrack is a cusp:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {walk = {c, First @ AdjacencyList[g, c], c}},
  {InfraGenericQ[g, walk], WalkSingularities[walk]}]
```

## Scope

The boundary of a square face, as a cycle graph, is a generic closed curve. Run around twice it is not: every vertex is visited twice and every edge traversed twice:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {square = First /@ First @ FindCycle[NeighborhoodGraph[g, c, 2], {4}]},
  {InfraGenericQ[g, Graph[DirectedEdge @@@ Partition[square, 2, 1, 1]]], InfraGenericQ[g, Join[square, square, Take[square, 1]]]}]
```

## Possible Issues

A vertex list is an open walk. A closed loop given as a list repeats its first vertex at the end, a self-intersection at the ends, so it is not generic. Give a cycle graph instead:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {square = First /@ First @ FindCycle[NeighborhoodGraph[g, c, 2], {4}]},
  {InfraGenericQ[g, Append[square, First @ square]], InfraGenericQ[g, Graph[DirectedEdge @@@ Partition[square, 2, 1, 1]]]}]
```
