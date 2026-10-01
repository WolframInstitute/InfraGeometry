---
Template: Symbol
Name: VolumeGrowthObservables
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/VolumeGrowthObservables
Keywords: [volume growth, dimension, scalar curvature, Bishop-Gromov, ball, sphere, fit window]
SeeAlso: [DimensionCurvatureFit, BallVolumes, ShellAreas, LogDifferenceQuotients, TubeVolumes]
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

The keys of the result:

| Key | Value |
|---|---|
| `"BallVolumes"`, `"ShellAreas"` | the profiles fitted: the ball under the chosen measure, the shell under `"FullCount"` |
| `"BallLogDifferenceQuotients"`, `"SphereLogDifferenceQuotients"` | the quotients *q(r)* at *r* = 1, 2, …, taken between the radii *r* and *r* + 1 |
| `"BallDimension"`, `"SphereDimension"` | the dimension read by each probe |
| `"BallScalarCurvature"`, `"SphereScalarCurvature"` | the scalar curvature read by each probe |
| `"BallCurvatureByRadius"`, `"SphereCurvatureByRadius"` | the comparison with flat space at each radius: *6(d + 2)/r² (1 − V(r)/V_flat(r))* and *6d/r² (1 − A(r)/A_flat(r))* |
| `"SphereMeanCurvatureByRadius"` | the discrete mean curvature of the shells, the differences of *log A(r)* |
| `"BallWindow"`, `"SphereWindow"` | the radius windows fitted |

Options:

| Option | Default | Values |
|---|---|---|
| `"Measure"` | `"HalfBoundary"` | the measure of the ball probe, as in [BallVolumes](); at half weight a flat lattice's volume has no *r^(d−1)* term |
| `"Dimension"` | `Automatic` | an integer fixes the dimension and fits the curvature alone |

## Basic Examples

Ball quotients against *r(r + 1)* at the centre of the discretized plane, the square tiling and the hexagonal tiling, the fitted window in orange, and the fitted line. All three read dimension 2 and curvature close to 0.

```wl
Row[Table[
  With[{gr = InfraSubstrate[nm, "Large"]},
    With[{obs = VolumeGrowthObservables[gr, InfraCenter[gr]]},
      With[{quots = obs["BallLogDifferenceQuotients"], win = obs["BallWindow"]},
        With[{scatter = Table[{rad (rad + 1), quots[[rad]]}, {rad, Length @ quots}]},
          Show[
            ListPlot[{scatter, scatter[[win[[1]] ;; win[[2]]]]}, PlotRange -> {All, {1, 3}},
              AxesLabel -> {"r(r+1)", "q"}, PlotLabel -> nm],
            Plot[obs["BallDimension"] - obs["BallScalarCurvature"] x/(3 (obs["BallDimension"] + 2)),
              {x, 0, Max[scatter[[All, 1]]]}, PlotStyle -> Gray],
            ImageSize -> 200]]]]],
  {nm, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The four fitted numbers and the two windows on the same substrates.

```wl
Dataset @ AssociationMap[
  With[{gr = InfraSubstrate[#, "Large"]},
    KeyTake[VolumeGrowthObservables[gr, InfraCenter[gr]],
      {"BallDimension", "SphereDimension", "BallScalarCurvature", "SphereScalarCurvature", "BallWindow", "SphereWindow"}]] &,
  {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}]
```

The keys of the result.

```wl
Keys @ VolumeGrowthObservables[GridGraph[{15, 15}], 113]
```

## Scope

On curved substrates the sign of the curvature shows: positive at the centre of a sphere mesh, negative on a hyperbolic tiling. The dimension read on the hyperbolic tiling is not 2: its balls grow exponentially, and only four radii fit before the rim.

```wl
Dataset @ AssociationMap[
  With[{gr = InfraSubstrate[#, "Large"]},
    KeyTake[VolumeGrowthObservables[gr, InfraCenter[gr]], {"BallDimension", "BallScalarCurvature"}]] &,
  {"SphereMeshGraph", "SquareTilingGraph", "HyperbolicTilingGraph"}]
```

A window given explicitly is fitted as it stands.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  KeyTake[VolumeGrowthObservables[g, InfraCenter[g], {3, 10}], {"BallDimension", "BallScalarCurvature", "BallWindow"}] // Normal]
```

## Options

### Measure

The ball probe on the flat 15 × 15 grid under three measures; the sphere probe, on the full shell count, is the same in all three.

```wl
Table[
  m -> KeyTake[VolumeGrowthObservables[GridGraph[{15, 15}], 113, "Measure" -> m], {"BallDimension", "SphereDimension"}] // Normal,
  {m, {"FullCount", "WithoutBoundary", "HalfBoundary"}}]
```

### Dimension

With the dimension fixed at 2, only the curvature is fitted.

```wl
With[
  {g = InfraSubstrate["SphereMeshGraph", "Large"]},
  KeyTake[VolumeGrowthObservables[g, InfraCenter[g], "Dimension" -> 2], {"BallDimension", "BallScalarCurvature"}] // Normal]
```

## Properties and Relations

The profiles in the result are those of [BallVolumes]() under the half-boundary measure and of [ShellAreas]() under the full count.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {ctr = InfraCenter[g]},
  With[{obs = VolumeGrowthObservables[g, ctr]},
    {obs["BallVolumes"] === BallVolumes[g, ctr, "Measure" -> "HalfBoundary"], obs["ShellAreas"] === ShellAreas[g, ctr]}]]
```
