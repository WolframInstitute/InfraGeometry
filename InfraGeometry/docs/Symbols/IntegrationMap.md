---
Template: Symbol
Name: IntegrationMap
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/IntegrationMap
Keywords: [integration map, differential form, cochain, Stokes theorem, chain map, clique complex]
SeeAlso: [RestrictionMap, FormDifferential, Coboundary, NaiveDifferential, FormWedge, CochainCup]
RelatedGuides: [Experimental]
---

## Usage

<code>[IntegrationMap]()[*g*, *ω*]</code> gives the alternating cochain *Iω* of the *k*-form *ω*: on each *(k + 1)*-clique, the signed mean of the germs at its vertices.

## Details & Options

*(Iω)(v₀, …, vₖ) = (1/(k + 1)) Σᵢ (−1)ⁱ ω(vᵢ; v₀, …, v̂ᵢ, …, vₖ)*, the sum over *i = 0, …, k*. *I* maps the *k*-forms to the *k*-cochains.

On a 1-form it is the antisymmetric part across each edge, *(Iω)(u, v) = (ω(u; v) − ω(v; u))/2*. On a 0-form it is the 0-cochain of the same values.

| Identity | Statement |
|---|---|
| left inverse of [RestrictionMap]() | *I(Rα) = α*, so *I* is onto |
| Stokes | *I(dω) = δ(Iω)*, with *d* the [FormDifferential]() and *δ* the [Coboundary]() |
| naive differential | *I(d₀ω) = (2/3) δ(Iω)* in degree 1, [NaiveDifferential]() |
| not a ring map | *I(Rα ∧ Rβ) = 2 α ∪ β* for 1-cochains, [FormWedge](), [CochainCup]() |

*R(Iω)* is not *ω* in general. In degree 1 it is the antisymmetric part of *ω* across each edge, the orthogonal projection onto the image of *R*.

A value 0 is not stored in the cochain.

## Basic Examples

The gradient of the distance from the centre integrates to the coboundary of the distance, on the square grid and on the square mesh:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    KeySort @ IntegrationMap[g, FormDifferential[g, ZeroForm[g, GraphDistance[g, c, #] &]]] ==
      KeySort @ Coboundary[g, AssociationThread[List /@ VertexList[g], GraphDistance[g, c]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On a random 1-form on the mesh the integral is the antisymmetric part across each edge:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
  {w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> 1]},
  {iw = IntegrationMap[g, w]},
  AllTrue[Sort /@ List @@@ EdgeList[g],
    CochainValue[iw, #] == (FormValue[w, #[[1]], {#[[2]]}] - FormValue[w, #[[2]], {#[[1]]}])/2 &]]
```

## Properties and Relations

Restricting the integral keeps the antisymmetric part only. For 100 random 1-forms on the mesh the part of the energy, the sum of the squares of the germ values, it keeps is about 1/2:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
  {energy = w |-> Total[Catenate[Values /@ Values[w]]^2]},
  Histogram @ Table[
    With[{w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> s]},
      N[energy[RestrictionMap[g, IntegrationMap[g, w]]] / energy[w]]],
    {s, 100}]]
```

Stokes and the naive differential, for a random 1-form on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {germ = v |-> AssociationThread[List /@ AdjacencyList[g, v], RandomInteger[{-4, 4}, VertexDegree[g, v]]]},
  {w = BlockRandom[AssociationMap[germ, VertexList[g]], RandomSeeding -> 1]},
  {exact = KeySort @ Coboundary[g, IntegrationMap[g, w]]},
  {KeySort @ IntegrationMap[g, FormDifferential[g, w]] == exact,
   KeySort @ IntegrationMap[g, NaiveDifferential[g, w]] == 2/3 exact}]
```

*I(Rα) = α*, and the integral of a wedge of restrictions is twice the cup product, for random 1-cochains on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {edges = Sort /@ List @@@ EdgeList[g]},
  {a = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 1]],
   b = AssociationThread[edges, BlockRandom[RandomChoice[{-2, -1, 1, 2}, Length[edges]], RandomSeeding -> 2]]},
  {KeySort @ IntegrationMap[g, RestrictionMap[g, a]] == KeySort[a],
   KeySort @ IntegrationMap[g, FormWedge[RestrictionMap[g, a], RestrictionMap[g, b]]] ==
     2 KeySort @ CochainCup[g, a, b]}]
```
