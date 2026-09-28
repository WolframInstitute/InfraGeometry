---
Template: Symbol
Name: DimensionCurvatureFit
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DimensionCurvatureFit
Keywords: [dimension, scalar curvature, Bishop-Gromov, volume growth, regression, Ricci curvature, tube]
SeeAlso: [LogDifferenceQuotients, VolumeGrowthObservables, BallVolumes, ShellAreas, TubeVolumes]
RelatedGuides: [RiemannianGeometryGuide]
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

Ball quotients against *r(r + 1)* over the fitted window, and the fitted line, at the centre of a sphere mesh, the square tiling and a hyperbolic tiling. The slope falls, stays level and rises: positive, zero and negative curvature.

```wl
Row[Table[
  With[{gr = InfraSubstrate[nm, "Large"]},
    With[{obs = VolumeGrowthObservables[gr, InfraCenter[gr]]},
      With[{win = obs["BallWindow"], quots = obs["BallLogDifferenceQuotients"]},
        With[{fitData = Table[{rad, quots[[rad]]}, {rad, win[[1]], win[[2]]}]},
          With[{fit = DimensionCurvatureFit[fitData]},
            Show[
              ListPlot[{#[[1]] (#[[1]] + 1), #[[2]]} & /@ fitData, PlotRange -> {All, {0, 3}},
                AxesLabel -> {"r(r+1)", "q"}, PlotLabel -> Column[{nm, Round[fit["ScalarCurvature"], 0.001]}]],
              Plot[fit["Dimension"] - fit["ScalarCurvature"] x/(3 (fit["Dimension"] + 2)), {x, 0, win[[2]] (win[[2]] + 1)},
                PlotStyle -> Gray],
              ImageSize -> 200]]]]]],
  {nm, {"SphereMeshGraph", "SquareTilingGraph", "HyperbolicTilingGraph"}}]]
```

Quotients of an exact Bishop–Gromov form, dimension 2 and curvature 0.1, give those numbers back.

```wl
DimensionCurvatureFit[Table[{r, 2 - 0.1 r (r + 1)/(3 (2 + 2))}, {r, 3, 10}]]
```

A bare list sits at the radii 0, 1, 2, ….

```wl
DimensionCurvatureFit[{2., 2., 2., 2.}]
```

## Options

### Probe

The same quotients read as a ball, a sphere and a tube.

```wl
With[
  {qdata = Table[{r, 2 - 0.1 r (r + 1)/12}, {r, 3, 10}]},
  Table[pr -> DimensionCurvatureFit[qdata, "Probe" -> pr], {pr, {"Ball", "Sphere", "Tube", "TubeMantle"}}]]
```

### Dimension

With the dimension fixed, only the slope is fitted.

```wl
With[
  {qdata = {{3, 1.9}, {4, 1.8}, {5, 1.7}}},
  {DimensionCurvatureFit[qdata], DimensionCurvatureFit[qdata, "Dimension" -> 2]}]
```

## Scope

`Around` quotients carry their spread into the dimension and the curvature: here the mean profile over five vertices near the centre of the discretized plane. Fitted from radius 1 on the full count, the intercept is biased high by the small radii; the windowed fit of [VolumeGrowthObservables]() reads 1.95 at the centre.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {sampleSet = Take[FindInfraBall[g, InfraCenter[g], 2], 5]},
  DimensionCurvatureFit @ Transpose[
    {Range[8], LogDifferenceQuotients[MeanAround /@ Transpose @ BallVolumes[g, sampleSet, {0, 8}]]}]]
```

## Properties and Relations

[VolumeGrowthObservables]() is this fit over the window it chooses.

```wl
With[
  {g = InfraSubstrate["SphereMeshGraph", "Large"]},
  With[{obs = VolumeGrowthObservables[g, InfraCenter[g]]},
    With[{win = obs["BallWindow"], quots = obs["BallLogDifferenceQuotients"]},
      DimensionCurvatureFit[Table[{rad, quots[[rad]]}, {rad, win[[1]], win[[2]]}]] ==
        <|"Dimension" -> obs["BallDimension"], "ScalarCurvature" -> obs["BallScalarCurvature"]|>]]]
```
