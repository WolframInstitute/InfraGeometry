---
Template: Symbol
Name: InfraDifferential
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraDifferential
Keywords: [differential, 1-form, gradient, coboundary, exact form, Leibniz rule, directed acyclic graph, link]
SeeAlso: [InfraCodifferential, InfraIntegral, InfraAntiderivative, InfraDerivative, InfraMeasurement, SprayGraph]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraDifferential]()[*f*]</code> is the differential of the vertex function *f*: the 1-form *df(u → v) = f(v) − f(u)*. It is a symbolic object; [InfraMeasurement]() evaluates it on a graph.

## Details & Options

Definition: the differential of a function *f* on the vertices is the 1-form that gives each edge *u → v* the increment *df(u → v) = f(v) − f(u)*.

*f* is a 0-form: an [Association]() *v* -> *x*, in which a missing vertex counts as 0, or a function applied to each vertex. A head with a `"Function"` reading, such as [InfraAntiderivative](), is read through it.

The edges carrying *df* depend on the substrate:

| Substrate | Edges of *df* |
|---|---|
| directed acyclic graph | the links *u ⋖ v*, the edges of `TransitiveReductionGraph` |
| undirected graph | every edge, oriented as in `EdgeList` |

On a directed acyclic graph the order is reachability and only its links are local. An implied edge *u → w*, which a longer chain also joins, carries no value, so adding or removing implied edges leaves the differential unchanged.

A 1-form is read antisymmetrically, *ω(v → u) = −ω(u → v)*: an undirected edge may be named in either orientation.

| Reading | Value |
|---|---|
| `"Function"` | the 1-form, an [Association]() `DirectedEdge[u, v] -> f(v) - f(u)` |

`All` gives the readings as an [Association](). On a directed graph with a cycle the reading stays unevaluated.

## Basic Examples

The differential of a function on the diamond, the four links of the order *1 < 2, 3 < 4*.

```wl
Normal @ InfraMeasurement[
  Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}],
  InfraDifferential[<|1 -> 10, 2 -> 3, 3 -> -2, 4 -> 7|>], "Function"]
```

The differential of the distance from the centre is 1 along an edge leading away from the centre, −1 against it and 0 across. On the discretized plane, the square grid and the hexagonal tiling, the edges are oriented the way it grows, and those on which it is constant are left out. They are the spray graph of the centre, drawn as the bundle of its walks.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {df = InfraMeasurement[g, InfraDifferential[AssociationThread[VertexList[g], GraphDistance[g, c]]], "Function"]},
    {uphill = Graph[VertexList[g], If[df[#] > 0, #, Reverse[#]] & /@ Select[Keys[df], df[#] != 0 &]]},
    InfraSubstrateHighlight[g, {uphill, c}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

A function applied to each vertex is the same 0-form as its values.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  InfraMeasurement[g, InfraDifferential[Mod[#, 7] &], "Function"] ===
    InfraMeasurement[g, InfraDifferential[AssociationThread[VertexList[g], Mod[VertexList[g], 7]]], "Function"]]
```

## Properties and Relations

The fundamental theorem: along every shortest path from *p* to *q* the integral of *df* is *f(q) − f(p)*. The value density of [InfraIntegral]() is one atom, carrying all the shortest paths.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5]], f = AssociationThread[VertexList[g], RandomInteger[{-9, 9}, VertexCount[g]]]},
  {Normal @ InfraMeasurement[g, InfraIntegral[InfraDifferential[f], InfraSegment[p, q]], "ValueDensity"],
   f[q] - f[p], InfraMeasurement[g, InfraSegment[p, q], "Cardinality"]}]
```

The Leibniz rule *d(f h) = f dh + h df + df dh*, with *f* and *h* read at the start of each edge. The last term is the price of the discreteness.

```wl
SeedRandom[2];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {f = AssociationThread[VertexList[g], RandomInteger[{-5, 5}, VertexCount[g]]], h = AssociationThread[VertexList[g], RandomInteger[{-5, 5}, VertexCount[g]]]},
  {df = InfraMeasurement[g, InfraDifferential[f], "Function"], dh = InfraMeasurement[g, InfraDifferential[h], "Function"],
   dfh = InfraMeasurement[g, InfraDifferential[f h], "Function"]},
  AllTrue[Keys[dfh], dfh[#] == f[First[#]] dh[#] + h[First[#]] df[#] + df[#] dh[#] &]]
```

On a directed acyclic graph the differential reads the order, not its encoding: the transitive closure, which adds every implied edge, gives the same 1-form.

```wl
With[
  {dag = Graph[Range[6], {1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = AssociationThread[Range[6], {5, -2, 7, 1, 3, -4}]},
  {Keys @ InfraMeasurement[dag, InfraDifferential[f], "Function"],
   InfraMeasurement[dag, InfraDifferential[f], "Function"] === InfraMeasurement[TransitiveClosureGraph[dag], InfraDifferential[f], "Function"]}]
```

The edges on which the differential of the distance from *c* is nonzero, oriented the way it grows, are the edges of the spray graph of *c*: the links of the order an antiderivative from the origin *c* reads.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small"]},
  {c = First @ GraphCenter[g]},
  {df = InfraMeasurement[g, InfraDifferential[AssociationThread[VertexList[g], GraphDistance[g, c]]], "Function"]},
  Sort[If[df[#] > 0, #, Reverse[#]] & /@ Select[Keys[df], df[#] != 0 &]] === Sort @ EdgeList @ SprayGraph[g, c]]
```

The codifferential of the differential is the Laplacian: on an undirected graph its Kirchhoff matrix, on a directed acyclic graph that of the undirected Hasse diagram.

```wl
SeedRandom[3];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {f = AssociationThread[VertexList[g], RandomInteger[{-5, 5}, VertexCount[g]]]},
  Values @ InfraMeasurement[g, InfraCodifferential[InfraDifferential[f]], "Function"] === KirchhoffMatrix[g] . Values[f]]
```
