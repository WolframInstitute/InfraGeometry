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

<code>[NaiveDifferential]()[*g*, *ω*]</code> gives the naive differential *d₀ω* of the 1-form *ω*: *(d₀ω)(v; w₁, w₂) = ω(v; w₁) − ω(v; w₂)* on each pair of neighbours of *v*.

## Details & Options

*d₀ω* is the [FormDifferential]() *dω* without its transport term *(ω(w₁; w₂) − ω(w₂; w₁))/2*: it reads the germ at *v* only.

The transport term is 0 unless *w₁* and *w₂* are adjacent. On the square grid no two neighbours of a vertex are adjacent, and *d₀ω = dω*. On the square mesh they differ across the triangles.

Integrating loses a third: *I(d₀ω) = (2/3) δ(Iω)*, with *I* the [IntegrationMap]() and *δ* the [Coboundary](), while *I(dω) = δ(Iω)*. Of the three edges of a triangle, the germ at a corner reaches only the two at that corner. The germ values of *d₀ω* and *dω* are not proportional; only their integrals are.

Only 1-forms are taken. On a form of another degree the call stays unevaluated.

## Basic Examples

The naive differential of a random 1-form against the differential. They agree on the square grid; on the square mesh they differ at the vertices drawn:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
    {w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> 1]},
    {naive = NaiveDifferential[g, w], exact = FormDifferential[g, w]},
    {differ = Select[VertexList[g], KeySort[naive[#]] =!= KeySort[exact[#]] &]},
    InfraSubstrateHighlight[g, {differ}, PlotLabel -> Length[differ]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the mesh the integral of the naive differential against the coboundary of the integral, triangle by triangle: a line of slope 2/3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
  {w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> 1]},
  {naive = IntegrationMap[g, NaiveDifferential[g, w]], exact = Coboundary[g, IntegrationMap[g, w]]},
  ListPlot[Transpose[{Values[exact], Lookup[naive, Keys[exact], 0]}], AspectRatio -> 1,
    PlotLabel -> Union[Lookup[naive, Keys[exact], 0] / Values[exact]]]]
```

## Properties and Relations

The germ values themselves are not proportional: *d₀ω* against *dω* over every pair of neighbours of every vertex of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
  {w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> 1]},
  {naive = NaiveDifferential[g, w], exact = FormDifferential[g, w]},
  ListPlot[Catenate @ Table[{FormValue[naive, v, pair], FormValue[exact, v, pair]},
    {v, VertexList[g]}, {pair, Subsets[Sort @ AdjacencyList[g, v], {2}]}], AspectRatio -> 1]]
```

## Possible Issues

On a 0-form the call stays unevaluated:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  Head @ NaiveDifferential[g, ZeroForm[g, GraphDistance[g, First @ GraphCenter[g], #] &]]]
```
