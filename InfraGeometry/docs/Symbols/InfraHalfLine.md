---
Template: Symbol
Name: InfraHalfLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHalfLine
Keywords: [ray, half-line, direction, pencil, symbolic object]
SeeAlso: [RayGraph, RandomInfraHalfLine, InfraHalfLineQ, InfraMeasurement, InfraInfiniteLine, InfraSegment]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraHalfLine]()[*p*, *q*]</code> is the ray from *p* through *q*: the family of all shortest paths from *p* through *q* that cannot be prolonged past their last vertex.

<code>[InfraHalfLine]()[*p*, *p*]</code> is the pencil at *p*: every ray from *p*.

## Details & Options

A ray from *p* is a shortest path *(p = v₀, …, vₙ)* whose end has no neighbour *u* with *d(p, u) = n + 1*. The ray from *p* through *q* is the family of the rays from *p* that pass through *q*.

A vertex *e* lies on the ray when it lies between *p* and *q*, or beyond *q*: *d(p, e) = d(p, q) + d(q, e)*. On the square grid the part beyond *q* is a quadrant when *q* is off the axes of *p*, and a half-plane when *q* is on one.

A ray ends where *d(p, ·)* has a local maximum. Rays with different ends can have different lengths. The ends of the pencil at *p* are all the local maxima of *d(p, ·)*.

[InfraHalfLine]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph, [RandomInfraHalfLine]() draws members and [InfraHalfLineQ]() tests one. A member is a vertex list that begins at *p*.

[InfraMeasurement]() reads:

| Property | Value |
|---|---|
| `"Graph"` | one DAG with source *p* whose source-to-sink paths are the rays, as [RayGraph]() |
| `"Cardinality"` | the number of rays |
| `"Length"` | the list of the lengths that occur |
| `"VertexDensity"` | the number of rays through each vertex |
| `"Faithful"` | `True` |

In an [InfraScene](), <code>[InfraHalfLine]()[*p*, *q*]</code> is the ray from the point *p* through the point *q*.

## Basic Examples

The ray from the centre through a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraHalfLine[p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three rays on the grid, with their lengths:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {members = RandomInfraHalfLine[g, InfraHalfLine[p, q], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[ray], p, q}, PlotLabel -> Length[ray] - 1], {ray, members}]]
```

The number of rays and the lengths that occur:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  InfraMeasurement[g, InfraHalfLine[p, q], {"Cardinality", "Length"}]]
```

## Scope

On the grid a ray along a row fills a half-plane beyond *q*, a diagonal ray a quadrant. The labels are the numbers of vertices covered:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[p, 2], "VertexDensity"]},
  {row = SelectFirst[shell, Length[RandomInfraSegment[g, p, #, All]] == 1 &]},
  {diagonal = SelectFirst[shell, Length[RandomInfraSegment[g, p, #, All]] == 2 &]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraHalfLine[p, q], p, q}, PlotLabel -> InfraMeasurement[g, InfraHalfLine[p, q], "CountingMeasure"]],
    {q, {row, diagonal}}]]
```

The pencil at the centre, with its ends: the vertices with no neighbour farther from the centre.

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {dag = InfraMeasurement[g, InfraHalfLine[p, p], "Graph"]},
    InfraSubstrateHighlight[g, {InfraHalfLine[p, p], Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &], p},
      PlotLabel -> InfraMeasurement[g, InfraHalfLine[p, p], "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The support of the ray is the interval from *p* to *q* together with the vertices *e* beyond *q*, *d(p, e) = d(p, q) + d(q, e)*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {beyond = Select[VertexList[g], GraphDistance[g, p, #] == GraphDistance[g, p, q] + GraphDistance[g, q, #] &]},
  Sort[Keys @ InfraMeasurement[g, InfraHalfLine[p, q], "VertexDensity"]] ===
    Union[beyond, Keys @ InfraMeasurement[g, InfraSegment[p, q], "VertexDensity"]]]
```

Every member satisfies [InfraHalfLineQ](), and the members are as many as the cardinality:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {members = RandomInfraHalfLine[g, InfraHalfLine[p, q], All]},
  {InfraHalfLineQ[g, members], Length[members] == InfraMeasurement[g, InfraHalfLine[p, q], "Cardinality"]}]
```
