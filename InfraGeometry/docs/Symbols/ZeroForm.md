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

<code>[ZeroForm]()[*g*, *f*]</code> gives the vertex function *f*, an [Association]() or a function, as a 0-form on *g*: its germ at the vertex *v* is the value *f*(*v*) on the empty tuple.

## Details & Options

Definition: a *k*-form *ω* on a graph assigns to every vertex *v* an alternating function *ω(v; w₁, …, wₖ)* on the *k*-tuples of distinct neighbours *w₁, …, wₖ* of *v*, its germ at *v*. For *k* = 0 the only tuple is the empty one, so a 0-form is a function on the vertices.

A form is stored as `<|v -> <|tuple -> value|>|>`, each tuple sorted, and the 0-form of *f* is `<|v -> <|{} -> f(v)|>|>`. [FormValue]() reads it: <code>[FormValue]()[*ω*, *v*, {}]</code> is *f*(*v*).

An [Association]() has to give a value at every vertex of *g*: at a vertex it misses, the germ holds the [Missing]() of the lookup.

A 0-form and a 0-cochain carry the same values: [IntegrationMap]() reads a 0-form as the 0-cochain `<|{v} -> f(v)|>` on the one-vertex cliques, and [RestrictionMap]() reads that back. The differential of a 0-form is its gradient, *(df)(v; w) = f(w) − f(v)* ([FormDifferential]()), and the wedge of two 0-forms is their product ([FormWedge]()).

## Basic Examples

The distance from the centre as a 0-form on the square, the hexagonal and the triangular tiling. Each vertex is drawn by its value.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {forms = Table[ZeroForm[substrate, GraphDistance[substrate, InfraCenter[substrate], #] &], {substrate, graphs}]},
  GraphicsRow[MapThread[InfraSubstrateHighlight[#1, First /@ #2] &, {graphs, forms}]]]
```

The germ at a vertex is its value on the empty tuple: 0 at the centre, 1 at a neighbour of the centre and 5 at a vertex of the rim.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g]},
  {form = ZeroForm[g, GraphDistance[g, center, #] &]},
  {corners = {center, First @ AdjacencyList[g, center], First @ MaximalBy[VertexList[g], GraphDistance[g, center, #] &]}},
  {InfraSubstrateHighlight[g, corners], FormValue[form, #, {}] & /@ corners}]
```

## Scope

The function may be an [Association](). A random integer function on the triangular tiling, positive values in blue, negative in red.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {values = (SeedRandom[1]; AssociationMap[RandomInteger[{-4, 4}] &, VertexList[g]])},
  {form = ZeroForm[g, values]},
  InfraSubstrateHighlight[g, {Select[First /@ form, Positive] -> StandardBlue, -Select[First /@ form, Negative] -> StandardRed}]]
```

## Properties and Relations

The differential of a 0-form is its gradient. The distance from the centre rises by 1 on every step away from the centre, drawn as a blue arc, and falls by 1 on every step towards it, an orange arc; on a step inside a shell it does not change.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {gradient = FormDifferential[g, ZeroForm[g, GraphDistance[g, InfraCenter[g], #] &]]},
  DisplacementPlot[g, {Map[Catenate @* Keys @* Select[Positive], gradient], Map[Catenate @* Keys @* Select[Negative], gradient]}]]
```

A 0-form and a 0-cochain carry the same values. [IntegrationMap]() gives the 0-cochain on the one-vertex cliques, where the value 0 at the centre is not stored, and [RestrictionMap]() reads back the value at every vertex.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {form = ZeroForm[g, GraphDistance[g, InfraCenter[g], #] &]},
  {cochain = IntegrationMap[g, form]},
  {InfraSubstrateHighlight[g, KeyMap[First, cochain]], Take[Normal[cochain], 4],
   AllTrue[VertexList[g], FormValue[RestrictionMap[g, cochain], #, {}] == FormValue[form, #, {}] &]}]
```

The wedge of two 0-forms is their product, here the square of the distance from the centre.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  {center = InfraCenter[g]},
  {squared = FormWedge[ZeroForm[g, GraphDistance[g, center, #] &], ZeroForm[g, GraphDistance[g, center, #] &]]},
  {InfraSubstrateHighlight[g, AssociationMap[FormValue[squared, #, {}] &, VertexList[g]]],
   AllTrue[VertexList[g], FormValue[squared, #, {}] == GraphDistance[g, center, #]^2 &]}]
```
