---
Template: Symbol
Name: InfraTube
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTube
Keywords: [tube, neighbourhood, region, symbolic object, volume, counting measure, Riemannian measure]
SeeAlso: [InfraCylinder, InfraCone, InfraBall, InfraMeasurement, InfraSolidOfRevolution, InfraSegment, InfraInterior, InfraBoundary]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraTube]()[*core*, *s*]</code> is the tube of radius *s* about *core*: the vertices at distance at most *s* from it.

<code>[InfraTube]()[*core*, {*s*, *t*}]</code> is the mantle: the vertices at distance between *s* and *t* from *core*.

<code>[InfraTube]()[*axis*, *profile*]</code> is the tube whose radius varies along the walk *axis*, given by a list of radii or bands, one per vertex, or a function of the position *i*.

## Details & Options

The tube of radius *s* is *Tₛ(K) = {v : d(v, K) ≤ s}*, with *d(v, K)* the distance to the nearest vertex of the core *K*. The tube of a vertex is the ball.

The core is a vertex, a vertex list, a density, a graph or an object such as [InfraSegment]().

Along an axis *a₁, …, aₘ* with radii *rᵢ* the tube is *{v : d(aᵢ, v) ≤ rᵢ for some i}*. A band {*sᵢ*, *tᵢ*} keeps the vertices with *d(aᵢ, v) ≤ tᵢ* for some *i* and *d(aᵢ, v) ≥ sᵢ* for all *i*. The band {*r*, *r*} is the surface at distance *r*.

[InfraTube]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [InfraSubstrateHighlight]() draws it.

The tube of a segment is the tube of its whole interval, the *fat tube*. It is fatter than the *thin tube* about one shortest path, a member drawn by [RandomInfraSegment]().

On the square grid, away from the rim, with *a* and *b* the axis steps from *p* to *q*, the fat tube has

*|Tₛ| = (a + 1)(b + 1) + 2s(a + b + 2) + 2s(s − 1)*

vertices. Its Riemannian measure is the same count at *s − 1*, for *s ≥ 1*. In the plane the set within *s* of a segment of length *L* has area *2sL + πs²*.

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the tube |
| `"RiemannianMeasure"` | the number of vertices of its [InfraInterior](), those all of whose neighbours lie in the tube |

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Balls"` | `"Balls"`: the union of the balls about the axis vertices, rounded at the ends; `"Sliced"`: each vertex reads the profile at its nearest axis vertex, and the ends are flat |

[InfraCylinder](), [InfraCone]() and [InfraSolidOfRevolution]() are sliced tubes.

## Basic Examples

The tube of radius 2 about a segment, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]]},
    InfraSubstrateHighlight[g, {InfraTube[seg, 2], seg}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The interior of the tube drawn over it. The Riemannian measure counts the interior, the counting measure the whole tube:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {tube = InfraTube[InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]], 2]},
    InfraSubstrateHighlight[g, {tube, InfraInterior[g, tube]},
      PlotLabel -> InfraMeasurement[g, tube, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The mantle of radii 2 to 3:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]]},
  InfraSubstrateHighlight[g, {InfraTube[seg, {2, 3}], seg}, ImageSize -> Medium]]
```

## Scope

A radius that grows to 2 and falls again along a straight axis of 5 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 3], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraTube[axis, {0, 1, 2, 1, 0}], axis}, ImageSize -> Medium]]
```

A profile can be a function of the position. The radius *i − 1* along a shortest path of the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraTube[axis, # - 1 &], axis}, ImageSize -> Medium]]
```

## Options

### Method

`"Balls"` rounds the ends; `"Sliced"` cuts them flat. The tube of radius 2 and its surface, the band {2, 2}:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 3], RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {tube, axis}],
    {tube, {InfraTube[axis, 2],
      InfraTube[axis, 2, Method -> "Sliced"], InfraTube[axis, {2, 2}, Method -> "Sliced"]}}]]
```

## Properties and Relations

The fat tube about a segment of the grid with steps 2 and 3 against *12 + 14s + 2s(s − 1)*, and its Riemannian measure, the same count one radius later:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]]},
  {Table[12 + 14 s + 2 s (s - 1), {s, 0, 4}],
   Table[InfraMeasurement[g, InfraTube[seg, s], m], {m, {"CountingMeasure", "RiemannianMeasure"}}, {s, 0, 4}]}]
```

The fat tube against the thin tube about one shortest path, both of radius 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraTube[core, 1], core},
      PlotLabel -> InfraMeasurement[g, InfraTube[core, 1], "CountingMeasure"]],
    {core, {InfraSegment[c, b], RandomInfraSegment[g, c, b, RandomSeeding -> 1]}}]]
```

The tube of a vertex is the ball:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraMeasurement[g, InfraTube[c, 3], "VertexDensity"] === InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]]
```
