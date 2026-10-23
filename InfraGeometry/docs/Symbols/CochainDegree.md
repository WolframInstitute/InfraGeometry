---
Template: Symbol
Name: CochainDegree
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CochainDegree
Keywords: [cochain, degree, clique complex, simplex]
SeeAlso: [CochainValue, Coboundary, CochainCup, OrderedCochainCup, CochainCupOne, FormDegree]
RelatedGuides: [Experimental]
---

## Usage

<code>[CochainDegree]()[*α*]</code> gives the degree *k* of the cochain *α*, one less than the number of vertices of the cliques on which it is stored.

## Details & Options

A *k*-cochain takes its values on the (*k* + 1)-cliques of a graph, the *k*-simplices of its clique complex.

It is stored as `<|{v0, …, vk} -> value, …|>`, and the degree is read off a key. The empty cochain has no key and no degree.

| Operation | Degree |
|---|---|
| [Coboundary]() | *k* + 1 |
| [CochainCup](), [OrderedCochainCup]() | *p* + *q* |
| [CochainCupOne]() | *p* + *q* − 1 |

## Basic Examples

A 0-cochain, its coboundary and a cup product on the square mesh: the distance *f* from the centre, *δf*, and *δf ∪ δy* for the coordinate *y*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {f = AssociationThread[List /@ VertexList[g], GraphDistance[g, First @ GraphCenter[g]]],
   y = AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]},
  CochainDegree /@ {f, Coboundary[g, f], CochainCup[g, Coboundary[g, f], Coboundary[g, y]]}]
```

## Possible Issues

The empty cochain has no degree, and the call stays unevaluated. On the square grid, which has no triangles, the cup of two 1-cochains is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {x = AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 1]]],
   y = AssociationThread[List /@ VertexList[g], GraphEmbedding[g][[All, 2]]]},
  {cup = CochainCup[g, Coboundary[g, x], Coboundary[g, y]]},
  {cup, Head @ CochainDegree[cup]}]
```

A vertex function keyed by the vertices is not a cochain:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {f = AssociationThread[VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
  {Head @ CochainDegree[f], CochainDegree[KeyMap[List, f]]}]
```
