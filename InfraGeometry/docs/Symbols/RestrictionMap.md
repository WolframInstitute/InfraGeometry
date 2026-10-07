---
Template: Symbol
Name: RestrictionMap
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RestrictionMap
Keywords: [restriction map, cochain, differential form, germ, clique complex]
SeeAlso: [IntegrationMap, CochainValue, FormValue, Coboundary, FormDifferential, ZeroForm]
RelatedGuides: [Experimental]
---

## Usage

<code>[RestrictionMap]()[*g*, *α*]</code> gives the form *Rα* of the alternating *k*-cochain *α*: its germ at the vertex *v* reads *α* with *v* prepended, *(Rα)(v; w₁, …, wₖ) = α(v, w₁, …, wₖ)*.

## Details & Options

Definition: *(Rα)(v; w₁, …, wₖ) = α(v, w₁, …, wₖ)* for every vertex *v* and every *k*-tuple of distinct neighbours of *v*. It maps the *k*-cochains to the *k*-forms.

*Rα* vanishes on every tuple of neighbours that does not span a clique with *v*, since *α* does. A vertex that lies on no clique where *α* has a value gets no germ.

[IntegrationMap]() is a left inverse, *I(Rα) = α* in every degree, so *R* is injective. In degree 1 its image is the forms that are antisymmetric across every edge, *ω(v; w) = −ω(w; v)*.

In degree 0 a cochain and its form carry the same values, and the restriction of the coboundary of a 0-cochain *f* is the gradient of its 0-form: *(Rδf)(v; w) = δf(v, w) = f(w) − f(v)*.

## Basic Examples

The coboundary of the distance from the centre of the triangular tiling, left, drawn by an arc along each edge in the direction in which it is 1, and its restriction, right, drawn by an arc from *v* to *w* where the germ at *v* is positive on the step to *w*, blue, or negative, orange. On each step between two shells the germ at the inner end is 1 towards the outer end, and the germ at the outer end is −1 towards the inner end.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cochain = Coboundary[g, AssociationMap[GraphDistance[g, First @ GraphCenter[g], First[#]] &, List /@ VertexList[g]]]},
  {form = RestrictionMap[g, cochain]},
  GraphicsRow[{
    DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
    DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], form], Map[Catenate @* Keys @* Select[Negative], form]}]}]]
```

The restriction of the 2-cochain that is 1 on one triangle at the centre has a germ at each of its three corners, on the pair of the other two, with the sign of moving the corner to the front.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g], positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {triangle = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[center]]},
  {Show[Graphics[{StandardBlue, Polygon[Lookup[positions, triangle]]}], g], triangle, Normal[Normal /@ RestrictionMap[g, <|triangle -> 1|>]]}]
```

## Properties and Relations

The restriction of the coboundary of a 0-cochain is the gradient of its 0-form, here for the distance from the centre.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {form = RestrictionMap[g, Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]]]},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]},
  {DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], gradient], Map[Catenate @* Keys @* Select[Negative], gradient]}],
   KeySort[KeySort /@ form] === KeySort[KeySort /@ gradient]}]
```

[IntegrationMap]() undoes the restriction: a random 1-cochain with values ±1 and ±2, drawn by an arc along each edge in the direction in which it is positive, comes back from its form unchanged.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cochain = (SeedRandom[1]; AssociationMap[RandomChoice[{-2, -1, 1, 2}] &, Sort /@ List @@@ EdgeList[g]])},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   KeySort[IntegrationMap[g, RestrictionMap[g, cochain]]] === KeySort[cochain]}]
```
