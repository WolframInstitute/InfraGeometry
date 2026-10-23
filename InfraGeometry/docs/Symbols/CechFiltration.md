---
Template: Symbol
Name: CechFiltration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CechFiltration
Keywords: [Cech filtration, nerve, filtration, persistence, Euler characteristic]
SeeAlso: [CechComplex, BallIntersectionFiltration, BallIntersectionBifiltration, MiniballRadius]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[CechFiltration]()[*data*, *radii*]</code> gives an [Association]() from each radius *r* of *radii*, in increasing order, to the Čech complex <code>[CechComplex]()[*data*, *r*]</code>.

## Details & Options

The Čech filtration is <code>[BallIntersectionFiltration]()[*data*, *radii*, [Infinity]()]</code>: the nested Čech complexes over the sorted radii. It takes the options of [BallIntersectionComplex]().

For Euclidean points a simplex enters at the radius of its smallest enclosing ball, its [MiniballRadius](). By the nerve theorem each complex has the homotopy type of the union of its balls.

## Basic Examples

The Euler characteristic of the Čech complex of the lattice points of the ball of radius 3, against the radius. It is 25, the number of points, below 1/2. From 1/2 the disks meet along the 36 edges of the grid and the union has 12 holes, one in each square: *25 − 36 = 1 − 12*. From *√2/2* the squares fill and it is 1:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  {filtration = CechFiltration[points, Range[0.05, 1.2, 0.05]]},
  ListLinePlot[KeyValueMap[{#1, Total[(-1)^(Length /@ #2 - 1)]} &, filtration], PlotMarkers -> Automatic]]
```

The complex at radius 0.6, with the 12 holes of the union of the disks:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]}, {complex = CechFiltration[points, {0.6}][0.6]},
  Graphics[{{StandardBlue, Opacity[0.15], Disk[#, 0.6] & /@ points},
    {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]}, Point[points]},
    PlotLabel -> Total[(-1)^(Length /@ complex - 1)], ImageSize -> Medium]]
```

## Scope

With `"Metric" -> g` the data are vertices of a graph. The number of simplices of the vertices within distance 2 of the centre of the grid, at radii 0 to 2. At radius 2 the centre lies within 2 of all 13 points, and every nonempty subset is a simplex, 2¹³ − 1 of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 2], "VertexDensity"]},
  Length /@ CechFiltration[data, Range[0, 2], "Metric" -> g]]
```

## Properties and Relations

The Čech filtration is the ball intersection filtration of order [Infinity]():

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]}, {radii = Range[0.4, 1.2, 0.1]},
  CechFiltration[points, radii] === BallIntersectionFiltration[points, radii, Infinity]]
```

A simplex enters at its miniball radius. The corners of a unit square: a side enters at 1/2, the whole square at *√2/2 ≈ 0.707*. The largest simplex at each radius:

```wl
With[{square = {{0, 0}, {1, 0}, {1, 1}, {0, 1}}},
  {Max[Length /@ #] & /@ CechFiltration[square, {0.49, 0.5, 0.7, 0.71}], MiniballRadius /@ {square[[{1, 2}]], square}}]
```
