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

<code>[DimensionCurvatureFit]()[{{*r1*, *q1*}, {*r2*, *q2*}, …}]</code> gives `<|"Dimension" -> d, "ScalarCurvature" -> R|>` fitted to the log-difference quotients *qi* at the radii *ri*.

<code>[DimensionCurvatureFit]()[{*q0*, *q1*, …}]</code> places the quotients at the radii 0, 1, 2, ….

## Details & Options

The fit is the least-squares line *q = c₁ + c₂ x* in *x = r(r + 1)*. The intercept gives the dimension and the slope the curvature.

On a Riemannian manifold of dimension *d* and scalar curvature *R*, the ball volume is *ωd rᵈ (1 − R r² / (6(d + 2)) + O(r⁴))*. So the log-log slope of the volume is *d − R r² / (3(d + 2))*: the intercept is *d* and *R = −3(d + 2) c₂*.

A quotient of a graph is taken across *[r, r + 1]*, so it is regressed on *r(r + 1)*, the square of the geometric-mean radius, not on *r²*.

`"Probe"` names the volume the quotients came from:

| `"Probe"` | Volume | Dimension | Curvature read |
|---|---|---|---|
| `"Ball"` | *V ~ rᵈ* | *c₁* | *R = −3(c₁ + 2) c₂* |
| `"Sphere"` | *A ~ rᵈ⁻¹* | *c₁ + 1* | *R = −3(c₁ + 1) c₂* |
| `"Tube"` | *T ~ sᵈ⁻¹*, about a geodesic | *c₁ + 1* | *R + Ric(v, v) = −3(c₁ + 2) c₂* |
| `"TubeMantle"` | *∂T ~ sᵈ⁻²* | *c₁ + 2* | *R + Ric(v, v) = −3(c₁ + 1) c₂* |

For the tube probes `"ScalarCurvature"` holds *R + Ric(v, v)*, with *v* the direction of the core geodesic. A ball reading of *R* over the same window leaves *Ric(v, v)*.

Every point given is fitted; the window is chosen by the caller. [VolumeGrowthObservables]() chooses it. [Around]() quotients give [Around]() results.

Options:

| Option | Default | Values |
|---|---|---|
| `"Probe"` | `"Ball"` | `"Ball"`, `"Sphere"`, `"Tube"`, `"TubeMantle"` |
| `"Dimension"` | `Automatic` | a number fixes the dimension, and only the slope is fitted |

## Basic Examples

The shell quotients about the centre against *r(r + 1)*, with the fitted line, on the square grid and on the sphere mesh. The grid reads dimension 2 and curvature 0; on the sphere the line falls, positive curvature:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 6}]},
    {data = Transpose[{Range[5], LogDifferenceQuotients[areas]}]},
    {fit = DimensionCurvatureFit[data, "Probe" -> "Sphere"]},
    Show[
      ListPlot[{#1 (#1 + 1), #2} & @@@ data, PlotRange -> {{0, 32}, {0, 1.5}}, PlotLabel -> Round[Values @ fit, 0.01]],
      Plot[fit["Dimension"] - 1 - fit["ScalarCurvature"] x/(3 fit["Dimension"]), {x, 0, 32}]]],
  {name, {"SquareGridGraph", "SphereMeshGraph"}}]
```

Quotients of an exact ball expansion with *d* = 2 and *R* = 0.1 give these numbers back:

```wl
DimensionCurvatureFit[Table[{r, 2 - 0.1 r (r + 1)/12}, {r, 3, 10}]]
```

A bare list sits at the radii 0, 1, 2, …. Constant quotients 2 read as the flat plane:

```wl
DimensionCurvatureFit[{2., 2., 2., 2.}]
```

## Scope

[Around]() quotients give [Around]() results. The mean shell sizes over the 19 vertices of the ball of radius 2 about the centre of the square mesh read dimension 2 and curvature 0 within the error:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {sample = Keys @ InfraMeasurement[g, InfraBall[c, 2], "VertexDensity"]},
  {areas = MeanAround /@ Transpose @
    Table[InfraMeasurement[g, InfraShell[v, r], "CountingMeasure"], {v, sample}, {r, 1, 6}]},
  DimensionCurvatureFit[Transpose[{Range[5], LogDifferenceQuotients[areas]}], "Probe" -> "Sphere"]]
```

## Options

### Probe

The same quotients read by the four probes. The probe moves the intercept and the factor of the slope:

```wl
With[{data = Table[{r, 2 - 0.1 r (r + 1)/12}, {r, 3, 10}]},
  AssociationMap[probe |-> Round[Values @ DimensionCurvatureFit[data, "Probe" -> probe], 0.001],
    {"Ball", "Sphere", "Tube", "TubeMantle"}]]
```

### Dimension

With the dimension fixed at 2, only the curvature is fitted. The shell quotients of the sphere mesh, the free line and the line through the intercept 1, labelled by their curvatures:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {areas = Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 6}]},
  {data = Transpose[{Range[5], LogDifferenceQuotients[areas]}]},
  {free = DimensionCurvatureFit[data, "Probe" -> "Sphere"]},
  {fixed = DimensionCurvatureFit[data, "Probe" -> "Sphere", "Dimension" -> 2]},
  Show[ListPlot[{#1 (#1 + 1), #2} & @@@ data, PlotRange -> {{0, 32}, {0, 1.5}},
      PlotLabel -> Round[{free["ScalarCurvature"], fixed["ScalarCurvature"]}, 0.01]],
    Plot[{free["Dimension"] - 1 - free["ScalarCurvature"] x/(3 free["Dimension"]),
      1 - fixed["ScalarCurvature"] x/6}, {x, 0, 32}]]]
```

## Properties and Relations

[VolumeGrowthObservables]() is this fit over the window it chooses:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {obs = VolumeGrowthObservables[g, c]},
  {window = obs["BallWindow"], q = obs["BallLogDifferenceQuotients"]},
  {DimensionCurvatureFit[Table[{r, q[[r]]}, {r, window[[1]], window[[2]]}]],
   KeyTake[obs, {"BallDimension", "BallScalarCurvature"}]}]
```
