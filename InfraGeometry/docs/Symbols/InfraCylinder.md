---
Template: Symbol
Name: InfraCylinder
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCylinder
Keywords: [cylinder, solid of revolution, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraTube, InfraCone, InfraBall, InfraMeasurement, InfraSolidOfRevolution, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCylinder]()[*axis*, *r*]</code> is the cylinder of radius *r* about the walk *axis*: the vertices within *r* of the axis vertex they project to, with flat ends.

<code>[InfraCylinder]()[*axis*, {*r*, *s*}]</code> is the shell of the cylinder: the vertices at distance between *r* and *s* from the axis vertex they project to.

## Details & Options

Let the axis be *a₁, …, aₙ*. A vertex *v* projects to the axis vertices nearest to it. The cylinder is *Z = {v : d(aᵢ, v) ≤ r for an axis vertex aᵢ nearest to v}*, the sliced tube <code>[InfraTube]()[*axis*, *r*, Method -> "Sliced"]</code>.

The axis is prolonged straight past both ends, and the vertices nearer the prolongation than the axis are cut off. So the ends are flat. A closed axis has no ends.

The axis is a vertex list or a path or cycle graph, such as one shortest path drawn by [RandomInfraSegment]().

On the square grid, away from the rim, the cylinder of radius *r* about a straight axis of *n* edges is the (*n* + 1) × (2*r* + 1) rectangle. Its counting measure is *(n + 1)(2r + 1)* and its Riemannian measure *(n − 1)(2r − 1)* for *r ≥ 1*.

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the cylinder |
| `"RiemannianMeasure"` | the number of vertices of its [InfraInterior](), those all of whose neighbours lie in the cylinder |

The cylinder of radius 0 is the axis. Its Riemannian measure is 0: a path in a grid is all boundary.

[InfraCylinder]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph. It has one member, the vertex set.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Sliced"` | `"Sliced"`: flat ends; `"Balls"`: the union of the balls of radius *r* about the axis vertices, with round ends |

## Basic Examples

The cylinder of radius 1 about a shortest path of length 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraCylinder[axis, 1], axis}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The interior drawn over the cylinder, with the two measures:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
    {cylinder = InfraCylinder[axis, 1]},
    InfraSubstrateHighlight[g, {cylinder, InfraInterior[g, Keys @ InfraMeasurement[g, cylinder, "VertexDensity"]]},
      PlotLabel -> InfraMeasurement[g, cylinder, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The shell of radius 1 to 2 about the axis, without the axis itself:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraCylinder[axis, {1, 2}], axis}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Options

### Method

Flat ends and round ends about a straight axis of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = SelectFirst[Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"], InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] == 1 &]},
  {axis = First @ RandomInfraSegment[g, c, q, All]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraCylinder[axis, 2, Method -> m], axis},
      PlotLabel -> InfraMeasurement[g, InfraCylinder[axis, 2, Method -> m], "CountingMeasure"]],
    {m, {"Sliced", "Balls"}}]]
```

## Properties and Relations

About a straight axis of 4 edges on the grid, the counting measure is *5(2r + 1)* and the Riemannian measure *3(2r − 1)*; the round ends add *2r²*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = SelectFirst[Keys @ InfraMeasurement[g, InfraShell[c, 4], "VertexDensity"], InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] == 1 &]},
  {axis = First @ RandomInfraSegment[g, c, q, All]},
  Table[{InfraMeasurement[g, InfraCylinder[axis, r], "CountingMeasure"], 5 (2 r + 1),
    InfraMeasurement[g, InfraCylinder[axis, r], "RiemannianMeasure"], 3 (2 r - 1), InfraMeasurement[g, InfraCylinder[axis, r, Method -> "Balls"], "CountingMeasure"] - 5 (2 r + 1)}, {r, 1, 3}]]
```

The cylinder lies in the tube about its axis, and with round ends it is the tube:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  {tube = Keys @ InfraMeasurement[g, InfraTube[axis, 2], "VertexDensity"]},
  {SubsetQ[tube, Keys @ InfraMeasurement[g, InfraCylinder[axis, 2], "VertexDensity"]],
   Keys @ InfraMeasurement[g, InfraCylinder[axis, 2, Method -> "Balls"], "VertexDensity"] === tube}]
```

It is the solid of revolution of the constant profile:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  Keys @ InfraMeasurement[g, InfraCylinder[axis, 2], "VertexDensity"] ===
    Keys @ InfraMeasurement[g, InfraSolidOfRevolution[axis, ConstantArray[2, Length[axis]]], "VertexDensity"]]
```
