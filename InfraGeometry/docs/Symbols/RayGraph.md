---
Template: Symbol
Name: RayGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RayGraph
Keywords: [construction graph, ray, half-line, shortest path, directed acyclic graph]
SeeAlso: [InfraHalfLine, RandomInfraHalfLine, InfraMeasurement, IntervalGraph, BeamGraph, ArcGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RayGraph]()[*g*, *p*, *q*]</code> gives the directed acyclic graph whose paths from *p* to a sink are exactly the rays from *p* through *q*.

<code>[RayGraph]()[*g*, *p*, *p*]</code> gives the spray at *p*.

## Details & Options

A ray from *p* through *q* is a shortest path from *p* that passes through *q* and that no edge prolongs: its last vertex *s* has no neighbour farther from *p* than *s*.

The source is *p*. The sinks are the last vertices of the rays. On a finite substrate they lie on the rim, and the rays end at different distances from *p*.

The vertices are those of *g* on some ray, and the edges *u → v* step from distance *d(p, u)* to *d(p, u)* + 1.

<code>[RayGraph]()[*g*, *p*, *q*]</code> is <code>[InfraMeasurement]()[*g*, [InfraHalfLine]()[*p*, *q*], "Graph"]</code>.

## Basic Examples

The rays from the centre through a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {RayGraph[g, p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The sinks are where the rays end. On the grid they lie at distances 6 to 9 from the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {dag = RayGraph[g, p, q]},
  {sinks = Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &]},
  InfraSubstrateHighlight[g, {dag, sinks, p}, PlotLabel -> Union[GraphDistance[g, p, #] & /@ sinks],
    ImageSize -> Medium]]
```

## Properties and Relations

The number of rays is the number of paths from the source to a sink:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {dag = RayGraph[g, p, q]},
  {sinks = Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &]},
  {Total[Length @ FindPath[dag, p, #, Infinity, All] & /@ sinks],
   InfraMeasurement[g, InfraHalfLine[p, q], "Cardinality"]}]
```

The rays from *p* through *p* are all the maximal shortest paths from *p*, the [SprayGraph]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {p = First @ GraphCenter[g]},
  Sort @ EdgeList @ RayGraph[g, p, p] === Sort @ EdgeList @ SprayGraph[g, p]]
```
