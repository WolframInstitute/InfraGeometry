---
Template: Symbol
Name: InfraHorizontalLift
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHorizontalLift
Keywords: [horizontal lift, path lifting, connection, walk]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraParallelTransport, InfraHolonomy, InfraWalk, FindInfraHorizontalLift]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*]</code> gives the horizontal lift of the base walk *walk* along the connection *conn*, starting at the total vertex *x*.

## Details & Options

For a walk *γ = (v₀, v₁, …, vₙ)* and a start *x₀* over *v₀*, the lift is *γ̃ = (x₀, x₁, …, xₙ)*, where *xᵢ* is the neighbour of *xᵢ₋₁* over *vᵢ* along *conn*. The projection of *γ̃* is *γ*, repeated vertices included.

A complete connection is a perfect matching over every base edge, so each step has exactly one choice and the lift is unique. Without a connection a walk in a fibered graph may have no lift or several.

The last vertex *xₙ* is the parallel transport of *x₀* along *γ*. For a closed walk it can differ from *x₀*; the permutation of the fiber is the holonomy.

The connection must satisfy [InfraConnectionQ](), *x* must lie over the first vertex of the walk, and consecutive vertices of the walk must be adjacent in the base. Otherwise the call stays unevaluated.

## Basic Examples

A random double covering of the 4 × 4 grid. The lift of the loop around the square 6, 7, 11, 10 starts at {6, 1} and ends at {6, 2}, on the other sheet:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {lift = InfraHorizontalLift[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {6, 1}, {6, 7, 11, 10, 6}]},
  InfraFiberedGraphHighlight[fib, {InfraWalk[lift]}, PlotLabel -> Last[lift], ImageSize -> Medium]]
```

The projection of the lift is the walk:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {lift = InfraHorizontalLift[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {6, 1}, {6, 7, 11, 10, 6}]},
  Lookup[InfraProjection[fib], Key /@ lift]]
```

## Scope

Fibers of two vertices joined completely, with a random connection. The lift of the walk around the rim of the grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {lift = InfraHorizontalLift[fib, conn, {1, 1}, {1, 2, 3, 4, 8, 12, 16, 15, 14, 13, 9, 5, 1}]},
  InfraFiberedGraphHighlight[fib, {conn, InfraWalk[lift]}, ImageSize -> Medium]]
```

## Properties and Relations

A walk that goes back along an edge has a lift that goes back too. A walk of length 0 lifts to its start:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {InfraHorizontalLift[fib, conn, {6, 1}, {6, 7, 11, 7, 6}], InfraHorizontalLift[fib, conn, {6, 1}, {6}]}]
```

The end of the lift is the parallel transport of the start:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {Last @ InfraHorizontalLift[fib, conn, {6, 1}, {6, 7, 11}],
   InfraParallelTransport[fib, conn, {6, 7, 11}][{6, 1}]}]
```

## Possible Issues

The start must lie over the first vertex of the walk. Otherwise the call stays unevaluated:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  Head @ InfraHorizontalLift[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {7, 1}, {6, 7}]]
```
