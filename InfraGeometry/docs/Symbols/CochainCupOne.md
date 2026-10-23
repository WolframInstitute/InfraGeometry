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

<code>[CochainCupOne]()[*g*, *α*, *β*]</code> gives Steenrod's cup-1 product *α ∪₁ β* of the ordered cochains *α* and *β*, a cochain of degree *p* + *q* − 1.

## Details & Options

For *α* of degree *p* and *β* of degree *q*, with *n* = *p* + *q*, on each increasing tuple *v₀ < … < vₙ₋₁* of a clique, *(α ∪₁ β)(v₀, …, vₙ₋₁) = Σᵢ εᵢ α(v₀, …, vᵢ, vⱼ, …, vₙ₋₁) β(vᵢ, …, vⱼ)*, the sum over *i* = 0, …, *p* − 1 with *j* = *i* + *q*. The sign *εᵢ* is −1 to the power *(p − i)(q + 1) + p + q + 1*.

Steenrod's identity: for cocycles *α* and *β*, *δ(α ∪₁ β) = α ∪ β − β ∪ α*, with a plus sign when *p* and *q* are both odd. Here ∪ is the ordered cup [OrderedCochainCup](). So the ordered cup is graded-commutative up to an explicit coboundary.

The cup-1 is 0 when *α* has degree 0. For two 1-cochains it is minus their product, *(α ∪₁ β)(u, v) = −α(u, v) β(u, v)*.

The result is an ordered cochain: read it with [OrderedCochainValue]().

Reference: N. E. Steenrod, Products of cocycles and extensions of mappings, *Annals of Mathematics* 48 (1947), 290–320.

## Basic Examples

For two 1-cochains the cup-1 is minus their product, edge by edge. The coboundaries of the distances from the centre and from a vertex at distance 4 on the square grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {a = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]],
   e = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, b]]]},
  KeySort @ CochainCupOne[g, a, e] === KeySort @ DeleteCases[-a e, 0]]
```

Steenrod's identity on the square mesh, for the same two cocycles: the coboundary of their cup-1 is the sum of their ordered cups in both orders, drawn on the triangles, blue where it is positive on the sorted corners and red where it is negative:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {pos = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {a = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]],
   e = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, b]]]},
  {commutator = DeleteCases[Merge[{OrderedCochainCup[g, a, e], OrderedCochainCup[g, e, a]}, Total], 0]},
  Show[Graphics[KeyValueMap[{t, x} |-> {If[x > 0, StandardBlue, StandardRed], Polygon[pos /@ t]}, commutator]],
    InfraSubstrateHighlight[g, {c, b}],
    PlotLabel -> (KeySort @ Coboundary[g, CochainCupOne[g, a, e]] === KeySort @ commutator)]]
```

## Scope

Steenrod's identity in the degrees *p*, *q* = 1, 2, 3 on the complete graph on six vertices, for the coboundaries of random cochains:

```wl
With[{g = CompleteGraph[6]},
  {cocycle = {k, s} |-> Coboundary[g,
     AssociationThread[Subsets[Range[6], {k}], BlockRandom[RandomInteger[{-4, 4}, Binomial[6, k]], RandomSeeding -> s]]],
   identity = {a, e, sign} |-> KeySort @ Coboundary[g, CochainCupOne[g, a, e]] ===
     KeySort @ DeleteCases[Merge[{OrderedCochainCup[g, a, e], -sign OrderedCochainCup[g, e, a]}, Total], 0]},
  Table[identity[cocycle[p, 1], cocycle[q, 2], (-1)^(p q)], {p, 3}, {q, 3}]]
```

## Properties and Relations

The cup-1 is 0 when the first factor has degree 0:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {f = AssociationThread[List /@ VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
  CochainCupOne[g, f, Coboundary[g, f]]]
```

## Possible Issues

The identity needs cocycles. A random 1-cochain on the mesh has a nonzero coboundary, and the identity fails:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {edges = Sort /@ List @@@ EdgeList[g]},
  {a = AssociationThread[edges, BlockRandom[RandomInteger[{-4, 4}, Length[edges]], RandomSeeding -> 1]],
   e = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]]},
  {commutator = DeleteCases[Merge[{OrderedCochainCup[g, a, e], OrderedCochainCup[g, e, a]}, Total], 0]},
  {Length @ Coboundary[g, a], KeySort @ Coboundary[g, CochainCupOne[g, a, e]] === KeySort @ commutator}]
```
