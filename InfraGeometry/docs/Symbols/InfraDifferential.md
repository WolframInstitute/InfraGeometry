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

<code>[InfraDifferential]()[*f*]</code> is the differential of the vertex function *f*: the 1-form that gives each edge *u → v* the increment *f(v) − f(u)*.

## Details & Options

The differential is *df(u → v) = f(v) − f(u)*.

*f* is a 0-form: an [Association]() *v* -> *x*, in which a missing vertex counts as 0, or a function applied to each vertex. [InfraCodifferential](), [InfraAntiderivative]() and [InfraDerivative]() are read as their 0-forms.

The edges that carry *df*:

| Substrate | Edges of *df* |
|---|---|
| undirected graph | every edge, oriented as in [EdgeList]() |
| directed acyclic graph | the links *u ⋖ v* of the reachability order, the edges of [TransitiveReductionGraph]() |

On a directed acyclic graph an implied edge *u → w*, which a longer chain also joins, carries no value. Adding or removing implied edges leaves *df* unchanged.

A 1-form is read antisymmetrically, *ω(v → u) = −ω(u → v)*, so an edge may be named in either orientation.

[InfraDifferential]() is a symbolic object. [InfraMeasurement]() reads it on a graph:

| Reading | Value |
|---|---|
| `"Function"` | the 1-form, an [Association]() `DirectedEdge[u, v] -> f(v) - f(u)` |

`All` gives the readings as an [Association](). On a directed graph with a cycle the reading stays unevaluated.

The integral of *df* along every shortest path from *p* to *q* is *f(q) − f(p)*, and the codifferential of *df* is the graph Laplacian of *f*.

## Basic Examples

The differential of the distance from the centre is 1 on an edge leading away from the centre, −1 against it and 0 across. The edges where it is not 0, oriented the way the distance grows, drawn by the number of shortest paths from the centre through each edge. On the mesh the grey edges join vertices at the same distance:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {df = InfraMeasurement[g, InfraDifferential[GraphDistance[g, c, #] &], "Function"]},
    {uphill = Graph[Join[Keys @ Select[df, Positive], Reverse /@ Keys @ Select[df, Negative]]]},
    InfraSubstrateHighlight[g, {uphill, c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the diamond *1 < 2, 3 < 4* the differential lives on the four links:

```wl
InfraMeasurement[Graph[{1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4}],
  InfraDifferential[<|1 -> 10, 2 -> 3, 3 -> -2, 4 -> 7|>], "Function"]
```

## Properties and Relations

The fundamental theorem. Along each of the shortest paths from *p* to *q* the integral of *df* is *f(q) − f(p)*, so the value density of the integral is one atom:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 5], RandomSeeding -> 1], f = Mod[#^2, 11] &},
  {InfraMeasurement[g, InfraIntegral[InfraDifferential[f], InfraSegment[p, q]], "ValueDensity"], f[q] - f[p],
   InfraMeasurement[g, InfraSegment[p, q], "Cardinality"]}]
```

The Leibniz rule *d(fh) = f dh + h df + df dh*, with *f* and *h* read at the tail of each edge. The last term has no continuum counterpart:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {f = Mod[#, 5] &, h = Mod[#, 3] - 1 &},
  {df = InfraMeasurement[g, InfraDifferential[f], "Function"],
   dh = InfraMeasurement[g, InfraDifferential[h], "Function"],
   dfh = InfraMeasurement[g, InfraDifferential[f[#] h[#] &], "Function"]},
  AllTrue[Keys[dfh], dfh[#] == f[First @ #] dh[#] + h[First @ #] df[#] + df[#] dh[#] &]]
```

The codifferential of the differential is the Laplacian, the [KirchhoffMatrix]() applied to *f*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {f = AssociationMap[Mod[#^2, 11] &, VertexList[g]]},
  Values @ InfraMeasurement[g, InfraCodifferential[InfraDifferential[f]], "Function"] ===
    KirchhoffMatrix[g] . Values[f]]
```

The edges on which the differential of the distance from *c* is not 0, oriented the way it grows, are the edges of the [SprayGraph]() of *c*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {df = InfraMeasurement[g, InfraDifferential[GraphDistance[g, c, #] &], "Function"]},
  Sort @ Join[Keys @ Select[df, Positive], Reverse /@ Keys @ Select[df, Negative]] ===
    Sort @ EdgeList @ SprayGraph[g, c]]
```

On a directed acyclic graph the differential sees the order, not the edges that encode it. The [TransitiveClosureGraph](), which adds every implied edge, gives the same 1-form on the same links:

```wl
With[{dag = Graph[{1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 5 -> 6, 1 -> 6}]},
  {df = InfraDifferential[<|1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4|>]},
  {InfraMeasurement[dag, df, "Function"],
   InfraMeasurement[dag, df, "Function"] === InfraMeasurement[TransitiveClosureGraph[dag], df, "Function"]}]
```

## Possible Issues

On a directed graph with a cycle there is no order, and the reading stays unevaluated:

```wl
Head @ InfraMeasurement[CycleGraph[3, DirectedEdges -> True], InfraDifferential[# &], "Function"]
```
