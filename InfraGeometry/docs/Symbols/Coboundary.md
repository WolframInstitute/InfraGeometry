---
Template: Symbol
Name: Coboundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/Coboundary
Keywords: [coboundary, cochain, clique complex, cohomology, simplicial cochain complex, Betti number]
SeeAlso: [CochainValue, CochainDegree, IntegrationMap, FormDifferential, CochainCup, RestrictionMap]
RelatedGuides: [Experimental]
---

## Usage

<code>[Coboundary]()[*g*, *α*]</code> gives the coboundary *δα* of the *k*-cochain *α*, a (*k* + 1)-cochain on the (*k* + 2)-cliques of *g*.

## Details & Options

The coboundary is *(δα)(v₀, …, vₖ₊₁) = Σᵢ (−1)ⁱ α(v₀, …, v̂ᵢ, …, vₖ₊₁)*, the sum over *i* = 0, …, *k* + 1.

A *k*-cochain lives on the *k*-simplices of the clique complex of *g*, its (*k* + 1)-cliques. It is an association `<|{v0, …, vk} -> value, …|>` on the increasing vertex lists; a 0-cochain is `<|{v} -> value, …|>`. A value 0 is not stored.

On a 0-cochain *f*, *(δf)(u, v) = f(v) − f(u)* on every edge.

*δ(δα) = 0*, and the cohomology *Hᵏ* of the clique complex is the kernel of *δ* in degree *k* modulo the image of *δ* from degree *k* − 1.

The square grid has no triangles. The coboundary of every 1-cochain on it is 0, and *H¹* has one dimension for every square cell. The square mesh is a triangulated disk, and its *H¹* is 0.

The coboundary is the same for alternating and for ordered cochains ([OrderedCochainCup]()).

## Basic Examples

The coboundary of the distance *f* from the centre. On the grid every edge joins two shells, so *δf* is ±1 on all 144 edges. On the mesh it is 0 on the 82 edges inside a shell, drawn:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {df = Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]]},
    InfraSubstrateHighlight[g, {c, InfraWalk /@ Complement[Sort /@ List @@@ EdgeList[g], Keys[df]]},
      PlotLabel -> {Length[df], EdgeCount[g]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The coboundary of a coboundary is 0. A random 0-cochain on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {f = AssociationThread[List /@ VertexList[g], BlockRandom[RandomInteger[{-4, 4}, 102], RandomSeeding -> 1]]},
  {Length[Coboundary[g, f]], Coboundary[g, Coboundary[g, f]]}]
```

## Scope

In degree 1 the coboundary lives on the triangles. The 1-cochain that is 1 on one edge at the centre of the mesh has coboundary ±1 on the two triangles at that edge: blue where it is positive on the counterclockwise order of the corners, red where it is negative. The edge runs counterclockwise round one triangle and clockwise round the other:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pos = AssociationThread[VertexList[g], GraphEmbedding[g]], edge = Sort[{c, First @ AdjacencyList[g, c]}]},
  {cob = Coboundary[g, <|edge -> 1|>]},
  Show[Graphics[KeyValueMap[
      {t, a} |-> {If[a Det[Differences[pos /@ t]] > 0, StandardBlue, StandardRed], Polygon[pos /@ t]}, cob]],
    InfraSubstrateHighlight[g, {InfraWalk[edge]}], PlotLabel -> Normal[cob]]]
```

## Properties and Relations

The first Betti number of the clique complex, *b₁ = dim ker δ₁ − rank δ₀*, from the matrices of the coboundary. On the grid it is 49, the number of square cells; on the mesh it is 0:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]},
    {edges = Sort /@ List @@@ EdgeList[g], triangles = Sort /@ FindClique[g, {3}, All]},
    {d0 = Table[Lookup[Coboundary[g, <|{v} -> 1|>], edges, 0], {v, VertexList[g]}],
     d1 = Table[Lookup[Coboundary[g, <|e -> 1|>], triangles, 0], {e, edges}]},
    Length[edges] - MatrixRank[d1] - MatrixRank[d0]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Possible Issues

A vertex function keyed by the vertices themselves is not a cochain, and the call stays unevaluated. Keyed by one-vertex lists it works:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {f = AssociationThread[VertexList[g], GraphDistance[g, First @ GraphCenter[g]]]},
  {Head @ Coboundary[g, f], Length @ Coboundary[g, KeyMap[List, f]]}]
```
