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

Definition: the complexes *C^(k)_r* grow with the radius *r* and shrink with the order *k*. Over a grid of radii and orders they form a filtration in two parameters: the result is *bif[k][r] = C^(k)_r*.

For a fixed radius the orders run from the Vietoris–Rips complex at *k = 2* down to the Čech complex. In *ℝ^d* the balls are convex and by Helly's theorem the ladder stops at *k = d + 1*. On a graph the balls need not be convex, and the ladder can go on.

The options are those of [BallIntersectionComplex](): `"Metric"`, `"IntersectionTest"`, `"MaxDimension"`.

## Basic Examples

The number of simplices of sixteen random points in the plane against the radius, at orders 2, 3 and [Infinity](). Orders 3 and [Infinity]() coincide, as Helly's theorem says.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {bifiltration = BallIntersectionBifiltration[points, Range[0.02, 0.3, 0.02], {2, 3, Infinity}]},
  ListLinePlot[
    Table[KeyValueMap[{#1, Length[#2]} &, bifiltration[k]], {k, {2, 3, Infinity}}],
    PlotLegends -> {2, 3, Infinity},
    AxesLabel -> {"r", "simplices"}]]
```

On the square tiling, with the graph metric, the ladder does not stop at order 3. The vertices within distance 3 of the centre at radius 1: the four corners of each of the twelve squares drawn are a simplex of order 3 and not of order 4.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {data = FindInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 3]]},
  {bifiltration = BallIntersectionBifiltration[data, {1}, {3, 4}, "Metric" -> g, "MaxDimension" -> 3]},
  {gap = Complement[bifiltration[3][1], bifiltration[4][1]]},
  {InfraSubstrateHighlight[g, {data[[#]] & /@ gap}], Length[gap]}]
```

## Properties and Relations

For each radius the complexes shrink as the order grows; in the plane they stop shrinking at order 3.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {radii = Range[0.02, 0.3, 0.02]},
  {bifiltration = BallIntersectionBifiltration[points, radii, {2, 3, 4}]},
  {ListLinePlot[Table[KeyValueMap[{#1, Length[#2]} &, bifiltration[k]], {k, {2, 3, 4}}], PlotLegends -> {2, 3, 4}, AxesLabel -> {"r", "simplices"}],
   AllTrue[radii, r |-> SubsetQ[bifiltration[2][r], bifiltration[3][r]] && SubsetQ[bifiltration[3][r], bifiltration[4][r]]]}]
```
