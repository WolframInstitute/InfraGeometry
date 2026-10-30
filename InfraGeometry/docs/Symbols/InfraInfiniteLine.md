---
Template: Symbol
Name: InfraInfiniteLine
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraInfiniteLine
Keywords: [line, inextensible shortest path, germ, symbolic object]
SeeAlso: [BeamGraph, RandomInfraInfiniteLine, InfraInfiniteLineQ, InfraMeasurement, InfraSegment, InfraHalfLine]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraInfiniteLine]()[*p*, *q*]</code> is the line through *p* and *q*: the family of all inextensible shortest paths that pass through *p* and then *q*.

<code>[InfraInfiniteLine]()[*germ*]</code> is the line through a germ: the inextensible shortest paths that contain the shortest path *germ* as a contiguous stretch.

## Details & Options

A line is a shortest path *(v₀, …, vₙ)*, *d(v₀, vₙ) = n*, that no neighbour of either end prolongs: no *u* adjacent to *v₀* has *d(u, vₙ) = n + 1*, and likewise at *vₙ*.

A graph line is finite and ends where the graph does not let it go on. A line through *p* and *q* has ends *a* and *b* with *d(a, b) = d(a, p) + d(p, q) + d(q, b)*, and its length is *d(a, b)*: lines through the same two points can have different lengths.

The line through two points is not unique. On the square grid it is a large family, and its support covers whole quadrants.

[InfraInfiniteLine]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph, [RandomInfraInfiniteLine]() draws members and [InfraInfiniteLineQ]() tests one. A member is a vertex list.

[InfraMeasurement]() reads:

| Property | Value |
|---|---|
| `"Graph"` | a list of DAGs, one per pair of ends *a*, *b*: the union of the intervals *I(a, p)*, *I(p, q)*, *I(q, b)*, as [BeamGraph]() |
| `"Cardinality"` | the number of lines |
| `"Length"` | the list of the lengths that occur |
| `"VertexDensity"` | the number of lines through each vertex |
| `"Faithful"` | `True`: the source-to-sink paths of the DAGs are exactly the lines |

The DAGs are not merged: their union can carry paths that are not shortest paths.

A line through *p* and *q* contains exactly one shortest path from *p* to *q*, so the line through *p* and *q* is the disjoint union of the lines through its germs. A germ has no unique line through it either: <code>[InfraInfiniteLine]()[*germ*]</code> is still a family. The two ends of a line are admissible only as a pair, so the family is smaller than the product of the two extension sets. On the 4-cycle the edge 1, 2 extends to 4, 1, 2 and to 1, 2, 3, but not to 4, 1, 2, 3. <code>[InfraInfiniteLine]()[*p*, *p*]</code> is every inextensible shortest path through *p*, once in each direction.

In an [InfraScene](), <code>[InfraInfiniteLine]()[*p*, *q*]</code> is the line through the points *p* and *q*.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 2 | To produce a finite straight line continuously in a straight line; here a segment is prolonged until the graph stops it. |

## Basic Examples

The line through the centre and a vertex at distance 2, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraInfiniteLine[p, q], p, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Three members on the grid. Each runs from rim to rim, and their lengths differ:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {members = RandomInfraInfiniteLine[g, InfraInfiniteLine[p, q], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraWalk[line], p, q}, PlotLabel -> Length[line] - 1], {line, members}]]
```

## Scope

On the grid the direction matters. The line through two points of a row reaches almost every vertex, the line through two points of a diagonal two opposite quadrants. The labels are the numbers of vertices covered:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[p, 2], "VertexDensity"]},
  {row = SelectFirst[shell, Length[RandomInfraSegment[g, p, #, All]] == 1 &]},
  {diagonal = SelectFirst[shell, Length[RandomInfraSegment[g, p, #, All]] == 2 &]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraInfiniteLine[p, q], p, q}, PlotLabel -> InfraMeasurement[g, InfraInfiniteLine[p, q], "CountingMeasure"]],
    {q, {row, diagonal}}]]
```

A germ fixes the middle stretch. The two shortest paths from *p* to a diagonal *q* split the lines through *p* and *q* in two:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {germs = RandomInfraSegment[g, p, q, All]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraInfiniteLine[germ], InfraWalk[germ]},
      PlotLabel -> InfraMeasurement[g, InfraInfiniteLine[germ], "Cardinality"]],
    {germ, germs}]]
```

With *p* = *q* every line through *p* counts once in each direction:

```wl
RandomInfraInfiniteLine[PathGraph[Range[5]], InfraInfiniteLine[3, 3], All]
```

## Properties and Relations

On the 6-cycle the line through the edge 1, 2 has three members, one per DAG. Each side alone extends to two vertices, but the far pair 5, 4 is adjacent, so three lines, not four:

```wl
With[{g = CycleGraph[6]}, {dags = InfraMeasurement[g, InfraInfiniteLine[1, 2], "Graph"]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {dag, 1, 2}], {dag, dags}]]
```

The same three lines, as members of the germ form:

```wl
RandomInfraInfiniteLine[CycleGraph[6], InfraInfiniteLine[{1, 2}], All]
```

The union of the three DAGs carries the path 5, 6, 1, 2, 3, 4 from 5 to 4, which is no shortest path:

```wl
With[{g = CycleGraph[6]}, {union = GraphUnion @@ InfraMeasurement[g, InfraInfiniteLine[1, 2], "Graph"]},
  {FindPath[union, 5, 4], GraphDistance[g, 5, 4]}]
```

Every ray from *p* through *q* is the tail of a line through *p* and *q*. Not conversely: a line stops where no step leads farther from its other end, which can come before a ray stops. On the mesh 22 rays and 28 tails:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {p = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[p, 2], RandomSeeding -> 1]},
  {tails = Union[Drop[#, First @ FirstPosition[#, p] - 1] & /@ RandomInfraInfiniteLine[g, InfraInfiniteLine[p, q], All]]},
  {rays = RandomInfraHalfLine[g, InfraHalfLine[p, q], All]},
  {SubsetQ[tails, rays], Length[rays], Length[tails]}]
```

## Possible Issues

A shortest path has no unique line through it. On the 4-cycle the edge 1, 2 lies on two lines, and neither contains the other:

```wl
RandomInfraInfiniteLine[CycleGraph[4], InfraInfiniteLine[{1, 2}], All]
```
