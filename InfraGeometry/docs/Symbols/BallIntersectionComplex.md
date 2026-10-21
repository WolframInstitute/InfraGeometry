---
Template: Symbol
Name: BallIntersectionComplex
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallIntersectionComplex
Keywords: [ball intersection complex, Cech complex, Vietoris-Rips complex, nerve, Helly, simplicial complex, miniball]
SeeAlso: [CechComplex, MiniballRadius, BallIntersectionFiltrationValue, BallIntersectionFiltration, BallIntersectionBifiltration, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallIntersectionComplex]()[*data*, *r*, *k*]</code> gives the order-*k* complex of the balls of radius *r* about the points of *data*: a set of balls is a simplex when every *k* of them have a common point.

<code>[BallIntersectionComplex]()[*data*, *r*]</code> takes *k* = [Infinity](): the Čech complex.

## Details & Options

Let *Bᵢ* be the closed ball of radius *r* about the *i*-th point. A set *σ* of positions is a simplex of *Cᵣ⁽ᵏ⁾* when every subset of *σ* with *min(k, |σ|)* elements has balls with a common point.

At *k* = 2 it is the Vietoris–Rips complex of the pairs at distance at most *2r*, for Euclidean points and for a graph at integer *r*. At *k* = [Infinity]() it is the Čech complex, the nerve of the balls. In between, *C⁽²⁾ ⊇ C⁽³⁾ ⊇ … ⊇ C⁽∞⁾*.

Balls in *ℝᵈ* are convex, and by Helly's theorem the sequence stops at *k = d + 1*. On a graph it can go on, already on the square grid.

A simplex is a sorted list of positions in *data*.

| Option | Default | Values |
|---|---|---|
| `"Metric"` | [Automatic]() | [Automatic]() for Euclidean points; a graph *g*; a distance matrix of *data*; a distance function |
| `"IntersectionTest"` | [Automatic]() | a test on the common region of Euclidean balls; [Automatic]() asks for a nonempty region |
| `"MaxDimension"` | [Infinity]() | the largest dimension of a simplex |

The common point depends on the metric:

| `"Metric"` | the balls meet when |
|---|---|
| [Automatic]() | <code>[MiniballRadius]()[*points*] ≤ *r*</code> |
| a graph *g* | some vertex of *g* lies within *r* of every centre |
| a matrix or a function | some point of *data* lies within *r* of every centre |

## Basic Examples

The balls of radius 1 about the four corners of a square of the grid. Every three meet, at a corner, but the four have no common vertex: the square is a simplex of order 3, not of order 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {corners = First /@ First @ FindCycle[{g, First @ GraphCenter[g]}, {4}]},
  InfraSubstrateHighlight[g, InfraBall[#, 1] & /@ corners,
    PlotLabel -> Table[MemberQ[BallIntersectionComplex[corners, 1, k, "Metric" -> g], {1, 2, 3, 4}], {k, {3, 4}}],
    ImageSize -> Medium]]
```

An equilateral triangle of side 1 with disks of radius 0.55. The disks meet in pairs but have no common point: the triangle is a simplex of order 2, not of order 3:

```wl
With[{points = N @ CirclePoints[1 / Sqrt[3], 3]},
  GraphicsRow @ Table[
    With[{complex = BallIntersectionComplex[points, 0.55, k]},
      Graphics[{{StandardBlue, Opacity[0.15], Disk[#, 0.55] & /@ points},
        {StandardRed, Opacity[0.4], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]}, Point[points]},
        PlotLabel -> k]],
    {k, {2, 3}}]]
```

## Scope

The vertices within distance 3 of the centre of the grid, at radius 1, with the graph metric. The number of simplices of each size at orders 2, 3, 4 and [Infinity](). Orders 2 and 3 agree, and so do 4 and [Infinity](); the 12 sets of four between them are the squares of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
  Table[Counts[Length /@ BallIntersectionComplex[data, 1, k, "Metric" -> g]], {k, {2, 3, 4, Infinity}}]]
```

## Options

### Metric

Two vertices of the grid at distance 2. With the graph their balls of radius 1 meet at a vertex between them; with the distance matrix of the two alone they do not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {pair = {c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]}},
  {BallIntersectionComplex[pair, 1, 2, "Metric" -> g], BallIntersectionComplex[pair, 1, 2, "Metric" -> {{0, 2}, {2, 0}}]}]
```

### IntersectionTest

At radius 0.6 the three disks about the triangle meet in a small region. Asking for an area above 0.05 drops the triangle:

```wl
With[{points = N @ CirclePoints[1 / Sqrt[3], 3]},
  Table[MemberQ[BallIntersectionComplex[points, 0.6, Infinity, "IntersectionTest" -> test], {1, 2, 3}],
    {test, {Automatic, RegionMeasure[#] > 0.05 &}}]]
```

### MaxDimension

`"MaxDimension" -> 1` keeps the vertices and the edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
  Counts[Length /@ BallIntersectionComplex[data, 1, 2, "Metric" -> g, "MaxDimension" -> 1]]]
```

## Properties and Relations

The edges of order 2 are the pairs at distance at most *2r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
  Select[BallIntersectionComplex[data, 1, 2, "Metric" -> g], Length[#] == 2 &] ===
    Select[Subsets[Range @ Length[data], {2}], GraphDistance[g, ##] <= 2 & @@ data[[#]] &]]
```

For points in the plane order 3 is the Čech complex. The lattice points of the ball of radius 3, at radius 1.2:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  {BallIntersectionComplex[points, 1.2, 3] === BallIntersectionComplex[points, 1.2],
   Length /@ {BallIntersectionComplex[points, 1.2, 2], BallIntersectionComplex[points, 1.2]}}]
```
