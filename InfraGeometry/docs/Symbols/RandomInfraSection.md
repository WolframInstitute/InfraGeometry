---
Template: Symbol
Name: RandomInfraSection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSection
Keywords: [section, partial section, section extension, continuous section, sampling]
SeeAlso: [InfraSection, InfraSectionQ, InfraContinuousSectionQ, InfraParallelSectionQ, RandomInfraFiberedGraph, RandomInfraConnection, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[RandomInfraSection]()[*fib*]</code> gives a random [InfraSection]() of *fib* over the whole base.

<code>[RandomInfraSection]()[*fib*, {*p₁*, *p₂*, …}]</code> gives a random section over the base vertices *pᵢ*.

<code>[RandomInfraSection]()[*fib*, [InfraSection]()[*s*]]</code> extends the partial section *s* to the whole base, keeping its values.

<code>[RandomInfraSection]()[*fib*, *spec*, *n*]</code> gives a list of *n* distinct sections; *spec* may be omitted.

## Details & Options

A section chooses one vertex *s(p)* in the fiber over each *p*. Without conditions there are *∏ₚ |Fₚ|* sections over the whole base.

With `Properties -> {"Continuous"}` every base edge *pq* of the domain goes to a total edge *s(p)s(q)*. A continuous section is a copy of its domain inside the total graph, and it may not exist.

The count *n* can be `n`, `UpTo[n]` or `All`. Without a count the result is one section; when none exists, or fewer than *n*, the result is `{}`. The section over an empty domain is `InfraSection[<||>]`.

The draws are not uniform over the continuous sections.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{}` | `{}` for all sections, `{"Continuous"}` for continuous ones |
| `"NextVertexFunction"` | `Automatic` | random order; `Identity` the vertex order; a function choosing or ordering the candidates in a fiber |
| [RandomSeeding]() | `Automatic` | an integer or a string for a reproducible draw; `Inherited` to draw from the current random state |

## Basic Examples

A random section of a fibered graph over the 4 × 4 grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {RandomInfraSection[fib, RandomSeeding -> 1]}, ImageSize -> Medium]]
```

On the product double covering, the value {6, 1} over 6 extends continuously only to the sheet through it:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {s = InfraSection[<|6 -> {6, 1}|>]},
  {ext = RandomInfraSection[fib, s, Properties -> {"Continuous"}, RandomSeeding -> 1]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, {s}], InfraFiberedGraphHighlight[fib, {ext, s}]}]]
```

## Scope

A section over the first row of the grid:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  RandomInfraSection[fib, {1, 2, 3, 4}, RandomSeeding -> 1]]
```

All sections. Their number is the product of the fiber sizes:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  {Length @ RandomInfraSection[fib, All], Times @@ (VertexCount /@ InfraFibers[fib])}]
```

## Options

### Properties

The product double covering of the grid has 2¹⁶ sections and 2 continuous ones, its sheets:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  Length /@ {RandomInfraSection[fib, All], RandomInfraSection[fib, All, Properties -> {"Continuous"}]}]
```

### RandomSeeding

A fixed seed gives the same draw whatever [SeedRandom]() has set:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  Table[SeedRandom[k]; RandomInfraSection[fib, RandomSeeding -> 7], {k, 2}]]
```

## Possible Issues

A continuous partial section need not extend. The values below lie over two vertices that are not adjacent, so the partial section is continuous; they lie on different sheets, so no continuous section joins them. Without the condition the extension exists:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], Graph[{1, 2}, {}], "Cartesian"], First]},
  {s = InfraSection[<|1 -> {1, 1}, 16 -> {16, 2}|>]},
  {InfraContinuousSectionQ[fib, s], RandomInfraSection[fib, s, Properties -> {"Continuous"}, RandomSeeding -> 1],
   InfraSectionQ[fib, RandomInfraSection[fib, s, RandomSeeding -> 1]]}]
```

A random double covering that exchanges the sheets around a square has no continuous section:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  RandomInfraSection[fib, All, Properties -> {"Continuous"}]]
```
