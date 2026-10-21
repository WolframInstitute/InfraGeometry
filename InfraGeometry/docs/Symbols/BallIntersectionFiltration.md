---
Template: Symbol
Name: BallIntersectionFiltration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallIntersectionFiltration
Keywords: [filtration, ball intersection complex, Vietoris-Rips filtration, Cech filtration, persistence]
SeeAlso: [BallIntersectionComplex, BallIntersectionFiltrationValue, CechFiltration, BallIntersectionBifiltration]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallIntersectionFiltration]()[*data*, *radii*, *k*]</code> gives an [Association]() from each radius *r* of *radii*, in increasing order, to the order-*k* complex <code>[BallIntersectionComplex]()[*data*, *r*, *k*]</code>.

<code>[BallIntersectionFiltration]()[*data*, *radii*]</code> takes *k* = [Infinity](): the Čech filtration.

## Details & Options

For *r ≤ s* the complex at *r* is a subcomplex of the complex at *s*, so the complexes over the sorted radii form a filtration. A simplex *σ* enters at the first radius not below <code>[BallIntersectionFiltrationValue]()[*data*, *σ*, *k*]</code>.

The options are those of [BallIntersectionComplex](): `"Metric"`, `"IntersectionTest"`, `"MaxDimension"`. With `"Metric" -> g` the value of every simplex is an integer, so integer radii suffice.

## Basic Examples

The number of edges, triangles and tetrahedra of the order-2 complex of the lattice points of the ball of radius 3, against the radius. The steps are at half the lattice distances 1, √2, 2, √5:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  {filtration = BallIntersectionFiltration[points, Range[0.4, 1.2, 0.05], 2]},
  ListLinePlot[Table[KeyValueMap[{#1, Count[#2, s_ /; Length[s] == m]} &, filtration], {m, 2, 4}],
    PlotLegends -> {"edges", "triangles", "tetrahedra"}]]
```

Three stages of the same filtration, at 0.5, 0.71 and 1:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  GraphicsRow @ KeyValueMap[{r, complex} |->
    Graphics[{{StandardBlue, Opacity[0.15], Disk[#, r] & /@ points},
      {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
      {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]}, Point[points]}, PlotLabel -> r],
    BallIntersectionFiltration[points, {0.5, 0.71, 1.}, 2]]]
```

## Scope

With `"Metric" -> g` the data are vertices of a graph. The Čech filtration of the vertices within distance 3 of the centre, on the square grid and on the square mesh, at radii 0 to 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small"]},
    {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
    {filtration = BallIntersectionFiltration[data, Range[0, 3], Infinity, "Metric" -> g, "MaxDimension" -> 2]},
    ListLinePlot[Table[KeyValueMap[{#1, Count[#2, s_ /; Length[s] == m]} &, filtration], {m, 2, 3}],
      PlotLegends -> {"edges", "triangles"}, PlotLabel -> name]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

Each complex contains the one before:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  {filtration = BallIntersectionFiltration[points, Range[0.4, 1.2, 0.1], 2]},
  And @@ MapThread[SubsetQ, {Rest @ Values[filtration], Most @ Values[filtration]}]]
```

The radii are sorted, and each complex is the ball intersection complex at its radius:

```wl
With[{points = Select[Tuples[Range[-2, 2], 2], Total[Abs[#]] <= 2 &]},
  {filtration = BallIntersectionFiltration[points, {1, 0.5, 0.75}, 3]},
  {Keys[filtration], AllTrue[Keys[filtration], r |-> filtration[r] === BallIntersectionComplex[points, r, 3]]}]
```
