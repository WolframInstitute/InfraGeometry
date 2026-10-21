---
Template: Symbol
Name: SprayGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SprayGraph
Keywords: [spray of shortest paths, exponential map, breadth-first search, shortest-path DAG, shortest paths]
SeeAlso: [RayGraph, IntervalGraph, InfraMeasurement, RandomInfraGeodesic, InfraShell, InfraBall]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[SprayGraph]()[*g*, *c*]</code> gives the spray at *c*: the directed acyclic graph of all shortest paths from *c*.

<code>[SprayGraph]()[*g*, {*c1*, *c2*, …}]</code> gives the spray of the vertex set, with the distance to the nearest *ci*.

<code>[SprayGraph]()[*g*, {{*u1*, *v1*}, {*u2*, *v2*}, …}]</code> gives the union of shortest paths from each *ui* to *vi*.

## Details & Options

The spray at *c* has an edge *u → v* for every edge *uv* of *g* with *d(c, v) = d(c, u) + 1*. Edges inside one shell about *c* are dropped.

The directed paths from *c* are exactly the shortest paths from *c*. The paths from *c* to a sink are the maximal ones: a sink is a vertex with no neighbour farther from *c*. The spray is the graph analogue of the exponential map at *c*.

On a bipartite graph such as the square grid no edge lies inside a shell, so the spray keeps every edge of *g*.

With several sources *d(c, v)* is replaced by *d(C, v) = min d(cᵢ, v)*.

The pair form picks shortest paths from each *uᵢ* to *vᵢ* and takes the union of their path graphs.

The spray keeps the vertex coordinates of *g*.

Options:

| Option | Default | Values |
|---|---|---|
| `"AxisLength"` | `All` | a depth *k*: keep only the vertices within distance *k* of the sources |
| `"PathThickness"` | `0` | pair form only: `0` one shortest path per pair, `Infinity` all of them, *t* those within Hausdorff distance *t* of the first |
| `"Directed"` | `True` | `False` keeps the same edges undirected |

## Basic Examples

The spray at the centre to depth 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {SprayGraph[g, c, "AxisLength" -> 4], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The sinks of the spray, where no step leads farther from the centre. They are the ends of the maximal shortest paths:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {spray = SprayGraph[g, c]}, {sinks = Select[VertexList[spray], VertexOutDegree[spray, #] == 0 &]},
    InfraSubstrateHighlight[g, {sinks, c}, PlotLabel -> Length[sinks]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The grid is bipartite and its spray keeps all 144 edges. The mesh has triangles, and its spray keeps 173 of 255:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {EdgeCount @ SprayGraph[g, c], EdgeCount[g]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The spray of two sources grows from both, each vertex reached from the nearer one:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2]},
  InfraSubstrateHighlight[g, {SprayGraph[g, {c, b}], c, b}, ImageSize -> Medium]]
```

## Options

### PathThickness

One shortest path, those within Hausdorff distance 1 of it, and all 20 shortest paths between two vertices of the grid. The labels are the edge counts:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 6], RandomSeeding -> 2]},
  GraphicsRow @ Table[
    With[{spray = SprayGraph[g, {{a, b}}, "PathThickness" -> t]},
      InfraSubstrateHighlight[g, {spray, a, b}, PlotLabel -> EdgeCount[spray]]],
    {t, {0, 1, Infinity}}]]
```

## Properties and Relations

The vertices at depth *r* are the shell of radius *r*, so the spray to depth *r* has the vertices of the ball:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[VertexCount @ SprayGraph[g, c, "AxisLength" -> r] == InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"],
    {r, 0, 6}]]
```

The paths of the spray from *c* to *v* are the shortest paths from *c* to *v*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 6]},
  {Length @ FindPath[SprayGraph[g, c], c, v, Infinity, All], InfraMeasurement[g, InfraSegment[c, v], "Cardinality"]}]
```

The spray at *c* is the [RayGraph]() of *c* through itself:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ EdgeList @ SprayGraph[g, c] === Sort @ EdgeList @ RayGraph[g, c, c]]
```
