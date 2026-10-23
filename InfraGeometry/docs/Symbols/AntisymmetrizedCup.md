---
Template: Symbol
Name: AntisymmetrizedCup
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/AntisymmetrizedCup
Keywords: [cup product, antisymmetrisation, alternating cochain, alias]
SeeAlso: [CochainCup, OrderedCochainCup, CochainCupOne]
RelatedGuides: [Experimental]
---

## Usage

<code>[AntisymmetrizedCup]()[*g*, *α*, *β*]</code> is the older name of <code>[CochainCup]()[*g*, *α*, *β*]</code>, the cup product of the alternating cochains *α* and *β*.

## Details & Options

[AntisymmetrizedCup]() takes the same arguments as [CochainCup]() and gives the same result. New code uses [CochainCup]().

## Basic Examples

The two names give one product: the cup of the coboundaries of the coordinates on the square mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {x = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  AntisymmetrizedCup[g, x, y] === CochainCup[g, x, y]]
```
