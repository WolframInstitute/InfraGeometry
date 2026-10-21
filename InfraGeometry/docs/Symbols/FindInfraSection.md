---
Template: Symbol
Name: FindInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraSection
Keywords: [continuous section, global section, sheet, covering]
SeeAlso: [RandomInfraSection, InfraSection, InfraContinuousSectionQ, InfraParallelSectionQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[FindInfraSection]()[*fib*, *n*]</code> gives a list of *n* continuous sections of the fibered graph *fib* over its whole base.

<code>[FindInfraSection]()[*fib*, [UpTo]()[*n*]]</code> gives at most *n*; <code>[FindInfraSection]()[*fib*, [All]()]</code> gives all of them.

## Details & Options

A continuous section *s* picks a total vertex *s(p)* over every base vertex *p*, with *{s(p), s(q)}* a total edge for every base edge *{p, q}*. The results are [InfraSection]() objects.

The sections come in a fixed order, the same on every call. <code>[FindInfraSection]()[*fib*, *n*]</code> is <code>[RandomInfraSection]()[*fib*, *n*, [Properties]() -> {"Continuous"}, "NextVertexFunction" -> [Identity]()]</code>; [RandomInfraSection]() also extends partial sections.

An exact count *n* larger than the number of continuous sections gives `{}`.

On a covering of a connected base, a continuous section is a sheet: a copy of the base in the total graph. A connected covering has none.

The number of continuous sections can grow exponentially with the size of the base, so `All` can be slow.

## Basic Examples

The two sheets of the trivial double cover of the square grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = InfraFiberedGraph[GraphProduct[g, Graph[{1, 2}, {}], "Cartesian"], First]},
  GraphicsRow @ Table[InfraFiberedGraphHighlight[fib, {s}, "BaseVertexCoordinates" -> xy],
    {s, FindInfraSection[fib, All]}]]
```

A connected double cover of the grid has no continuous section:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {ConnectedGraphQ @ InfraTotalSpace[fib], FindInfraSection[fib, All]}]
```

## Properties and Relations

The same sections as [RandomInfraSection]() with the continuity property and the vertices taken in order:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = InfraFiberedGraph[GraphProduct[g, Graph[{1, 2}, {}], "Cartesian"], First]},
  FindInfraSection[fib, All] ===
    RandomInfraSection[fib, All, Properties -> {"Continuous"}, "NextVertexFunction" -> Identity]]
```

## Possible Issues

There are two sheets. Asking for exactly three gives `{}`, asking for up to three gives the two:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = InfraFiberedGraph[GraphProduct[g, Graph[{1, 2}, {}], "Cartesian"], First]},
  Length /@ {FindInfraSection[fib, 3], FindInfraSection[fib, UpTo[3]]}]
```
