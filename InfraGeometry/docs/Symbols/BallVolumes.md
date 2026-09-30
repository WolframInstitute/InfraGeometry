---
Template: Symbol
Name: BallVolumes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BallVolumes
Keywords: [ball volume, volume growth, coordination sequence, growth function, dimension, Bishop-Gromov]
SeeAlso: [ShellAreas, TubeVolumes, FindInfraBall, LogDifferenceQuotients, DimensionCurvatureFit, VolumeGrowthObservables]
RelatedGuides: [RiemannianGeometryGuide]
---

## Usage

<code>[BallVolumes]()[*g*, *v*]</code> gives the ball-volume profile {*V*(0), *V*(1), …, *V*(*e*)} at the vertex *v*, where *V*(*r*) = |*B_r*(*v*)| and *e* is the eccentricity of *v*.

<code>[BallVolumes]()[*g*, *v*, *r*]</code> gives the single volume *V*(*r*).

<code>[BallVolumes]()[*g*, *v*, {*rmin*, *rmax*}]</code> gives the volumes for the radii *rmin* to *rmax*.

<code>[BallVolumes]()[*g*, {*v1*, *v2*, …}, …]</code> gives one profile per vertex; `All` takes every vertex, and <code>[BallVolumes]()[*g*]</code> is <code>[BallVolumes]()[*g*, All]</code>.

## Details & Options

Definition: the ball of radius *r* about *v* is *B_r(v) = {w : d(v, w) ≤ r}*, and its volume is *V(r) = |B_r(v)|*. Position *i* of the profile is the radius *i* − 1.

On a Riemannian manifold of dimension *d* and scalar curvature *R*, *Vol B_r = ω_d r^d (1 − R r² / (6(d + 2)) + O(r⁴))*. The count on a graph is the observer's measurement of this volume: the exponent is the dimension and the correction the curvature. [LogDifferenceQuotients]() reads the exponent off the profile, and [DimensionCurvatureFit]() both numbers.

On a flat lattice the count is the volume of the ball of a norm, not of a round disk: *2r² + 2r + 1* on the square grid, the ℓ¹ ball, and *1 + 3r(r + 1)/2* on the hexagonal tiling. The path metric of a periodic graph converges to a polyhedral norm, and the volumes see that norm.

A window past the eccentricity repeats *V(e)*, the whole component, so that the profiles of several vertices have equal length and can be transposed. The list and `All` forms read every vertex off one distance matrix.

The count is a convention for the outermost layer. Option `"Measure"`, with ∂*B_r* the vertices of the ball that have a neighbour outside it:

| Value | *V(r)* |
|---|---|
| `"FullCount"` (default) | the number of vertices of *B_r* |
| `"WithoutBoundary"` | that number less the number of vertices of ∂*B_r*: the vertices all of whose neighbours are in the ball; in the bulk of a lattice this is *V(r − 1)* |
| `"HalfBoundary"` | the full count less half the boundary: on a flat lattice the norm-ball volume with no *r^(d−1)* term, *2r² + 1* on the square grid |
| `"ExpandingFront"` | the passage count of [FindAdvancingInfraFront](), which does not stop at the eccentricity; *r* is then a step count, and `All` runs twice the eccentricity |

## Basic Examples

Ball volume against radius at the centre of the discretized plane, the square tiling and the hexagonal tiling. All three grow quadratically; the coefficient belongs to the substrate.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[With[{gr = InfraSubstrate[nm, "Large"]}, BallVolumes[gr, InfraCenter[gr], {0, 12}]], {nm, names}],
    DataRange -> {0, 12}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"r", "V(r)"}]]
```

The ball of radius 3 at the centre of a grid and its boundary, the vertices with a neighbour outside. The three measures count 25, 13 and 19.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {ballSet = FindInfraBall[g, 41, 3]},
  Labeled[
    InfraSubstrateHighlight[g, {ballSet -> $InfraBallColor, Directive[$InfraPointColor], Sequence @@ FindInfraShell[g, 41, 3]},
      ImageSize -> 220],
    BallVolumes[g, 41, 3, "Measure" -> #] & /@ {"FullCount", "WithoutBoundary", "HalfBoundary"}]]
```

The profile at one vertex, and a single volume.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {BallVolumes[g, InfraCenter[g], {0, 6}], BallVolumes[g, InfraCenter[g], 6]}]
```

## Options

### Measure

The four measures at the centre of the square tiling. Without the boundary the profile is shifted by one radius; at half weight it is *2r² + 1* from radius 1 on.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  Table[m -> BallVolumes[g, InfraCenter[g], {0, 6}, "Measure" -> m],
    {m, {"FullCount", "WithoutBoundary", "HalfBoundary", "ExpandingFront"}}]]
```

On a cycle the ball fills the graph at radius 5, and the expanding front keeps going round.

```wl
{BallVolumes[CycleGraph[10], 1], BallVolumes[CycleGraph[10], 1, "Measure" -> "ExpandingFront"]}
```

## Scope

A window past the eccentricity saturates, so the profiles of a vertex list line up.

```wl
BallVolumes[GridGraph[{5, 5}], {1, 13}, {0, 6}]
```

The mean profile over a set of vertices, carrying the spread as `Around` values.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Large"]},
  {sampleSet = Take[FindInfraBall[g, InfraCenter[g], 2], 5]},
  MeanAround /@ Transpose @ BallVolumes[g, sampleSet, {0, 5}]]
```

## Properties and Relations

The profile counts the balls that [FindInfraBall]() builds.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Large"]},
  {c = InfraCenter[g]},
  BallVolumes[g, c, {0, 6}] === Table[Length @ FindInfraBall[g, c, r], {r, 0, 6}]]
```

The square tiling's profile is the ℓ¹ ball *2r² + 2r + 1*, up to its rim.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {prof = BallVolumes[g, InfraCenter[g]]},
  prof === Table[2 r^2 + 2 r + 1, {r, 0, Length[prof] - 1}]]
```

The shell areas are the differences of the volumes, under every measure.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Medium"]},
  {c = InfraCenter[g]},
  Table[Accumulate @ ShellAreas[g, c, "Measure" -> m] === BallVolumes[g, c, "Measure" -> m],
    {m, {"FullCount", "WithoutBoundary", "HalfBoundary"}}]]
```
