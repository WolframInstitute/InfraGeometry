---
Template: Symbol
Name: ShellAreas
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ShellAreas
Keywords: [shell area, sphere area, coordination sequence, coordination number, volume growth, dimension]
SeeAlso: [BallVolumes, FindInfraShell, TubeVolumes, LogDifferenceQuotients, DimensionCurvatureFit, VolumeGrowthObservables]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[ShellAreas]()[*g*, *v*]</code> gives the shell-area profile {*A*(0), *A*(1), …, *A*(*e*)} at the vertex *v*, where *A*(*r*) = *V*(*r*) − *V*(*r* − 1) for the ball volumes *V* and *e* is the eccentricity of *v*.

<code>[ShellAreas]()[*g*, *v*, *r*]</code> gives the single area *A*(*r*); <code>[ShellAreas]()[*g*, *v*, {*rmin*, *rmax*}]</code> the areas for the radii *rmin* to *rmax*.

<code>[ShellAreas]()[*g*, {*v1*, *v2*, …}, …]</code> gives one profile per vertex; `All` takes every vertex.

## Details & Options

Definition: the shell area at radius *r* is the radial difference of the ball volume, *A(r) = V(r) − V(r − 1)* with *V(−1) = 0*. Under the default measure it is the number of vertices of the shell *S_r(v) = {w : d(v, w) = r}*.

It is the area of the geodesic sphere as the observer counts it. On a Riemannian manifold, *Area S_r = σ_(d−1) r^(d−1) (1 − R r² / (6d) + O(r⁴))*: the exponent is one less than the dimension, and the curvature enters with *6d* where the ball has *6(d + 2)*. The ball and the shell are therefore two independent probes of the same dimension and curvature.

Under `"FullCount"` the profile is the coordination sequence of crystallography, and *A(1)* is the degree of *v*, the coordination number. On a flat lattice it is linear: *4r* on the square grid, *3r* on the hexagonal tiling.

Every option value of [BallVolumes]() is available, and the areas are the differences of those volumes, so `Accumulate` of the areas is the volume profile under the same measure. Each value is counted directly:

| `"Measure"` | *A(r)* |
|---|---|
| `"FullCount"` (default) | the number of vertices of the shell *S_r* |
| `"WithoutBoundary"` | the interior shell; in the bulk of a lattice the shell of radius *r* − 1 |
| `"HalfBoundary"` | the centred count *(A(r) + A(r − 1))/2*, with *A(0) = 1/2* |
| `"ExpandingFront"` | the size of the advancing front at step *r*, which goes on past the eccentricity |

A window past the eccentricity pads with `0`, the empty shell.

## Basic Examples

Shell area against radius at the centre of the discretized plane, the square tiling and the hexagonal tiling. All three grow linearly, the statement that they are two-dimensional; the slope belongs to the substrate.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[With[{gr = InfraSubstrate[nm, "Large"]}, ShellAreas[gr, InfraCenter[gr], {0, 12}]], {nm, names}],
    DataRange -> {0, 12}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "A(r)"}]]
```

The shells of radius 1 to 4 about the centre of a grid, of 4, 8, 12 and 16 vertices.

```wl
With[
  {g = GridGraph[{9, 9}]},
  Labeled[
    InfraSubstrateHighlight[g, Table[FindInfraShell[g, 41, r] -> $InfraShellColor, {r, 1, 4}], ImageSize -> 220],
    ShellAreas[g, 41, {1, 4}]]]
```

The first areas at the centre of the square tiling; the second entry is the degree.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  ShellAreas[g, InfraCenter[g], {0, 6}]]
```

## Options

### Measure

The four measures at the centre of the square tiling.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  Table[m -> ShellAreas[g, InfraCenter[g], {0, 6}, "Measure" -> m],
    {m, {"FullCount", "WithoutBoundary", "HalfBoundary", "ExpandingFront"}}]]
```

## Scope

On a closed surface the shell does not keep growing. On the square torus it grows linearly, levels off once it has wrapped round the short way, and shrinks as it closes up on the far side.

```wl
With[
  {g = InfraSubstrate["SquareTorusGraph", "Large"]},
  ListLinePlot[ShellAreas[g, First @ VertexList[g]], PlotMarkers -> Automatic, AxesLabel -> {"r", "A(r)"}]]
```

A window past the eccentricity pads with `0`.

```wl
ShellAreas[GridGraph[{5, 5}], 13, {0, 6}]
```

## Properties and Relations

The areas count the shells that [FindInfraShell]() builds.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Large"]},
  {c = InfraCenter[g]},
  ShellAreas[g, c, {0, 6}] === Table[Length @ FindInfraShell[g, c, r], {r, 0, 6}]]
```

`Accumulate` of the areas is the volume profile of [BallVolumes](), under every measure.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium"]},
  {c = InfraCenter[g]},
  Table[Accumulate @ ShellAreas[g, c, "Measure" -> m] === BallVolumes[g, c, "Measure" -> m],
    {m, {"FullCount", "WithoutBoundary", "HalfBoundary"}}]]
```

The second area is the degree.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium"]},
  {c = InfraCenter[g]},
  ShellAreas[g, c, 1] === VertexDegree[g, c]]
```
