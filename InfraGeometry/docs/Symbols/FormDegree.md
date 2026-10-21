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

<code>[FormDegree]()[*ω*]</code> gives the degree *k* of the form *ω*, the length of the neighbour tuples on which its germs are stored.

## Details & Options

A *k*-form has at every vertex *v* a germ on the *k*-tuples of neighbours of *v* ([FormValue]()).

The degree is read off a germ that holds a value. The zero form, all of whose germs are empty, has no degree.

| Operation | Degree |
|---|---|
| [ZeroForm]() | 0 |
| [FormDifferential]() | *k* + 1 |
| [FormWedge]() | *p* + *q* |
| [IntegrationMap](), [RestrictionMap]() | *k* |

## Basic Examples

A 0-form, its gradient and a wedge of two gradients on the square grid. The grid has no triangles, yet the 2-form *dx ∧ dy* is not 0:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {x = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  FormDegree /@ {x, FormDifferential[g, x], FormWedge[FormDifferential[g, x], FormDifferential[g, y]]}]
```

## Possible Issues

The zero form has no degree, and the call stays unevaluated. Every germ of the gradient of a constant is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {df = FormDifferential[g, ZeroForm[g, 1 &]]},
  {Union @ Values[df], Head @ FormDegree[df]}]
```
