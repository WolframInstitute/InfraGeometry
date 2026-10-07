---
Template: Symbol
Name: CochainCupOne
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainCupOne
Keywords: [cup-1 product, Steenrod, ordered cochain, graded commutator, homotopy, cocycle]
SeeAlso: [OrderedCochainCup, CochainCup, OrderedCochainValue, Coboundary]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainCupOne]()[*g*, *α*, *β*]</code> gives Steenrod's cup-1 product *α ∪₁ β* of the ordered cochains *α* and *β*, of degree *p* + *q* − 1; for cocycles its coboundary is the graded commutator of the ordered cup.

## Details & Options

Definition: for *α* of degree *p* and *β* of degree *q*, with *n* = *p* + *q*, on each increasing tuple *v₀ < … < vₙ₋₁* of a clique, *(α ∪₁ β)(v₀, …, vₙ₋₁) = Σᵢ (−1)^((p − i)(q + 1) + p + q + 1) α(v₀, …, vᵢ, vⱼ, …, vₙ₋₁) β(vᵢ, …, vⱼ)*, the sum over *i* = 0, …, *p* − 1 with *j* = *i* + *q*: *β* reads the *q* + 1 consecutive vertices from *vᵢ*, and *α* the others together with *vᵢ* and *vⱼ*.

Steenrod's theorem, in the signs of this formula: for cocycles *α* and *β*, *δ(α ∪₁ β) = α ∪ β − (−1)^(pq) β ∪ α*, with ∪ the ordered cup [OrderedCochainCup]() and *δ* the [Coboundary](). So the ordered cup is graded-commutative up to an explicit coboundary. The sign matters: on a triangulated torus the plain difference of the ordered cups of the two generators of the first cohomology is not exact.

It vanishes when *α* has degree 0. For two 1-cochains it is minus their product, *(α ∪₁ β)(v₀, v₁) = −α(v₀, v₁) β(v₀, v₁)*.

The result is an ordered cochain: read it with [OrderedCochainValue](). The cup [CochainCup]() needs no such primitive, being graded-commutative.

Reference: N. E. Steenrod, Products of cocycles and extensions of mappings, *Annals of Mathematics* 48 (1947), 290–320.

## Basic Examples

The cup-1 of the coboundaries of the distances from the centre of the triangular tiling and from a vertex three steps away, drawn by an arc along each edge in the direction in which it is positive: minus the product of the two coboundaries, edge by edge.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {apex = (SeedRandom[1]; FindInfraPoint[g, InfraShell[center, 3]])},
  {fromCenter = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
   fromApex = Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]},
  {cupOne = CochainCupOne[g, fromCenter, fromApex]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cupOne, Positive], Reverse /@ Keys @ Select[cupOne, Negative]], First -> Last]],
   KeySort[cupOne] === KeySort[DeleteCases[AssociationMap[-fromCenter[#] fromApex[#] &, Intersection[Keys[fromCenter], Keys[fromApex]]], 0]]}]
```

The two coboundaries are cocycles, and the coboundary of their cup-1 is the sum of their ordered cups in both orders, the graded commutator in degrees 1 and 1. It is drawn on its triangles, blue where its value on the sorted corners is positive and red where it is negative.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; FindInfraPoint[g, InfraShell[center, 3]])},
  {fromCenter = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
   fromApex = Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]},
  {commutator = DeleteCases[Merge[{OrderedCochainCup[g, fromCenter, fromApex], OrderedCochainCup[g, fromApex, fromCenter]}, Total], 0]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {If[value > 0, StandardBlue, StandardRed], Polygon[Lookup[positions, triangle]]},
     commutator]], g],
   KeySort[Coboundary[g, CochainCupOne[g, fromCenter, fromApex]]] === KeySort[commutator]}]
```

## Scope

Steenrod's identity in the degrees *p*, *q* = 1, 2, 3 on the complete graph on six vertices, for random cocycles, the coboundaries of random cochains.

```wl
With[
  {g = CompleteGraph[6]},
  {g, Table[
    With[{cocycle = (SeedRandom[p]; Coboundary[g, AssociationMap[RandomInteger[{-4, 4}] &, Subsets[Range[6], {p}]]]),
       otherCocycle = (SeedRandom[10 + q]; Coboundary[g, AssociationMap[RandomInteger[{-4, 4}] &, Subsets[Range[6], {q}]]])},
      KeySort[Coboundary[g, CochainCupOne[g, cocycle, otherCocycle]]] ===
        KeySort[DeleteCases[Merge[{
          OrderedCochainCup[g, cocycle, otherCocycle],
          -(-1)^(p q) OrderedCochainCup[g, otherCocycle, cocycle]}, Total], 0]]],
    {p, 3}, {q, 3}]}]
```

## Properties and Relations

The cup-1 vanishes when the first factor has degree 0: the distance from the centre against the coboundary of the distance from a vertex three steps away.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {apex = (SeedRandom[1]; FindInfraPoint[g, InfraShell[center, 3]])},
  {values = AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]},
  {InfraSubstrateHighlight[g, KeyMap[First, values]],
   Normal @ CochainCupOne[g, values, Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]}]
```

## Possible Issues

The identity needs cocycles. A random 1-cochain, whose coboundary is drawn on its triangles, is not closed, and with it the coboundary of the cup-1 is not the graded commutator.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {cochain = (SeedRandom[1]; AssociationMap[RandomInteger[{-4, 4}] &, Sort /@ List @@@ EdgeList[g]]),
   fromCenter = Coboundary[g, AssociationMap[GraphDistance[g, First @ GraphCenter[g], First[#]] &, List /@ VertexList[g]]]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {If[value > 0, StandardBlue, StandardRed], Polygon[Lookup[positions, triangle]]},
     Coboundary[g, cochain]]], g],
   KeySort[Coboundary[g, CochainCupOne[g, cochain, fromCenter]]] ===
     KeySort[DeleteCases[Merge[{OrderedCochainCup[g, cochain, fromCenter], OrderedCochainCup[g, fromCenter, cochain]}, Total], 0]]}]
```
