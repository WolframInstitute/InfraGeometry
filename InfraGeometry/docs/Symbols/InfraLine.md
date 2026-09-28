---
Template: Symbol
Name: InfraLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraLine
Keywords: [line, inextensible geodesic, atoms, inert head]
SeeAlso: [FindInfraLine, InfraLineQ, InfraMeasurement, InfraVertexList, InfraSegment, InfraRay]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraLine]()[*p*, *q*]</code> is the line through *p* and *q*: every inextensible geodesic through *p* and then *q*. It is inert; [InfraMeasurement]() and [InfraVertexList]() evaluate it on a graph.

<code>[InfraLine]()[*p*, *q*]</code> inside an [InfraScene]() is the line construction token; [FindInfraLine]() is the search.

## Details & Options

Definition: a line is an inextensible geodesic — a shortest path that no neighbour of either end prolongs.

Its graph — <code>[InfraMeasurement]()[*g*, *line*, "Graph"]</code> — is a `List` of DAGs, one per pair of ends (*a*, *b*) that is compatible, *d(a, b) = d(a, p) + d(p, q) + d(q, b)*, and maximal, no neighbour of *a* or *b* lengthening *d(a, b)*. The DAG for (*a*, *b*) is the union of the intervals *I(a, p)*, *I(p, q)* and *I(q, b)*. Its chains are exactly the lines with those ends, and every line is a chain of exactly one DAG, so `"Faithful"` is `True`.

The list is not optional. The union of the DAGs can carry chains that are not geodesics: through the edge 1–2 of the 6-cycle there are three DAGs and three lines, while their union would add a fourth path that is not a geodesic.

The DAGs are alternatives, so the counts add across them. The family can be astronomical while the list stays small.

With *p* = *q*, <code>[InfraLine]()[*p*, *p*]</code> is every maximal geodesic through *p*, once per orientation.

## Basic Examples

Twelve lines pass the interior edge 6–7 of a 4 × 4 grid, carried by two DAGs.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {line = InfraLine[6, 7]},
  {Length @ InfraMeasurement[g, line, "Graph"], InfraMeasurement[g, line, "Cardinality"],
   InfraMeasurement[g, line, "Length"]}
]
```

Two of them.

```wl
InfraVertexList[GridGraph[{4, 4}], InfraLine[6, 7], 2]
```

Through an edge of the 6-cycle there are three lines, one per DAG.

```wl
With[
  {g = CycleGraph[6]},
  {Length @ InfraMeasurement[g, InfraLine[1, 2], "Graph"], InfraVertexList[g, InfraLine[1, 2], All]}
]
```

## Properties and Relations

The anchors lie on every line, so their density is the cardinality.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {density = InfraMeasurement[g, InfraLine[6, 7], "VertexDensity"]},
  {density[6], density[7], density[1]}
]
```

Every member satisfies [InfraLineQ]().

```wl
With[
  {g = GridGraph[{4, 4}]},
  InfraLineQ[g, InfraVertexList[g, InfraLine[6, 7], All]]
]
```
