---
Template: Symbol
Name: GeodesicSprayGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GeodesicSprayGraph
Keywords: [geodesic spray, exponential map, breadth-first search, geodesic DAG, shortest paths]
SeeAlso: [GeodesicIntervalGraph, GeodesicExtensionGraph, FindInfraGeodesic, FindInfraShell, BallVolumes]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[GeodesicSprayGraph]()[*g*, *c*]</code> gives the directed acyclic graph of all geodesics from *c*: an edge *u → v* for every edge of *g* with *d(c, v) = d(c, u) + 1*.

<code>[GeodesicSprayGraph]()[*g*, {*c1*, *c2*, …}]</code> measures the distance from the nearest of the sources.

<code>[GeodesicSprayGraph]()[*g*, {{*u1*, *v1*}, {*u2*, *v2*}, …}]</code> gives the union of geodesics between the listed pairs.

## Details & Options

Definition: the spray at *c* orients every edge of *g* that joins two consecutive shells about *c* outward, from the shell of radius *r* to that of radius *r* + 1. Edges inside one shell are dropped.

Its directed paths starting at *c* are exactly the geodesics from *c*, each once, and the paths from *c* to a sink are the maximal ones — the geodesics that cannot be continued away from *c*. It is the graph analogue of the exponential map at *c*: every direction the observer can walk in without turning back towards *c*, with the branching left in.

With several sources the distance is to the nearest source, so the spray grows out of the whole set.

The pair form picks geodesics between each pair and takes the union of their path graphs. It enumerates, unlike the other two forms.

Options:

| Option | Default | Values |
|---|---|---|
| `"AxisLength"` | `All` | a depth *k*: keep only the vertices within distance *k* of the sources |
| `"PathThickness"` | `0` | pair form only: `0` keeps one geodesic per pair, `Infinity` all of them, *t* those within Hausdorff distance *t* of the first |
| `"Directed"` | `True` | `False` keeps the same edges undirected |

The spray keeps the embedding of *g*, so it is drawn in place.

## Basic Examples

The spray at the centre of a grid, drawn by the geodesics through each edge, and the spray itself cut at depth 3.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Row[{
    InfraHighlightGraph[g, {GeodesicSprayGraph[g, 41], Directive[$InfraPointColor], 41}, ImageSize -> 180],
    Graph[GeodesicSprayGraph[g, 41, "AxisLength" -> 3], ImageSize -> 180]}, Spacer[20]]]
```

The spray from the centre covers the grid, and its sinks are the four corners.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {sprayDag = GeodesicSprayGraph[g, 41]},
  {VertexCount[sprayDag], EdgeCount[sprayDag], Select[VertexList[sprayDag], VertexOutDegree[sprayDag, #] == 0 &]}]
```

The maximal geodesics from the centre: 70 to each corner.

```wl
With[
  {sprayDag = GeodesicSprayGraph[GridGraph[{9, 9}], 41]},
  Length /@ (FindPath[sprayDag, 41, #, Infinity, All] & /@ {1, 9, 73, 81})]
```

## Options

### PathThickness

One geodesic between the pair, every geodesic, or those within distance 1 of the first.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Table[EdgeCount @ GeodesicSprayGraph[g, {{1, 21}}, "PathThickness" -> t], {t, {0, 1, Infinity}}]]
```

## Properties and Relations

A layer of the spray is a shell: the vertices at depth *r* are [FindInfraShell]()`[g, c, r]`, and their number is the shell area.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {sprayDag = GeodesicSprayGraph[g, 41, "AxisLength" -> 3]},
  {Sort @ Complement[VertexList[sprayDag], FindInfraBall[g, 41, 2]] === FindInfraShell[g, 41, 3],
   VertexCount[sprayDag] === BallVolumes[g, 41, 3]}]
```

The geodesics from *c* to *v* are the paths of the spray from *c* to *v*; the [GeodesicIntervalGraph]() holds the same family.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Sort @ FindPath[GeodesicSprayGraph[g, 41], 41, 61, Infinity, All] ===
    Sort @ FindPath[GeodesicIntervalGraph[g, 41, 61], 41, 61, Infinity, All]]
```
