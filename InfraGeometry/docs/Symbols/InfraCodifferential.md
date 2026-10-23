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

<code>[InfraCodifferential]()[*ω*]</code> is the codifferential of the 1-form *ω*: the vertex function whose value at *v* is the net amount of *ω* flowing into *v*.

## Details & Options

The codifferential is *δω(v) = Σ ω(u → v) − Σ ω(v → w)*, the first sum over the edges *u → v* into *v*, the second over the edges *v → w* out of *v*.

*ω* is an [Association]() `DirectedEdge[u, v] -> x`, in which a missing edge counts as 0, or <code>[InfraDifferential]()[*f*]</code>. It is read antisymmetrically, *ω(v → u) = −ω(u → v)*, so an edge may be named in either orientation.

The edges summed over:

| Substrate | Edges of *δω(v)* |
|---|---|
| undirected graph | every edge at *v*; *δω(v)* is the sum of *ω(u → v)* over the neighbours *u* |
| directed acyclic graph | the links into and out of *v*, the edges of [TransitiveReductionGraph]() |

[InfraCodifferential]() is a symbolic object. [InfraMeasurement]() reads it on a graph:

| Reading | Value |
|---|---|
| `"Function"` | the 0-form, an [Association]() *v* -> *δω(v)* over the vertices of the graph |

`All` gives the readings as an [Association](). On a directed graph with a cycle the reading stays unevaluated.

The integral of *δω* over a region is the flux of *ω* into it (Gauss). The codifferential of a differential is the graph Laplacian: *δdf(v) = Σ (f(v) − f(u))*, the sum over the neighbours *u* of *v*.

## Basic Examples

The codifferential of the differential of the distance from the centre: at each vertex, the neighbours nearer the centre minus those farther out. Negative values are drawn as rings. On the grid it is −4 at the centre, −2 on the axes, 1 at the pendant vertices of the rim and 0 elsewhere:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {div = InfraMeasurement[g, InfraCodifferential[InfraDifferential[GraphDistance[g, c, #] &]], "Function"]},
    InfraSubstrateHighlight[g, {div, c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the diamond *1 < 2, 3 < 4* the bottom only sends and the top only receives:

```wl
InfraMeasurement[Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}],
  InfraCodifferential[<|DirectedEdge[1, 2] -> 3, DirectedEdge[1, 3] -> 5, DirectedEdge[2, 4] -> -1,
    DirectedEdge[3, 4] -> 2|>], "Function"]
```

An edge may be named in either orientation. Here *ω(2 → 3) = −5*:

```wl
InfraMeasurement[PathGraph[Range[4]],
  InfraCodifferential[<|DirectedEdge[1, 2] -> 3, DirectedEdge[3, 2] -> 5, DirectedEdge[3, 4] -> 1|>], "Function"]
```

## Properties and Relations

Gauss: the integral of *δω* over a ball is the flux of *ω* into the ball, the values on the edges entering it minus those on the edges leaving it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {ball = InfraBall[First @ GraphCenter[g], 3]},
  {omega = AssociationMap[Mod[3 First[#] + Last[#], 7] - 3 &, DirectedEdge @@@ EdgeList[g]]},
  {InfraMeasurement[g, InfraIntegral[InfraCodifferential[omega], ball], "Value"],
   InfraMeasurement[g, InfraIntegral[omega, ball], "Flux"]}]
```

The whole graph has no boundary, so the codifferential sums to 0:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {omega = AssociationMap[Mod[3 First[#] + Last[#], 7] - 3 &, DirectedEdge @@@ EdgeList[g]]},
  Total @ InfraMeasurement[g, InfraCodifferential[omega], "Function"]]
```

The codifferential of a differential is the Laplacian, the [KirchhoffMatrix]() applied to *f*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {f = AssociationMap[Mod[#^2, 11] &, VertexList[g]]},
  Values @ InfraMeasurement[g, InfraCodifferential[InfraDifferential[f]], "Function"] ===
    KirchhoffMatrix[g] . Values[f]]
```

On a directed acyclic graph it is the Laplacian of the undirected Hasse diagram, which an implied edge does not change:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {f = <|1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4|>},
  Values @ InfraMeasurement[dag, InfraCodifferential[InfraDifferential[f]], "Function"] ===
    KirchhoffMatrix[UndirectedGraph @ TransitiveReductionGraph[dag]] . Values[f]]
```
