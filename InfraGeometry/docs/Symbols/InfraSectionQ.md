---
Template: Symbol
Name: InfraSectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSectionQ
Keywords: [section, partial section, fibration, projection]
SeeAlso: [InfraSection, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraSection, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraSectionQ]()[*fib*, [InfraSection]()[*s*]]</code> gives [True]() if every value *s(p)* is a total vertex of *fib* over *p*, and [False]() otherwise.

<code>[InfraSectionQ]()[*fib*, {*sec₁*, *sec₂*, …}]</code> gives [True]() if every *secᵢ* is a section of *fib*.

## Details & Options

The condition is *π(s(p)) = p* for every key *p* of *s*. The keys need not cover the base: a partial section is a section of its domain.

Only the projection is tested. Continuity is tested by [InfraContinuousSectionQ](), compatibility with a connection by [InfraParallelSectionQ]().

The empty section `InfraSection[<||>]` is a section. An empty list gives [False]().

## Basic Examples

A random section of a fibered graph over the 4 × 4 grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  {s = RandomInfraSection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {s}, PlotLabel -> InfraSectionQ[fib, s], ImageSize -> Medium]]
```

On the product double covering of the grid, the value over 6 must be {6, 1} or {6, 2}. A value over 7, or a vertex that does not exist, fails:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  InfraSectionQ[fib, InfraSection[<|6 -> #|>]] & /@ {{6, 1}, {6, 2}, {7, 1}, {6, 3}}]
```

## Scope

A list of sections is tested together. The two sheets of the product covering:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  InfraSectionQ[fib, RandomInfraSection[fib, All, Properties -> {"Continuous"}]]]
```

## Properties and Relations

A section need not be continuous. A random section of the product covering jumps between the sheets:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {s = RandomInfraSection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {s}, PlotLabel -> {InfraSectionQ[fib, s], InfraContinuousSectionQ[fib, s]},
    ImageSize -> Medium]]
```

## Possible Issues

The empty section is a section, but an empty list of sections gives [False]():

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {InfraSectionQ[fib, InfraSection[<||>]], InfraSectionQ[fib, {}]}]
```
