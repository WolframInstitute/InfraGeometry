---
Template: Symbol
Name: InfraCodifferential
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCodifferential
Keywords: [codifferential, divergence, 1-form, flux, Gauss theorem, Laplacian, Kirchhoff matrix, directed acyclic graph]
SeeAlso: [InfraDifferential, InfraIntegral, InfraMeasurement, InfraAntiderivative]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[InfraCodifferential]()[*ω*]</code> is the codifferential of the 1-form *ω*: the vertex function *δω(v)*, the values of *ω* on the links into *v* minus those on the links out of *v*. It is a symbolic object; [InfraMeasurement]() evaluates it on a graph.

## Details & Options

Definition: the codifferential of a 1-form *ω* is the 0-form *δω(v) = Σ_(u → v) ω(u → v) − Σ_(v → w) ω(v → w)*, the net amount of *ω* flowing into *v*.

*ω* is an [Association]() on edges `DirectedEdge[u, v] -> x`, in which a missing edge counts as 0, or <code>[InfraDifferential]()[*f*]</code>, read through its `"Function"`. It is read antisymmetrically, *ω(v → u) = −ω(u → v)*.

The edges summed over depend on the substrate:

| Substrate | Edges of *δω(v)* |
|---|---|
| directed acyclic graph | the links into and out of *v*, the edges of `TransitiveReductionGraph` |
| undirected graph | every edge at *v*, so that *δω(v)* is the sum of *ω(u → v)* over the neighbours *u* |

| Reading | Value |
|---|---|
| `"Function"` | the 0-form, an [Association]() *v* -> *δω(v)* over the vertices of the graph |

`All` gives the readings as an [Association](). On a directed graph with a cycle the reading stays unevaluated.

## Basic Examples

The codifferential of a 1-form on the diamond. The bottom only sends, the top only receives.

```wl
Normal @ InfraMeasurement[
  Graph[{1, 2, 3, 4}, {1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}],
  InfraCodifferential[<|DirectedEdge[1, 2] -> 3, DirectedEdge[1, 3] -> 5, DirectedEdge[2, 4] -> -1, DirectedEdge[3, 4] -> 2|>], "Function"]
```

The codifferential of the differential of the distance from the centre counts, at each vertex, the neighbours nearer the centre minus those farther out. It is drawn where it is negative, by its size, on the discretized plane, the square grid and the hexagonal tiling: at the vertices with more edges leading away from the centre than towards it. On the square grid these are the axes, the corners of the balls.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {divergence = InfraMeasurement[g, InfraCodifferential[InfraDifferential[AssociationThread[VertexList[g], GraphDistance[g, c]]]], "Function"]},
    InfraSubstrateHighlight[g, {-Select[divergence, Negative], c}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

An edge may be named in either orientation.

```wl
Normal @ InfraMeasurement[PathGraph[Range[4]],
  InfraCodifferential[<|DirectedEdge[1, 2] -> 3, DirectedEdge[3, 2] -> 5, DirectedEdge[3, 4] -> 1|>], "Function"]
```

## Properties and Relations

Gauss: the integral of *δω* over a region is the flux of *ω* into it, the values on the edges entering it minus those on the edges leaving it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {omega = AssociationThread[DirectedEdge @@@ EdgeList[g], RandomInteger[{-5, 5}, EdgeCount[g]]], ball = InfraBall[First @ GraphCenter[g], 3]},
  {InfraMeasurement[g, InfraIntegral[InfraCodifferential[omega], ball], "Value"], InfraMeasurement[g, InfraIntegral[omega, ball], "Flux"]}]
```

The whole graph has no boundary, so the codifferential sums to zero.

```wl
SeedRandom[2];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {omega = AssociationThread[DirectedEdge @@@ EdgeList[g], RandomInteger[{-5, 5}, EdgeCount[g]]]},
  Total @ InfraMeasurement[g, InfraCodifferential[omega], "Function"]]
```

The codifferential of a differential is the Laplacian. On a directed acyclic graph it is the Laplacian of the undirected Hasse diagram, which an implied edge does not change.

```wl
With[
  {dag = Graph[Range[6], {1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = AssociationThread[Range[6], {5, -2, 7, 1, 3, -4}]},
  Values @ InfraMeasurement[dag, InfraCodifferential[InfraDifferential[f]], "Function"] ===
    KirchhoffMatrix[UndirectedGraph @ TransitiveReductionGraph[dag]] . Values[f]]
```
