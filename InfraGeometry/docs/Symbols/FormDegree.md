---
Template: Symbol
Name: FormDegree
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FormDegree
Keywords: [differential form, degree, germ, k-form]
SeeAlso: [FormValue, ZeroForm, FormDifferential, FormWedge, CochainDegree]
RelatedGuides: [Experimental]
---

## Usage

<code>[FormDegree]()[*ω*]</code> gives the degree *k* of the form *ω*, the length of the tuples on which its germs are stored.

## Details & Options

Definition: a *k*-form takes its germs on the *k*-tuples of neighbours of each vertex, and *k* is its degree.

The degree is read off the first germ that holds a value. A form whose germs hold tuples of different lengths is not a form of one degree.

[ZeroForm]() gives degree 0, [FormDifferential]() raises the degree by one, [FormWedge]() adds the degrees, and [RestrictionMap]() and [IntegrationMap]() keep the degree ([CochainDegree]()).

## Basic Examples

A 0-form, its gradient and the wedge of two gradients on the triangular tiling, of degrees 0, 1 and 2. The 0-form is the distance from the centre, drawn by its values; the 1-form is drawn by its steps, blue where it is positive and orange where it is negative; the 2-form by its germ at the centre, a matrix over the pairs of neighbours.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g]},
  {apex = (SeedRandom[1]; RandomInfraPoint[g, center, 3]), form = ZeroForm[g, GraphDistance[g, center, #] &]},
  {gradient = FormDifferential[g, form]},
  {twoForm = FormWedge[gradient, FormDifferential[g, ZeroForm[g, GraphDistance[g, apex, #] &]]]},
  {GraphicsRow[{
     InfraSubstrateHighlight[g, First /@ form],
     DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], gradient], Map[Catenate @* Keys @* Select[Negative], gradient]}],
     MatrixPlot[Table[FormValue[twoForm, center, {nbr, neighbour}], {nbr, AdjacencyList[g, center]}, {neighbour, AdjacencyList[g, center]}]]}],
   FormDegree /@ {form, gradient, twoForm}}]
```

## Possible Issues

The zero form has no degree to read: every germ of the gradient of a constant is empty. [FormDegree]() then issues messages and returns 1; the call is wrapped in [Quiet]() here.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {gradient = FormDifferential[g, ZeroForm[g, 1 &]]},
  {InfraSubstrateHighlight[g, AssociationMap[1 &, VertexList[g]]], Union[Length /@ Values[gradient]], Quiet @ FormDegree[gradient]}]
```
