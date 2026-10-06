---
Template: Symbol
Name: OrderedCochainCup
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/OrderedCochainCup
Keywords: [cup product, Alexander-Whitney, ordered cochain, front face, back face, associative, differential graded algebra]
SeeAlso: [CochainCup, CochainCupOne, OrderedCochainValue, Coboundary, CochainValue]
RelatedGuides: [Experimental]
---

## Usage

<code>[OrderedCochainCup]()[*g*, *α*, *β*]</code> gives the ordered cup product of the ordered cochains *α* and *β*, the Alexander–Whitney formula *α(v₀, …, vₚ) β(vₚ, …, vₙ)* on each increasing tuple *v₀ < … < vₙ* of a clique of *g*.

## Details & Options

Definition: for *α* of degree *p* and *β* of degree *q*, with *n* = *p* + *q*, *(α ∪ β)(v₀, …, vₙ) = α(v₀, …, vₚ) β(vₚ, …, vₙ)* on the increasing tuples, the front face of *α* times the back face of *β*. The order of the vertices is the one in which [Sort]() puts their names.

It is associative and unital: both bracketings of three factors read the three consecutive faces of the tuple, and the constant 0-cochain 1 is a unit. The coboundary is a derivation for it, so the ordered cochains form a differential graded algebra.

It is not graded-commutative. On a triangle *v₀ < v₁ < v₂*, the 1-cochains *α*, 1 on *(v₀, v₁)*, and *β*, 1 on *(v₁, v₂)*, have *α ∪ β* = 1 and *β ∪ α* = 0 there.

The product of two alternating cochains is not alternating, so the result is an ordered cochain: read it with [OrderedCochainValue](), not with [CochainValue](). Its antisymmetrisation is the cup [CochainCup](), and on cohomology the two agree: the ordered cup and the cup of two cocycles differ by a coboundary. On cocycles the graded commutator *α ∪ β − (−1)^(pq) β ∪ α* is the coboundary of [CochainCupOne]().

## Basic Examples

On the mesh of a square, the ordered cup of the coboundaries of the two coordinates against the signed area of each triangle on its sorted corners, beside the cup [CochainCup]() of the same two cochains. The cup is the area; the ordered cup depends on the order of the corners and is not.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {dx = Coboundary[g, KeyMap[List, positions[[All, 1]]]], dy = Coboundary[g, KeyMap[List, positions[[All, 2]]]]},
  ListPlot[{
     KeyValueMap[{triangle, value} |-> {Det[Differences[Lookup[positions, triangle]]] / 2, value}, CochainCup[g, dx, dy]],
     KeyValueMap[{triangle, value} |-> {Det[Differences[Lookup[positions, triangle]]] / 2, value}, OrderedCochainCup[g, dx, dy]]},
   PlotLegends -> {"cup", "ordered cup"}, AxesLabel -> {"signed area", "product"}]]
```

The ordered cup is not graded-commutative. On a triangle at the centre of the triangular tiling, the 1-cochain that is 1 on its front edge and the 1-cochain that is 1 on its back edge multiply to 1 in this order and to 0 in the other.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {triangle = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[center]]},
  {front = <|triangle[[{1, 2}]] -> 1|>, back = <|triangle[[{2, 3}]] -> 1|>},
  {Show[Graphics[{StandardBlue, Polygon[Lookup[positions, triangle]]}], g],
   Normal @ OrderedCochainCup[g, front, back], Normal @ OrderedCochainCup[g, back, front]}]
```

## Properties and Relations

The ordered cup is associative: for two random 1-cochains and a random 0-cochain on the triangular tiling, both bracketings give the same 2-cochain, drawn on its triangles, blue where its value on the sorted corners is positive and red where it is negative.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {firstCochain = (SeedRandom[1]; AssociationMap[RandomInteger[{-4, 4}] &, Sort /@ List @@@ EdgeList[g]]),
   secondCochain = (SeedRandom[2]; AssociationMap[RandomInteger[{-4, 4}] &, Sort /@ List @@@ EdgeList[g]]),
   values = (SeedRandom[3]; AssociationMap[RandomInteger[{-4, 4}] &, List /@ VertexList[g]])},
  {product = OrderedCochainCup[g, OrderedCochainCup[g, firstCochain, secondCochain], values]},
  {Show[Graphics[KeyValueMap[{triangle, value} |-> {If[value > 0, StandardBlue, StandardRed], Polygon[Lookup[positions, triangle]]}, product]], g],
   KeySort[product] === KeySort[OrderedCochainCup[g, firstCochain, OrderedCochainCup[g, secondCochain, values]]]}]
```

The constant 0-cochain 1 is a unit on either side.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cochain = Coboundary[g, AssociationMap[GraphDistance[g, InfraCenter[g], First[#]] &, List /@ VertexList[g]]],
   unit = AssociationMap[1 &, List /@ VertexList[g]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   {KeySort[OrderedCochainCup[g, unit, cochain]] === KeySort[cochain], KeySort[OrderedCochainCup[g, cochain, unit]] === KeySort[cochain]}}]
```
