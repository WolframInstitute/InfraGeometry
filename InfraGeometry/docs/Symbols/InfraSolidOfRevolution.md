---
Template: Symbol
Name: InfraSolidOfRevolution
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSolidOfRevolution
Keywords: [solid of revolution, surface of revolution, profile, sliced tube, region, symbolic object, volume]
SeeAlso: [InfraTube, InfraCylinder, InfraCone, InfraBall, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSolidOfRevolution]()[*axis*, *profile*]</code> is the solid about the walk *axis* whose radius at the *i*-th axis vertex is the *i*-th entry of *profile*.

<code>[InfraSolidOfRevolution]()[*axis*, *profile*, Method -> "Balls"]</code> is the union of the balls of the profile radii about the axis vertices.

## Details & Options

For the axis *a₁, …, aₘ* and the radii *r₁, …, rₘ*, a vertex *v* belongs to the solid when *d(aᵢ, v) ≤ rᵢ* for an axis vertex *aᵢ* nearest to *v*. The nearest axis vertex is the foot of the perpendicular from *v*: the radius is read slice by slice, and a jump of the profile is a sharp step.

The axis is prolonged straight past both ends, and the vertices nearer a prolongation than the axis are cut, so the ends are flat. With `Method -> "Balls"` the solid is the union of the balls *B_{rᵢ}(aᵢ)*, with round ends and no sharp steps.

*profile* is a list with one entry per axis vertex, or a function of the position *i*. An entry {*s*, *t*} keeps the vertices at distance *s* to *t*; the constant band {*r*, *r*} gives the surface of revolution.

[InfraCylinder]() is the constant profile, [InfraCone]() the linear profile *rᵢ = m (i − 1)*.

[InfraSolidOfRevolution]() is a symbolic object, a region with one member, its vertex set. [InfraMeasurement]() reads its density and the two measures.

## Basic Examples

A solid about a shortest path of 7 vertices from the centre, its radius rising from 1 to 3 and back:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {1, 2, 3, 3, 3, 2, 1}], axis}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A sharp step of the profile, sliced and as a union of balls. The balls round the ends and spread the step into a diamond:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {1, 1, 1, 3, 1, 1, 1}, Method -> method], axis},
      PlotLabel -> InfraMeasurement[g, InfraSolidOfRevolution[axis, {1, 1, 1, 3, 1, 1, 1}, Method -> method], "CountingMeasure"]],
    {method, {"Sliced", "Balls"}}]]
```

## Scope

A profile can be a function of the position along the axis:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, i |-> Round[3 Sin[Pi (i - 1)/6]]], axis}, ImageSize -> Medium]]
```

The constant band {2, 2} is the surface of revolution:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {2, 2}], axis}, ImageSize -> Medium]]
```

## Properties and Relations

The constant profile is the cylinder, and the linear profile the cone:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
  {Keys @ InfraMeasurement[g, InfraSolidOfRevolution[axis, ConstantArray[2, 7]], "VertexDensity"] ==
     Keys @ InfraMeasurement[g, InfraCylinder[axis, 2], "VertexDensity"],
   Keys @ InfraMeasurement[g, InfraSolidOfRevolution[axis, i |-> i - 1], "VertexDensity"] ==
     Keys @ InfraMeasurement[g, InfraCone[axis, 1], "VertexDensity"]}]
```

The balls contain the sliced solid:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {axis = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 2], RandomSeeding -> 1]},
  SubsetQ[Keys @ InfraMeasurement[g, InfraSolidOfRevolution[axis, {1, 2, 3, 3, 3, 2, 1}, Method -> "Balls"], "VertexDensity"],
    Keys @ InfraMeasurement[g, InfraSolidOfRevolution[axis, {1, 2, 3, 3, 3, 2, 1}], "VertexDensity"]]]
```
