---
Template: Symbol
Name: InfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSection
Keywords: [section, partial section, inert map, projection]
SeeAlso: [InfraSectionQ, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraSection, InfraFiberedGraph, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraSection]()[*s*]</code> is the section given by the association *s* from base vertices *p* to total vertices *s(p)*.

## Details & Options

A section of a fibered graph is a choice of one vertex in each fiber: *π(s(p)) = p* for every *p* in its domain, as for a section *s : B → E* of a fiber bundle. The keys of *s* are the domain, which may be part of the base; such a section is partial.

A section is continuous when every base edge *pq* between keys goes to a total edge *s(p)s(q)*. A continuous section over the whole base is a copy of the base inside the total graph.

[InfraSection]() is a symbolic object and carries no graph. [InfraSectionQ]() checks it against a fibered graph, [InfraContinuousSectionQ]() checks continuity, [InfraParallelSectionQ]() checks that it follows a connection, [RandomInfraSection]() draws one and [InfraFiberedGraphHighlight]() draws it.

The empty association gives the empty section, `InfraSection[<||>]`.

On a covering, the holonomy of every loop at *p* fixes the value *s(p)* of a continuous section. So a double covering with a loop that exchanges the sheets has no continuous section over the whole base.

## Basic Examples

A random section of a fibered graph over the 4 × 4 grid picks one vertex in each fiber:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {RandomInfraSection[fib, RandomSeeding -> 1]}, ImageSize -> Medium]]
```

The product double covering of the 4 × 4 grid has two continuous sections, its two sheets:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {sheets = RandomInfraSection[fib, All, Properties -> {"Continuous"}]},
  GraphicsRow[InfraFiberedGraphHighlight[fib, {#}] & /@ sheets]]
```

## Scope

A partial section with values over 6 and 7. It is a section, but the edge 6–7 does not go to a total edge, so it is not continuous:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {s = InfraSection[<|6 -> {6, 1}, 7 -> {7, 2}|>]},
  InfraFiberedGraphHighlight[fib, {s}, PlotLabel -> {InfraSectionQ[fib, s], InfraContinuousSectionQ[fib, s]},
    ImageSize -> Medium]]
```

## Properties and Relations

A random double covering of the grid exchanges the sheets around some square, and it has no continuous section:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {InfraHolonomy[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {5, 6, 10, 9, 5}],
   RandomInfraSection[fib, Properties -> {"Continuous"}, RandomSeeding -> 1]}]
```
