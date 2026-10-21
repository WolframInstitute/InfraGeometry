---
Template: Symbol
Name: MiniballRadius
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/MiniballRadius
Keywords: [miniball, smallest enclosing ball, minimum enclosing circle, circumradius, Cech complex]
SeeAlso: [CechComplex, BallIntersectionComplex, BallIntersectionFiltrationValue, BoundingRegion]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[MiniballRadius]()[*points*]</code> gives the radius of the smallest closed ball that contains the Euclidean *points*.

## Details & Options

The radius is *ρ(P) = minₓ maxᵢ |x − pᵢ|*. The point *x* attaining it is the centre of <code>[BoundingRegion]()[[N]()[*points*], "MinBall"]</code>.

The balls of radius *r* about the points have a common point exactly when *r ≥ ρ(P)*: a common point is the centre of a ball of radius *r* that holds them all. That is the test of [CechComplex]() and [BallIntersectionComplex]() for Euclidean points.

One point has radius 0. For a triangle without an obtuse angle the radius is the circumradius; for an obtuse triangle it is half the longest side. The points may lie in any dimension.

The result is a machine number, except the exact 0 for a single point.

## Basic Examples

The lattice points of the ball of radius 3 of the square grid, and their smallest enclosing circle. Its radius is 3, the distance from the centre to the four corners:

```wl
With[{points = Select[Tuples[Range[-3, 3], 2], Total[Abs[#]] <= 3 &]},
  Graphics[{Point[points], StandardRed, Circle @@ BoundingRegion[N @ points, "MinBall"]},
    PlotLabel -> MiniballRadius[points], ImageSize -> Medium]]
```

An acute and an obtuse triangle with the same longest side. The obtuse one fits in the circle on its longest side, drawn blue; the acute one needs its circumcircle:

```wl
With[{acute = N @ {{0, 0}, {2, 0}, {1, 1.5}}, obtuse = N @ {{0, 0}, {2, 0}, {1, 0.4}}},
  GraphicsRow @ Table[
    Graphics[{Line[Append[t, First[t]]], StandardRed, Circle @@ BoundingRegion[t, "MinBall"],
      StandardBlue, Circle[{1, 0}, 1]},
      PlotLabel -> MiniballRadius[t]],
    {t, {acute, obtuse}}]]
```

## Scope

The corners of the unit cube have radius *√3/2*:

```wl
With[{corners = Tuples[{0, 1}, 3]},
  Graphics3D[{Point[corners], StandardRed, Opacity[0.2], BoundingRegion[N @ corners, "MinBall"]},
    PlotLabel -> MiniballRadius[corners]]]
```

One point has radius 0, and so do equal points:

```wl
{MiniballRadius[{{0, 0}}], MiniballRadius[{{1, 2, 3}}], MiniballRadius[{{0, 0}, {0, 0}}]}
```

## Properties and Relations

The disks of radius *r* about the corners of the acute triangle have a common point exactly from *r = ρ* on. At *0.9 ρ* they miss; at *ρ* they meet in the centre of the circumcircle:

```wl
With[{points = N @ {{0, 0}, {2, 0}, {1, 1.5}}}, {rho = MiniballRadius[points]},
  GraphicsRow @ Table[
    Graphics[{{StandardBlue, Opacity[0.15], Disk[#, s] & /@ points}, Point[points]},
      PlotLabel -> MemberQ[CechComplex[points, s], {1, 2, 3}]],
    {s, {0.9 rho, rho}}]]
```

## Possible Issues

The radius of exact points is a machine number, not an exact one:

```wl
{MiniballRadius[Tuples[{0, 1}, 3]], Sqrt[3] / 2}
```
