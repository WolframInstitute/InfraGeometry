---
Template: Symbol
Name: InfraParallelSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraParallelSectionQ
Keywords: [parallel section, connection, parallel transport, horizontal section]
SeeAlso: [InfraSection, InfraSectionQ, InfraContinuousSectionQ, InfraConnection, InfraConnectionQ, InfraParallelTransport, RandomInfraSection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraParallelSectionQ]()[*fib*, *conn*, [InfraSection]()[*s*]]</code> gives [True]() if *s* is a section that the connection *conn* transports along every base edge of its domain, and [False]() otherwise.

<code>[InfraParallelSectionQ]()[*fib*, *conn*, {*sec₁*, *sec₂*, …}]</code> gives [True]() if every *secᵢ* is parallel.

## Details & Options

A section *s* is parallel when *τₚq(s(p)) = s(q)* for every base edge *pq* with both ends in its domain, where *τₚq* is the parallel transport of *conn* along *pq*. Equivalently, every edge *s(p)s(q)* belongs to *conn*.

A parallel section is continuous. A continuous section need not be parallel: it may use transverse edges the connection does not choose.

The horizontal lift of a path that visits each vertex once is a parallel section over the path. Around a closed walk a parallel section is fixed by the holonomy.

The connection must satisfy [InfraConnectionQ](). Otherwise the call stays unevaluated. The empty section is parallel; an empty list gives [False]().

## Basic Examples

Fibers of two vertices over the 4 × 4 grid, joined completely, with a random connection. The lift of a path along two sides of the grid is a parallel section over the path:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {path = {1, 2, 3, 4, 8, 12, 16}},
  {s = InfraSection[AssociationThread[path, InfraHorizontalLift[fib, conn, {1, 1}, path]]]},
  InfraFiberedGraphHighlight[fib, {conn, s}, PlotLabel -> InfraParallelSectionQ[fib, conn, s],
    ImageSize -> Medium]]
```

On these complete joins every section is continuous, but a random section is not parallel:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {s = RandomInfraSection[fib, RandomSeeding -> 1]},
  {InfraContinuousSectionQ[fib, s], InfraParallelSectionQ[fib, conn, s]}]
```

## Properties and Relations

A covering has one connection, its transverse edges, so its continuous sections are parallel. The two sheets of the product double covering:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraParallelSectionQ[fib, conn, RandomInfraSection[fib, All, Properties -> {"Continuous"}]]]
```

A section over a square is parallel only if the transport around the square fixes its value. On a random double covering it exchanges the two values over 6, and the square has no continuous section, so no parallel one:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {InfraParallelTransport[fib, conn, {6, 7, 11, 10, 6}],
   RandomInfraSection[fib, {6, 7, 11, 10}, All, Properties -> {"Continuous"}]}]
```
