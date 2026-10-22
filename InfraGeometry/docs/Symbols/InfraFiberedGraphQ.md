---
Template: Symbol
Name: InfraFiberedGraphQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphQ
Keywords: [fibered graph, projection, predicate]
SeeAlso: [InfraFiberedGraph, InfraProjection, InfraFibrationQ, InfraEqualFiberSizesQ, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphQ]()[*fib*]</code> gives `True` if *fib* is a fibered graph: a total graph with a projection defined on all its vertices.

## Details & Options

A fibered graph is a graph *E* with a map *π* on its vertices. [InfraFiberedGraphQ]() tests only that *π* is defined on every vertex of *E*.

The total graph must be finite, simple, undirected, unweighted and without edge tags. The projection is an association with one key for each vertex, or a function. A projection that is not a function, such as a string or a list, leaves its values as unevaluated applications *π*[*v*], and gives `False`.

No further condition is tested. Fibers of different sizes, vertical edges and vertices without lifts are allowed; [InfraFibrationQ]() and [InfraFiberBundleQ]() test those.

Accepted heads:

| Head | Object |
|---|---|
| [InfraFiberedGraph]() | a fibered graph |
| [InfraFibration]() | the same, older name |
| [InfraTangentBundle](), [InfraCotangentBundle](), [InfraDisplacementBundle]() | a construction over a graph |

The empty graph with the empty projection is a fibered graph.

A list of objects gives `True` when every member is a fibered graph. The empty list gives `False`.

## Basic Examples

A fibered graph need not have lifts. The vertices 2 and 4 have no neighbour in the other fiber, so it is not a fibration:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[4], {1 <-> 3}], <|1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q"|>]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> {InfraFiberedGraphQ[fib], InfraFibrationQ[fib]},
    ImageSize -> Medium]]
```

Every entry of the catalogue is a fibered graph:

```wl
AllTrue[InfraFiberedSubstrate[All], InfraFiberedGraphQ @ InfraFiberedSubstrate[#, "Small"] &]
```

## Scope

The square grid with the projection to its columns, and the tangent bundle of a grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {columns = AssociationThread[VertexList[g], Round @ GraphEmbedding[g][[All, 1]]]},
  {InfraFiberedGraphQ[InfraFiberedGraph[g, columns]],
   InfraFiberedGraphQ[InfraTangentBundle[GridGraph[{4, 4}], 2]]}]
```

A string is not a map, and the object is not a fibered graph, nor a fibration:

```wl
With[{fib = InfraFiberedGraph[CycleGraph[4], "bad"]}, {InfraFiberedGraphQ[fib], InfraFibrationQ[fib]}]
```

## Possible Issues

A projection that misses a vertex, a directed total graph and an expression that is not a fibered graph leave the test unevaluated, not `False`:

```wl
{InfraFiberedGraphQ @ InfraFiberedGraph[CycleGraph[4], <|1 -> "a", 2 -> "a", 3 -> "b"|>],
 InfraFiberedGraphQ @ InfraFiberedGraph[Graph[{1 -> 2}], Identity], InfraFiberedGraphQ[5]}
```
