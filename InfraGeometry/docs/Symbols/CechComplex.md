---
Template: Symbol
Name: CechComplex
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CechComplex
Keywords: [Cech complex, nerve, ball cover, simplicial complex, miniball]
SeeAlso: [BallIntersectionComplex, CechFiltration, MiniballRadius, FindBallCover, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[CechComplex]()[*data*, *r*]</code> gives the Čech complex of the balls of radius *r* about the points of *data*: a set of balls is a simplex when they have a common point.

## Details & Options

The Čech complex is the nerve of the balls *Bᵢ*: the sets *σ* of positions with *⋂ Bᵢ ≠ ∅*, *i ∈ σ*. It is <code>[BallIntersectionComplex]()[*data*, *r*, [Infinity]()]</code> and takes the same options, `"Metric"`, `"IntersectionTest"` and `"MaxDimension"`.

For Euclidean points a set is a simplex when its points fit in a ball of radius *r*: <code>[MiniballRadius]()[*points*] ≤ *r*</code>. The balls are convex, and by the nerve theorem the complex has the homotopy type of the union of the balls.

With `"Metric" -> g` the points are vertices of the graph *g*, and a set is a simplex when some vertex of *g* lies within *r* of each of them.

A simplex is a sorted list of positions in *data*.

## Basic Examples

The nerve of a smallest cover by balls of radius 3, on the square grid and on the square mesh. A line joins two centres whose balls meet:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {cover = FindBallCover[g, 3]},
    {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    {edges = Select[CechComplex[cover, 3, "Metric" -> g], Length[#] == 2 &]},
    Show[InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ cover],
      Graphics[{Thick, Line[Lookup[xy, cover[[#]]]] & /@ edges}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The lattice points of the ball of radius 3 of the grid, with disks of radius 0.5 and 0.75. At 0.5 the disks meet along the edges of the grid; at 0.75 the four disks at the corners of each square meet, and the complex fills the diamond:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  GraphicsRow @ Table[
    With[{complex = CechComplex[points, r]},
      Graphics[{{StandardBlue, Opacity[0.15], Disk[#, r] & /@ points},
        {StandardRed, Opacity[0.4], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
        {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]}, Point[points]}, PlotLabel -> r]],
    {r, {0.5, 0.75}}]]
```

## Scope

With the graph metric the common point can be any vertex of the graph. The four corners of a square of the grid: the largest simplex has 3 vertices at radius 1 and all 4 at radius 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {corners = First /@ First @ FindCycle[{g, First @ GraphCenter[g]}, {4}]},
  Table[Max[Length /@ CechComplex[corners, r, "Metric" -> g]], {r, 1, 2}]]
```

`"MaxDimension"` bounds the size of the simplices:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  Table[Counts[Length /@ CechComplex[points, 0.75, "MaxDimension" -> m]], {m, 1, 3}]]
```

## Properties and Relations

A set of Euclidean points is a simplex exactly when its smallest enclosing ball has radius at most *r*. The lattice points of the ball of radius 2 at radius 0.75:

```wl
With[{points = Select[Tuples[Range[-2, 2], 2], Total[Abs[#]] <= 2 &]},
  CechComplex[points, 0.75] === Select[Subsets[Range @ Length[points], {1, 4}], MiniballRadius[points[[#]]] <= 0.75 &]]
```

The Čech complex is the ball intersection complex of order [Infinity]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 2], "VertexDensity"]},
  CechComplex[data, 1, "Metric" -> g] === BallIntersectionComplex[data, 1, Infinity, "Metric" -> g]]
```
