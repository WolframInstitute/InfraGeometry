---
Template: Symbol
Name: Coboundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/Coboundary
Keywords: [coboundary, cochain, clique complex, cohomology, simplicial cochain complex]
SeeAlso: [CochainValue, CochainDegree, IntegrationMap, FormDifferential, CochainCup, RestrictionMap]
RelatedGuides: [Experimental]
---

## Usage

<code>[Coboundary]()[*g*, *α*]</code> gives the coboundary *δα* of the *k*-cochain *α*: on each (*k* + 2)-clique of *g*, the alternating sum of *α* over its faces.

## Details & Options

Definition: *(δα)(v₀, …, vₖ₊₁) = Σᵢ (−1)ⁱ α(v₀, …, v̂ᵢ, …, vₖ₊₁)*, the sum over the positions *i* = 0, …, *k* + 1. It maps the *k*-cochains to the (*k* + 1)-cochains of the clique complex of *g*.

On a 0-cochain *f*, *(δf)(u, v) = f(v) − f(u)* on every edge.

*δ(δα) = 0*: in the double sum each pair of deleted vertices occurs twice, with opposite signs. The cohomology of the clique complex is the kernel of *δ* modulo its image.

The coboundary is the same in the alternating and in the ordered convention: it reads only the stored values on the faces of an increasing tuple, which are increasing.

A *k*-cochain is keyed by increasing (*k* + 1)-vertex lists, a 0-cochain by one-vertex lists, `<|{v} -> value|>`; an association keyed by anything else stays unevaluated. A value equal to 0, a machine 0. too, is not stored.

## Basic Examples

The coboundary of the distance from the centre on the square, the hexagonal and the triangular tiling, drawn by an arc along each edge in the direction in which it is 1: every step from one shell to the next. Beside it, the number of edges with a value and the number of edges. The square and the hexagonal tiling are bipartite, and on the triangular tiling 60 edges lie inside a shell, where the coboundary is 0.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {cochains = Table[
     Coboundary[substrate, AssociationMap[GraphDistance[substrate, First @ GraphCenter[substrate], First[#]] &, List /@ VertexList[substrate]]],
     {substrate, graphs}]},
  {GraphicsRow[MapThread[
     DisplacementPlot[#1, GroupBy[Join[Keys @ Select[#2, Positive], Reverse /@ Keys @ Select[#2, Negative]], First -> Last]] &,
     {graphs, cochains}]],
   Transpose[{Length /@ cochains, EdgeCount /@ graphs}]}]
```

The coboundary of a coboundary is empty. The coboundary of a random 0-cochain on the triangular tiling has three values round each triangle that add up to 0, so its own coboundary is empty.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cochain = Coboundary[g, (SeedRandom[1]; AssociationMap[RandomInteger[{-4, 4}] &, List /@ VertexList[g]])]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   Normal @ Coboundary[g, cochain]}]
```

## Scope

In degree 1 the coboundary lives on the triangles. The 1-cochain that is 1 on one edge at the centre has coboundary ±1 on the two triangles at that edge, drawn blue where it is positive on the counterclockwise order of the corners and red where it is negative: the edge runs counterclockwise round one triangle and clockwise round the other.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {cochain = Coboundary[g, <|Sort[{center, First @ AdjacencyList[g, center]}] -> 1|>]},
  {Show[Graphics[KeyValueMap[
     {triangle, value} |-> {
       If[value Det[Differences[Lookup[positions, triangle]]] > 0, StandardBlue, StandardRed],
       Polygon[Lookup[positions, triangle]]},
     cochain]], g],
   Normal[cochain]}]
```

## Possible Issues

A vertex function keyed by the vertices themselves is no cochain, since a vertex name may be a list: the call stays unevaluated, with no message. Keyed by one-vertex lists it has 150 values.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = AssociationMap[GraphDistance[g, First @ GraphCenter[g], #] &, VertexList[g]]},
  {InfraSubstrateHighlight[g, values], Head @ Coboundary[g, values], Length @ Coboundary[g, KeyMap[List, values]]}]
```
