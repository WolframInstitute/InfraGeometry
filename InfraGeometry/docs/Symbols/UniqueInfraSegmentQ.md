---
Template: Symbol
Name: UniqueInfraSegmentQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniqueInfraSegmentQ
Keywords: [unique shortest path, geodetic graph, segment, uniqueness, test]
SeeAlso: [InfraSegment, InfraMeasurement, RandomInfraSegment, MetricInterval, IntervalGraph]
---

## Usage

<code>[UniqueInfraSegmentQ]()[*g*, *u*, *v*]</code> gives `True` if there is exactly one shortest path from *u* to *v* in *g*.

<code>[UniqueInfraSegmentQ]()[*g*]</code> gives `True` if *g* is geodetic: every two vertices are joined by exactly one shortest path.

## Details & Options

The test is that the segment <code>[InfraSegment]()[*u*, *v*]</code> has cardinality 1. In the plane every segment is unique; on a graph uniqueness is the exception.

On the square grid the shortest path from *u* to *v* is unique exactly when *u* and *v* lie on one row or one column; otherwise there are *C(a + b, a)* of them, with *a* and *b* the steps along the two axes.

Trees, complete graphs, odd cycles and the Petersen graph are geodetic. Even cycles and grids are not.

## Basic Examples

The vertices within distance 4 of the centre joined to it by a unique shortest path. On the grid they are the two axes:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {near = Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]},
    {unique = Select[near, UniqueInfraSegmentQ[g, c, #] &]},
    InfraSubstrateHighlight[g, {InfraBall[c, 4], unique, c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Which small graphs are geodetic:

```wl
UniqueInfraSegmentQ /@ <|"C7" -> CycleGraph[7], "C6" -> CycleGraph[6], "Petersen" -> PetersenGraph[],
  "K5" -> CompleteGraph[5], "tree" -> KaryTree[10]|>
```

## Properties and Relations

The test is that the segment has cardinality 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Table[{InfraMeasurement[g, InfraSegment[45, v], "Cardinality"], UniqueInfraSegmentQ[g, 45, v]},
    {v, {48, 57, 67}}]]
```
