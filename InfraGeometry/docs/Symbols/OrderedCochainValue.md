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

<code>[OrderedCochainValue]()[*α*, {*v₀*, …, *vₖ*}]</code> gives the value of the ordered cochain *α* on the increasing tuple *v₀ < … < vₖ*.

## Details & Options

An ordered *k*-cochain is a function on the increasing *(k + 1)*-tuples of the cliques, in the order in which [Sort]() puts the vertex names. It is stored like an alternating cochain, `<|{v0, …, vk} -> value|>`, one value per clique, and a value 0 is not stored.

On an increasing tuple [OrderedCochainValue]() gives the stored value, or 0. On any other tuple it gives `Missing["NonIncreasingTuple", tuple]`: an ordered cochain has no value there. [CochainValue]() would extend it by the sign rule, which is right for alternating cochains only.

[OrderedCochainCup]() and [CochainCupOne]() give ordered cochains.

## Basic Examples

The ordered cup *δx ⌣ δy* of the coordinates on a triangle at the centre of the square mesh, read on the six orderings of its corners. Only the increasing one has a value:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {dx = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   dy = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {t = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[c]]},
  {cup = OrderedCochainCup[g, dx, dy]},
  AssociationMap[OrderedCochainValue[cup, #] &, Permutations[t]]]
```

An increasing tuple that is not stored gives 0. The product of the 1-cochain that is 1 on the front edge of a triangle with the one that is 1 on its back edge vanishes on every other triangle:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {triangles = Sort /@ FindClique[g, {3}, All]}, {t = First @ Select[triangles, MemberQ[c]]},
  {cup = OrderedCochainCup[g, <|t[[{1, 2}]] -> 1|>, <|t[[{2, 3}]] -> 1|>]},
  InfraSubstrateHighlight[g, {t}, PlotLabel -> Counts[OrderedCochainValue[cup, #] & /@ triangles],
    ImageSize -> Medium]]
```

## Properties and Relations

On increasing tuples [OrderedCochainValue]() and [CochainValue]() agree. On the reversed tuples [CochainValue]() applies the sign of the permutation:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {dx = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   dy = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {cup = OrderedCochainCup[g, dx, dy]},
  {AllTrue[Keys[cup], OrderedCochainValue[cup, #] == CochainValue[cup, #] &],
   AllTrue[Keys[cup], CochainValue[cup, Reverse[#]] == -cup[#] &],
   Union[Head /@ (OrderedCochainValue[cup, Reverse[#]] & /@ Keys[cup])]}]
```

## Possible Issues

The cochain carries no graph, so an increasing tuple that spans no clique also gives 0. A tuple with a repeated vertex is not increasing:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {t = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[c]]},
  {cup = OrderedCochainCup[g, <|t[[{1, 2}]] -> 1|>, <|t[[{2, 3}]] -> 1|>]},
  {OrderedCochainValue[cup, Take[Sort @ VertexList[g], 3]], OrderedCochainValue[cup, t[[{1, 1, 2}]]]}]
```
