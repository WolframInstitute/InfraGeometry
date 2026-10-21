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

For a *p*-form *ω* and a *q*-form *η*, with *n* = *p* + *q*, *(ω ∧ η)(v; w₁, …, wₙ)* is the sum of *sgn(σ) ω(v; wσ₍₁₎, …, wσ₍ₚ₎) η(v; wσ₍ₚ₊₁₎, …, wσ₍ₙ₎)* over the shuffles *σ*, the permutations that keep the first *p* and the last *q* places in order. For two 1-forms, *(ω ∧ η)(v; w₁, w₂) = ω(v; w₁) η(v; w₂) − ω(v; w₂) η(v; w₁)*.

On 0-forms it is the product of functions, and a 0-form times a *k*-form multiplies the germ at each vertex by the value there.

The product is associative and graded-commutative, *η ∧ ω = ω ∧ η* with a minus sign when *p* and *q* are both odd. So *ω ∧ ω = 0* for a 1-form.

The differential is not a derivation for it: on 0-forms *d(f ∧ h) − df ∧ h − f ∧ dh* is the step-by-step product *(f(w) − f(v))(h(w) − h(v))* of the gradients.

On the square grid *(dx ∧ dy)(v; w₁, w₂)* is the determinant of the steps *w₁ − v* and *w₂ − v*, ±1 or 0. The grid has no triangles, so the integral of every 2-form is 0. On the square mesh the integral of *dx ∧ dy* is *2 δx ∪ δy* ([CochainCup]()), twice the signed area of each triangle.

The product has a germ at the vertices where both factors have one.

## Basic Examples

The germ of *dx ∧ dy* at the centre of the grid, over the ordered pairs of its four neighbours, and the integral of the 2-form, which is 0:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]],
   y = ZeroForm[g, AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]]},
  {wedge = FormWedge[FormDifferential[g, x], FormDifferential[g, y]]},
  {MatrixForm @ Table[FormValue[wedge, c, {u, w}], {u, AdjacencyList[g, c]}, {w, AdjacencyList[g, c]}],
   IntegrationMap[g, wedge]}]
```

On the mesh the integral of *dx ∧ dy* is twice the cup *δx ∪ δy* on every triangle:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {x = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]],
   y = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]},
  {integral = IntegrationMap[g, FormWedge[FormDifferential[g, ZeroForm[g, x]], FormDifferential[g, ZeroForm[g, y]]]],
   cup = CochainCup[g, Coboundary[g, KeyMap[List, x]], Coboundary[g, KeyMap[List, y]]]},
  {Length[cup], Max @ Abs[Lookup[integral, Keys[cup]] - 2 Values[cup]] < 10^-12}]
```

## Properties and Relations

The wedge is graded-commutative. For the gradients of the distances from the centre and from a vertex at distance 4 on the mesh, exchanging the factors changes the sign, and the wedge of a gradient with itself is 0:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]},
  {df = FormDifferential[g, ZeroForm[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]],
   dh = FormDifferential[g, ZeroForm[g, AssociationThread[VertexList[g], GraphDistance[g, b]]]]},
  {KeySort /@ FormWedge[dh, df] == KeySort /@ -FormWedge[df, dh], Union @ Values @ FormWedge[df, df]}]
```

The differential fails the Leibniz rule. For the distance *f* from the centre of the grid, *d(f ∧ f) − 2 f ∧ df* is the square of the gradient, 1 on every step:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {f = ZeroForm[g, AssociationThread[VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]]},
  {df = FormDifferential[g, f]},
  {defect = Merge[{FormDifferential[g, FormWedge[f, f]], -2 FormWedge[f, df]}, Merge[#, Total] &]},
  {Union @ Flatten[Values /@ Values[defect]], KeySort /@ defect == KeySort /@ df^2}]
```
