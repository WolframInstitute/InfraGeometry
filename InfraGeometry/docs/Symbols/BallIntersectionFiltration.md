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

<code>[BallIntersectionFiltration]()[*data*, *radii*]</code> takes *k* = [Infinity](), the Čech filtration.

## Details & Options

Definition: for *r ≤ s* the complex at *r* is a subcomplex of the complex at *s*, so the complexes over the sorted radii form a filtration. A simplex enters at the first radius not below its value <code>[BallIntersectionFiltrationValue]()[*data*, *σ*, *k*]</code>.

The radii are sorted. The options are those of [BallIntersectionComplex](): `"Metric"`, `"IntersectionTest"`, `"MaxDimension"`.

The association is the form a persistence computation reads. Under `"MaxDimension"` -> *m* nothing above dimension *m* is there to fill an *m*-cycle, so only the dimensions below *m* carry persistence.

## Basic Examples

The number of edges, triangles and tetrahedra of the order-2 complex of sixteen random points against the radius.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {filtration = BallIntersectionFiltration[points, Range[0.02, 0.3, 0.02], 2]},
  ListLinePlot[
    Table[KeyValueMap[{#1, Count[#2, simplex_ /; Length[simplex] == m]} &, filtration], {m, 2, 4}],
    PlotLegends -> {"edges", "triangles", "tetrahedra"},
    AxesLabel -> {"r", "simplices"}]]
```

Three stages of the same filtration, each complex containing the one before.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {radii = {0.08, 0.12, 0.16}},
  {filtration = BallIntersectionFiltration[points, radii, 2]},
  {GraphicsRow @ Table[
     Graphics[{
       {StandardBlue, Opacity[0.15], Disk[#, r] & /@ points},
       {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[filtration[r], Length[#] == 3 &]},
       {StandardRed, Line[points[[#]]] & /@ Select[filtration[r], Length[#] == 2 &]},
       Point[points]},
       PlotLabel -> r],
     {r, radii}],
   And @@ MapThread[SubsetQ, {Rest @ Values[filtration], Most @ Values[filtration]}]}]
```

## Scope

With `"Metric"` -> *g* the data are vertices of a graph. The number of edges and triangles of the Čech filtration of the vertices within distance 3 of the centre of the hexagonal tiling, at integer radii.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small"]},
  {data = RandomInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 3]]},
  {filtration = BallIntersectionFiltration[data, Range[0, 3], Infinity, "Metric" -> g, "MaxDimension" -> 2]},
  ListLinePlot[
    Table[KeyValueMap[{#1, Count[#2, simplex_ /; Length[simplex] == m]} &, filtration], {m, 2, 3}],
    PlotLegends -> {"edges", "triangles"},
    AxesLabel -> {"r", "simplices"}]]
```
