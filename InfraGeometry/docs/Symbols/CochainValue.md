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

<code>[CochainValue]()[*α*, {*v₀*, …, *vₖ*}]</code> gives *α(v₀, …, vₖ)*, the value of the alternating *k*-cochain *α* on a tuple of vertices.

## Details & Options

An alternating *k*-cochain satisfies *α(vσ₍₀₎, …, vσ₍ₖ₎) = sgn(σ) α(v₀, …, vₖ)* for every permutation *σ*, and is 0 on a tuple that spans no clique.

It is stored on the increasing tuples, one value per *k*-simplex of the clique complex: `<|{v0, …, vk} -> value, …|>`. The value on any tuple is the stored value on the sorted tuple times the sign of the sorting permutation.

The value is 0 on a tuple with a repeated vertex, on a tuple that spans no clique and on a tuple whose stored value is 0.

The storage does not say whether a cochain is alternating or ordered. [OrderedCochainCup]() and [CochainCupOne]() give ordered cochains; read them with [OrderedCochainValue]().

## Basic Examples

The coboundary of the distance from the centre of the grid, on the step from the centre to a neighbour and on the step back:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {df = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]], w = First @ AdjacencyList[g, c]},
  InfraSubstrateHighlight[g, {InfraWalk[{c, w}], c}, PlotLabel -> {CochainValue[df, {c, w}], CochainValue[df, {w, c}]},
    ImageSize -> Medium]]
```

## Scope

On a triangle the six orderings give the stored value with the signs of the six permutations. The 2-cochain that is 1 on one triangle at the centre of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {t = Sort @ SelectFirst[FindClique[g, {3}, All], MemberQ[c]]},
  AssociationMap[CochainValue[<|t -> 1|>, #] &, Permutations[t]]]
```

The centre and a vertex at distance 2 span no clique, and the value is 0; so is the value on a repeated vertex. On an edge it is 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {df = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]]},
  {v = First @ Keys @ InfraMeasurement[g, InfraShell[c, 2], "VertexDensity"]},
  {CochainValue[df, {c, v}], CochainValue[df, {c, c}], CochainValue[df, {c, First @ AdjacencyList[g, c]}]}]
```

## Possible Issues

Every cochain is read as alternating. On the ordered cup of two 1-cochains on the complete graph on four vertices, the Alexander–Whitney formula gives *a(1, 3) b(3, 2) = −2* on the ordering (1, 3, 2), while [CochainValue]() gives the sign of the ordering times the stored value on (1, 2, 3), −1:

```wl
With[{g = CompleteGraph[4]},
  {a = <|{1, 2} -> 1, {1, 3} -> 2, {1, 4} -> 0, {2, 3} -> -1, {2, 4} -> 3, {3, 4} -> 1|>,
   b = <|{1, 2} -> 0, {1, 3} -> 1, {1, 4} -> 2, {2, 3} -> 1, {2, 4} -> 0, {3, 4} -> -2|>},
  {CochainValue[a, {1, 3}] CochainValue[b, {3, 2}], CochainValue[OrderedCochainCup[g, a, b], {1, 3, 2}]}]
```
