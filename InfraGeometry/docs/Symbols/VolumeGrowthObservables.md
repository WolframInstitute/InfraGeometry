---
Template: Symbol
Name: VolumeGrowthObservables
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/VolumeGrowthObservables
Keywords: [volume growth, dimension, scalar curvature, Bishop-Gromov, ball, sphere, fit window, counting measure, Riemannian measure]
SeeAlso: [DimensionCurvatureFit, LogDifferenceQuotients, InfraMeasurement, InfraBall, InfraShell]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[VolumeGrowthObservables]()[*g*, *v*]</code> gives the dimension and the scalar curvature at the vertex *v* read from the growth of the balls and of the shells about *v*, with the profiles, quotients and fit windows, as an [Association]().

<code>[VolumeGrowthObservables]()[*g*, *v*, {*rmin*, *rmax*}]</code> fits over the radii *rmin* to *rmax*.

<code>[VolumeGrowthObservables]()[*g*, {*v1*, *v2*, …}]</code> gives one [Association]() per vertex.

<code>[VolumeGrowthObservables]()[*g*]</code> gives one [Association]() for each vertex of *g*.

## Details & Options

Two probes read the same pair *(d, R)* at *v*, by [DimensionCurvatureFit]() on the log-difference quotients against *r(r + 1)*:

| Probe | Profile | Expansion on a manifold |
|---|---|---|
| ball | *V(r)*, the measure of the ball | *V ∝ rᵈ (1 − R r² / (6(d + 2)))* |
| sphere | *A(r)*, the number of vertices of the shell | *A ∝ rᵈ⁻¹ (1 − R r² / (6d))* |

The sphere probe is the reliable one on a graph. The ball volume counts its boundary, which at small radius is a large share of the ball. On the square grid the sphere probe reads *d* = 2 and *R* = 0 exactly, since the shells have *4r* vertices; the ball probe reads the dimension above 2 under the Riemannian measure and below 2 under the counting measure.

The window can be a pair {*rmin*, *rmax*}, `All` for every radius, or `Automatic`, the default. The `Automatic` window is the longest run of radii, up to the peak of *A(r)*, on which the quotients lie on a line within twice the noise.

The keys of the result:

| Key | Value |
|---|---|
| `"BallVolumes"`, `"ShellAreas"` | *V(r)* and *A(r)* for *r* = 0, 1, … up to the eccentricity of *v* |
| `"BallLogDifferenceQuotients"`, `"SphereLogDifferenceQuotients"` | the quotients between the radii *r* and *r* + 1, for *r* = 1, 2, … |
| `"BallDimension"`, `"SphereDimension"` | the dimension read by each probe |
| `"BallScalarCurvature"`, `"SphereScalarCurvature"` | the scalar curvature read by each probe |
| `"BallCurvatureByRadius"`, `"SphereCurvatureByRadius"` | *6(d + 2)/r² (1 − V(r)/V₀(r))* and *6d/r² (1 − A(r)/A₀(r))*, with *V₀*, *A₀* the flat ball and sphere |
| `"SphereMeanCurvatureByRadius"` | the differences of *log A(r)* |
| `"BallWindow"`, `"SphereWindow"` | the radii fitted |

Options:

| Option | Default | Values |
|---|---|---|
| `"Measure"` | `"RiemannianMeasure"` | `"RiemannianMeasure"` or `"CountingMeasure"`, the measure of the balls |
| `"Dimension"` | `Automatic` | a number fixes the dimension, and only the curvature is fitted |

## Basic Examples

The shells at the two ends of the sphere window, with the dimension and the scalar curvature read there. The square grid is flat; the sphere mesh has positive curvature:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {obs = VolumeGrowthObservables[g, c]}, {window = obs["SphereWindow"]},
    InfraSubstrateHighlight[g, {InfraShell[c, window[[1]]], InfraShell[c, window[[2]]], c},
      PlotLabel -> Round[{obs["SphereDimension"], obs["SphereScalarCurvature"]}, 0.01]]],
  {name, {"SquareGridGraph", "SphereMeshGraph"}}]
```

The quotients of the two probes at the centre of the square grid, the sphere quotients raised by 1. The sphere quotients are exactly 2 until the shells reach the rim; the ball quotients stay above 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]},
  {obs = VolumeGrowthObservables[g, First @ GraphCenter[g]]},
  ListLinePlot[{obs["BallLogDifferenceQuotients"], 1 + obs["SphereLogDifferenceQuotients"]},
    PlotMarkers -> Automatic, PlotLegends -> {"ball", "sphere"}, GridLines -> {None, {2}}, PlotRange -> {0, 3}]]
```

The keys of the result:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]},
  Keys @ VolumeGrowthObservables[g, First @ GraphCenter[g]]]
```

## Scope

A window given explicitly is fitted as it stands:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  KeyTake[VolumeGrowthObservables[g, c, {2, 6}], {"SphereDimension", "SphereScalarCurvature", "SphereWindow"}]]
```

A list of vertices gives one result each. At five random vertices of the sphere mesh the sphere probe reads a dimension close to 2 and a positive curvature:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]},
  {vs = RandomInfraPoint[g, 5, RandomSeeding -> 1]},
  Round[Lookup[VolumeGrowthObservables[g, vs], {"SphereDimension", "SphereScalarCurvature"}], 0.01]]
```

## Options

### Measure

The ball dimension at the centre of the square grid under the two measures, below and above 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  AssociationMap[m |-> VolumeGrowthObservables[g, c, "Measure" -> m]["BallDimension"],
    {"CountingMeasure", "RiemannianMeasure"}]]
```

### Dimension

With the dimension fixed at 2, only the curvature is fitted. The sphere probe at the centre of the sphere mesh, free and fixed:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  Table[KeyTake[VolumeGrowthObservables[g, c, "Dimension" -> d], {"SphereDimension", "SphereScalarCurvature"}],
    {d, {Automatic, 2}}]]
```

## Properties and Relations

The profiles are the measures of [InfraBall]() and [InfraShell]() at every radius:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {obs = VolumeGrowthObservables[g, c]}, {radii = Range[0, VertexEccentricity[g, c]]},
  {obs["BallVolumes"] == Table[InfraMeasurement[g, InfraBall[c, r], "RiemannianMeasure"], {r, radii}],
   obs["ShellAreas"] == Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, radii}]}]
```

## Possible Issues

A measure other than the two leaves the call unevaluated:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Head @ VolumeGrowthObservables[g, 45, "Measure" -> "VertexDensity"]]
```

## Neat Examples

The sphere probe at every vertex of the sphere mesh. The curvature is positive everywhere:

```wl
With[{g = InfraSubstrate["SphereMeshGraph", "Medium", "KeepCoordinates" -> True]},
  Histogram[Lookup[VolumeGrowthObservables[g], "SphereScalarCurvature"], {0, 0.2, 0.01}]]
```
