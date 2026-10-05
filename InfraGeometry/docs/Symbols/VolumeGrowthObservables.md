---
Template: Symbol
Name: VolumeGrowthObservables
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/VolumeGrowthObservables
Keywords: [volume growth, dimension, scalar curvature, Bishop-Gromov, ball, sphere, fit window, counting measure, Riemannian measure]
SeeAlso: [DimensionCurvatureFit, InfraMeasurement, InfraBall, InfraShell, LogDifferenceQuotients, InfraTube]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[VolumeGrowthObservables]()[*g*, *v*]</code> fits the dimension and the scalar curvature to the growth of the balls and of the shells at *v*, and gives the profiles, the quotients, the fits and the windows used as one `Association`.

<code>[VolumeGrowthObservables]()[*g*, *v*, {*rmin*, *rmax*}]</code> fits over the given window of radii; `All` fits every radius, `Automatic` chooses the window.

<code>[VolumeGrowthObservables]()[*g*, {*v1*, *v2*, …}, …]</code> gives one `Association` per vertex; `All` takes every vertex.

## Details & Options

Definition: at *v* the ball probe regresses the log-difference quotient of the ball volumes, and the sphere probe that of the shell areas, on *r(r + 1)* by [DimensionCurvatureFit](). The ball reads *d* from the intercept and *R* = −3(*d* + 2) times the slope; the sphere reads *d* − 1 from the intercept and *R* = −3*d* times the slope.

The two probes measure the same pair independently, since *Vol B_r ∝ r^d (1 − R r² / (6(d + 2)))* while *Area S_r ∝ r^(d−1) (1 − R r² / (6d))*. Their agreement is the check that the substrate behaves like a manifold near *v*; where they disagree, trust the sphere, since the ball accumulates the small-radius artefacts.

The quotient is affine in *r(r + 1)* only over a middle window: at small radius it carries the discretisation, and past the peak of the shell count the ball fills the graph instead of growing. The `Automatic` window is the longest run of radii up to that peak whose least-squares residual stays within twice the noise floor. The windows used are reported.

The ball volume is a count of vertices, and at the radii fitted the boundary of the ball is not negligible. The ball probe reads it under the `"Measure"` option, through [InfraMeasurement]() on [InfraBall](): the `"RiemannianMeasure"`, the default, leaves out the vertices with a neighbour outside the ball, the `"CountingMeasure"` keeps them. On the square grid they are *2 r^2 − 2 r + 1* and *2 r^2 + 2 r + 1*. The term of order *r^(d − 1)* has opposite signs in the two, so on a flat lattice the ball probe reads the dimension from above under the Riemannian measure and from below under the counting measure. The sphere probe reads the shells under the counting measure in both cases, since the Riemannian measure of a shell is `0`.

The keys of the result:

| Key | Value |
|---|---|
| `"BallVolumes"`, `"ShellAreas"` | the profiles fitted, read through [InfraMeasurement](): the ball under the chosen measure, the shell under `"CountingMeasure"` |
| `"BallLogDifferenceQuotients"`, `"SphereLogDifferenceQuotients"` | the quotients *q(r)* at *r* = 1, 2, …, taken between the radii *r* and *r* + 1 |
| `"BallDimension"`, `"SphereDimension"` | the dimension read by each probe |
| `"BallScalarCurvature"`, `"SphereScalarCurvature"` | the scalar curvature read by each probe |
| `"BallCurvatureByRadius"`, `"SphereCurvatureByRadius"` | the comparison with flat space at each radius: *6(d + 2)/r² (1 − V(r)/V_flat(r))* and *6d/r² (1 − A(r)/A_flat(r))* |
| `"SphereMeanCurvatureByRadius"` | the discrete mean curvature of the shells, the differences of *log A(r)* |
| `"BallWindow"`, `"SphereWindow"` | the radius windows fitted |

Options:

| Option | Default | Values |
|---|---|---|
| `"Measure"` | `"RiemannianMeasure"` | `"RiemannianMeasure"` or `"CountingMeasure"`, the measure of the ball probe, as [InfraMeasurement]() reads it on [InfraBall](); any other name leaves the call unevaluated |
| `"Dimension"` | `Automatic` | an integer fixes the dimension and fits the curvature alone |

## Basic Examples

Ball quotients against *r(r + 1)* at the centre of the discretized plane, the square tiling and the hexagonal tiling, the fitted window in orange, and the fitted line. All three read a dimension a little above 2, as the Riemannian measure does, and curvature close to 0.

```wl
GraphicsRow @ Table[
  With[
    {gr = InfraSubstrate[nm, "Large"]},
    {obs = VolumeGrowthObservables[gr, InfraCenter[gr]]},
    {quots = obs["BallLogDifferenceQuotients"], win = obs["BallWindow"]},
    {scatter = Table[{rad (rad + 1), quots[[rad]]}, {rad, Length @ quots}]},
    Show[
      ListPlot[{scatter, scatter[[win[[1]] ;; win[[2]]]]}, PlotRange -> {All, {1, 3}}, AxesLabel -> {"r(r+1)", "q"}, PlotLabel -> nm],
      Plot[obs["BallDimension"] - obs["BallScalarCurvature"] x/(3 (obs["BallDimension"] + 2)), {x, 0, Max[scatter[[All, 1]]]},
        PlotStyle -> Gray]]],
  {nm, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

The two probes on the same substrates: the ball quotients and the sphere quotients plus one, both tending to the dimension 2, beside the fitted numbers and the windows.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {obsList = With[{gr = InfraSubstrate[#, "Large"]}, VolumeGrowthObservables[gr, InfraCenter[gr]]] & /@ names},
  {GraphicsRow @ MapThread[
     ListLinePlot[{#1["BallLogDifferenceQuotients"], #1["SphereLogDifferenceQuotients"] + 1}, PlotRange -> {All, {1, 3.5}},
       PlotMarkers -> Automatic, PlotLabel -> #2, AxesLabel -> {"r", "q"}] &, {obsList, names}],
   Dataset @ AssociationThread[names,
     KeyTake[#, {"BallDimension", "SphereDimension", "BallScalarCurvature", "SphereScalarCurvature", "BallWindow", "SphereWindow"}] & /@ obsList]}]
```

The balls at the two ends of the fitted ball window on the square tiling, beside the keys of the result.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {obs = VolumeGrowthObservables[g, c]},
  {InfraSubstrateHighlight[g, {FindInfraRepresentative[g, InfraBall[c, Last @ obs["BallWindow"]]], FindInfraRepresentative[g, InfraBall[c, First @ obs["BallWindow"]]], c}],
   obs["BallWindow"], Keys @ obs}]
```

## Scope

The comparison with flat space at each radius, and the fitted numbers. On curved substrates the sign of the curvature shows: positive at the centre of a sphere mesh, negative on a hyperbolic tiling. The dimension read on the hyperbolic tiling is not 2: its balls grow exponentially, and only a few radii fit before the rim.

```wl
With[
  {names = {"SphereMeshGraph", "SquareTilingGraph", "HyperbolicTilingGraph"}},
  {obsList = With[{gr = InfraSubstrate[#, "Large"]}, VolumeGrowthObservables[gr, InfraCenter[gr]]] & /@ names},
  {ListLinePlot[#["BallCurvatureByRadius"] & /@ obsList, PlotMarkers -> Automatic, PlotLegends -> names, PlotRange -> {All, {-3, 1}}, AxesLabel -> {"r", "R(r)"}],
   Dataset @ AssociationThread[names, KeyTake[#, {"BallDimension", "BallScalarCurvature"}] & /@ obsList]}]
```

A window given explicitly is fitted as it stands, here radii 3 to 10 on the discretized plane, in orange.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {obs = VolumeGrowthObservables[g, InfraCenter[g], {3, 10}]},
  {quots = obs["BallLogDifferenceQuotients"]},
  {scatter = Table[{rad (rad + 1), quots[[rad]]}, {rad, Length @ quots}]},
  {ListPlot[{scatter, scatter[[3 ;; 10]]}, PlotRange -> {All, {1, 3}}, AxesLabel -> {"r(r+1)", "q"}],
   KeyTake[obs, {"BallDimension", "BallScalarCurvature", "BallWindow"}]}]
```

## Options

### Measure

The ball quotients on the square tiling under the two measures; the sphere probe, on the counting measure of the shells, is the same in both. On a flat lattice the Riemannian measure of a ball is the counting measure of the ball one radius smaller, so the two probes read the dimension from above and from below.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {measures = {"CountingMeasure", "RiemannianMeasure"}},
  {obsList = VolumeGrowthObservables[g, InfraCenter[g], "Measure" -> #] & /@ measures},
  {ListLinePlot[#["BallLogDifferenceQuotients"] & /@ obsList, PlotMarkers -> Automatic, PlotLegends -> measures,
     PlotRange -> {All, {0, 4}}, AxesLabel -> {"r", "q"}],
   AssociationThread[measures, KeyTake[#, {"BallDimension", "SphereDimension"}] & /@ obsList]}]
```

### Dimension

With the dimension fixed at 2, only the curvature is fitted: the free line in gray, the line through the intercept 2 dashed, at the centre of the sphere mesh.

```wl
With[
  {g = InfraSubstrate["SphereMeshGraph", "Large"]},
  {free = VolumeGrowthObservables[g, InfraCenter[g]]},
  {fixed = VolumeGrowthObservables[g, InfraCenter[g], "Dimension" -> 2]},
  {quots = free["BallLogDifferenceQuotients"], win = free["BallWindow"]},
  {scatter = Table[{rad (rad + 1), quots[[rad]]}, {rad, win[[1]], win[[2]]}]},
  {Show[
     ListPlot[scatter, PlotRange -> {All, {1, 3}}, AxesLabel -> {"r(r+1)", "q"}],
     Plot[{free["BallDimension"] - free["BallScalarCurvature"] x/(3 (free["BallDimension"] + 2)), 2 - fixed["BallScalarCurvature"] x/12},
       {x, 0, Max[scatter[[All, 1]]]}, PlotStyle -> {Gray, Dashed}]],
   KeyTake[fixed, {"BallDimension", "BallScalarCurvature"}]}]
```

## Properties and Relations

The profiles in the result are the `"RiemannianMeasure"` of the balls and the `"CountingMeasure"` of the shells, read at every radius.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {obs = VolumeGrowthObservables[g, ctr]},
  {ListLinePlot[{obs["BallVolumes"], obs["ShellAreas"]}, PlotMarkers -> Automatic, PlotLegends -> {"ball", "shell"}, AxesLabel -> {"r + 1", None}],
   {obs["BallVolumes"] === Table[InfraMeasurement[g, InfraBall[ctr, r], "RiemannianMeasure"], {r, 0, Length @ obs["BallVolumes"] - 1}],
    obs["ShellAreas"] === Table[InfraMeasurement[g, InfraShell[ctr, r], "CountingMeasure"], {r, 0, Length @ obs["ShellAreas"] - 1}]}}]
```
