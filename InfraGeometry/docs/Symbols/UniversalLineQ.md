---
Template: Symbol
Name: UniversalLineQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniversalLineQ
Keywords: [universal line, Chen-Chvátal conjecture, metric line, betweenness, de Bruijn-Erdős]
SeeAlso: [InfraInfiniteLine, RandomInfraInfiniteLine, LineCount, MetricInterval, InfraSegment]
---

## Usage

<code>[UniversalLineQ]()[*g*, {*u*, *v*}]</code> gives `True` if the line through *u* and *v* is the whole connected component of *g* containing them.

<code>[UniversalLineQ]()[*g*]</code> gives `True` if some two vertices of *g* span such a universal line.

## Details & Options

The line through *u* and *v* is the set of the vertices *w* such that one of *u*, *v*, *w* lies between the other two: *d(u, w) + d(w, v) = d(u, v)*, *d(w, u) + d(u, v) = d(w, v)* or *d(u, v) + d(v, w) = d(u, w)*. It is the union of the maximal geodesics through *u* and *v*.

In the plane a line through two points misses almost every point. In a graph a line can contain every vertex; it is then universal. On a full grid [GridGraph]() the line through any two adjacent vertices is universal.

Chen and Chvátal conjectured that a metric space on *n* points with no universal line has at least *n* distinct lines, the metric form of the de Bruijn–Erdős theorem.

The test reads every maximal geodesic of *g*, and is slow on graphs beyond a few dozen vertices.

## Basic Examples

On the 3 × 4 grid the line through two adjacent vertices, or through opposite corners, is universal; the line through two vertices on a short diagonal is not:

```wl
With[{g = GridGraph[{3, 4}]}, Table[UniversalLineQ[g, p], {p, {{5, 8}, {1, 12}, {1, 5}}}]]
```

The pairs that span a universal line, drawn as edges: the 17 edges of the grid and the two long diagonals, 19 of the 66 pairs:

```wl
With[{g = GridGraph[{3, 4}]}, {pairs = Select[Subsets[VertexList[g], {2}], UniversalLineQ[g, #] &]},
  Graph[VertexList[g], UndirectedEdge @@@ pairs, VertexCoordinates -> GraphEmbedding[g],
    PlotLabel -> Length[pairs], ImageSize -> Medium]]
```

## Scope

Which small graphs have a universal line. Two antipodal vertices of an even cycle span one, and so do the centre and a leaf of a star; an odd cycle, the Petersen graph and a complete graph have none:

```wl
UniversalLineQ /@ <|"C5" -> CycleGraph[5], "C6" -> CycleGraph[6], "Petersen" -> PetersenGraph[],
  "K4" -> CompleteGraph[4], "star" -> StarGraph[5]|>
```
