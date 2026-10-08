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

<code>[FormValue]()[*ω*, *v*, {*w*₁, …, *w*ₖ}]</code> gives *ω(v; w₁, …, wₖ)*, the value of the germ of the *k*-form *ω* at the vertex *v* on a tuple of neighbours of *v*.

## Details & Options

Definition: a *k*-form *ω* assigns to every vertex *v* an alternating function on the *k*-tuples of distinct neighbours of *v*, *ω(v; wσ(1), …, wσ(k)) = sgn(σ) ω(v; w₁, …, wₖ)* for every permutation *σ*.

A germ is stored on the sorted tuples, `<|v -> <|{w1, ..., wk} -> value|>|>`. [FormValue]() sorts the tuple, as [Sort]() orders the vertex names, and multiplies the stored value by the sign of the sorting permutation. A tuple with a repeated vertex gives 0, and so does a tuple that is not stored, of any length: a value 0 is not stored, and a vertex that is not a neighbour of *v* carries no value. A form is read as an element of the whole exterior algebra, whose components of every other degree are 0.

The tuple need not span a clique. From degree 2 on, a germ also takes values on tuples of neighbours that span no clique, where every cochain vanishes; that is what separates the forms from the cochains read by [CochainValue]().

At scale 1 a tangent vector at *v* is a step from *v* to a neighbour *w*. A 1-form germ is a linear function of the steps from *v*: *ω(v; w)* is its value on the step to *w*. For a 0-form the tuple is {}.

## Basic Examples

The gradient of the distance from the centre of the triangular tiling, at the centre: 1 on the step to every neighbour.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]},
  {DisplacementPlot[g, <|center -> AdjacencyList[g, center]|>], FormValue[gradient, center, {#}] & /@ AdjacencyList[g, center]}]
```

At a neighbour of the centre the gradient is −1 on the step back to the centre, an orange arc, 0 on the two steps inside its shell, and 1 on the three steps outward, blue arcs.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]},
  {node = First @ AdjacencyList[g, center]},
  {DisplacementPlot[g, {
     <|node -> Select[AdjacencyList[g, node], FormValue[gradient, node, {#}] > 0 &]|>,
     <|node -> Select[AdjacencyList[g, node], FormValue[gradient, node, {#}] < 0 &]|>}],
   Normal @ AssociationMap[FormValue[gradient, node, {#}] &, AdjacencyList[g, node]]}]
```

## Scope

A tuple is read in any order, with the sign of its sorting permutation. The germ at the centre of a 2-form, the wedge of the gradients of the distances from the centre and from a vertex three steps away, as a matrix over the ordered pairs of neighbours of the centre: it is antisymmetric, and its diagonal, the pairs with a repeated vertex, is 0.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {apex = (SeedRandom[1]; FindInfraPoint[g, InfraShell[center, 3]])},
  {twoForm = FormWedge[
     FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]],
     FormDifferential[g, ZeroForm[g, GraphDistance[g, apex, #] &]]]},
  {matrix = Table[FormValue[twoForm, center, {nbr, neighbour}], {nbr, AdjacencyList[g, center]}, {neighbour, AdjacencyList[g, center]}]},
  {MatrixPlot[matrix], matrix == -Transpose[matrix]}]
```

The length of the tuple is not checked, and a tuple of another length than the degree gives 0, the value of the component of that degree. The gradient of the distance, a 1-form, read on one neighbour and on a pair of neighbours.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]]},
  {DisplacementPlot[g, <|center -> Take[AdjacencyList[g, center], 2]|>],
   {FormValue[gradient, center, Take[AdjacencyList[g, center], 1]], FormValue[gradient, center, Take[AdjacencyList[g, center], 2]]}}]
```
