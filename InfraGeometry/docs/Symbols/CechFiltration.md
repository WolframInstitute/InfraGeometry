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

Definition: it is <code>[BallIntersectionFiltration]()[*data*, *radii*, [Infinity]()]</code>, the nested Čech complexes over the sorted radii, and takes the options of [BallIntersectionComplex]().

For Euclidean points a simplex enters at the radius of its smallest enclosing ball, [MiniballRadius](). By the nerve theorem each complex has the homotopy type of the union of its balls.

## Basic Examples

The Euler characteristic of the Čech complex of sixteen random points, the alternating count of its simplices, against the radius. It starts at the number of points and ends at 1. Between, it is the number of pieces of the union of the disks minus the number of its holes.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {filtration = CechFiltration[points, Range[0.01, 0.4, 0.01]]},
  ListLinePlot[KeyValueMap[{#1, Total[(-1)^(Length /@ #2 - 1)]} &, filtration], AxesLabel -> {"r", "\[Chi]"}]]
```

At radius 0.15 the union of the disks has three pieces and one hole, and the Euler characteristic is 2.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {complex = CechFiltration[points, {0.15}][0.15]},
  {Graphics[{
     {StandardBlue, Opacity[0.15], Disk[#, 0.15] & /@ points},
     {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
     {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]},
     Point[points]}],
   Total[(-1)^(Length /@ complex - 1)]}]
```

## Properties and Relations

The Čech filtration is the ball intersection filtration of order [Infinity]().

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {radii = Range[0.02, 0.3, 0.02]},
  {ListLinePlot[KeyValueMap[{#1, Length[#2]} &, CechFiltration[points, radii]], AxesLabel -> {"r", "simplices"}],
   CechFiltration[points, radii] == BallIntersectionFiltration[points, radii, Infinity]}]
```
