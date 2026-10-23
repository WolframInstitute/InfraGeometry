---
Template: Symbol
Name: InfraRayQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRayQ
Keywords: [ray, half-line, shortest path, inextensible, predicate]
SeeAlso: [InfraHalfLineQ, InfraRay, RandomInfraRay, InfraSegmentQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraRayQ]()[*g*, *ray*]</code> is the older name of <code>[InfraHalfLineQ]()[*g*, *ray*]</code>: it tests whether *ray* is a shortest path that cannot be prolonged past its last vertex.

## Details & Options

[InfraRayQ]() takes the same arguments as [InfraHalfLineQ]() and gives the same result. New code uses [InfraHalfLineQ]().

## Basic Examples

A ray from the centre of the square grid, and the same walk without its last vertex, which can still be prolonged:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {ray = RandomInfraRay[g, c, First @ AdjacencyList[g, c], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[ray], c}, PlotLabel -> {InfraRayQ[g, ray], InfraRayQ[g, Most @ ray]}, ImageSize -> Medium]]
```

## Properties and Relations

[InfraRayQ]() and [InfraHalfLineQ]() agree:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {rays = RandomInfraRay[g, c, First @ AdjacencyList[g, c], All]},
  {InfraRayQ[g, rays], InfraHalfLineQ[g, rays], InfraRayQ[g, Most /@ rays] === InfraHalfLineQ[g, Most /@ rays]}]
```
