---
Template: Symbol
Name: LogDifferenceQuotients
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/LogDifferenceQuotients
Keywords: [log-log slope, growth exponent, volume-growth dimension, difference quotient, Around]
SeeAlso: [BallVolumes, ShellAreas, TubeVolumes, DimensionCurvatureFit, VolumeGrowthObservables]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[LogDifferenceQuotients]()[*w*]</code> gives the log-difference quotients {*q*(1), *q*(2), …} of the sequence *w* = {*w*(0), *w*(1), …}, where *q*(*r*) = (log *w*(*r*) − log *w*(*r* − 1)) / (log(*r* + 1) − log *r*).

## Details & Options

Definition: *q(r) = (log w(r) − log w(r − 1)) / (log(r + 1) − log r)* for *r* = 1, 2, …, the slope of the sequence on log-log axes between two consecutive positions. Position *i* of *w*, counted from 1, is placed at *i*: so a sequence growing like *(r + 1)^d* has every quotient equal to *d*.

It is the discrete *d log w / d log r*. Applied to a ball-volume profile, the quotient is the growth exponent at each radius, the volume-growth dimension: it tends to 2 on a planar lattice and to 3 on a cubic one. Applied to the shell areas it tends to one less.

The quotient is not constant on a finite graph. At small radius it carries the discretisation, and at large radius it falls as the ball meets the rim or wraps round. [DimensionCurvatureFit]() regresses it on *r(r + 1)* over a middle window to read the dimension and the curvature, and [VolumeGrowthObservables]() chooses that window.

*w* may be any numeric sequence, or a sequence of `Around` values; then the spread is carried into the quotients. The positions are fixed by the list, so a window of a profile starting at radius *r0* is placed at 1, not at *r0* + 1. `LogDifferenceQuotients` equals `ResourceFunction["LogDifferences"]`.

## Basic Examples

The quotients of the ball volumes at the centre of the discretized plane, the square tiling and the hexagonal tiling. All three approach 2, the dimension of the plane; the gray line.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[With[{gr = InfraSubstrate[nm, "Large"]}, LogDifferenceQuotients @ BallVolumes[gr, InfraCenter[gr], {0, 12}]], {nm, names}],
    DataRange -> {1, 12}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "q(r)"},
    GridLines -> {None, {{2, Gray}}}, PlotRange -> {0, 3.5}]]
```

A pure power has constant quotients equal to its exponent.

```wl
LogDifferenceQuotients[Table[r^3, {r, 1, 6}]]
```

The first quotients of the square tiling's ball volumes, 2r² + 2r + 1.

```wl
LogDifferenceQuotients[Table[2 r^2 + 2 r + 1, {r, 0, 5}]]
```

## Scope

A sequence of `Around` values carries its spread into the quotients: here the mean ball-volume profile over five vertices near the centre of the discretized plane.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {sampleSet = Take[FindInfraBall[g, InfraCenter[g], 2], 5]},
  LogDifferenceQuotients[MeanAround /@ Transpose @ BallVolumes[g, sampleSet, {0, 5}]]]
```

## Properties and Relations

The quotients of the shell areas of a planar lattice tend to 1, one less than those of the volumes.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {Last @ LogDifferenceQuotients @ BallVolumes[g, ctr, {0, 12}],
   Last @ LogDifferenceQuotients @ ShellAreas[g, ctr, {1, 12}]}]
```

A sequence indexed from 0 is placed from 1: the profile *(r + 1)²* has every quotient equal to 2.

```wl
LogDifferenceQuotients[Table[(r + 1)^2, {r, 0, 5}]]
```
