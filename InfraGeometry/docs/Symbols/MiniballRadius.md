---
Template: Symbol
Name: MiniballRadius
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/MiniballRadius
Keywords: [miniball, smallest enclosing ball, minimum enclosing circle, circumradius, Cech complex]
SeeAlso: [CechComplex, BallIntersectionComplex, BallIntersectionFiltrationValue]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[MiniballRadius]()[*points*]</code> gives the radius of the smallest closed ball that contains the Euclidean *points*.

## Details & Options

Definition: the radius is *min_x max_i |x − p_i|*, the least *r* for which a ball of radius *r* contains every *p_i*. The centre of that ball is the point *x* attaining it, given by <code>[BoundingRegion]()[*points*, "MinBall"]</code>.

The closed balls of radius *r* about the points have a common point exactly when *r* is at least this radius: a common point is the centre of a ball of radius *r* containing them all. That is the test of [CechComplex]() and [BallIntersectionComplex]() for Euclidean points.

The radius of one point is 0.

For a triangle with no obtuse angle the radius is the circumradius; for an obtuse triangle it is half the longest side. The points may be in any dimension.

## Basic Examples

Seven random points in the plane and their smallest enclosing circle.

```wl
With[
  {points = (SeedRandom[5]; RandomReal[1, {7, 2}])},
  {Graphics[{Point[points], StandardRed, Circle @@ BoundingRegion[points, "MinBall"]}], MiniballRadius[points]}]
```

An acute and an obtuse triangle with the same longest side, the circle on that side in blue and the smallest enclosing circle in red. The obtuse triangle fits in the circle on its longest side; the acute one needs its circumcircle.

```wl
With[
  {acute = N @ {{0, 0}, {2, 0}, {1, 1.5}}},
  {obtuse = N @ {{0, 0}, {2, 0}, {1, 0.4}}},
  {GraphicsRow @ Table[
     Graphics[{Line[Append[t, First[t]]], StandardRed, Circle @@ BoundingRegion[t, "MinBall"], StandardBlue, Circle[{1, 0}, 1]}],
     {t, {acute, obtuse}}],
   MiniballRadius /@ {acute, obtuse}}]
```

## Scope

The corners of the unit cube have radius *√3/2*.

```wl
With[
  {corners = N @ Tuples[{0, 1}, 3]},
  {Graphics3D[{Point[corners], StandardRed, Opacity[0.2], BoundingRegion[corners, "MinBall"]}], MiniballRadius[corners]}]
```

A single point has radius 0, exactly, in any dimension; so do equal points.

```wl
{MiniballRadius[{{0, 0}}], MiniballRadius[{{1, 2, 3}}], MiniballRadius[{{0, 0}, {0, 0}}]}
```

## Properties and Relations

The three disks about the corners of the acute triangle have no common point at nine tenths of the radius, and touch at one point at the radius. The triangle is a simplex of the Čech complex only from that radius on.

```wl
With[
  {points = N @ {{0, 0}, {2, 0}, {1, 1.5}}},
  {rho = MiniballRadius[points]},
  {GraphicsRow @ Table[Graphics[{{StandardBlue, Opacity[0.15], Disk[#, s] & /@ points}, Point[points]}, PlotLabel -> s], {s, {0.9 rho, rho}}],
   MemberQ[CechComplex[points, 0.9 rho], {1, 2, 3}], MemberQ[CechComplex[points, rho], {1, 2, 3}]}]
```

## Possible Issues

The points are converted to machine numbers first. On exact coordinates [BoundingRegion]() can return a ball that misses some of the points: for the corners of the cube it returns the ball about one face.

```wl
With[
  {corners = Tuples[{0, 1}, 3]},
  {BoundingRegion[corners, "MinBall"], BoundingRegion[N @ corners, "MinBall"], MiniballRadius[corners]}]
```
