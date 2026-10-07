---
Template: Symbol
Name: InfraCone
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCone
Keywords: [cone, solid of revolution, region, inert head, volume, counting measure, Riemannian measure]
SeeAlso: [InfraTube, InfraCylinder, InfraBall, InfraMeasurement, FindInfraRepresentative, InfraSolidOfRevolution, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCone]()[*axis*, *slope*]</code> is the cone along *axis* with apex *axis*[[1]]: the vertices within *slope* (*i* − 1) of the *i*-th vertex of the axis they project to, with a flat base. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCone]()[*axis*, *slope*, Method -> "Balls"]</code> is the rounded cone, the union of the balls of radius *slope* (*i* − 1) about the vertices of the axis.

## Details & Options

Definition: with the axis *a_1, …, a_n*, the cone of slope *m* is the sliced tube <code>[InfraTube]()[*axis*, *i* |-> *m* (*i* − 1), Method -> "Sliced"]</code>. Slice *i* is the set of vertices whose nearest axis vertex is *a_i*, a tie lying in every nearest slice, and *v* is in the cone when *d(a_i, v) ≤ m (i − 1)* for its slice: the radius grows linearly from the apex, and is read at the axis vertex the vertex projects to.

A radius is a whole number of steps, so the radius *m (i − 1)* is rounded down: a cone of slope 1/2 grows by one step every second vertex of the axis, and its mantle is a staircase.

The axis is prolonged straight on past both ends and the vertices nearer a prolongation than the axis are cut, so the base is flat: the cone keeps a full row at the last axis vertex. <code>Method -> "Balls"</code> drops the slicing and rounds the base. The rounded cone of the earlier releases is <code>[InfraTube]()[*axis*, *i* |-> *m* (*i* − 1)]</code>.

*axis* is a walk: a vertex list, for example one representative of a segment or a ray, or a path or cycle graph. Reverse it for the other apex. Slope 0 gives the axis.

[InfraMeasurement]() gives two measures of a cone:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the cone |
| `"RiemannianMeasure"` | the number of vertices of the cone all of whose neighbours lie in it: the count without the mantle and the base |

The apex is boundary, and so is the axis near it, where the cone is thinner than one step.

A slope *m ≥ 1* gives a ball under <code>Method -> "Balls"</code>. When the axis *a_1, …, a_n* is a shortest path, the rounded cone of slope *m ≥ 1* is <code>[InfraBall]()[*a_n*, ⌊*m* (*n* − 1)⌋]</code>, the ball about the far end: a vertex within *⌊m (i − 1)⌋* of *a_i* is within *⌊m (i − 1)⌋ + n − i ≤ ⌊m (n − 1)⌋* of *a_n*, by the triangle inequality along the axis. So the counts of [InfraBall]() apply. For *0 < m < 1* no lattice count is known, and the cone is measured.

In the continuum two cones are the references. In the Euclidean plane the union of the disks of radius *m t* about the points at distance *t* along a segment of length *R*, for *0 ≤ m < 1*, is the convex hull of the apex and the far disk of radius *m R*, with area

*m R² √(1 − m²) + m² R² (π − arccos m)*.

In a Riemannian manifold of dimension *n* the angular cone *{exp_p(t u) : u ∈ Ω, 0 ≤ t ≤ r}* over a set *Ω* of unit directions at the apex *p*, of spherical measure *σ(Ω)*, has volume

*σ(Ω) r^n / n − r^(n+2) / (6(n + 2)) ∫_Ω Ric(u, u) dσ + O(r^(n+3))*.

Over the round cap *Ω* of half-angle *α* about the axis direction *v*, *∫_Ω Ric(u, u) dσ = c_⊥ Scal + (c_∥ − c_⊥) Ric(v, v)*, with *c_∥ = |S^(n−2)| ∫_0^α cos² t sin^(n−2) t dt* and *c_⊥ = (σ(Ω) − c_∥)/(n − 1)*: a thin cone reads the Ricci curvature along its axis. The rounded cone of this head is the hull, not an angular cone; it agrees with the angular cone of half-angle *arcsin m* within distance *R (1 − m)* of the apex.

How the number is measured: <code>[InfraMeasurement]()[*g*, [InfraCone]()[*axis*, *m*], *measure*]</code> takes the vertices within *⌊m (i − 1)⌋* of the axis vertex they project to, or the union of the balls of radius *⌊m (i − 1)⌋* about the vertices of the axis under <code>Method -> "Balls"</code>, and counts them, or counts their [InfraInterior](). The profile is the list over the slope.

The head computes nothing. A cone has one member, the vertex set. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`.

## Basic Examples

The cone of slope 1/2 along a shortest path on the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure counts the inner vertices, in green; the counting measure adds the boundary, in blue.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4]])]]},
    {cone = InfraCone[axis, 1/2]},
    {support = FindInfraRepresentative[g, cone]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}],
      InfraMeasurement[g, cone, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The same axis read from the other end gives the other apex; the base is a full row.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4]])]]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCone[axis, 1], axis}],
    InfraSubstrateHighlight[g, {InfraCone[Reverse @ axis, 1], axis}]}]]
```

## Properties and Relations

The two measures against the slope, along a shortest path of length 6 on the square grid. Slope 0 is the axis, all boundary.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium"]},
  {c = First @ GraphCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 6]])]]},
  {slopes = Range[0, 2, 1/4]},
  ListLinePlot[
    Table[{m, InfraMeasurement[g, InfraCone[axis, m], measure]}, {measure, {"CountingMeasure", "RiemannianMeasure"}}, {m, slopes}],
    PlotMarkers -> Automatic, PlotLegends -> {"CountingMeasure", "RiemannianMeasure"}, AxesLabel -> {"slope", None}]]
```

The cone of slope 1 along a shortest path, sliced, rounded, and the ball of radius the length of the axis about the far end. The rounded cone is that ball; the sliced one keeps the base flat.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4]])]]},
  {cone = InfraCone[axis, 1, Method -> "Balls"]},
  {farBall = InfraBall[Last[axis], 4]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {InfraCone[axis, 1], axis}], InfraSubstrateHighlight[g, {cone, axis}], InfraSubstrateHighlight[g, {farBall, Last[axis]}]}],
   FindInfraRepresentative[g, cone] === FindInfraRepresentative[g, farBall]}]
```

The cone is contained in the cylinder of radius *slope* (*n* − 1).

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small"]},
  {c = First @ GraphCenter[g]},
  {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 4]])]]},
  SubsetQ[FindInfraRepresentative[g, InfraCylinder[axis, Length[axis] - 1]], FindInfraRepresentative[g, InfraCone[axis, 1]]]]
```
