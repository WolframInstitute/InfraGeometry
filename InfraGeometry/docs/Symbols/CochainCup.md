---
Template: Symbol
Name: CochainCup
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainCup
Keywords: [cup product, alternating cochain, Alexander-Whitney, antisymmetrisation, clique complex, graded-commutative, associator, area]
SeeAlso: [OrderedCochainCup, CochainCupOne, AntisymmetrizedCup, Coboundary, CochainValue, FormWedge]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainCup]()[*g*, *α*, *β*]</code> gives the cup product *α ∪ β* of the alternating cochains *α* and *β* on the clique complex of *g*.

## Details & Options

For *α* of degree *p* and *β* of degree *q*, with *n* = *p* + *q*, the cup product is the Alexander–Whitney product averaged over the orderings of each clique, *(α ∪ β)(v₀, …, vₙ) = (1/(n + 1)!) Σ sgn(σ) α(σ₀, …, σₚ) β(σₚ, …, σₙ)*, the sum over the orderings *σ* of *{v₀, …, vₙ}*.

The product is again alternating and needs no order of the vertices.

| Property | Statement |
|---|---|
| unit | the constant 0-cochain 1 |
| graded-commutative | *β ∪ α = α ∪ β*, with a minus sign when *p* and *q* are both odd |
| Leibniz rule | *δ(α ∪ β) = δα ∪ β + (−1)ᵖ α ∪ δβ* |
| not associative | *((f ∪ h) ∪ β − f ∪ (h ∪ β))(u, v) = (f(v) − f(u))(h(v) − h(u)) β(u, v)/4* for 0-cochains *f*, *h* |

The cup with a 0-cochain *f* multiplies by the mean of *f* over each clique. On cohomology the product agrees with [OrderedCochainCup](), the associative Alexander–Whitney product.

On the square mesh, *δx ∪ δy* for the coordinates *x*, *y* is the signed area of each triangle. On the square grid there are no triangles, and the cup of two 1-cochains is 0.

## Basic Examples

The cup of the coboundaries of the distances from the centre and from a vertex at distance 4, on the square mesh. It is ±1/2 on 95 of the 154 triangles: blue where it is positive on the counterclockwise order of the corners, red where it is negative, one sign on each side of the line through the two vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {pos = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {cup = CochainCup[g, Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]],
     Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, b]]]]},
  Show[Graphics[KeyValueMap[
      {t, a} |-> {If[a Det[Differences[pos /@ t]] > 0, StandardBlue, StandardRed], Polygon[pos /@ t]}, cup]],
    InfraSubstrateHighlight[g, {c, b}], PlotLabel -> {Union @ Values[cup], Length[cup]}]]
```

On every triangle of the mesh, counterclockwise, *δx ∪ δy* is the area. Its sum is the area of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {pos = AssociationThread[VertexList[g], GraphEmbedding[g]], triangles = FindClique[g, {3}, All]},
  {x = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {counterclockwise = If[Det[Differences[pos /@ #]] > 0, #, Reverse[#]] & /@ triangles},
  {Total[CochainValue[CochainCup[g, x, y], #] & /@ counterclockwise],
   Total[Area @* Polygon @* Map[pos] /@ triangles]}]
```

## Properties and Relations

The cup with a 0-cochain multiplies by its mean over each edge. For the distance *f* from the centre of the grid, *f ∪ δf = δ(f²/2)*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {f = AssociationThread[List /@ VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
  CochainCup[g, f, Coboundary[g, f]] == Coboundary[g, f^2 / 2]]
```

The cup is not associative. For the same *f*, *(f ∪ f) ∪ δf − f ∪ (f ∪ δf) = (δf)³/4*, ±1/4 on every edge:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {f = AssociationThread[List /@ VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
  {df = Coboundary[g, f]},
  {associator = Merge[{CochainCup[g, CochainCup[g, f, f], df], -CochainCup[g, f, CochainCup[g, f, df]]},
     Total]},
  {Union[Values[associator]], associator == df^3 / 4}]
```

The cup is graded-commutative and has the unit 1. Two 1-cochains on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {x = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {one = AssociationThread[List /@ VertexList[g], 1]},
  {CochainCup[g, y, x] == -CochainCup[g, x, y], CochainCup[g, one, x] == x}]
```

The coboundary satisfies the Leibniz rule. For random 1-cochains *α*, *β* on the complete graph on six vertices, *δ(α ∪ β) = δα ∪ β − α ∪ δβ*:

```wl
With[{g = CompleteGraph[6]},
  {a = AssociationThread[Subsets[Range[6], {2}], BlockRandom[RandomInteger[{-4, 4}, 15], RandomSeeding -> 1]],
   b = AssociationThread[Subsets[Range[6], {2}], BlockRandom[RandomInteger[{-4, 4}, 15], RandomSeeding -> 2]]},
  Coboundary[g, CochainCup[g, a, b]] ==
    DeleteCases[Merge[{CochainCup[g, Coboundary[g, a], b], -CochainCup[g, a, Coboundary[g, b]]}, Total], 0]]
```
