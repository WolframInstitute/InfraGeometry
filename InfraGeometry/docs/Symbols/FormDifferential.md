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

<code>[FormDifferential]()[*g*, *f*]</code> gives the gradient *df* of the 0-form *f*: *(df)(v; w) = f(w) − f(v)* on the step from *v* to each neighbour *w*.

<code>[FormDifferential]()[*g*, *ω*]</code> gives the differential *dω* of the 1-form *ω*: *(dω)(v; w₁, w₂) = ω(v; w₁) − ω(v; w₂) + (ω(w₁; w₂) − ω(w₂; w₁))/2*.

## Details & Options

Definition: in degree *k*, *(dω)(v; w₁, …, wₖ₊₁) = Σᵢ (−1)ⁱ ω(v; w₁, …, ŵᵢ, …, wₖ₊₁) + (Iω)(w₁, …, wₖ₊₁)*, the sum over *i* = 1, …, *k* + 1, where *I* is [IntegrationMap](). It is the coboundary read on the tuple *(v, w₁, …, wₖ₊₁)*: each face through *v* is read from the germ at *v*, and the one face that misses *v* is read by integration.

The last term is the transport term, the one place where the germ at *v* is compared with the germs at its neighbours. It vanishes unless *w₁, …, wₖ₊₁* span a clique. [NaiveDifferential]() drops it.

Stokes: *I(dω) = δ(Iω)* in every degree, *δ* being [Coboundary](). The transport term is forced. With the transport term multiplied by *λ*, the integral of the differential is ((*k* + 1 + *λ*)/(*k* + 2)) *δ(Iω)*, and since the germ values are independent coordinates, comparing their coefficients leaves only *λ* = 1.

*d(dω) ≠ 0*. On the gradient of a 0-form *f*, *(d(df))(v; w₁, w₂)* is 0 when *w₁* and *w₂* are adjacent and *f(w₁) − f(w₂)* when they are not: the square of the differential sees the missing edges.

[FormDifferential]() computes degrees 0 and 1.

## Basic Examples

The gradient of the distance from the centre on the square, the hexagonal and the triangular tiling, drawn by an arc from *v* to *w* where the germ at *v* is positive on the step to *w*, blue, or negative, orange: 1 on every step away from the centre, −1 on every step towards it, 0 on a step inside a shell.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {forms = Table[FormDifferential[substrate, ZeroForm[substrate, GraphDistance[substrate, First @ GraphCenter[substrate], #] &]], {substrate, graphs}]},
  GraphicsRow[MapThread[
    DisplacementPlot[#1, {Map[Catenate @* Keys @* Select[Positive], #2], Map[Catenate @* Keys @* Select[Negative], #2]}] &,
    {graphs, forms}]]]
```

The differential of the gradient is not zero. At a vertex two steps from the centre of the triangular tiling, its germ, as a matrix over the ordered pairs of neighbours, is 0 on the pairs of adjacent neighbours and the difference of their distances from the centre on the others.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {twoForm = FormDifferential[g, FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]],
   node = First @ Select[VertexList[g], GraphDistance[g, center, #] == 2 &]},
  {GraphicsRow[{
     InfraSubstrateHighlight[g, {node, AdjacencyList[g, node]}],
     MatrixPlot[Table[FormValue[twoForm, node, {nbr, neighbour}], {nbr, AdjacencyList[g, node]}, {neighbour, AdjacencyList[g, node]}]]}],
   GraphDistance[g, center, #] & /@ AdjacencyList[g, node]}]
```

## Properties and Relations

Stokes: on a random 1-form on the triangular tiling, the integral of the differential against the coboundary of the integral, triangle by triangle, on the diagonal.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  {form = (SeedRandom[1]; AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
  {lhs = IntegrationMap[g, FormDifferential[g, form]], exact = Coboundary[g, IntegrationMap[g, form]]},
  {ListPlot[Transpose[{Values[exact], Lookup[lhs, Keys[exact], 0]}], AxesLabel -> {"δ(Iω)", "I(dω)"}], KeySort[lhs] === KeySort[exact]}]
```

In degree 0 Stokes says that the gradient integrates to the coboundary.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = AssociationMap[GraphDistance[g, First @ GraphCenter[g], #] &, VertexList[g]]},
  {cochain = IntegrationMap[g, FormDifferential[g, ZeroForm[g, values]]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   KeySort[cochain] === KeySort[Coboundary[g, KeyMap[List, values]]]}]
```

On the square tiling no two neighbours of a vertex are adjacent, so the differential of the gradient of the distance has a germ wherever a vertex has neighbours at two distances: at every vertex but the centre and the 28 vertices of the rim. Beside it, the number of vertices without a germ.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {twoForm = FormDifferential[g, FormDifferential[g, ZeroForm[g, GraphDistance[g, First @ GraphCenter[g], #] &]]]},
  {InfraSubstrateHighlight[g, AssociationThread[Keys @ Select[twoForm, # =!= <||> &], 1]], Count[Values[twoForm], <||>]}]
```

## Possible Issues

On a form of degree 2 or more the germs come out empty, with no message. The differential of the gradient of the distance on the triangular tiling is a 2-form with a germ at the vertices drawn, and its differential is the zero form.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {twoForm = FormDifferential[g, FormDifferential[g, ZeroForm[g, GraphDistance[g, First @ GraphCenter[g], #] &]]]},
  {InfraSubstrateHighlight[g, AssociationThread[Keys @ Select[twoForm, # =!= <||> &], 1]],
   FormDegree[twoForm], Union[Length /@ Values[FormDifferential[g, twoForm]]]}]
```
