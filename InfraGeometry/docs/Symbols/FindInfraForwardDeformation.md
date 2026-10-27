---
Template: Symbol
Name: FindInfraForwardDeformation
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraForwardDeformation
Keywords: [forward walk, deformation, shortest path, tube, excess length, enumeration]
SeeAlso: [InfraForwardDeformation, InfraMeasurement, InfraDeformationSize, FindInfraHomotopy]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindInfraForwardDeformation]()[*g*, *family*]</code> gives one vertex-list walk from the [InfraForwardDeformation]() family on *g*.

<code>[FindInfraForwardDeformation]()[*g*, *family*, *n*]</code> gives *n* walks; *n* can be `UpTo[n]` or `All`.

## Details & Options

The family specifies a shortest reference path, an excess-length bound and a tube radius. Its walks never decrease their distance from the reference's starting vertex. They end at its final vertex, at first arrival by default.

Without a count the result is one vertex list, or `{}` when there is no member. An exact integer count gives that many distinct walks, or `{}` when fewer exist. `UpTo[n]` gives as many as available up to *n*. `All` lists every member.

The walks are paths through the family's finite layered graphs. They can revisit substrate vertices, so they need not be simple paths. Enumeration is deterministic.

Use <code>[InfraMeasurement]()[*g*, *family*, "Cardinality"]</code> when only a count is needed; it does not enumerate the walks. Enumeration can have exponentially many results even when counting is inexpensive.

## Basic Examples

Both shortest routes around a square:

```wl
With[{g = CycleGraph[4]},
  FindInfraForwardDeformation[g, InfraForwardDeformation[{1, 2, 3}, {0}], All]]
```

The edge and the longer route across a triangle:

```wl
With[{g = CycleGraph[3]},
  FindInfraForwardDeformation[g, InfraForwardDeformation[{1, 2}, UpTo[1]], All]]
```

## Properties and Relations

Enumeration agrees with the exact count:

```wl
With[{g = CycleGraph[4]}, {family = InfraForwardDeformation[{1, 2, 3}, UpTo[2]]},
  Length[FindInfraForwardDeformation[g, family, All]] == InfraMeasurement[g, family, "Cardinality"]]
```
