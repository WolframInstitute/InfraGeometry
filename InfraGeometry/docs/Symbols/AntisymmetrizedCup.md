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

<code>[AntisymmetrizedCup]()[*g*, *α*, *β*]</code> is <code>[CochainCup]()[*g*, *α*, *β*]</code>, the cup product of the alternating cochains *α* and *β*, under the name the antisymmetrised product carried before it became the cup product.

## Details & Options

Definition: the Alexander–Whitney product averaged with signs over all orderings of each clique, *(α ∪ β)(v₀, …, vₙ) = (1/(n + 1)!) Σ sgn(σ) α(σ₀, …, σₚ) β(σₚ, …, σₙ)*, as on the [CochainCup]() page.

It is kept for code written before the antisymmetrised product became the cup product: the arguments and the result are those of [CochainCup](). New code calls [CochainCup]().

## Basic Examples

The two names give one product: the cup of the coboundaries of the distances from the centre of the triangular tiling and from a vertex three steps away, drawn on its triangles, blue where it is positive on the counterclockwise order of the corners and red where it is negative.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {fromCenter = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
   fromApex = Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]},
  {cup = AntisymmetrizedCup[g, fromCenter, fromApex]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {
       If[value Det[Differences[Lookup[positions, triangle]]] > 0, StandardBlue, StandardRed],
       Polygon[Lookup[positions, triangle]]},
     cup]], g],
   KeySort[cup] === KeySort[CochainCup[g, fromCenter, fromApex]]}]
```
