---
Template: Symbol
Name: LogDifferenceQuotients
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/LogDifferenceQuotients
Keywords: [log-log slope, growth exponent, volume-growth dimension, difference quotient, Around]
SeeAlso: [InfraMeasurement, InfraBall, InfraShell, DimensionCurvatureFit, VolumeGrowthObservables]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[LogDifferenceQuotients]()[*w*]</code> gives the log-difference quotients {*q*(1), *q*(2), …} of the sequence *w* = {*w*(0), *w*(1), …}.

## Details & Options

The quotient is *q(r) = (log w(r) − log w(r − 1)) / (log(r + 1) − log r)*, the slope of *w* on log-log axes between two consecutive positions. It is the discrete *d log w / d log r*.

The *i*-th entry of *w*, counted from 1, sits at position *i*. A sequence *w(r) = (r + 1)ᵈ* has every quotient equal to *d*.

Applied to the ball volumes about a vertex, the quotient is the growth exponent at each radius: it tends to the dimension, 2 on a planar graph. Applied to the shell sizes it tends to one less.

On a finite graph the quotient is not constant. At small radius it carries the discretization; once the ball meets the rim of the graph it falls. [DimensionCurvatureFit]() reads the dimension and the curvature from a middle window, and [VolumeGrowthObservables]() chooses the window.

On the square grid the ball volume is *2r² + 2r + 1*, and the quotient is *2 + 1/r + O(1/r²)*: it approaches 2 from above.

*w* may hold numbers or [Around]() values; the spread is carried into the quotients.

## Basic Examples

The quotients of the ball volumes about the centre, on the square grid and on the square mesh. Both approach 2 until the ball reaches the rim:

```wl
ListLinePlot[Table[
    With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
      LogDifferenceQuotients @ Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 10}]],
    {name, {"SquareGridGraph", "SquareMeshGraph"}}],
  PlotMarkers -> Automatic, PlotLegends -> {"SquareGridGraph", "SquareMeshGraph"}, GridLines -> {None, {2}}]
```

A sequence *(r + 1)²* has every quotient equal to 2:

```wl
LogDifferenceQuotients[Table[(r + 1)^2, {r, 0, 5}]] // Chop
```

The ball volumes of the square grid, *2r² + 2r + 1*, give quotients above 2, close to *2 + 1/r* at large *r*:

```wl
N @ LogDifferenceQuotients[Table[2 r^2 + 2 r + 1, {r, 0, 8}]]
```

## Scope

A sequence of [Around]() values gives quotients with error bars. The mean ball volumes over the ball of radius 1 about the centre of the square mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sample = Keys @ InfraMeasurement[g, InfraBall[c, 1], "VertexDensity"]},
  {volumes = MeanAround /@ Transpose @
    Table[InfraMeasurement[g, InfraBall[v, r], "CountingMeasure"], {v, sample}, {r, 0, 6}]},
  ListPlot[LogDifferenceQuotients[volumes], GridLines -> {None, {2}}, PlotRange -> {1.5, 3.5}]]
```

## Properties and Relations

The shells of the square grid have *4r* vertices for *r* ≥ 1. Taken from radius 1, their quotients are exactly 1, one less than the dimension:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 8}]},
  {areas, LogDifferenceQuotients[areas]}]
```

## Possible Issues

The positions come from the list, not from the radii. The same ball volumes of the grid, taken from radius 0 and from radius 1, give different quotients:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {volumes = Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 8}]},
  ListLinePlot[{LogDifferenceQuotients[volumes], LogDifferenceQuotients[Rest @ volumes]}, PlotMarkers -> Automatic,
    PlotLegends -> {"from radius 0", "from radius 1"}, GridLines -> {None, {2}}]]
```
