---
Template: Symbol
Name: InfraTotalSpace
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTotalSpace
Keywords: [total space, total graph, fibered graph]
SeeAlso: [InfraFiberedGraph, InfraBaseSpace, InfraProjection, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraTotalSpace]()[*fib*]</code> gives the total graph *E* of the fibered graph *fib*.

## Details & Options

A fibered graph is a graph *E* with a projection *π* from its vertices to the vertices of a base *B*. *E* is the total graph, and the fiber over *p* is the subgraph of *E* induced on *π⁻¹(p)*.

An edge of *E* is vertical when it lies in one fiber and transverse when it joins two fibers. The base is read off *E*: *p* and *q* are adjacent in *B* iff some transverse edge joins the fibers over *p* and *q*.

For <code>[InfraFiberedGraph]()[*E*, *π*]</code> the result is *E*; the projection is not checked, [InfraFiberedGraphQ]() checks it. For [InfraTangentBundle](), [InfraCotangentBundle]() and [InfraDisplacementBundle]() the total graph is built from the base on every call; <code>[InfraFiberedGraph]()[*fib*]</code> builds it once.


## Basic Examples

A random double covering of the 4 × 4 grid: its total graph and its base.

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  GraphicsRow[{InfraTotalSpace[fib], InfraBaseSpace[fib]}]]
```

The total graph of the product double covering is two copies of the base. The random covering above is connected:

```wl
With[{prod = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {twisted = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  Length @ ConnectedComponents[InfraTotalSpace[#]] & /@ {prod, twisted}]
```

## Scope

The total graph of a tangent bundle is built from the base. Its vertices are the rays: the 4 × 4 grid has 104 rays of length 2:

```wl
With[{g = GridGraph[{4, 4}]}, {total = InfraTotalSpace[InfraTangentBundle[g, 2]]},
  {VertexCount[total], Total[Length[InfraRays[g, #, 2]] & /@ VertexList[g]], EdgeCount[total]}]
```

## Properties and Relations

The number of vertices of the total graph is the sum of the fiber sizes:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  {VertexCount[InfraTotalSpace[fib]], Total[VertexCount /@ InfraFibers[fib]]}]
```

Projecting the transverse edges of the total graph gives the edges of the base:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, "VerticalEdgeCount" -> 2,
    RandomSeeding -> 1]},
  {proj = InfraProjection[fib]},
  {edges = DeleteDuplicates[Sort /@ Map[Lookup[proj, Key[#]] &, List @@@ EdgeList[InfraTotalSpace[fib]], {2}]]},
  Sort[Select[edges, Apply[UnsameQ]]] === Sort[List @@@ EdgeList[GridGraph[{4, 4}]]]]
```
