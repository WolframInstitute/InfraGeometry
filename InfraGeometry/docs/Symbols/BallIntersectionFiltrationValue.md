---
Template: Symbol
Name: BallIntersectionFiltrationValue
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallIntersectionFiltrationValue
Keywords: [filtration value, birth radius, ball intersection complex, Cech complex, Vietoris-Rips complex, miniball]
SeeAlso: [BallIntersectionComplex, BallIntersectionFiltration, MiniballRadius, CechComplex]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[BallIntersectionFiltrationValue]()[*data*, *σ*, *k*]</code> gives the least radius at which the positions *σ* form a simplex of the order-*k* ball intersection complex of *data*.

<code>[BallIntersectionFiltrationValue]()[*data*, *σ*]</code> takes *k* = [Infinity](), the Čech complex.

## Details & Options

Definition: let *ρ(τ)* be the least radius at which the balls about the points of *τ* have a common point. Then *f_k(σ) = ρ(σ)* when *σ* has at most *k* elements, and otherwise *f_k(σ)* is the largest *ρ(τ)* over the subsets *τ* of *σ* with *k* elements.

The set *σ* is a simplex of <code>[BallIntersectionComplex]()[*data*, *r*, *k*]</code> exactly when *f_k(σ) ≤ r*. Since *ρ* grows with the set, *f_k* is monotone under faces, and it grows with *k* up to *ρ(σ)*.

For Euclidean points *ρ* is [MiniballRadius](). Option `"Metric"` -> *g* reads *data* as vertices of the graph *g*, and *ρ(τ)* is the least *r* such that some vertex of *g* lies within *r* of every point of *τ*. A distance matrix or a function looks for that point among the points of *data*. For *k* = 2 the value of a pair is therefore half its distance for Euclidean points, the ceiling of that half for a graph, and in general neither for a matrix or a function.

## Basic Examples

The equilateral triangle of side 1. At order 2 it is born at radius 1/2, when the disks touch in pairs; in the Čech complex at radius *1/√3*, when all three meet at the centre.

```wl
With[
  {points = N @ CirclePoints[1/Sqrt[3], 3]},
  {values = BallIntersectionFiltrationValue[points, {1, 2, 3}, #] & /@ {2, Infinity}},
  {GraphicsRow @ Table[Graphics[{{StandardBlue, Opacity[0.15], Disk[#, s] & /@ points}, Point[points]}, PlotLabel -> s], {s, values}], values}]
```

The four corners of a square of the square tiling, with the graph metric. Three of their balls meet from radius 1, all four only from radius 2.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {corners = First /@ First @ FindCycle[{g, First @ GraphCenter[g]}, {4}]},
  {InfraSubstrateHighlight[g, {InfraWalk[Append[corners, First[corners]]]}],
   Table[BallIntersectionFiltrationValue[corners, Range[4], k, "Metric" -> g], {k, 2, 4}]}]
```

## Options

### Metric

Two vertices of a path at distance 2. Their balls first meet at radius 1 in the graph, at the vertex between them, and in the plane; with the distance matrix of the two alone the common point must be one of them, and the radius is 2.

```wl
With[
  {g = PathGraph[Range[5]]},
  {InfraSubstrateHighlight[g, {InfraBall[1, 1], InfraBall[3, 1]}],
   BallIntersectionFiltrationValue[{1, 3}, {1, 2}, 2, "Metric" -> g],
   BallIntersectionFiltrationValue[{{0, 0}, {2, 0}}, {1, 2}, 2],
   BallIntersectionFiltrationValue[{1, 3}, {1, 2}, 2, "Metric" -> {{0, 2}, {2, 0}}]}]
```

## Properties and Relations

The order-2 complex of ten random points at radius 0.2 is the set of all subsets whose value is at most 0.2.

```wl
With[
  {points = (SeedRandom[4]; RandomReal[1, {10, 2}])},
  {complex = BallIntersectionComplex[points, 0.2, 2]},
  {Graphics[{
     {StandardBlue, Opacity[0.15], Disk[#, 0.2] & /@ points},
     {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
     {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]},
     Point[points]}],
   complex == Select[Subsets[Range[10], {1, 10}], BallIntersectionFiltrationValue[points, #, 2] <= 0.2 &]}]
```
