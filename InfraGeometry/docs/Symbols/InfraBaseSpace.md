---
Template: Symbol
Name: InfraBaseSpace
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBaseSpace
Keywords: [base space, base graph, quotient, projection]
SeeAlso: [InfraFiberedGraph, InfraTotalSpace, InfraProjection, InfraFiber]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraBaseSpace]()[*fib*]</code> gives the base graph of the fibered graph *fib*: the projected vertices, two of them adjacent when a total edge joins their fibers.

## Details & Options

For a total graph *E* and a projection *π*, the base *B* has the vertices *π(V(E))*, and *p ≠ q* are adjacent iff some edge *{x, y}* of *E* has *π(x) = p* and *π(y) = q*.

The base is reconstructed from *E* and *π*, never stored. A vertical edge, inside one fiber, gives no base edge. A projected vertex with no edge to another fiber is an isolated base vertex.

A base edge exists only if some total edge lies over it. Deleting the total edges over a base edge deletes the base edge.

The construction heads [InfraTangentBundle](), [InfraCotangentBundle]() and [InfraDisplacementBundle]() are fibered graphs too, and their base is the graph they are built on.


## Basic Examples

The vertices 1 and 2 project to `"a"`, 3 and 4 to `"b"`, 5 to `"c"`. The vertical edge 1 – 2 gives no base edge, and `"c"` is isolated:

```wl
With[{fib = InfraFiberedGraph[Graph[Range[5], {1 <-> 2, 2 <-> 3}],
    <|1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b", 5 -> "c"|>]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, VertexLabels -> Automatic],
    Graph[InfraBaseSpace[fib], VertexLabels -> Automatic]}]]
```

The base of a double cover of the square grid is the grid. A total graph with 288 edges gives a base with 144:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {base = InfraBaseSpace[fib]},
  {EdgeCount @ InfraTotalSpace[fib], EdgeCount[base], Sort @ EdgeList[base] === Sort @ EdgeList[g]}]
```

## Scope

The tangent bundle at scale 2 and the displacement bundle at scale 1 of the square mesh have the mesh as base:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  Table[Sort[Sort /@ EdgeList @ InfraBaseSpace[fib]] === Sort[Sort /@ EdgeList[g]],
    {fib, {InfraTangentBundle[g, 2], InfraDisplacementBundle[g, 1]}}]]
```

## Properties and Relations

The prism over the cycle of length 8 has 24 edges. Its 8 rungs are vertical, and its base is the cycle with 8 edges:

```wl
With[{fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> EdgeCount /@ {InfraTotalSpace[fib], InfraBaseSpace[fib]},
    ImageSize -> Medium]]
```

## Possible Issues

Deleting the two total edges over an edge at the centre of the grid deletes that base edge. The result is still a fibration, over the smaller base:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]}, {q = First @ AdjacencyList[g, c]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {total = InfraTotalSpace[fib]}, {over = Select[EdgeList[total], Sort[First /@ List @@ #] == Sort[{c, q}] &]},
  {cut = InfraFiberedGraph[EdgeDelete[total, over], First]},
  {EdgeCount @ InfraBaseSpace[cut], EdgeQ[InfraBaseSpace[cut], c <-> q], InfraFibrationQ[cut]}]
```
