---
Template: Symbol
Name: FormDifferential
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FormDifferential
Keywords: [exterior derivative, differential form, gradient, transport term, Stokes theorem, discrete calculus]
SeeAlso: [NaiveDifferential, IntegrationMap, Coboundary, ZeroForm, FormWedge, FormValue]
RelatedGuides: [Experimental]
---

## Usage

<code>[FormDifferential]()[*g*, *f*]</code> gives the gradient *df* of the 0-form *f*, *(df)(v; w) = f(w) − f(v)* on the step from *v* to each neighbour *w*.

<code>[FormDifferential]()[*g*, *ω*]</code> gives the differential *dω* of the 1-form *ω*, *(dω)(v; w₁, w₂) = ω(v; w₁) − ω(v; w₂) + (ω(w₁; w₂) − ω(w₂; w₁))/2*.

## Details & Options

The differential is the coboundary read on the tuple *(v, w₁, …, wₖ₊₁)*: the faces through *v* are read from the germ at *v*, and the one face that misses *v* is read by integration over its vertices ([IntegrationMap]()).

The last term of *dω* is the transport term, the one place where the germ at *v* meets the germs at its neighbours. It is 0 unless *w₁* and *w₂* are adjacent. [NaiveDifferential]() drops it.

Stokes: *I(dω) = δ(Iω)*, with *I* the [IntegrationMap]() and *δ* the [Coboundary](). Without the transport term the left side is *(2/3) δ(Iω)*.

*d(df) ≠ 0*: *(d(df))(v; w₁, w₂)* is 0 when *w₁* and *w₂* are adjacent and *f(w₁) − f(w₂)* when they are not. On the square grid no two neighbours of a vertex are adjacent.

Only degrees 0 and 1 are computed: on a form of degree 2 the call stays unevaluated.

## Basic Examples

Stokes in degree 0: the integral of the gradient of the distance from the centre is the coboundary of the distance:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {f = AssociationThread[VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
    KeySort @ IntegrationMap[g, FormDifferential[g, ZeroForm[g, f]]] ==
      KeySort @ Coboundary[g, KeyMap[List, f]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The differential of a gradient is not 0. The vertices where *d(dx)* has a germ, for the coordinate *x*: on the grid every vertex of degree at least 2, on the mesh 86 of the 102 vertices:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {x = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]]},
    {ddx = FormDifferential[g, FormDifferential[g, x]]},
    {support = Keys @ Select[ddx, # =!= <||> &]},
    InfraSubstrateHighlight[g, {support}, PlotLabel -> Length[support]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The germ of *d(df)* at *v* is 0 on adjacent neighbours and *f(w₁) − f(w₂)* on the others. The coordinate *x* at the centre of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]},
  {ddx = FormDifferential[g, FormDifferential[g, ZeroForm[g, x]]]},
  AllTrue[Subsets[AdjacencyList[g, c], {2}],
    FormValue[ddx, c, #] == If[EdgeQ[g, UndirectedEdge @@ #], 0, x[First[#]] - x[Last[#]]] &]]
```

Stokes in degree 1, for a random 1-form on the mesh, and the factor 2/3 lost without the transport term:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {w = BlockRandom[
     AssociationMap[v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]], VertexList[g]],
     RandomSeeding -> 1]},
  {exact = KeySort @ Coboundary[g, IntegrationMap[g, w]]},
  {KeySort @ IntegrationMap[g, FormDifferential[g, w]] == exact,
   KeySort @ IntegrationMap[g, NaiveDifferential[g, w]] == 2/3 exact}]
```

## Possible Issues

The differential of a 2-form is not computed, and the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {x = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]]},
  {ddx = FormDifferential[g, FormDifferential[g, x]]},
  {FormDegree[ddx], Head @ FormDifferential[g, ddx]}]
```
