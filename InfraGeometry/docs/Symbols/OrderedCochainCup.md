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

<code>[OrderedCochainCup]()[*g*, *α*, *β*]</code> gives the Alexander–Whitney cup product *α ⌣ β* of the cochains *α* and *β* on the increasing tuples of the cliques of *g*.

## Details & Options

For *α* of degree *p* and *β* of degree *q*, with *n = p + q*, *(α ⌣ β)(v₀, …, vₙ) = α(v₀, …, vₚ) β(vₚ, …, vₙ)* on each increasing tuple *v₀ < … < vₙ* of a clique: the front face of *α* times the back face of *β*. The order is the one in which [Sort]() puts the vertex names.

| Property | Statement |
|---|---|
| associative | *(α ⌣ β) ⌣ γ = α ⌣ (β ⌣ γ)*: both read three consecutive faces |
| unit | the constant 0-cochain 1 |
| Leibniz rule | *δ(α ⌣ β) = δα ⌣ β + (−1)ᵖ α ⌣ δβ* |
| not graded-commutative | on cocycles *α ⌣ β − β ⌣ α = δ(α ⌣₁ β)*, with a plus sign when *p* and *q* are both odd and *⌣₁* the [CochainCupOne]() |

The result is an ordered cochain, defined on the increasing tuples only: read it with [OrderedCochainValue](). [CochainCup]() averages the product over the orderings of each clique, and is alternating and graded-commutative but not associative.

On the square grid there are no triangles, and the product of two 1-cochains is empty.

## Basic Examples

The ordered cup of the coboundaries of the coordinates *x* and *y* of the square mesh, against the signed area of each triangle on its sorted corners. [CochainCup]() gives the area; the ordered cup depends on the order of the corners:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {pos = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {dx = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   dy = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {area = t |-> Det[Differences[pos /@ t]]/2},
  ListPlot[Table[KeyValueMap[{area[#1], #2} &, cup[g, dx, dy]], {cup, {CochainCup, OrderedCochainCup}}],
    AspectRatio -> 1, PlotLegends -> {"CochainCup", "OrderedCochainCup"}]]
```

The product is not graded-commutative. On a triangle *v₀ < v₁ < v₂* at the centre of the mesh, the 1-cochain that is 1 on *(v₀, v₁)* times the one that is 1 on *(v₁, v₂)* is 1; in the other order it is 0, which is not stored:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {t = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[c]]},
  {front = <|t[[{1, 2}]] -> 1|>, back = <|t[[{2, 3}]] -> 1|>},
  InfraSubstrateHighlight[g, {InfraWalk[t[[{1, 2}]]], InfraWalk[t[[{2, 3}]]]},
    PlotLabel -> {OrderedCochainCup[g, front, back], OrderedCochainCup[g, back, front]}, ImageSize -> Medium]]
```

## Properties and Relations

Associativity and the unit, for a random 0-cochain *f* and random 1-cochains *α*, *β* on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {edges = Sort /@ List @@@ EdgeList[g], vs = List /@ VertexList[g]},
  {a = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 1]],
   b = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 2]],
   f = AssociationThread[vs, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[vs]], RandomSeeding -> 3]],
   one = AssociationThread[vs, 1]},
  {KeySort @ OrderedCochainCup[g, OrderedCochainCup[g, f, a], b] ==
     KeySort @ OrderedCochainCup[g, f, OrderedCochainCup[g, a, b]],
   KeySort @ OrderedCochainCup[g, one, a] == KeySort[a] == KeySort @ OrderedCochainCup[g, a, one]}]
```

The Leibniz rule, *δ(f ⌣ β) = δf ⌣ β + f ⌣ δβ*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {edges = Sort /@ List @@@ EdgeList[g], vs = List /@ VertexList[g]},
  {b = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 2]],
   f = AssociationThread[vs, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[vs]], RandomSeeding -> 3]]},
  {right = Merge[{OrderedCochainCup[g, Coboundary[g, f], b], OrderedCochainCup[g, f, Coboundary[g, b]]}, Total]},
  KeySort @ Coboundary[g, OrderedCochainCup[g, f, b]] == KeySort @ DeleteCases[right, 0]]
```

On the cocycles *δx* and *δy* of the mesh, *δx ⌣ δy + δy ⌣ δx* is the coboundary of the cup-1 product:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {dx = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   dy = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {commutator = Merge[{OrderedCochainCup[g, dx, dy], OrderedCochainCup[g, dy, dx]}, Total]},
  Max @ Abs[Values @ Merge[{commutator, -Coboundary[g, CochainCupOne[g, dx, dy]]}, Total]] < 10^-12]
```

## Possible Issues

The product is defined on increasing tuples only. [CochainValue]() extends it by the sign rule, which is not the product on the reversed tuple; [OrderedCochainValue]() refuses that tuple:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {t = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[c]]},
  {cup = OrderedCochainCup[g, <|t[[{1, 2}]] -> 1|>, <|t[[{2, 3}]] -> 1|>]},
  {CochainValue[cup, Reverse @ t], OrderedCochainValue[cup, Reverse @ t]}]
```
