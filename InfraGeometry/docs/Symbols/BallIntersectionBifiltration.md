---
Template: Symbol
Name: BallIntersectionBifiltration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallIntersectionBifiltration
Keywords: [bifiltration, ball intersection complex, Vietoris-Rips complex, Cech complex, Helly, multiparameter persistence]
SeeAlso: [BallIntersectionComplex, BallIntersectionFiltration, CechFiltration, BallIntersectionFiltrationValue]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallIntersectionBifiltration]()[*data*, *radii*, *orders*]</code> gives an [Association]() from each order *k* of *orders* to the filtration <code>[BallIntersectionFiltration]()[*data*, *radii*, *k*]</code>.

## Details & Options

The complexes *Cᵣ⁽ᵏ⁾* grow with the radius *r* and shrink with the order *k*. Over a grid of radii and orders they form a filtration in two parameters, *bif[k][r] = Cᵣ⁽ᵏ⁾*.

For a fixed radius the orders run from the Vietoris–Rips complex at *k* = 2 down to the Čech complex at *k* = [Infinity](). In *ℝᵈ* the balls are convex, and by Helly's theorem the sequence stops at *k = d + 1*. On a graph it can go on: on the square grid the four corners of a square are a simplex of order 3 at radius 1, not of order 4.

The options are those of [BallIntersectionComplex](): `"Metric"`, `"IntersectionTest"`, `"MaxDimension"`.

## Basic Examples

The four corners of a square of the grid, with the graph metric. Whether they form a simplex, at orders 2, 3 and 4 and radii 1 and 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {corners = First /@ First @ FindCycle[{g, First @ GraphCenter[g]}, {4}]},
  {bif = BallIntersectionBifiltration[corners, {1, 2}, {2, 3, 4}, "Metric" -> g]},
  Table[MemberQ[bif[k][r], {1, 2, 3, 4}], {k, {2, 3, 4}}, {r, {1, 2}}]]
```

The vertices within distance 3 of the centre of the grid at radius 1. The sets of four that are simplices of order 3 and not of order 4 are the 12 squares of the grid in that ball. They are drawn as a density: the size of a vertex is the number of these squares it is a corner of:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {data = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 3], "VertexDensity"]},
  {bif = BallIntersectionBifiltration[data, {1}, {3, 4}, "Metric" -> g, "MaxDimension" -> 3]},
  {gap = Complement[bif[3][1], bif[4][1]]},
  InfraSubstrateHighlight[g, {data, data[[#]] & /@ gap}, PlotLabel -> Length[gap], ImageSize -> Medium]]
```

## Properties and Relations

For Euclidean points the sequence stops at order 3. The number of simplices of the lattice points of the ball of radius 3 against the radius, at orders 2, 3 and [Infinity](). Orders 3 and [Infinity]() agree at every radius; order 2 has more simplices from 1.15 on:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  {bif = BallIntersectionBifiltration[points, Range[0.4, 1.2, 0.05], {2, 3, Infinity}]},
  ListLinePlot[Table[KeyValueMap[{#1, Length[#2]} &, bif[k]], {k, {2, 3, Infinity}}], PlotLegends -> {2, 3, Infinity}]]
```

At every radius the complexes shrink as the order grows:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]}, {radii = Range[0.4, 1.2, 0.1]},
  {bif = BallIntersectionBifiltration[points, radii, {2, 3, 4}]},
  AllTrue[radii, r |-> SubsetQ[bif[2][r], bif[3][r]] && SubsetQ[bif[3][r], bif[4][r]]]]
```
