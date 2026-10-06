---
Template: Symbol
Name: InfraSubstrateCode
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateCode
Keywords: [substrate, code, construction, reproducibility, held code]
SeeAlso: [InfraSubstrate, InfraSubstrateStyle, TessellationNeighborhoodGraph, BoundarylessGraph, InflateGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InfraSubstrateCode]()[*name*, *size*]</code> gives the code of the substrate <code>[InfraSubstrate]()[*name*, *size*]</code>, held: [ReleaseHold]() of it builds the graph.

<code>[InfraSubstrateCode]()[*name*]</code> gives the code of the `"Medium"` size.

## Details & Options

The roster of [InfraSubstrate]() is written as held code: [InfraSubstrate]() evaluates it, and [InfraSubstrateCode]() prints it. The printed code is therefore the code that runs, with the size table replaced by the value *size* selects, and it names only exported functions.

[ReleaseHold]() of the code gives the graph that [InfraSubstrate]() draws with the style `"Default"`. The style is not code; splice it back with [Sequence]() @@ <code>[InfraSubstrateStyle]()[*size*]</code>.

The code also carries what the options add: the layout of a substrate without `"KeepCoordinates"` -> [True](), and the call of [InflateGraph]() for `"Inflate"`. A Wolfram-model universe carries its rule and initial condition.

The options are those of [InfraSubstrate](): `"KeepCoordinates"` and `"Inflate"`. [Graph]() options are passed on into the code.

The result is a [HoldForm](), so it reads as code in an output cell.

A substrate drawn from a random construction is seeded from outside. Building the code evaluates it once, so set the seed after building the code and before [ReleaseHold]().

## Basic Examples

The code of the discretized plane, the square tiling and the hexagonal tiling, beside the graph it builds.

```wl
Grid[
  Table[
    With[
      {code = InfraSubstrateCode[name, "Small", "KeepCoordinates" -> True]},
      {code, ReleaseHold[code]}],
    {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}],
  Alignment -> Left]
```

Without `"KeepCoordinates"` the code lays the substrate out by springs.

```wl
With[
  {code = InfraSubstrateCode["SquareTilingGraph", "Small"]},
  {code, ReleaseHold[code]}]
```

## Scope

A torus: the flat torus graph, placed on a torus of revolution.

```wl
With[
  {code = InfraSubstrateCode["SquareTorusGraph", "Small", "KeepCoordinates" -> True]},
  {code, ReleaseHold[code]}]
```

An inflated substrate: the code calls [InflateGraph]().

```wl
With[
  {code = InfraSubstrateCode["HexagonalTilingGraph", "Small", "Inflate" -> 1, "KeepCoordinates" -> True]},
  {code, (SeedRandom[1]; ReleaseHold[code])}]
```

The diluted tree: every vertex has one child, except at the depths 0, 3, 8 and 15, one less than the squares, where it has two.

```wl
With[
  {code = InfraSubstrateCode["DilutedTreeGraph", "Small"]},
  {code, ReleaseHold[code]}]
```

## Properties and Relations

With the seed set after the build, the code gives the substrate drawn with no style.

```wl
With[
  {code = InfraSubstrateCode["SquareTilingGraph", "Small", "Inflate" -> 1, "KeepCoordinates" -> True]},
  {graph = (SeedRandom[1]; ReleaseHold[code])},
  {substrate = (SeedRandom[1]; InfraSubstrate["SquareTilingGraph", "Small", "Default", "Inflate" -> 1, "KeepCoordinates" -> True])},
  {graph, graph === substrate}]
```

The style of the size spliced in gives the substrate as [InfraSubstrate]() draws it.

```wl
With[
  {graph = ReleaseHold @ InfraSubstrateCode["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {styled = Graph[graph, Sequence @@ InfraSubstrateStyle["Small"]]},
  {styled, styled === InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]}]
```

## Possible Issues

A seed set before the code is built is spent on the build. The graph then differs from the substrate drawn at that seed.

```wl
With[
  {graph = (SeedRandom[1]; ReleaseHold[InfraSubstrateCode["SquareTilingGraph", "Small", "Inflate" -> 1, "KeepCoordinates" -> True]])},
  {substrate = (SeedRandom[1]; InfraSubstrate["SquareTilingGraph", "Small", "Default", "Inflate" -> 1, "KeepCoordinates" -> True])},
  {GraphicsRow[{graph, substrate}], graph === substrate}]
```
