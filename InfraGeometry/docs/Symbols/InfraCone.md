---
Template: Symbol
Name: InfraCone
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCone
Keywords: [cone, solid of revolution, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraTube, InfraCylinder, InfraBall, InfraMeasurement, InfraSolidOfRevolution, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCone]()[*axis*, *m*]</code> is the cone of slope *m* along the walk *axis*, with its apex at the first vertex of the axis and a flat base at the last.

## Details & Options

Let the axis be *a₁, …, aₙ*. The cone is the cylinder whose radius grows from the apex: *v* is in the cone when *d(aᵢ, v) ≤ ⌊m (i − 1)⌋* for an axis vertex *aᵢ* nearest to *v*. It is the sliced tube <code>[InfraTube]()[*axis*, *i* |-> *m* (*i* − 1), Method -> "Sliced"]</code>.

A radius is a whole number of steps. A cone of slope 1/2 grows by one step every second axis vertex, and its side is a staircase.

The base is flat: as for [InfraCylinder](), the vertices nearer the prolongation of the axis than the axis are cut off. Reverse the axis to put the apex at the other end. Slope 0 gives the axis.

On the square grid, away from the rim, the cone of slope 1 along a straight axis of *n* edges is a triangle with *(n + 1)²* vertices, *(n − 1)²* of them interior.

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the cone |
| `"RiemannianMeasure"` | the number of vertices of its [InfraInterior](), those all of whose neighbours lie in the cone |

The apex is boundary, and so is the axis near it, where the cone is thinner than one step.

[InfraCone]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph. It has one member, the vertex set.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Sliced"` | `"Sliced"`: a flat base; `"Balls"`: the union of the balls of radius *⌊m (i − 1)⌋* about the axis vertices, with a round base |

With `Method -> "Balls"` and *m ≥ 1* along a shortest path, the cone is the ball of radius *⌊m (n − 1)⌋* about the far end *aₙ*: by the triangle inequality every ball about *aᵢ* lies in it.

## Basic Examples

The cone of slope 1/2 along a shortest path of length 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraCone[axis, 1/2], axis}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The cone of slope 1 along a straight axis of the grid and its interior, with the two measures *(n + 1)² = 49* and *(n − 1)² = 25* for *n* = 6:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {q = SelectFirst[Keys @ InfraMeasurement[g, InfraShell[c, 6], "VertexDensity"], InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] == 1 &]},
  {cone = InfraCone[First @ RandomInfraSegment[g, c, q, All], 1]},
  InfraSubstrateHighlight[g, {cone, InfraInterior[g, Keys @ InfraMeasurement[g, cone, "VertexDensity"]]},
    PlotLabel -> InfraMeasurement[g, cone, {"CountingMeasure", "RiemannianMeasure"}], ImageSize -> Medium]]
```

## Scope

The reversed axis puts the apex at the other end:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {InfraCone[a, 1], a}], {a, {axis, Reverse[axis]}}]]
```

## Options

### Method

The cone of slope 1 with a flat base, with a round base, and the ball of radius 4 about the far end. The last two are equal:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {region, axis}],
    {region, {InfraCone[axis, 1], InfraCone[axis, 1, Method -> "Balls"], InfraBall[Last[axis], 4]}}]]
```

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  Keys @ InfraMeasurement[g, InfraCone[axis, 1, Method -> "Balls"], "VertexDensity"] ===
    Keys @ InfraMeasurement[g, InfraBall[Last[axis], 4], "VertexDensity"]]
```

## Properties and Relations

The two measures against the slope, along a shortest path of length 6 on the grid. Slope 0 is the axis, all boundary:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1], RandomSeeding -> 1]},
  ListLinePlot[
    Table[{m, InfraMeasurement[g, InfraCone[axis, m], measure]}, {measure, {"CountingMeasure", "RiemannianMeasure"}}, {m, 0, 3/2, 1/4}],
    PlotMarkers -> Automatic, PlotLegends -> {"CountingMeasure", "RiemannianMeasure"}]]
```

The cone of slope *m* lies in the cylinder of radius *m (n − 1)*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
  SubsetQ[Keys @ InfraMeasurement[g, InfraCylinder[axis, Length[axis] - 1], "VertexDensity"],
    Keys @ InfraMeasurement[g, InfraCone[axis, 1], "VertexDensity"]]]
```
