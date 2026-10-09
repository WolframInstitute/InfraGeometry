---
Template: Symbol
Name: CochainCup
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainCup
Keywords: [cup product, alternating cochain, Alexander-Whitney, antisymmetrisation, clique complex, graded-commutative, associator]
SeeAlso: [OrderedCochainCup, CochainCupOne, AntisymmetrizedCup, Coboundary, CochainValue, FormWedge]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainCup]()[*g*, *α*, *β*]</code> gives the cup product *α ∪ β* of the alternating cochains *α* and *β*: the Alexander–Whitney product averaged with signs over all orderings of each clique of *g*.

## Details & Options

Definition: for *α* of degree *p* and *β* of degree *q*, with *n* = *p* + *q*, *(α ∪ β)(v₀, …, vₙ) = (1/(n + 1)!) Σ sgn(σ) α(σ₀, …, σₚ) β(σₚ, …, σₙ)*, the sum over the orderings *σ* = *(σ₀, …, σₙ)* of the clique *{v₀, …, vₙ}*, *sgn(σ)* the sign of the ordering. The front face ends where the back face begins.

It needs no order of the vertices: *α ∪ β* is again alternating.

The constant 0-cochain 1 is a unit. The product is graded-commutative, *β ∪ α = (−1)^(pq) α ∪ β*, by reversing each ordering, and the coboundary is a derivation, *δ(α ∪ β) = δα ∪ β + (−1)^p α ∪ δβ*.

It is not associative. The cup with a 0-cochain *f* multiplies by the mean of *f* over the clique, and the mean of a product is not the product of the means: in degrees 0, 0 and 1, *((f ∪ g) ∪ β − f ∪ (g ∪ β))(u, v) = (f(v) − f(u))(g(v) − g(u)) β(u, v)/4* on every edge.

The normalisation 1/(*n* + 1)! is the one under which the cup of two cocycles is cohomologous to their ordered cup, [OrderedCochainCup](): with twice the cup the class changes, as on a triangulated torus. For the associative product use [OrderedCochainCup](). [AntisymmetrizedCup]() is the same function.

## Basic Examples

The cup of the coboundaries of the distances from the centre of the triangular tiling and from a vertex three steps away, drawn on its triangles, blue where it is positive on the counterclockwise order of the corners and red where it is negative. It is ±1/2 where the two distances grow in different directions, of one sign on either side of the line through the two vertices, and 0 where they grow together.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {cup = CochainCup[g,
     Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
     Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {
       If[value Det[Differences[Lookup[positions, triangle]]] > 0, StandardBlue, StandardRed],
       Polygon[Lookup[positions, triangle]]},
     cup]], g],
   Union[Values[cup]]}]
```

On the mesh of a square the cup of the coboundaries of the two coordinates is the signed area of each triangle, *det(v₁ − v₀, v₂ − v₀)/2* on its sorted corners: against it, the cup lies on the diagonal.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {cup = CochainCup[g, Coboundary[g, KeyMap[List, positions[[All, 1]]]], Coboundary[g, KeyMap[List, positions[[All, 2]]]]]},
  ListPlot[KeyValueMap[{triangle, value} |-> {Det[Differences[Lookup[positions, triangle]]] / 2, value}, cup], AxesLabel -> {"signed area", "cup"}]]
```

## Properties and Relations

The cup with a 0-cochain multiplies by its mean over each edge. For the distance *f* from the centre, *f ∪ δf = δ(f²/2)*, drawn by an arc along each edge in the direction in which it is positive: *(f(u) + f(v))/2* times *f(v) − f(u)*.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = AssociationMap[GraphDistance[g, First @ GraphCenter[g], First[#]] &, List /@ VertexList[g]]},
  {product = CochainCup[g, values, Coboundary[g, values]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[product, Positive], Reverse /@ Keys @ Select[product, Negative]], First -> Last]],
   KeySort[product] === KeySort[Coboundary[g, values^2 / 2]]}]
```

The cup is not associative. For the distance *f* from the centre, *(f ∪ f) ∪ δf − f ∪ (f ∪ δf)* is *(δf)³/4*, ±1/4 on every edge between two shells.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = AssociationMap[GraphDistance[g, First @ GraphCenter[g], First[#]] &, List /@ VertexList[g]]},
  {associator = DeleteCases[Merge[{
      CochainCup[g, CochainCup[g, values, values], Coboundary[g, values]],
      -CochainCup[g, values, CochainCup[g, values, Coboundary[g, values]]]}, Total], 0]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[associator, Positive], Reverse /@ Keys @ Select[associator, Negative]], First -> Last]],
   Union[Abs[Values[associator]]], KeySort[associator] === KeySort[Coboundary[g, values]^3 / 4]}]
```

The cup is graded-commutative and unital: the cup of the two coboundaries above in the other order is its negative, and the cup with the constant 1 changes nothing.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]])},
  {fromCenter = Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]],
   fromApex = Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {
       If[value Det[Differences[Lookup[positions, triangle]]] > 0, StandardBlue, StandardRed],
       Polygon[Lookup[positions, triangle]]},
     CochainCup[g, fromApex, fromCenter]]], g],
   KeySort[CochainCup[g, fromApex, fromCenter]] === KeySort[-CochainCup[g, fromCenter, fromApex]],
   KeySort[CochainCup[g, AssociationMap[1 &, List /@ VertexList[g]], fromCenter]] === KeySort[fromCenter]}]
```

The coboundary is a derivation. On the complete graph on six vertices, where the cup of two 1-cochains has a coboundary, for random 1-cochains *α* and *β*: *δ(α ∪ β) = δα ∪ β − α ∪ δβ*.

```wl
With[
  {g = CompleteGraph[6]},
  {firstCochain = (SeedRandom[1]; AssociationMap[RandomInteger[{-4, 4}] &, Subsets[Range[6], {2}]]),
   secondCochain = (SeedRandom[2]; AssociationMap[RandomInteger[{-4, 4}] &, Subsets[Range[6], {2}]])},
  {g, KeySort[Coboundary[g, CochainCup[g, firstCochain, secondCochain]]] ===
    KeySort[DeleteCases[Merge[{
      CochainCup[g, Coboundary[g, firstCochain], secondCochain],
      -CochainCup[g, firstCochain, Coboundary[g, secondCochain]]}, Total], 0]]}]
```
