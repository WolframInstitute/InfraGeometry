---
Template: Symbol
Name: InfraLineQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraLineQ
Keywords: [line, inextensible shortest path, predicate, alias]
SeeAlso: [InfraInfiniteLineQ, RandomInfraLine, InfraLine, InfraSegmentQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraLineQ]()[*g*, *walk*]</code> is the older name of <code>[InfraInfiniteLineQ]()[*g*, *walk*]</code>: it tests whether *walk* is a shortest path that no neighbour of either end prolongs.

## Details & Options

[InfraLineQ]() takes the same arguments as [InfraInfiniteLineQ]() and gives the same result. New code uses [InfraInfiniteLineQ]().

## Basic Examples

A line through the centre of the square grid, and the same walk without its last vertex, which can be prolonged:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {line = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {line, c}, PlotLabel -> {InfraLineQ[g, line], InfraLineQ[g, Most @ line]},
    ImageSize -> Medium]]
```

## Properties and Relations

[InfraLineQ]() and [InfraInfiniteLineQ]() agree:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {lines = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {InfraLineQ[g, lines], InfraInfiniteLineQ[g, lines],
   InfraLineQ[g, Most /@ lines] === InfraInfiniteLineQ[g, Most /@ lines]}]
```
