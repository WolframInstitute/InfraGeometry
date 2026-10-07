---
Template: Symbol
Name: NaiveDifferential
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/NaiveDifferential
Keywords: [naive differential, differential form, transport term, Stokes theorem, discrete calculus]
SeeAlso: [FormDifferential, IntegrationMap, Coboundary, FormValue]
RelatedGuides: [Experimental]
---

## Usage

<code>[NaiveDifferential]()[*g*, *ω*]</code> gives the naive differential of the 1-form *ω*, the difference of germ values *ω(v; w₁) − ω(v; w₂)* on each pair of neighbours of *v*: the form differential with its transport term dropped.

## Details & Options

Definition: the naive differential of a 1-form is *(d₀ω)(v; w₁, w₂) = ω(v; w₁) − ω(v; w₂)*. In degree *k* it is the sum *Σᵢ (−1)ⁱ ω(v; w₁, …, ŵᵢ, …, wₖ₊₁)* of [FormDifferential]() without its transport term *(Iω)(w₁, …, wₖ₊₁)*: it reads only the germ at *v*.

Integrating it loses a fixed fraction: *I(d₀ω) = ((k + 1)/(k + 2)) δ(Iω)*, two thirds in degree 1, where *I* is [IntegrationMap]() and *δ* is [Coboundary](). Of the *k* + 2 faces of a (*k* + 1)-clique, the germ at a vertex reaches only the *k* + 1 that contain the vertex.

The transport term is not a multiple of the naive difference: the germ values of *dω* and *d₀ω* are not proportional, and only their integrals differ by a factor.

It is kept for the comparison with [FormDifferential]().

## Basic Examples

On a random 1-form on the triangular tiling, the integral of the naive differential against the coboundary of the integral, triangle by triangle: a line of slope 2/3.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  {form = (SeedRandom[1]; AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
  {naive = IntegrationMap[g, NaiveDifferential[g, form]], exact = Coboundary[g, IntegrationMap[g, form]]},
  {ListPlot[Transpose[{Values[exact], Lookup[naive, Keys[exact], 0]}], AxesLabel -> {"δ(Iω)", "I(d₀ω)"}],
   Union[Lookup[naive, Keys[exact], 0] / Values[exact]]}]
```

## Properties and Relations

The germ values of the naive differential against those of the differential on the same 1-form, over every pair of neighbours of every vertex: the transport term is not a rescaling.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  {form = (SeedRandom[1]; AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
  {naive = NaiveDifferential[g, form], exact = FormDifferential[g, form]},
  ListPlot[
    Catenate @ Table[
      {FormValue[naive, node, pairOf], FormValue[exact, node, pairOf]},
      {node, VertexList[g]}, {pairOf, Subsets[Sort @ AdjacencyList[g, node], {2}]}],
    AxesLabel -> {"d₀ω", "dω"}]]
```

On a pair of neighbours that are not adjacent the transport term vanishes, and the two differentials agree there: on the square tiling, which has no triangles, they are equal.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {form = (SeedRandom[1]; AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
  {DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], form], Map[Catenate @* Keys @* Select[Negative], form]}],
   KeySort[KeySort /@ NaiveDifferential[g, form]] === KeySort[KeySort /@ FormDifferential[g, form]]}]
```

## Possible Issues

On a 0-form the germs come out empty, with no message: [NaiveDifferential]() computes degree 1 only. The naive differential of a 0-form *f* would be *−f(v)* on each step from *v*.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {form = ZeroForm[g, GraphDistance[g, First @ GraphCenter[g], #] &]},
  {InfraSubstrateHighlight[g, First /@ form], Union[Length /@ Values[NaiveDifferential[g, form]]]}]
```
