---
Template: Symbol
Name: ZeroForm
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ZeroForm
Keywords: [0-form, differential form, vertex function, germ, gradient, clique complex]
SeeAlso: [FormValue, FormDifferential, FormWedge, IntegrationMap, RestrictionMap, FormDegree]
RelatedGuides: [Experimental]
---

## Usage

<code>[ZeroForm]()[*g*, *f*]</code> gives the vertex function *f*, an association or a function, as a 0-form on *g*.

## Details & Options

A *k*-form *ω* on a graph gives every vertex *v* an alternating function *ω(v; w₁, …, wₖ)* of *k* distinct neighbours of *v*, its germ at *v*. For *k = 0* the only argument is the empty tuple, and a 0-form is a function on the vertices: *ω(v; ) = f(v)*.

A form is stored as `<|v -> <|tuple -> value|>|>`, and the 0-form of *f* as `<|v -> <|{} -> f(v)|>|>`. <code>[FormValue]()[*ω*, *v*, {}]</code> reads *f(v)*.

A 0-form and a 0-cochain carry the same values: [IntegrationMap]() gives the 0-cochain `<|{v} -> f(v)|>`, and [RestrictionMap]() gives the 0-form back. The differential of a 0-form is its gradient, *(df)(v; w) = f(w) − f(v)* ([FormDifferential]()), and the wedge of two 0-forms is their product ([FormWedge]()).

An association must give a value at every vertex.

## Basic Examples

The distance from the centre as a 0-form on the square grid and on the square mesh, each vertex drawn by its value:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {f = ZeroForm[g, GraphDistance[g, c, #] &]},
    InfraSubstrateHighlight[g, {AssociationMap[FormValue[f, #, {}] &, VertexList[g]], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The germ at the centre, at a neighbour of the centre and at a farthest vertex:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {f = ZeroForm[g, GraphDistance[g, c, #] &]},
  {f[c], f[First @ AdjacencyList[g, c]], f[First @ MaximalBy[VertexList[g], GraphDistance[g, c, #] &]]}]
```

## Scope

An association as the function. The coordinate *x* of the mesh, and its gradient on the steps from the centre, the differences of *x*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {x = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 1]]]},
  FormDifferential[g, ZeroForm[g, x]][c] == AssociationMap[x[First @ #] - x[c] &, List /@ AdjacencyList[g, c]]]
```

## Properties and Relations

The gradient of the distance from the centre is 1 on each step outward and −1 on each step inward; on a step inside a shell it is 0 and not stored. On the mesh 173 of the 255 edges join two shells:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Counts @ Catenate[Values /@ Values @ FormDifferential[g, ZeroForm[g, GraphDistance[g, c, #] &]]]]
```

A 0-form and a 0-cochain carry the same values. The value 0 at the centre is not stored in the cochain:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {f = ZeroForm[g, GraphDistance[g, c, #] &]}, {cochain = IntegrationMap[g, f]},
  {KeySort[cochain] == KeySort @ DeleteCases[AssociationThread[List /@ VertexList[g], GraphDistance[g, c]], 0],
   AllTrue[VertexList[g], FormValue[RestrictionMap[g, cochain], #, {}] == FormValue[f, #, {}] &]}]
```

The wedge of two 0-forms is their product:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {f = ZeroForm[g, GraphDistance[g, c, #] &]},
  AllTrue[VertexList[g], FormValue[FormWedge[f, f], #, {}] == GraphDistance[g, c, #]^2 &]]
```

## Possible Issues

An association that misses a vertex leaves a [Missing]() value in the germ there:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {f = ZeroForm[g, <|c -> 1|>]}, {f[c], f[First @ AdjacencyList[g, c]]}]
```
