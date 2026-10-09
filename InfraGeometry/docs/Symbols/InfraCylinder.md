---
Template: Symbol
Name: InfraCylinder
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCylinder
Keywords: [cylinder, solid of revolution, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraTube, InfraCone, InfraBall, InfraMeasurement, FindInfraRepresentative, InfraSolidOfRevolution, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCylinder]()[*axis*, *r*]</code> is the cylinder of radius *r* about *axis*: the vertices within *r* of the axis vertex they project to, with flat ends. It is a symbolic object; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraCylinder]()[*axis*, {*r*, *s*}]</code> is the mantle: the vertices at distance between *r* and *s* from their axis vertex.

<code>[InfraCylinder]()[*axis*, *r*, Method -> "Balls"]</code> is the rounded cylinder, the union of the balls of radius *r* about the axis vertices.

## Details & Options

Definition: the cylinder of radius *r* about *axis* is the sliced tube <code>[InfraTube]()[*axis*, *r*, Method -> "Sliced"]</code>. Slice *i* is the set of vertices whose nearest axis vertex is *a_i*, a tie lying in every nearest slice, and *v* is in the cylinder when *d(a_i, v) ≤ r* for its slice.

The axis is a walk: a vertex, a vertex list, or a path or cycle graph. A density or a Euclidean head such as [InfraSegment]() leaves the call unevaluated; <code>[FindInfraRepresentative]()[*g*, [InfraSegment]()[*p*, *q*]]</code> gives the axis of one shortest path.

The axis is prolonged straight on past both ends, through the neighbours of an end vertex that continue the line, and the vertices nearer a prolongation than the axis are cut. So the ends are flat, which is what makes a cylinder and not a tube. A closed axis has no ends.

<code>Method -> "Balls"</code> reads the same profile as the union of the balls, <code>[InfraTube]()[*axis*, *r*]</code>, rounded at both ends.

[InfraMeasurement]() gives two measures of a cylinder:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the cylinder |
| `"RiemannianMeasure"` | the number of vertices of the cylinder all of whose neighbours lie in it: the count without the mantle and the ends |

The cylinder of radius 0 is the axis, and its Riemannian measure is `0`: a path in a grid is all boundary.

The head computes nothing. A cylinder has one member, the vertex set. [InfraMeasurement]() also reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`.

## Basic Examples

The cylinder of radius 1 about a shortest path on the discretized plane, the square grid and the hexagonal tiling. The Riemannian measure counts the inner vertices, in green; the counting measure adds the boundary, in blue.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {axis = FindInfraRepresentative[g, InfraSegment[c, (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 4]])]]},
    {cylinder = InfraCylinder[axis, 1]},
    {support = FindInfraRepresentative[g, cylinder]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraInterior[g, support] -> StandardGreen, InfraBoundary[g, support] -> StandardBlue}],
      InfraMeasurement[g, cylinder, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

## Properties and Relations

On the square grid the sliced cylinder about a column is the rectangle with flat ends, and the rounded one adds the half disks.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axis = {39, 40, 41, 42, 43}},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraCylinder[axis, 2], axis}],
    InfraSubstrateHighlight[g, {InfraCylinder[axis, 2, Method -> "Balls"], axis}]}]]
```

The rounded cylinder is the tube about the axis, and the cylinder lies in it.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axis = {39, 40, 41, 42, 43}},
  {tube = FindInfraRepresentative[g, InfraTube[axis, 2]]},
  {FindInfraRepresentative[g, InfraCylinder[axis, 2, Method -> "Balls"]] === tube,
   SubsetQ[tube, FindInfraRepresentative[g, InfraCylinder[axis, 2]]]}]
```

The cylinder is the solid of revolution of the constant profile.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axis = {39, 40, 41, 42, 43}},
  FindInfraRepresentative[g, InfraCylinder[axis, 2]] === FindInfraRepresentative[g, InfraSolidOfRevolution[axis, ConstantArray[2, 5]]]]
```
