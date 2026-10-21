---
Template: Symbol
Name: BeamGraph
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BeamGraph
Keywords: [construction graph, line, inextensible shortest path, directed acyclic graph]
SeeAlso: [InfraInfiniteLine, InfraMeasurement, IntervalGraph, RayGraph, ArcGraph, SprayGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[BeamGraph]()[*g*, *p*, *q*]</code> gives the list of directed acyclic graphs whose source-to-sink paths are the lines through *p* and then *q*.

<code>[BeamGraph]()[*g*, *germ*]</code> gives the list of DAGs of the lines that contain the shortest path *germ*.

## Details & Options

<code>[BeamGraph]()[*g*, *p*, *q*]</code> is <code>[InfraMeasurement]()[*g*, [InfraInfiniteLine]()[*p*, *q*], "Graph"]</code>. A line is an inextensible shortest path; see [InfraInfiniteLine]().

There is one DAG for each pair of ends *a*, *b* with *d(a, b) = d(a, p) + d(p, q) + d(q, b)* that no neighbour of *a* or *b* prolongs. The DAG is the union of the intervals *I(a, p)*, *I(p, q)* and *I(q, b)*, from source *a* to sink *b*.

The list must not be merged. The union of two DAGs can carry a path from one end to another that is not a shortest path.

In the germ form the middle interval *I(p, q)* is replaced by the germ itself.

## Basic Examples

The DAGs of the line through the centre and a vertex at distance 2 on the square grid, drawn together, and their number:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {dags = BeamGraph[g, p, q]},
  InfraSubstrateHighlight[g, Join[dags, {p, q}], PlotLabel -> Length[dags], ImageSize -> Medium]]
```

Three of the DAGs on the square mesh, each drawn with its source and its sink:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {dag, Select[VertexList[dag], VertexInDegree[dag, #] == 0 || VertexOutDegree[dag, #] == 0 &]}],
    {dag, Take[BeamGraph[g, p, q], 3]}]]
```

## Scope

The germ form keeps one shortest path from *p* to *q* in the middle. On the grid each of the two germs between diagonal neighbours keeps all 64 pairs of ends, and half of the lines:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]}, {germs = RandomInfraSegment[g, p, q, All]},
  {Length @ BeamGraph[g, p, q], Length @ BeamGraph[g, #] & /@ germs,
   InfraMeasurement[g, InfraInfiniteLine[p, q], "Cardinality"], InfraMeasurement[g, InfraInfiniteLine[#], "Cardinality"] & /@ germs}]
```

## Properties and Relations

On the 6-cycle the line through an edge has three DAGs, one line each. Their union carries the path 5, 6, 1, 2, 3, 4, which is not a shortest path, since 5 and 4 are adjacent:

```wl
With[{g = CycleGraph[6]}, {dags = BeamGraph[g, 1, 2]},
  {Length[dags], FindPath[GraphUnion @@ dags, 5, 4], GraphDistance[g, 5, 4]}]
```

Each DAG has one source and one sink. Its source-to-sink paths are the lines with those ends, so their total number is the cardinality of the line:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {Total @ Table[
    Length @ FindPath[dag, First @ Select[VertexList[dag], VertexInDegree[dag, #] == 0 &],
      First @ Select[VertexList[dag], VertexOutDegree[dag, #] == 0 &], Infinity, All],
    {dag, BeamGraph[g, p, q]}], InfraMeasurement[g, InfraInfiniteLine[p, q], "Cardinality"]}]
```
