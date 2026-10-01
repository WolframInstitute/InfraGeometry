---
Template: Symbol
Name: TubeVolumes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TubeVolumes
Keywords: [tube volume, tubular neighbourhood, Gray tube formula, Ricci curvature, directional growth, metric interval]
SeeAlso: [BallVolumes, ShellAreas, SegmentGraph, MetricInterval, FindInfraBall, DimensionCurvatureFit]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[TubeVolumes]()[*g*, *core*]</code> gives the tube-volume profile {*T*(0), *T*(1), …} of the vertex list *core*, where *T*(*s*) is the number of vertices within distance *s* of the core.

<code>[TubeVolumes]()[*g*, *p*, *q*]</code> takes the metric interval between *p* and *q* as the core.

<code>[TubeVolumes]()[*g*, *p*, {*q1*, *q2*, …}]</code> gives one profile per target, each about the interval from *p*; `All` takes every vertex as a target.

<code>[TubeVolumes]()[*g*, …, *s*]</code> gives the single volume *T*(*s*), and <code>[TubeVolumes]()[*g*, …, {*smin*, *smax*}]</code> the volumes for the radii *smin* to *smax*.

## Details & Options

Definition: the tube of radius *s* about a vertex set *K* is *T_s(K) = {w : d(w, K) ≤ s}*, and its volume is the number of its vertices. *T(0)* is the size of the core, and the profile saturates at the component of the core.

The tube reads the curvature along a direction, which the ball cannot. For a geodesic of length *L* and direction *v* on a Riemannian manifold, Gray's tube formula is *Vol T_s = ω_(d−1) s^(d−1) L (1 − (R + Ric(v, v)) s² / (6(d + 1)) + O(s⁴))*. The regression of [DimensionCurvatureFit]() with `"Probe" -> "Tube"` reads *R + Ric(v, v)*, and subtracting the scalar curvature read by the ball leaves the Ricci curvature in the direction *v*.

The pair form takes as core the metric interval *I(p, q) = {w : d(p, w) + d(w, q) = d(p, q)}*, the union of all geodesics from *p* to *q*, which is the vertex set of [SegmentGraph](). On a lattice the interval is fat: on the square grid it is the rectangle spanned by *p* and *q*, and a tube about it is exactly *(a + 1)(b + 1) + 2s(a + b + 2) + 2s(s − 1)* vertices, with *a* and *b* the two coordinate differences. The spread of the tube volumes over a shell of targets is then the spread of the rectangles, not curvature.

The target form reads every profile off one distance matrix, so the distribution of tube volumes over a shell of *p* is one call.

Option `"Measure"` sets the convention for the outermost layer, as in [BallVolumes](), with the boundary of the tube in place of that of the ball: `"FullCount"` (default), `"WithoutBoundary"`, `"HalfBoundary"`, `"ExpandingFront"`.

## Basic Examples

Tube volume against radius about the interval from the centre to a vertex six steps away, on the discretized plane, the square tiling and the hexagonal tiling.

```wl
With[
  {names = {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  ListLinePlot[
    Table[
      With[{gr = InfraSubstrate[nm, "Large"]},
        With[{ctr = InfraCenter[gr]},
          TubeVolumes[gr, ctr, First @ FindInfraShell[gr, ctr, 6], {0, 8}]]],
      {nm, names}],
    DataRange -> {0, 8}, PlotMarkers -> Automatic, PlotLegends -> names, AxesLabel -> {"s", "T(s)"}]]
```

The tube of radius 2 about a shortest path of four edges from the centre of the square tiling, beside its profile.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {core = FindInfraSegment[g, c, b]},
  {InfraSubstrateHighlight[g, {FindInfraBall[g, core, 2] -> $InfraBallColor, InfraWalk[core] -> $InfraSegmentColor}],
   TubeVolumes[g, core, {0, 2}]}]
```

The tube of radius 1 about a whole line through the centre, beside its profile.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {line = FindInfraLine[g, c, First @ AdjacencyList[g, c]]},
  {InfraSubstrateHighlight[g, {FindInfraBall[g, line, 1] -> $InfraBallColor, InfraWalk[line] -> $InfraLineColor}],
   TubeVolumes[g, line]}]
```

## Scope

The volumes of the tubes of radius 2 about the intervals from the centre of the square tiling to each vertex of its shell of radius 6, as a histogram.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {tubes = TubeVolumes[g, ctr, FindInfraShell[g, ctr, 6], 2]},
  {Histogram[tubes, {1}, AxesLabel -> {"T(2)", "targets"}], KeySort @ Counts @ tubes}]
```

## Properties and Relations

A tube about one vertex is a ball.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {ListPlot[{TubeVolumes[g, {ctr}, {0, 6}], BallVolumes[g, ctr, {0, 6}]}, DataRange -> {0, 6},
     PlotMarkers -> {Automatic, Medium}, PlotLegends -> {"T(s)", "V(s)"}],
   TubeVolumes[g, {ctr}, {0, 6}] === BallVolumes[g, ctr, {0, 6}]}]
```

The pair form is the tube about the [MetricInterval](), drawn with its tube of radius 1.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = InfraCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, c, 4])},
  {interval = MetricInterval[g, c, b]},
  {InfraSubstrateHighlight[g, {FindInfraBall[g, interval, 1] -> $InfraBallColor, interval -> $InfraSegmentColor}],
   TubeVolumes[g, c, b] === TubeVolumes[g, interval]}]
```

On the square tiling the tube about an interval is the exact rectangle count, the gray curve: here *a* = 2, *b* = 4.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large"]},
  {ctr = InfraCenter[g]},
  {tube = TubeVolumes[g, ctr, First @ Sort @ FindInfraShell[g, ctr, 6], {0, 5}]},
  {Show[ListPlot[tube, DataRange -> {0, 5}, AxesLabel -> {"s", "T(s)"}],
     Plot[3 * 5 + 2 s (2 + 4 + 2) + 2 s (s - 1), {s, 0, 5}, PlotStyle -> Gray]],
   tube === Table[3 * 5 + 2 s (2 + 4 + 2) + 2 s (s - 1), {s, 0, 5}]}]
```
