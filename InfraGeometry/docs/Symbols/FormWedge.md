---
Template: Symbol
Name: FormWedge
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FormWedge
Keywords: [wedge product, exterior product, differential form, germ, Leibniz rule, area form]
SeeAlso: [FormDifferential, ZeroForm, FormValue, IntegrationMap, RestrictionMap, CochainCup]
RelatedGuides: [Experimental]
---

## Usage

<code>[FormWedge]()[*ω*, *η*]</code> gives the wedge product *ω ∧ η* of the forms *ω* and *η*, the exterior product of their germs at every vertex.

## Details & Options

Definition: for a *p*-form *ω* and a *q*-form *η*, with *n* = *p* + *q*, *(ω ∧ η)(v; w₁, …, wₙ) = Σ sgn(σ) ω(v; wσ(1), …, wσ(p)) η(v; wσ(p+1), …, wσ(n))*, the sum over the shuffles *σ*, the permutations that keep the first *p* and the last *q* places in order. For two 1-forms *(ω ∧ η)(v; w₁, w₂) = ω(v; w₁) η(v; w₂) − ω(v; w₂) η(v; w₁)*.

On 0-forms it is the product of functions, and a 0-form times a *k*-form multiplies the germ at each vertex by the value there.

It is associative and graded-commutative, *η ∧ ω = (−1)^(pq) ω ∧ η*: at each vertex it is the exterior product of the alternating functions of the steps from the vertex. In particular *ω ∧ ω = 0* for a 1-form.

The differential is not a derivation for it. On 0-forms *d(f ∧ g) − df ∧ g − f ∧ dg = df ⊙ dg*, the product of the two gradients step by step, *(f(w) − f(v))(g(w) − g(v))*; it is of second order in the increments and has no smooth counterpart.

[IntegrationMap]() does not carry it to the cup product: for cochains *α*, *β* of degrees *p*, *q*, *I(Rα ∧ Rβ) = ((p + q)!/(p! q!)) α ∪ β* on every graph tried ([CochainCup]()), a factor 2 for two 1-cochains.

The product keeps the vertices at which both forms have a germ.

## Basic Examples

The wedge of the gradients of the two coordinates of the square tiling. At a vertex *v* its value on two neighbours *w₁*, *w₂* is the determinant of *w₁ − v* and *w₂ − v*, twice the signed area of the triangle *v w₁ w₂*: ±2 on two perpendicular steps, 0 on two opposite ones. The germ at the centre, as a matrix over the ordered pairs of neighbours, beside its integral: the square tiling has no triangles, so every 2-cochain on it is 0, while the 2-form is not.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]], center = First @ GraphCenter[g]},
  {wedge = FormWedge[FormDifferential[g, ZeroForm[g, positions[[All, 1]]]], FormDifferential[g, ZeroForm[g, positions[[All, 2]]]]]},
  {MatrixPlot[Table[FormValue[wedge, center, {nbr, neighbour}], {nbr, AdjacencyList[g, center]}, {neighbour, AdjacencyList[g, center]}]],
   Normal @ IntegrationMap[g, wedge]}]
```

On the triangulated mesh of a square the integral of the same 2-form is twice the cup of the coboundaries of the coordinates, which is the signed area of each triangle: the factor (*p* + *q*)!/(*p*! *q*!) = 2.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {positions = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {xCoordinate = positions[[All, 1]], yCoordinate = positions[[All, 2]]},
  {integral = IntegrationMap[g, FormWedge[FormDifferential[g, ZeroForm[g, xCoordinate]], FormDifferential[g, ZeroForm[g, yCoordinate]]]],
   cup = CochainCup[g, Coboundary[g, KeyMap[List, xCoordinate]], Coboundary[g, KeyMap[List, yCoordinate]]]},
  {ListPlot[Transpose[{Values[cup], Lookup[integral, Keys[cup], 0]}], AxesLabel -> {"δx ∪ δy", "I(dx ∧ dy)"}],
   MinMax[Lookup[integral, Keys[cup], 0] / Values[cup]]}]
```

## Properties and Relations

The wedge is graded-commutative. For the gradients of the distances from the centre of the triangular tiling and from a vertex three steps away, exchanging the factors changes the sign, and the wedge of a gradient with itself is 0. The germ of their wedge at the centre is drawn as a matrix over the ordered pairs of neighbours.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = First @ GraphCenter[g]},
  {apex = (SeedRandom[1]; FindInfraPoint[g, InfraShell[center, 3]])},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, center, #] &]],
   otherGradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, apex, #] &]]},
  {MatrixPlot[Table[
     FormValue[FormWedge[gradient, otherGradient], center, {nbr, neighbour}],
     {nbr, AdjacencyList[g, center]}, {neighbour, AdjacencyList[g, center]}]],
   KeySort[KeySort /@ FormWedge[otherGradient, gradient]] === KeySort[KeySort /@ -FormWedge[gradient, otherGradient]],
   Union[Length /@ Values[FormWedge[gradient, gradient]]]}]
```

The differential fails the Leibniz rule. For the distance *f* from the centre, *d(f ∧ f) − 2 f ∧ df* is the square of the gradient: 1 on every step between two shells, in both directions.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {form = ZeroForm[g, GraphDistance[g, First @ GraphCenter[g], #] &]},
  {gradient = FormDifferential[g, form]},
  {leibniz = DeleteCases[Merge[{FormDifferential[g, FormWedge[form, form]], -2 FormWedge[form, gradient]}, Merge[#, Total] &], 0, {2}]},
  {DisplacementPlot[g, Map[Catenate @* Keys @* Select[Positive], leibniz]], KeySort[KeySort /@ leibniz] === KeySort[KeySort /@ gradient^2]}]
```
