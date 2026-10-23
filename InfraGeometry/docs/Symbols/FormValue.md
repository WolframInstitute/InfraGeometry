---
Template: Symbol
Name: FormValue
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FormValue
Keywords: [differential form, germ, alternating, tangent vector, covector, step, neighbour tuple]
SeeAlso: [ZeroForm, FormDegree, FormDifferential, FormWedge, CochainValue, RestrictionMap]
RelatedGuides: [Experimental]
---

## Usage

<code>[FormValue]()[*ω*, *v*, {*w₁*, …, *wₖ*}]</code> gives *ω(v; w₁, …, wₖ)*, the value of the germ of the *k*-form *ω* at the vertex *v* on a tuple of neighbours of *v*.

## Details & Options

A *k*-form assigns to every vertex *v* a germ: an alternating function of the *k*-tuples of distinct neighbours of *v*, *ω(v; wσ₍₁₎, …, wσ₍ₖ₎) = sgn(σ) ω(v; w₁, …, wₖ)*.

A step from *v* to a neighbour *w* is a tangent vector at *v*. A 1-form germ is a function of the steps, *ω(v; w)* its value on the step to *w*. A 0-form is read on the empty tuple {}.

A form is stored as `<|v -> <|{w1, …, wk} -> value, …|>, …|>` on the sorted tuples. The value on any tuple is the stored value on the sorted tuple times the sign of the sorting permutation.

The value is 0 on a tuple with a repeated vertex, on a vertex that is not a neighbour, on a tuple whose stored value is 0 and on a tuple of another length than the degree.

The tuple need not span a clique. On the square grid no two neighbours of a vertex are adjacent, so every 2-cochain is 0 while a 2-form need not be. This is what separates forms from cochains ([CochainValue]()).

## Basic Examples

The gradient of the distance from the centre at a vertex *v* at distance 2, as a density on the neighbours of *v*: a dot on a step outward, value 1, a ring on a step inward, value −1. On the mesh a step inside the shell has value 0 and is not drawn:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {df = FormDifferential[g, ZeroForm[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]],
     v = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {c, v, AssociationMap[FormValue[df, v, {#}] &, AdjacencyList[g, v]]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A tuple is read in any order, with the sign of its sorting permutation. The germ of *dx ∧ dy* at the centre of the grid, over the ordered pairs of the four neighbours: the determinant of the two steps, ±1 on perpendicular steps and 0 on opposite ones:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {wedge = FormWedge[FormDifferential[g, x], FormDifferential[g, y]]},
  MatrixForm @ Table[FormValue[wedge, c, {u, w}], {u, AdjacencyList[g, c]}, {w, AdjacencyList[g, c]}]]
```

A tuple of another length than the degree gives 0. The gradient, a 1-form, on one neighbour and on two:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {df = FormDifferential[g, ZeroForm[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]]},
  {FormValue[df, c, Take[AdjacencyList[g, c], 1]], FormValue[df, c, Take[AdjacencyList[g, c], 2]]}]
```

## Properties and Relations

The value of the gradient *df* on the step from *v* to *w* is *f(w) − f(v)*. The coordinate *x* on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {x = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]},
  {dx = FormDifferential[g, ZeroForm[g, x]]},
  AllTrue[EdgeList[g], FormValue[dx, First[#], {Last[#]}] == x[Last[#]] - x[First[#]] &]]
```
