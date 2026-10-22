---
Template: Symbol
Name: InfraGeodesic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraGeodesic
Keywords: [geodesic, infra-scale, window graph, extension, germ, symbolic object]
SeeAlso: [RandomInfraGeodesic, InfraGeodesicQ, InfraMeasurement, InfraHalfLine, InfraInfiniteLine]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraGeodesic]()[*germ*, *s*]</code> is the family of the geodesics at infra-scale *s* through the vertex list *germ* that are simple and cannot be extended.

## Details & Options

A walk is a geodesic at infra-scale *s* when every *s* + 1 consecutive vertices form a shortest path, as [InfraGeodesicQ]() tests. A member of <code>[InfraGeodesic]()[*germ*, *s*]</code> contains *germ*, visits no vertex twice, and cannot be prolonged at either end without breaking one of the two conditions.

The geodesic is the Riemannian geodesic seen by an observer who compares only points fewer than *s* + 1 steps apart. At scale 1 every walk qualifies; at scale [Infinity]() a member is a maximal shortest path through *germ*. The larger the scale, the straighter the members.

The germ must itself be a geodesic at scale *s*.

[InfraGeodesic]() is a symbolic object: [RandomInfraGeodesic]() draws members, and [InfraMeasurement]() gives its `"Graph"`.

The `"Graph"` is the window graph of the forward extensions of *germ*. A vertex is a window, the last *s* vertices of a walk or fewer at the start. A window *w₁*, …, *wₘ* has an arrow to the window that appends *v* when *d(w₁, v) = m*. The walks of *k* edges from the germ's window are the *k*-step geodesic extensions of *germ*, revisits included. At scale 1 the windows are vertices; at scale 2 they are directed edges. At scale [Infinity]() the graph is the part of the graph of <code>[InfraHalfLine]()[*p*, *q*]</code> past *q*, with *p* and *q* the ends of the germ.

## Basic Examples

A member at scale 3 through an edge at the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {germ = {c, First @ AdjacencyList[g, c]}},
    {member = RandomInfraGeodesic[g, InfraGeodesic[germ, 3], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[member], germ}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Members through the same edge of the grid at scales 2, 4 and [Infinity]():

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {germ = {c, First @ AdjacencyList[g, c]}},
    {member = RandomInfraGeodesic[g, InfraGeodesic[germ, s], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[member], germ}, PlotLabel -> s]],
  {s, {2, 4, Infinity}}]
```

The window graph at scale [Infinity]() drawn on the grid, the germ at its root:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  {windows = InfraMeasurement[g, InfraGeodesic[germ, Infinity], "Graph"]},
  InfraSubstrateHighlight[g, {windows, InfraWalk[germ]}, ImageSize -> Medium]]
```

## Scope

The family drawn whole, each edge as strong as the number of members through it. The geodesics at scale 4 through a shortest path of two edges from the centre of the mesh, and their number:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {germ = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraGeodesic[germ, 4], InfraWalk[germ]},
    PlotLabel -> Length @ RandomInfraGeodesic[g, InfraGeodesic[germ, 4], All], ImageSize -> Medium]]
```

## Properties and Relations

The number of windows at scales 1, 2 and 3 on the grid: the vertices, the directed edges reached, and the windows of three vertices reached:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  Table[VertexCount @ InfraMeasurement[g, InfraGeodesic[germ, s], "Graph"], {s, 1, 3}]]
```

The *k*-step extensions are the walks of *k* edges from the germ's window: the powers of the adjacency matrix count what [RandomInfraGeodesic]() lists. At scale 2 with *k* = 5:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {germ = {c, First @ AdjacencyList[g, c]}},
  {windows = InfraMeasurement[g, InfraGeodesic[germ, 2], "Graph"]},
  {start = UnitVector[VertexCount[windows], VertexIndex[windows, germ]]},
  {Total[start . MatrixPower[AdjacencyMatrix[windows], 5]], Length @ RandomInfraGeodesic[g, germ, 2, {5}, All]}]
```

At scale [Infinity]() the window graph is the part of the [InfraHalfLine]() graph past the germ:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]}, {q = First @ AdjacencyList[g, c]},
  {ray = InfraMeasurement[g, InfraHalfLine[c, q], "Graph"]},
  Sort @ EdgeList @ InfraMeasurement[g, InfraGeodesic[{c, q}, Infinity], "Graph"] ===
    Sort @ EdgeList @ Subgraph[ray, VertexOutComponent[ray, q]]]
```

## Possible Issues

A germ that is not a geodesic at the scale has no members, and its graph stays unevaluated. Stepping back fails at scale 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {RandomInfraGeodesic[g, InfraGeodesic[{45, 46, 45}, 2], RandomSeeding -> 1],
   Head @ InfraMeasurement[g, InfraGeodesic[{45, 46, 45}, 2], "Graph"]}]
```
