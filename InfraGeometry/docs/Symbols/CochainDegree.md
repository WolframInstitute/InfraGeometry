---
Template: Symbol
Name: CochainDegree
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainDegree
Keywords: [cochain, degree, clique complex, simplex]
SeeAlso: [CochainValue, Coboundary, CochainCup, OrderedCochainCup, CochainCupOne, FormDegree]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainDegree]()[*α*]</code> gives the degree *k* of the cochain *α*, one less than the number of vertices of the cliques on which it is stored.

## Details & Options

Definition: a *k*-cochain takes its values on the (*k* + 1)-cliques of a graph, the *k*-simplices of its clique complex, and *k* is its degree.

A *k*-cochain is stored as `<|{v0, ..., vk} -> value|>` on the sorted cliques, and the degree is read off the first key. The empty cochain has no key, and an association keyed by anything but vertex lists is no cochain: [CochainDegree]() stays unevaluated on both.

[Coboundary]() raises the degree by one, [CochainCup]() and [OrderedCochainCup]() add the degrees, [CochainCupOne]() gives one less than their sum, and [IntegrationMap]() and [RestrictionMap]() keep the degree ([FormDegree]()).

## Basic Examples

A 0-cochain, its coboundary and a cup on the triangular tiling, of degrees 0, 1 and 2. The 0-cochain is the distance from the centre, drawn by its values; the 1-cochain is drawn by an arc along each edge in the direction in which it is positive; the 2-cochain, the cup of the coboundaries of the distances from the centre and from a vertex three steps away, is drawn on its triangles, blue where it is positive on the counterclockwise order of the corners and red where it is negative.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[center, 3]]), cochain = AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]},
  {edgeCochain = Coboundary[g, cochain]},
  {triangleCochain = CochainCup[g, edgeCochain, Coboundary[g, AssociationMap[GraphDistance[g, apex, First[#]] &, List /@ VertexList[g]]]]},
  {GraphicsRow[{
     InfraSubstrateHighlight[g, KeyMap[First, cochain]],
     DisplacementPlot[g, GroupBy[Join[Keys @ Select[edgeCochain, Positive], Reverse /@ Keys @ Select[edgeCochain, Negative]], First -> Last]],
     Show[Graphics[KeyValueMap[
       {triangle, value} |-> {
         If[value Det[Differences[Lookup[positions, triangle]]] > 0, StandardBlue, StandardRed],
         Polygon[Lookup[positions, triangle]]},
       triangleCochain]], g]}],
   CochainDegree /@ {cochain, edgeCochain, triangleCochain}}]
```

## Possible Issues

The empty cochain has no key to read. The coboundary of a coboundary is empty, and [CochainDegree]() of it stays unevaluated, with no message. So does a vertex function keyed by the vertices themselves, which is no cochain.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = AssociationMap[GraphDistance[g, First @ GraphCenter[g], #] &, VertexList[g]]},
  {edgeCochain = Coboundary[g, KeyMap[List, values]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[edgeCochain, Positive], Reverse /@ Keys @ Select[edgeCochain, Negative]], First -> Last]],
   Normal @ Coboundary[g, edgeCochain], Head @ CochainDegree[Coboundary[g, edgeCochain]], Head @ CochainDegree[values]}]
```
