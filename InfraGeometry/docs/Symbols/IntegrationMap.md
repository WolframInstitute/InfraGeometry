---
Template: Symbol
Name: IntegrationMap
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/IntegrationMap
Keywords: [integration map, differential form, cochain, Stokes theorem, chain map, clique complex]
SeeAlso: [RestrictionMap, FormDifferential, Coboundary, NaiveDifferential, FormWedge, CochainCup]
RelatedGuides: [Experimental]
---

## Usage

<code>[IntegrationMap]()[*g*, *ω*]</code> gives the alternating cochain *Iω* of the *k*-form *ω*: on each (*k* + 1)-clique of *g*, the mean over its vertices of the germ at the vertex on the others, with the sign of its position.

## Details & Options

Definition: *(Iω)(v₀, …, vₖ) = (1/(k + 1)) Σᵢ (−1)ⁱ ω(vᵢ; v₀, …, v̂ᵢ, …, vₖ)*, the sum over the positions *i* = 0, …, *k*. It maps the *k*-forms to the *k*-cochains.

On a 1-form it is the antisymmetric part across each edge, *(Iω)(u, v) = (ω(u; v) − ω(v; u))/2*. On a 0-form it is the 0-cochain of the same values.

*I(Rα) = α* for every cochain *α* and in every degree, [RestrictionMap]() being *R*: moving *vᵢ* to the front of *(v₀, …, vₖ)* costs (−1)ⁱ, so each term of the mean is *α(v₀, …, vₖ)*. So *I* is onto. From degree 1 on, *R(Iω)* is not *ω* in general: *I* reads a germ only on the tuples that span a clique with its vertex. On 1-forms *R(Iω)* is the antisymmetrisation of *ω* across each edge, the orthogonal projection onto the image of *R*.

*I* is a chain map, *I(dω) = δ(Iω)*, the discrete Stokes theorem of [FormDifferential](); for the naive differential the integral is (*k* + 1)/(*k* + 2) of *δ(Iω)* ([NaiveDifferential]()). It is not a ring map: for cochains *α*, *β* of degrees *p*, *q*, *I(Rα ∧ Rβ) = ((p + q)!/(p! q!)) α ∪ β* on every graph tried ([FormWedge](), [CochainCup]()).

A value 0 is not stored in the cochain.

## Basic Examples

The gradient of the distance from the centre of the triangular tiling integrates to the coboundary of the distance: on each step from one shell to the next, (1 − (−1))/2 = 1. The cochain is drawn by an arc along each edge in the direction in which it is positive.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {cochain = IntegrationMap[g, FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]]},
  {DisplacementPlot[g, GroupBy[Join[Keys @ Select[cochain, Positive], Reverse /@ Keys @ Select[cochain, Negative]], First -> Last]],
   KeySort[cochain] === KeySort[Coboundary[g, AssociationMap[GraphDistance[g, center, First[#]] &, List /@ VertexList[g]]]]}]
```

A random 1-form, left, and the restriction of its integral, right, each drawn by an arc from *v* to *w* where the germ at *v* is positive on the step to *w*, blue, or negative, orange. The integral keeps the antisymmetric part across each edge; the restriction back to the forms keeps about half of the energy, the sum of the squares of the germ values.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {form = (SeedRandom[1]; AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
  {projected = RestrictionMap[g, IntegrationMap[g, form]]},
  {GraphicsRow[{
     DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], form], Map[Catenate @* Keys @* Select[Negative], form]}],
     DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], projected], Map[Catenate @* Keys @* Select[Negative], projected]}]}],
   N[Total[Catenate[Values /@ Values[projected]]^2] / Total[Catenate[Values /@ Values[form]]^2]]}]
```

## Properties and Relations

*I(Rα) = α*: a random 1-cochain with values ±1 and ±2 against the integral of its restriction, edge by edge, on the diagonal.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  {cochain = (SeedRandom[1]; AssociationMap[RandomChoice[{-2, -1, 1, 2}] &, Sort /@ List @@@ EdgeList[g]])},
  {integral = IntegrationMap[g, RestrictionMap[g, cochain]]},
  ListPlot[Transpose[{Values[cochain], Lookup[integral, Keys[cochain], 0]}], AxesLabel -> {"α", "I(Rα)"}]]
```

The energy that the restriction of the integral keeps, over 100 random 1-forms on the triangular tiling, concentrates near 1/2: on an edge with germ values *a* and *b* it keeps (*a* − *b*)²/2 of *a*² + *b*².

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  Histogram[Table[
    With[
      {form = (SeedRandom[seedNumber];
        AssociationMap[node |-> AssociationMap[RandomInteger[{-4, 4}] &, List /@ AdjacencyList[g, node]], VertexList[g]])},
      N[Total[Catenate[Values /@ Values[RestrictionMap[g, IntegrationMap[g, form]]]]^2] / Total[Catenate[Values /@ Values[form]]^2]]],
    {seedNumber, 100}]]]
```
