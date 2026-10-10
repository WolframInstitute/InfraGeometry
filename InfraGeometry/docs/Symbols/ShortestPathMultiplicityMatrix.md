---
Template: Symbol
Name: ShortestPathMultiplicityMatrix
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ShortestPathMultiplicityMatrix
Keywords: [shortest paths, shortest paths, multiplicity, count matrix, path counting]
SeeAlso: [InfraSegment, InfraMeasurement, RandomInfraSegment, SprayGraph, InfraDensity]
RelatedGuides: [Experimental]
---

## Usage

<code>[ShortestPathMultiplicityMatrix]()[*graph*]</code> gives the matrix whose *(i, j)* entry is the number of shortest paths from the *i*-th to the *j*-th vertex, 0 when there is none.

## Details & Options

The vertices are taken in the order of <code>VertexList[*graph*]</code>. The diagonal is 1: the one path of length 0. Two vertices of different components have no path, and the entry is 0.

The matrix is symmetric for an undirected graph. The entry *(i, j)* is the `"Cardinality"` of the segment from the *i*-th to the *j*-th vertex, <code>[InfraMeasurement]()[*graph*, [InfraSegment]()[*u*, *v*], "Cardinality"]</code>, for all pairs at once.

The distance matrix is the built-in <code>GraphDistanceMatrix</code>; the earlier release returned it beside the counts, as a pair, and this function returns the counts only.

## Basic Examples

The numbers of shortest paths on the 3 × 3 grid. The opposite corners are joined by 6 = C(4, 2) shortest paths.

```wl
MatrixForm @ ShortestPathMultiplicityMatrix[GridGraph[{3, 3}]]
```

The matrix of a cycle: the opposite vertices of a cycle of even length are joined by two shortest paths.

```wl
MatrixPlot @ ShortestPathMultiplicityMatrix[CycleGraph[6]]
```

## Properties and Relations

The matrix is the cardinality of the segment between every pair.

```wl
With[
  {g = GridGraph[{3, 3}]},
  And @@ Table[ShortestPathMultiplicityMatrix[g][[1, j]] == InfraMeasurement[g, InfraSegment[1, j], "Cardinality"], {j, 2, 9}]]
```

On a path graph, or any tree, every entry is 1.

```wl
Union @ Flatten @ ShortestPathMultiplicityMatrix[PathGraph[Range[6]]]
```

The matrix of a disconnected graph is zero between the components.

```wl
MatrixForm @ ShortestPathMultiplicityMatrix[Graph[{1, 2, 3, 4}, {1 <-> 2, 3 <-> 4}]]
```
