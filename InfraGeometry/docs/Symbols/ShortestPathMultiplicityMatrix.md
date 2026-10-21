---
Template: Symbol
Name: ShortestPathMultiplicityMatrix
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ShortestPathMultiplicityMatrix
Keywords: [shortest paths, multiplicity, count matrix, path counting, geodetic]
SeeAlso: [InfraSegment, InfraMeasurement, RandomInfraSegment, UniqueInfraSegmentQ, SprayGraph]
RelatedGuides: [Experimental]
---

## Usage

<code>[ShortestPathMultiplicityMatrix]()[*g*]</code> gives the matrix whose entry *(i, j)* is the number of shortest paths from the *i*-th to the *j*-th vertex of *g*.

## Details & Options

The entry *σ(u, v)* is the number of shortest paths from *u* to *v*, the `"Cardinality"` of <code>[InfraSegment]()[*u*, *v*]</code>. The vertices are in the order of [VertexList]().

The diagonal is 1, the path of length 0. Between two components the entry is 0. On an undirected graph the matrix is symmetric.

On the square grid, with *a* steps from *u* to *v* along one axis and *b* along the other, *σ(u, v) = C(a + b, a)*.

All entries are 1 exactly when every two vertices are joined by one shortest path, as on a tree or an odd cycle; [UniqueInfraSegmentQ]() tests this.

The distance matrix is [GraphDistanceMatrix]().

## Basic Examples

The number of shortest paths from the centre to every vertex, drawn as the size of the vertex, on the square grid and on the square mesh. On the grid the largest is *C(8, 4) = 70*, at the corner four steps right and four up:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {row = ShortestPathMultiplicityMatrix[g][[First @ FirstPosition[VertexList[g], c]]]},
    InfraSubstrateHighlight[g, {AssociationThread[VertexList[g], row], c}, PlotLabel -> Max[row]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the 3 × 3 grid graph opposite corners are joined by *C(4, 2) = 6* shortest paths:

```wl
MatrixForm @ ShortestPathMultiplicityMatrix[GridGraph[{3, 3}]]
```

## Properties and Relations

A row of the matrix is the cardinality of the segments from one vertex:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  ShortestPathMultiplicityMatrix[g][[First @ FirstPosition[VertexList[g], c]]] ==
    (InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] & /@ VertexList[g])]
```

On a tree and on an odd cycle every entry is 1; opposite vertices of an even cycle are joined by two shortest paths:

```wl
Table[{Union @ Flatten @ ShortestPathMultiplicityMatrix[g], UniqueInfraSegmentQ[g]},
  {g, {KaryTree[15], CycleGraph[7], CycleGraph[6]}}]
```

## Possible Issues

Between two components there is no path, and the entry is 0:

```wl
MatrixForm @ ShortestPathMultiplicityMatrix[Graph[{1, 2, 3, 4}, {1 <-> 2, 3 <-> 4}]]
```
