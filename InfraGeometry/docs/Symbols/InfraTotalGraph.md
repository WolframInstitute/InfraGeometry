---
Template: Symbol
Name: InfraTotalGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTotalGraph
Keywords: [compatibility, fibered graph, InfraTotalSpace]
SeeAlso: [InfraTotalSpace, InfraFiberedGraph, InfraBaseSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraTotalGraph]()[*fib*]</code> gives the total graph of the fibered graph *fib*. It is the older name of [InfraTotalSpace]().

## Details & Options

The total graph of a fibered graph is the graph *E* whose vertices the projection *π* sends to the base.

[InfraTotalGraph]() gives the same result as [InfraTotalSpace]() on every input, including [InfraFiberedGraph](), [InfraFibration]() and the tangent, cotangent and displacement bundles. New code uses [InfraTotalSpace]().

## Basic Examples

The total graph and the base of a random double covering of the 4 × 4 grid:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  GraphicsRow[{InfraTotalGraph[fib], InfraBaseSpace[fib]}]]
```

## Properties and Relations

It is [InfraTotalSpace]():

```wl
With[{g = GridGraph[{4, 4}]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {1, 3}, RandomSeeding -> 1]},
  {InfraTotalGraph[fib] === InfraTotalSpace[fib],
   InfraTotalGraph[InfraTangentBundle[g, 2]] === InfraTotalSpace[InfraTangentBundle[g, 2]]}]
```
