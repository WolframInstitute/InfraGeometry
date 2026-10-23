---
Template: Symbol
Name: InfraCoveringQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCoveringQ
Keywords: [graph covering, covering map, sheet, discrete fiber, unique edge lifting]
SeeAlso: [InfraUniqueEdgeLiftingQ, InfraFiberBundleQ, InfraFibrationQ, InfraEdgeLiftMultiplicity, InfraHolonomy]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraCoveringQ]()[*fib*]</code> gives [True]() if the fibered graph *fib* is a covering: every total vertex has exactly one neighbour over each neighbour of its base vertex, and no total edge is vertical.

## Details & Options

*fib* is a covering when, for every total vertex *x* over *p* and every base neighbour *q* of *p*, *x* has exactly one neighbour over *q*, and every fiber *Fₚ* has no edges. The projection then maps the neighbours of *x* one to one onto the neighbours of *p*.

On a connected base every fiber has the same number of vertices, the number of sheets.

A covering is a graph bundle whose fiber has no edges: over a connected base it satisfies [InfraFiberBundleQ]().

Coverings see the cycles of the graph, not the topology of the space it models. The plane has no connected double cover, but the square grid has many: going once around a cycle of the base may end on the other sheet.

A list of fibered graphs gives [True]() when every member is a covering; the empty list gives [False]().

## Basic Examples

Random double covers of the square grid and of the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, {}, "BaseVertexCoordinates" -> xy, PlotLabel -> InfraCoveringQ[fib]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Every total vertex has exactly one neighbour over each base neighbour, and the double cover of the grid is connected:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {Union @ Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]], ConnectedGraphQ @ InfraTotalSpace[fib]}]
```

## Scope

Three fibered graphs over the cycle of length 8 with two vertices in every fiber. All have unique edge lifting; the prism and the Möbius ladder have vertical edges, the rungs, and are not coverings:

```wl
GraphicsRow @ Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]},
    InfraFiberedGraphHighlight[fib, PlotLabel -> {InfraUniqueEdgeLiftingQ[fib], InfraCoveringQ[fib]}]],
  {name, {"CycleProductBundle", "CycleDoubleCover", "MoebiusLadderCover"}}]
```

## Properties and Relations

A covering is a fibration with at most one lift over each base edge:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {InfraFibrationQ[fib], InfraAtMostOneEdgeLiftQ[fib], InfraCoveringQ[fib]}]
```

The lift of a square with a corner at the centre 45 of the grid starts on sheet 1 and ends on sheet 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {lift = InfraHorizontalLift[fib, InfraConnection[EdgeList @ InfraTotalSpace[fib]], {45, 1}, {45, 46, 36, 35, 45}]},
  InfraFiberedGraphHighlight[fib, {InfraWalk[lift]}, "BaseVertexCoordinates" -> xy,
    PlotLabel -> Last /@ {First @ lift, Last @ lift}, ImageSize -> Medium]]
```

The displacement bundle of the grid is a fibration but not a covering: a pair has several lifts over a base edge.

```wl
With[{fib = InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1]},
  {InfraFibrationQ[fib], InfraAtMostOneEdgeLiftQ[fib], InfraCoveringQ[fib]}]
```
