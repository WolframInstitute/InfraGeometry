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

<code>[BallIntersectionComplex]()[*data*, *r*, *k*]</code> gives the order-*k* complex of the closed balls of radius *r* about the points of *data*: a set of balls is a simplex when every *k* of them have a common point.

<code>[BallIntersectionComplex]()[*data*, *r*]</code> takes *k* = [Infinity](), the Čech complex.

## Details & Options

Definition: let *B_i* be the closed ball of radius *r* about the *i*-th point. A set *σ* of positions is a simplex of *C^(k)_r* when every subset of *σ* with *min(k, |σ|)* elements has balls with a common point.

At *k = 2* every pair of balls meets: the Vietoris–Rips complex at scale *2r*, the pairs at distance at most *2r* and every set all of whose pairs are such. At *k* = [Infinity]() all the balls of *σ* meet: the Čech complex, the nerve of the balls. In between the complexes are nested, *C^(2) ⊇ C^(3) ⊇ … ⊇* Čech.

Balls in *ℝ^d* are convex, and by Helly's theorem the ladder stops at *k = d + 1*: in the plane order 3 is already Čech. On a graph it may go further.

A simplex is a sorted list of positions in *data*, not of the points themselves. The complex is built level by level, a set being tested only when all its faces are in, so it is closed under faces.

Euclidean balls about the points have a common point when their centres fit in a ball of radius *r*, the test of [MiniballRadius]().

Options:

| Option | Values | Default |
|---|---|---|
| `"Metric"` | [Automatic]() (Euclidean points), a [Graph]() *g* (*data* are vertices of *g*), a distance matrix of *data*, or a distance function | [Automatic]() |
| `"IntersectionTest"` | a function of the common region of Euclidean balls that must give `True` | [Automatic](), the region is not empty |
| `"MaxDimension"` | the largest dimension of a simplex | [Infinity]() |

With a graph *g* the balls meet when some vertex of *g* lies within *r* of every centre, so order 2 is again the Vietoris–Rips complex at *2r*. With a matrix or a function the common point must be a point of *data*.

## Basic Examples

The three corners of an equilateral triangle of side 1, with disks of radius 0.55. Every pair of disks meets, so the triangle is a simplex of order 2; the three have no common point, so it is not one of the Čech complex.

```wl
With[
  {points = N @ CirclePoints[1/Sqrt[3], 3]},
  GraphicsRow @ Table[
    With[{complex = BallIntersectionComplex[points, 0.55, k]},
      Graphics[{
        {StandardBlue, Opacity[0.15], Disk[#, 0.55] & /@ points},
        {StandardRed, Opacity[0.4], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
        {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]},
        Point[points]},
        PlotLabel -> k]],
    {k, {2, Infinity}}]]
```

The balls of radius 1 about the four corners of a square of the square tiling meet three at a time, at a corner, but not all four. The four corners are a simplex of order 3 and not of order 4.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {corners = First /@ First @ FindCycle[{g, InfraCenter[g]}, {4}]},
  {InfraSubstrateHighlight[g, InfraBall[#, 1] & /@ corners],
   MemberQ[BallIntersectionComplex[corners, 1, 3, "Metric" -> g], {1, 2, 3, 4}],
   MemberQ[BallIntersectionComplex[corners, 1, 4, "Metric" -> g], {1, 2, 3, 4}]}]
```

## Options

### Metric

On a path two vertices at distance 2 have balls of radius 1 that meet at the vertex between them. With the distance matrix of the two vertices alone that vertex is not a candidate, and the balls do not meet.

```wl
With[
  {g = PathGraph[Range[5]]},
  {InfraSubstrateHighlight[g, {InfraBall[1, 1], InfraBall[3, 1]}],
   BallIntersectionComplex[{1, 3}, 1, 2, "Metric" -> g],
   BallIntersectionComplex[{1, 3}, 1, 2, "Metric" -> {{0, 2}, {2, 0}}]}]
```

### IntersectionTest

At radius 0.6 the three disks about the triangle meet in a small region. Asking for a common region of area more than 0.05 drops the triangle.

```wl
With[
  {points = N @ CirclePoints[1/Sqrt[3], 3]},
  {Graphics[{{StandardBlue, Opacity[0.15], Disk[#, 0.6] & /@ points}, Point[points]}],
   BallIntersectionComplex[points, 0.6, Infinity, "IntersectionTest" -> (RegionMeasure[#] > 0.05 &)]}]
```

### MaxDimension

`"MaxDimension"` -> 1 keeps the vertices and the edges.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {complex = BallIntersectionComplex[points, 0.15, 2, "MaxDimension" -> 1]},
  Graphics[{{StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]}, Point[points]}]]
```

## Properties and Relations

The edges of order 2 are the pairs at distance at most *2r*, and in the plane order 3 is the Čech complex. Order 2 has one triangle more.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {rips = BallIntersectionComplex[points, 0.15, 2]},
  {cech = BallIntersectionComplex[points, 0.15, Infinity]},
  {Graphics[{
     {StandardBlue, Opacity[0.15], Disk[#, 0.15] & /@ points},
     {StandardRed, Opacity[0.4], Polygon[points[[#]]] & /@ Complement[rips, cech]},
     {StandardRed, Line[points[[#]]] & /@ Select[rips, Length[#] == 2 &]},
     Point[points]}],
   Select[rips, Length[#] == 2 &] == Select[Subsets[Range[16], {2}], EuclideanDistance @@ points[[#]] <= 0.3 &],
   BallIntersectionComplex[points, 0.15, 3] == cech,
   Complement[rips, cech]}]
```
