---
Template: Symbol
Name: OrderedCochainValue
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/OrderedCochainValue
Keywords: [ordered cochain, Alexander-Whitney, increasing tuple, vertex order, cup product]
SeeAlso: [CochainValue, OrderedCochainCup, CochainCupOne, CochainCup, CochainDegree]
RelatedGuides: [Experimental]
---

## Usage

<code>[OrderedCochainValue]()[*α*, {*v*₀, …, *v*ₖ}]</code> gives the value of the ordered *k*-cochain *α* on an increasing tuple *v₀ < … < vₖ*, and `Missing["NonIncreasingTuple", tuple]` on any other tuple.

## Details & Options

Definition: with the vertices in a linear order, an ordered *k*-cochain is a function on the increasing (*k* + 1)-tuples of the cliques alone, extended by 0 to the increasing tuples that span no clique. The order is the one in which [Sort]() puts the vertex names.

Restricting an alternating cochain to the increasing tuples identifies the alternating and the ordered *k*-cochains as vector spaces, one value per *k*-simplex, so both are stored alike, `<|{v0, ..., vk} -> value|>`. The identification does not respect the products: extended by the sign rule, the ordered cup of two alternating cochains is not their Alexander–Whitney product on the other orderings. An ordered cochain is therefore read on the increasing tuples only.

[OrderedCochainCup]() and [CochainCupOne]() give ordered cochains, and [OrderedCochainValue]() reads them. On an increasing tuple it agrees with [CochainValue]().

## Basic Examples

The ordered cup of the coboundaries of the distances from the centre of the triangular tiling and from a vertex three steps away, drawn on its triangles, blue where it is positive and red where it is negative. On a triangle at the centre it has a value on the increasing ordering of the corners and none on the five others.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {cup = OrderedCochainCup[g,
     Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
     Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]},
  {triangle = First @ Select[Keys[cup], MemberQ[center]]},
  {Show[Graphics[KeyValueMap[{simplex, value} |-> {If[value > 0, StandardBlue, StandardRed], Polygon[Lookup[positions, simplex]]}, cup]], g],
   Normal @ AssociationMap[OrderedCochainValue[cup, #] &, Permutations[triangle]]}]
```

## Properties and Relations

On an increasing tuple the two readings agree, whatever the convention of the cochain.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {cup = OrderedCochainCup[g,
     Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
     Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]},
  {Show[Graphics[{StandardBlue, Polygon[Lookup[positions, #]] & /@ Keys[cup]}], g],
   AllTrue[Keys[cup], OrderedCochainValue[cup, #] == CochainValue[cup, #] &]}]
```

An increasing tuple that is not stored gives 0, not [Missing](): a triangle on which the ordered cup vanishes.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {cup = OrderedCochainCup[g,
     Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
     Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]},
  {triangle = First @ Complement[Sort /@ FindClique[g, {3}, All], Keys[cup]]},
  {Show[Graphics[{StandardBlue, Polygon[Lookup[positions, triangle]]}], g], OrderedCochainValue[cup, triangle]}]
```
