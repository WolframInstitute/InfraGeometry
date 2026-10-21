---
Template: Symbol
Name: ArcGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ArcGraph
Keywords: [construction graph, arc, circle, band, directed acyclic graph]
SeeAlso: [InfraArc, InfraMeasurement, IntervalGraph, RayGraph, BeamGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[ArcGraph]()[*g*, *c*, {*p*, *q*}]</code> gives the directed acyclic graph whose paths from *p* to *q* are the arcs around *c* from *p* to *q*.

<code>[ArcGraph]()[*g*, *c*, {*p*}]</code> gives the graph of the closed arc: a list of DAGs whose paths from *p* to a copy of *p* are the circles around *c* through *p*.

## Details & Options

<code>[ArcGraph]()[*g*, *c*, *points*]</code> is <code>[InfraMeasurement]()[*g*, [InfraArc]()[*c*, *points*], "Graph"]</code>. The arcs are the shortest paths from *p* to *q* in the band of the circle through *p*; see [InfraArc]().

For an open arc the graph is the interval DAG of the band from *p* to *q*, the [IntervalGraph]() of the subgraph induced on the band.

For a closed arc the circle is cut open at *p*. The sink is the vertex `{p, 3/2}`, a second copy of *p*, so the graph is acyclic and each circle through *p* is one path from *p* to `{p, 3/2}`.

A list of points with more than two entries gives the graph of the polyline arc.

| Option | Default | Values |
|---|---|---|
| `"RadiusDelta"` | `0` | *δ* for the band {*r*, *r* + *δ*}, {*δᵢₙ*, *δₒᵤₜ*} for {*r* − *δᵢₙ*, *r* + *δₒᵤₜ*}, with *r = d(c, p)* |

## Basic Examples

The arc graph between two farthest points of the circle of radius 3, drawn on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {ArcGraph[g, c, pq, "RadiusDelta" -> 1], c, pq}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The graph on its own. Its source is *p*, its sink *q*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {dag = ArcGraph[g, c, pq, "RadiusDelta" -> 1]},
  {pq, Select[VertexList[dag], VertexInDegree[dag, #] == 0 &], Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &]}]
```

## Scope

The closed arc through a point at distance 3 on the mesh. The 14 paths from *p* to its copy `{p, 3/2}` are the 14 circles through *p*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {dag = First @ ArcGraph[g, c, {p}, "RadiusDelta" -> 1]},
  {Length @ FindPath[dag, p, {p, 3/2}, Infinity, All], InfraMeasurement[g, InfraArc[c, {p}, "RadiusDelta" -> 1], "Cardinality"]}]
```

## Properties and Relations

The paths of the graph are the arcs, so their number is the cardinality of the arc:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {Length @ FindPath[ArcGraph[g, c, pq, "RadiusDelta" -> 1], First[pq], Last[pq], Infinity, All],
   InfraMeasurement[g, InfraArc[c, pq, "RadiusDelta" -> 1], "Cardinality"]}]
```

It is the [IntervalGraph]() of the band:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pq = RandomInfraPoint[g, InfraShell[c, 3], 2, "PairwiseDistance" -> "Max", RandomSeeding -> 1]},
  {band = Keys @ InfraMeasurement[g, InfraShell[c, {3, 4}], "VertexDensity"]},
  ArcGraph[g, c, pq, "RadiusDelta" -> 1] === IntervalGraph[Subgraph[g, band], First[pq], Last[pq]]]
```
