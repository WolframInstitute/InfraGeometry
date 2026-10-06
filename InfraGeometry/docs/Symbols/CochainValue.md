---
Template: Symbol
Name: CochainValue
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainValue
Keywords: [cochain, alternating cochain, clique complex, orientation, simplex]
SeeAlso: [OrderedCochainValue, CochainDegree, Coboundary, CochainCup, FormValue, IntegrationMap]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainValue]()[*α*, {*v*₀, …, *v*ₖ}]</code> gives *α(v₀, …, vₖ)*, the value of the alternating *k*-cochain *α* on a tuple of vertices.

## Details & Options

Definition: an alternating *k*-cochain *α* on a graph is a function on the orderings of its (*k* + 1)-cliques with *α(vσ(0), …, vσ(k)) = sgn(σ) α(v₀, …, vₖ)* for every permutation *σ*, extended by 0 to the tuples that span no clique.

An alternating cochain is determined by its values on the increasing tuples, one value per *k*-simplex of the clique complex, and it is stored so: `<|{v0, ..., vk} -> value|>` on the sorted cliques. [CochainValue]() sorts the tuple, as [Sort]() orders the vertex names, and multiplies the stored value by the sign of the sorting permutation. A tuple with a repeated vertex gives 0, and so does a tuple that is not stored: a value 0 is not stored, and a tuple that spans no clique carries no value.

The same storage carries the ordered cochains, functions on the increasing tuples alone, and nothing in the data says which convention a cochain follows. [OrderedCochainCup]() and [CochainCupOne]() give ordered cochains; read them with [OrderedCochainValue]().

## Basic Examples

The coboundary of the distance from the centre of the triangular tiling, drawn by an arc along each edge in the direction in which it is 1. On the step from the centre to a neighbour it is 1, on the step back −1.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g]},
  {cochain = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   {CochainValue[cochain, {center, First @ AdjacencyList[g, center]}], CochainValue[cochain, {First @ AdjacencyList[g, center], center}]}}]
```

## Scope

On a triangle the six orderings give the stored value with the signs of the six permutations, here for the 2-cochain that is 1 on one triangle at the centre.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {triangle = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[center]]},
  {Show[Graphics[{StandardBlue, Polygon[Lookup[positions, triangle]]}], g],
   Normal @ AssociationMap[CochainValue[<|triangle -> 1|>, #] &, Permutations[triangle]]}]
```

A pair that is not an edge gives 0. The coboundary of the distance from the centre lives on the edges: on the centre and a vertex of the rim, five steps away, it is 0.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g]},
  {cochain = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]]},
  {corner = First @ MaximalBy[VertexList[g], GraphDistance[g, center, #] &]},
  {InfraSubstrateHighlight[g, {center, corner}], GraphDistance[g, center, corner], CochainValue[cochain, {center, corner}]}]
```

## Possible Issues

[CochainValue]() reads every cochain as alternating. On the ordered cup of two 1-cochains on the complete graph on four vertices, the Alexander–Whitney formula gives *a(1, 3) b(3, 2) = −2* on the ordering (1, 3, 2), while [CochainValue]() returns the sign of the ordering times the stored value on (1, 2, 3), −1.

```wl
With[
  {g = CompleteGraph[4]},
  {a = <|{1, 2} -> 1, {1, 3} -> 2, {1, 4} -> 0, {2, 3} -> -1, {2, 4} -> 3, {3, 4} -> 1|>,
   b = <|{1, 2} -> 0, {1, 3} -> 1, {1, 4} -> 2, {2, 3} -> 1, {2, 4} -> 0, {3, 4} -> -2|>},
  {g, CochainValue[a, {1, 3}] CochainValue[b, {3, 2}], CochainValue[OrderedCochainCup[g, a, b], {1, 3, 2}]}]
```
