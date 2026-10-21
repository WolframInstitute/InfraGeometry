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

The result is a [HoldForm]() of the construction, with the size table replaced by the value *size* selects. It is the code [InfraSubstrate]() runs, and it uses exported functions only.

[ReleaseHold]() of the code gives the substrate drawn with the style `"Default"`. The style is not code; <code>[Graph]()[*g*, [Sequence]() @@ [InfraSubstrateStyle]()[*size*]]</code> splices it back.

The code carries what the options add: a spring layout unless `"KeepCoordinates"` -> [True](), and the call of [InflateGraph]() for `"Inflate"`. The options are those of [InfraSubstrate](); [Graph]() options are passed on into the code.

Building the code builds the graph once. For a random construction, fix the seed after building the code and before [ReleaseHold]().

## Basic Examples

The code of the square grid:

```wl
InfraSubstrateCode["SquareGridGraph", "Small", "KeepCoordinates" -> True]
```

[ReleaseHold]() builds the square grid and the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = ReleaseHold @ InfraSubstrateCode[name, "Small", "KeepCoordinates" -> True]}, Graph[g, PlotLabel -> VertexCount[g]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

Without `"KeepCoordinates"` the code lays the substrate out by springs:

```wl
InfraSubstrateCode["SquareGridGraph", "Small"]
```

An inflated substrate: the code calls [InflateGraph]() with the amount and the options:

```wl
InfraSubstrateCode["SquareMeshGraph", "Small", "Inflate" -> {2, "VerticalEdges" -> 1}, "KeepCoordinates" -> True]
```

## Properties and Relations

The code gives the substrate drawn with no style, and with the style of its size spliced in, the substrate as drawn:

```wl
With[{g = ReleaseHold @ InfraSubstrateCode["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {g === InfraSubstrate["SquareMeshGraph", "Small", "Default", "KeepCoordinates" -> True],
   Graph[g, Sequence @@ InfraSubstrateStyle["Small"]] === InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}]
```

For a random construction, the seed set after the build gives the substrate drawn at that seed:

```wl
With[{code = InfraSubstrateCode["SquareGridGraph", "Small", "Inflate" -> 2, "KeepCoordinates" -> True]},
  BlockRandom[ReleaseHold[code], RandomSeeding -> 1] ===
    BlockRandom[InfraSubstrate["SquareGridGraph", "Small", "Default", "Inflate" -> 2, "KeepCoordinates" -> True], RandomSeeding -> 1]]
```

## Possible Issues

A seed set before the code is built is spent on the build, and the graph differs from the substrate drawn at that seed:

```wl
BlockRandom[ReleaseHold @ InfraSubstrateCode["SquareGridGraph", "Small", "Inflate" -> 2, "KeepCoordinates" -> True],
    RandomSeeding -> 1] ===
  BlockRandom[InfraSubstrate["SquareGridGraph", "Small", "Default", "Inflate" -> 2, "KeepCoordinates" -> True], RandomSeeding -> 1]
```
