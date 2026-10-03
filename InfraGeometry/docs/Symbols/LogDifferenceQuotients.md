---
Template: Symbol
Name: LogDifferenceQuotients
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/LogDifferenceQuotients
Keywords: [log-log slope, growth exponent, volume-growth dimension, difference quotient, Around]
SeeAlso: [InfraMeasurement, InfraBall, InfraShell, InfraTube, DimensionCurvatureFit, VolumeGrowthObservables]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[LogDifferenceQuotients]()[*w*]</code> gives the log-difference quotients {*q*(1), *q*(2), …} of the sequence *w* = {*w*(0), *w*(1), …}, where *q*(*r*) = (log *w*(*r*) − log *w*(*r* − 1)) / (log(*r* + 1) − log *r*).

## Details & Options

Definition: *q(r) = (log w(r) − log w(r − 1)) / (log(r + 1) − log r)* for *r* = 1, 2, …, the slope of the sequence on log-log axes between two consecutive positions. Position *i* of *w*, counted from 1, is placed at *i*: so a sequence growing like *(r + 1)^d* has every quotient equal to *d*.

It is the discrete *d log w / d log r*. Applied to a ball-volume profile, the quotient is the growth exponent at each radius, the volume-growth dimension: it tends to 2 on a planar lattice and to 3 on a cubic one. Applied to the shell areas it tends to one less.

Which radius a quotient is read at is a convention, and it moves the curve. A ball profile *V(0), V(1), …* given from radius 0 has position *i* at radius *i − 1*, so the quotient placed at *r* is *(log V(r) − log V(r − 1)) / (log(r + 1) − log r)*: the quotient of the profile *ρ ↦ V(ρ − 1)* at its own radius. On a lattice *V(ρ − 1)* is the Riemannian measure of the ball of radius *ρ* ([InfraBall]()), so this is the quotient of the `"RiemannianMeasure"` profile from radius 1, and it is the curve the Wolfram Physics technical introduction plots in section 4.5. The profile given from radius 1, *V(1), V(2), …*, is the counting curve, each volume at its own radius.

The two curves part at the rate *1/r*. For a polynomial profile of degree *d* with leading coefficient *c* and coefficient *b* of *r^(d−1)*, *q(r) = d − (b/c)/r + O(1/r²)*. For a ball count *L(r)* of a lattice of dimension *d*, the counting curve is *d − d/(2r) + O(1/r²)* and the Riemannian curve, of *L(r − 1)*, is *d + d/(2r) + O(1/r²)*: one from below, one from above, with mean *d + O(1/r²)*.

On a Riemannian manifold the ball's expansion *ω_d r^d (1 − Scal r² / (6(d + 2)))* makes the quotient affine in *r(r + 1)*, with intercept *d* and slope *−Scal / (3(d + 2))*, to first order in the curvature; [DimensionCurvatureFit]() fits that line.

The quotient is not constant on a finite graph. At small radius it carries the discretisation, and at large radius it falls as the ball meets the rim or wraps round. [DimensionCurvatureFit]() regresses it on *r(r + 1)* over a middle window to read the dimension and the curvature, and [VolumeGrowthObservables]() chooses that window.

*w* may be any numeric sequence, or a sequence of `Around` values; then the spread is carried into the quotients. The positions are fixed by the list, so a window of a profile starting at radius *r0* is placed at 1, not at *r0* + 1. `LogDifferenceQuotients` equals `ResourceFunction["LogDifferences"]`.

## Basic Examples

The quotients of the ball volumes from radius 0 at the centre of the discretized plane, the square tiling and the hexagonal tiling, the curves of the technical introduction. All three approach 2, the dimension of the plane; the gray line.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[With[{gr = InfraSubstrate[nm, "Large"]}, LogDifferenceQuotients @ Table[InfraMeasurement[gr, InfraBall[InfraCenter[gr], r], "CountingMeasure"], {r, 0, 12}]], {nm, names}],
    DataRange -> {1, 12}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "q(r)"},
    GridLines -> {None, {{2, Gray}}}, PlotRange -> {0, 3.5}]]
```

A pure power has constant quotients equal to its exponent.

```wl
With[
  {quots = LogDifferenceQuotients[Table[r^3, {r, 1, 6}]]},
  {ListPlot[quots, DataRange -> {1, 5}, PlotRange -> {0, 4}, AxesLabel -> {"r", "q(r)"}], Round[quots, 0.001]}]
```

The quotients of the square tiling's ball volumes, *2r² + 2r + 1*, stay above 2 and approach it slowly.

```wl
With[
  {quots = LogDifferenceQuotients[Table[2 r^2 + 2 r + 1, {r, 0, 12}]]},
  {ListPlot[quots, DataRange -> {1, 12}, PlotRange -> {0, 3.5}, GridLines -> {None, {{2, Gray}}}, AxesLabel -> {"r", "q(r)"}],
   Round[Take[quots, 4], 0.001]}]
```

## Scope

A sequence of `Around` values carries its spread into the quotients, drawn as error bars: here the mean ball-volume profile over five vertices near the centre of the discretized plane.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {sampleSet = Take[FindInfraRepresentative[g, InfraBall[InfraCenter[g], 2]], 5]},
  {quots = LogDifferenceQuotients[MeanAround /@ Transpose @ Table[InfraMeasurement[g, InfraBall[v, r], "CountingMeasure"], {v, sampleSet}, {r, 0, 8}]]},
  {ListPlot[quots, DataRange -> {1, 8}, PlotRange -> {0, 3.5}, GridLines -> {None, {{2, Gray}}}, AxesLabel -> {"r", "q(r)"}], quots}]
```

## Properties and Relations

The counting curve and the Riemannian curve of the balls about the centre of the large square tiling, as points, against *2 − 1/r* and *2 + 1/r*, as curves. The Riemannian curve is also the quotient of the counting profile given from radius 0.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {c = InfraCenter[g]},
  {counting = LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 1, 13}]},
  {riemannian = LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"], {r, 1, 13}]},
  {shifted = LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 12}]},
  {Show[
     Plot[{2 - 1/r, 2 + 1/r}, {r, 1, 12}, PlotRange -> {1, 3}],
     ListPlot[{counting, riemannian}, DataRange -> {1, 12}, PlotMarkers -> Automatic],
     AxesLabel -> {"r", "q(r)"}, GridLines -> {None, {{2, Gray}}}],
   riemannian == shifted}]
```

The quotients of the shell areas of a planar lattice tend to 1, one less than those of the volumes.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {ballQuots = LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraBall[ctr, r], "CountingMeasure"], {r, 0, 12}]},
  {shellQuots = LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraShell[ctr, r], "CountingMeasure"], {r, 1, 12}]},
  {ListLinePlot[{ballQuots, shellQuots}, PlotMarkers -> Automatic, PlotLegends -> {"ball", "shell"}, PlotRange -> {0, 3.5},
     GridLines -> {None, {{1, Gray}, {2, Gray}}}, AxesLabel -> {"r", "q(r)"}],
   N @ {Last @ ballQuots, Last @ shellQuots}}]
```

A sequence indexed from 0 is placed from 1: the profile *(r + 1)²* has every quotient equal to 2.

```wl
With[
  {quots = LogDifferenceQuotients[Table[(r + 1)^2, {r, 0, 5}]]},
  {ListPlot[quots, DataRange -> {1, 5}, PlotRange -> {0, 3}, AxesLabel -> {"r", "q(r)"}], Round[quots, 0.001]}]
```
