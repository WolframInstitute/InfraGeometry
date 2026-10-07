---
Template: Symbol
Name: DimensionCurvatureFit
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DimensionCurvatureFit
Keywords: [dimension, scalar curvature, Bishop-Gromov, volume growth, regression, Ricci curvature, tube]
SeeAlso: [LogDifferenceQuotients, VolumeGrowthObservables, InfraMeasurement, InfraBall, InfraShell, InfraTube]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[DimensionCurvatureFit]()[{{*r1*, *q1*}, {*r2*, *q2*}, …}]</code> fits the dimension and the scalar curvature to log-difference quotients *qi* at radii *ri*, and gives `<|"Dimension" -> d, "ScalarCurvature" -> R|>`.

<code>[DimensionCurvatureFit]()[{*q0*, *q1*, …}]</code> places the quotients at the radii 0, 1, 2, ….

## Details & Options

Definition: the fit is the least-squares line *q = c1 + c2 x* through the points *(x, q)* with *x = r(r + 1)*. The intercept gives the dimension and the slope the curvature, by the expansion of the probe's volume.

On a Riemannian manifold of dimension *d* and scalar curvature *R* the log-log slope of the ball volume is *d log V / d log r = d − R r² / (3(d + 2)) + O(r⁴)*. The quotient is therefore affine in *r²*, and a line through it reads *d* as the intercept and *R* as −3(*d* + 2) times the slope. This is Bishop–Gromov read as a measurement.

On a graph *r* is an integer and the quotient is a difference across *[r, r + 1]*, not a derivative. To first order in the curvature it is affine in *r(r + 1)*, the square of the geometric-mean radius, not in *r²*; regressing on *r²* would leave an error linear in *r* in the slope, and so in *R*.

Option `"Probe"` names the volume the quotients came from:

| `"Probe"` | Volume | Dimension | Curvature read |
|---|---|---|---|
| `"Ball"` (default) | *V ~ r^d* | *c1* | *R = −3(c1 + 2) c2* |
| `"Sphere"` | *A ~ r^(d−1)* | *c1* + 1 | *R = −3(c1 + 1) c2* |
| `"Tube"` | *T ~ s^(d−1)*, about a geodesic | *c1* + 1 | *R + Ric(v, v) = −3(c1 + 2) c2* |
| `"TubeMantle"` | *∂T ~ s^(d−2)* | *c1* + 2 | *R + Ric(v, v) = −3(c1 + 1) c2* |

For the two tube probes the `"ScalarCurvature"` entry holds *R + Ric(v, v)*, the scalar curvature plus the Ricci curvature along the core's direction *v*; subtract a ball reading of *R* over the same window to leave *Ric(v, v)*.

Option `"Dimension" -> d` fixes the dimension and fits the slope alone. The default `Automatic` fits both.

Every point given is fitted: the window is the caller's, chosen by slicing the quotients. [VolumeGrowthObservables]() chooses it automatically. The quotient convention is the caller's too: [LogDifferenceQuotients]() of a profile, or the radius-consistent quotients that [VolumeGrowthObservables]() takes. `Around` quotients give `Around` results.

## Basic Examples

Ball quotients against *r(r + 1)* over the fitted window, and the fitted line, at the centre of a sphere mesh, the square tiling and a hyperbolic tiling. The slope falls, stays level and rises: positive, zero and negative curvature, the number above each plot.

```wl
GraphicsRow @ Table[
  With[
    {gr = InfraSubstrate[nm, "Large"]},
    {obs = VolumeGrowthObservables[gr, First @ GraphCenter[gr]]},
    {win = obs["BallWindow"], quots = obs["BallLogDifferenceQuotients"]},
    {fitData = Table[{rad, quots[[rad]]}, {rad, win[[1]], win[[2]]}]},
    {fit = DimensionCurvatureFit[fitData]},
    Show[
      ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ fitData, PlotRange -> {All, {0, 3}},
        AxesLabel -> {"r(r+1)", "q"}, PlotLabel -> Column[{nm, Round[fit["ScalarCurvature"], 0.001]}]],
      Plot[fit["Dimension"] - fit["ScalarCurvature"] x/(3 (fit["Dimension"] + 2)), {x, 0, win[[2]] (win[[2]] + 1)},
        PlotStyle -> Gray]]],
  {nm, {"SphereMeshGraph", "SquareTilingGraph", "HyperbolicTilingGraph"}}]
```

Quotients of an exact Bishop–Gromov form, dimension 2 and curvature 0.1, against *r(r + 1)*, with the fitted line; the fit gives those numbers back.

```wl
With[
  {qdata = Table[{r, 2 - 0.1 r (r + 1)/(3 (2 + 2))}, {r, 3, 10}]},
  {fit = DimensionCurvatureFit[qdata]},
  {Show[ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ qdata, AxesLabel -> {"r(r+1)", "q"}],
     Plot[fit["Dimension"] - fit["ScalarCurvature"] x/(3 (fit["Dimension"] + 2)), {x, 0, 110}, PlotStyle -> Gray]],
   fit}]
```

A bare list sits at the radii 0, 1, 2, …: constant quotients 2 read as a flat plane.

```wl
With[
  {quots = {2., 2., 2., 2.}},
  {ListPlot[quots, DataRange -> {0, 3}, PlotRange -> {0, 3}, AxesLabel -> {"r", "q"}], DimensionCurvatureFit[quots]}]
```

## Options

### Probe

The same quotients read as a ball, a sphere, a tube and a tube mantle: the probe moves the intercept and the factor of the slope.

```wl
With[
  {qdata = Table[{r, 2 - 0.1 r (r + 1)/12}, {r, 3, 10}]},
  {ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ qdata, AxesLabel -> {"r(r+1)", "q"}],
   Table[pr -> DimensionCurvatureFit[qdata, "Probe" -> pr], {pr, {"Ball", "Sphere", "Tube", "TubeMantle"}}]}]
```

### Dimension

With the dimension fixed, only the slope is fitted: the free line in gray, the line through the intercept 2 dashed.

```wl
With[
  {qdata = {{3, 1.9}, {4, 1.8}, {5, 1.7}}},
  {free = DimensionCurvatureFit[qdata]},
  {fixed = DimensionCurvatureFit[qdata, "Dimension" -> 2]},
  {Show[
     ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ qdata, PlotRange -> {{0, 32}, {1.5, 2.2}}, AxesLabel -> {"r(r+1)", "q"}],
     Plot[{free["Dimension"] - free["ScalarCurvature"] x/(3 (free["Dimension"] + 2)), 2 - fixed["ScalarCurvature"] x/12}, {x, 0, 32},
       PlotStyle -> {Gray, Dashed}]],
   {free, fixed}}]
```

## Scope

`Around` quotients carry their spread into the dimension and the curvature: here the mean profile over five vertices near the centre of the discretized plane. Fitted from radius 1 on the counting measure, the intercept is biased high by the small radii; the windowed fit of [VolumeGrowthObservables]() chooses its window by the residual.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {sampleSet = Take[FindInfraRepresentative[g, InfraBall[First @ GraphCenter[g], 2]], 5]},
  {qdata = Transpose[{Range[8], LogDifferenceQuotients[MeanAround /@ Transpose @ Table[InfraMeasurement[g, InfraBall[v, r], "CountingMeasure"], {v, sampleSet}, {r, 0, 8}]]}]},
  {ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ qdata, PlotRange -> {All, {0, 3.5}}, AxesLabel -> {"r(r+1)", "q"}],
   DimensionCurvatureFit[qdata]}]
```

## Properties and Relations

[VolumeGrowthObservables]() is this fit over the window it chooses, drawn here at the centre of the sphere mesh.

```wl
With[
  {g = InfraSubstrate["SphereMeshGraph", "Large"]},
  {obs = VolumeGrowthObservables[g, First @ GraphCenter[g]]},
  {win = obs["BallWindow"], quots = obs["BallLogDifferenceQuotients"]},
  {fitData = Table[{rad, quots[[rad]]}, {rad, win[[1]], win[[2]]}]},
  {ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ fitData, PlotRange -> {All, {0, 3}}, AxesLabel -> {"r(r+1)", "q"}],
   DimensionCurvatureFit[fitData] == <|"Dimension" -> obs["BallDimension"], "ScalarCurvature" -> obs["BallScalarCurvature"]|>}]
```
