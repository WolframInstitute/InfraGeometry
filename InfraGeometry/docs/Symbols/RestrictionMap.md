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

<code>[RestrictionMap]()[*g*, *α*]</code> gives the form *Rα* of the alternating *k*-cochain *α*, whose germ at *v* is *α* with *v* put in front: *(Rα)(v; w₁, …, wₖ) = α(v, w₁, …, wₖ)*.

## Details & Options

*R* maps the *k*-cochains to the *k*-forms. *Rα* vanishes on every tuple of neighbours that does not span a clique with *v*, and a vertex on no clique where *α* has a value gets no germ.

[IntegrationMap]() is a left inverse: *I(Rα) = α* in every degree, so *R* is injective. In degree 1 the image is the forms antisymmetric across every edge, *ω(v; w) = −ω(w; v)*.

In degree 0 a cochain and its form carry the same values. The restriction of a coboundary is the gradient: *(R δf)(v; w) = f(w) − f(v)*, the [FormDifferential]() of the [ZeroForm]() of *f*.

On the square grid there are no triangles, so no 2-cochains and no 2-forms; on the square mesh there are 154 triangles.

## Basic Examples

The 2-cochain that is 1 on one triangle at the centre of the mesh. Its form has a germ at each corner, on the other two corners, with the sign of putting the corner in front:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {t = Sort @ First @ Select[FindClique[g, {3}, All], MemberQ[c]]}, {form = RestrictionMap[g, <|t -> 1|>]},
  InfraSubstrateHighlight[g, {t}, PlotLabel -> (FormValue[form, #, DeleteCases[t, #]] & /@ t),
    ImageSize -> Medium]]
```

The restriction of the coboundary of the distance from the centre is the gradient of the distance:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {f = AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]},
    KeySort[KeySort /@ RestrictionMap[g, Coboundary[g, f]]] ==
      KeySort[KeySort /@ FormDifferential[g, ZeroForm[g, GraphDistance[g, c, #] &]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

[IntegrationMap]() undoes the restriction, for random 1- and 2-cochains on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {edges = Sort /@ List @@@ EdgeList[g], triangles = Sort /@ FindClique[g, {3}, All]},
  {a1 = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 1]],
   a2 = AssociationThread[triangles,
     BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[triangles]], RandomSeeding -> 2]]},
  Table[KeySort[IntegrationMap[g, RestrictionMap[g, a]]] == KeySort[a], {a, {a1, a2}}]]
```

In degree 1 the form of a cochain is antisymmetric across every edge:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {edges = Sort /@ List @@@ EdgeList[g]},
  {a = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 1]]},
  {form = RestrictionMap[g, a]},
  AllTrue[edges, FormValue[form, #[[1]], {#[[2]]}] == -FormValue[form, #[[2]], {#[[1]]}] &]]
```

## Possible Issues

The cochain is not checked against the graph. The square grid has no triangles, yet a value on three of its vertices gives germs:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {t = Take[VertexList[g], 3]},
  {Length @ FindClique[g, {3}, All], Normal /@ RestrictionMap[g, <|t -> 1|>]}]
```
