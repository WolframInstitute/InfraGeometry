---
Template: Symbol
Name: InfraSolidOfRevolution
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSolidOfRevolution
Keywords: [solid of revolution, profile, sliced tube, region, symbolic object, volume]
SeeAlso: [InfraTube, InfraCylinder, InfraCone, InfraBall, InfraMeasurement, RandomInfraSolidOfRevolution, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSolidOfRevolution]()[*axis*, *profile*]</code> is the solid about *axis* whose radius along the axis is *profile*: the vertices within the radius of the axis vertex they project to, with flat ends. It is a symbolic object; [InfraMeasurement]() and [RandomInfraSolidOfRevolution]() evaluate it on a graph.

<code>[InfraSolidOfRevolution]()[*axis*, *profile*, Method -> "Balls"]</code> is the rounded solid, the union of the balls of radius *r_i* about the axis vertices.

## Details & Options

Definition: the solid of revolution of the profile *r_1, …, r_m* about the axis *a_1, …, a_m* is the sliced tube <code>[InfraTube]()[*axis*, *profile*, Method -> "Sliced"]</code>. Slice *i* is the set of vertices whose nearest axis vertex is *a_i*, a tie lying in every nearest slice, and *v* is in the solid when *d(a_i, v) ≤ r_i* for its slice. The profile is read at the discrete foot of the perpendicular, so a jump of the profile is a sharp step.

*profile* is a list of radii or bands, one per axis vertex, or a function of the position *i*; a band *{s, t}* keeps the vertices at distance between *s* and *t*, and the band *{r, r}* is the surface. A pair of numbers is a band constant along the axis.

The axis is a walk: a vertex, a vertex list, or a path or cycle graph. It is prolonged straight on past both ends, and the vertices nearer a prolongation than the axis are cut, so the ends are flat. A closed axis has no ends.

[InfraCylinder]() is the constant profile and [InfraCone]() the linear one, *r_i = slope (i − 1)*. <code>Method -> "Balls"</code> drops the slicing.

The head computes nothing. A solid has one member, the vertex set. [InfraMeasurement]() reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`, and the two measures.

## Basic Examples

A strip of width 3 with one row of width 7, a sharp step, about a row of the square grid; the profile as a list, a function of the position, and rounded.

```wl
With[
  {g = GridGraph[{11, 11}]},
  {axis = 55 + Range[2, 8]},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {1, 1, 1, 3, 1, 1, 1}], axis}],
    InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, i |-> 1 + Floor[3 Sin[Pi (i - 1)/6]]], axis}],
    InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {1, 1, 1, 3, 1, 1, 1}, Method -> "Balls"], axis}]}]]
```

## Properties and Relations

The constant profile is the cylinder, and the linear profile the cone.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{11, 11}]},
  {axis = 55 + Range[2, 8]},
  {RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, ConstantArray[1, 7]] ] === RandomInfraCylinder[ g, InfraCylinder[axis, 1] ],
   RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, i |-> i - 1] ] === RandomInfraCone[ g, InfraCone[axis, 1] ]}]
```

The two measures of the solid.

```wl
With[
  {g = GridGraph[{11, 11}]},
  {axis = 55 + Range[2, 8]},
  InfraMeasurement[g, InfraSolidOfRevolution[axis, {1, 1, 1, 3, 1, 1, 1}], {"CountingMeasure", "RiemannianMeasure"}]]
```

The surface of revolution is the band profile *{r, r}*: the vertices at distance exactly *r* from their axis vertex.

```wl
With[
  {g = GridGraph[{11, 11}]},
  {axis = 55 + Range[2, 8]},
  InfraSubstrateHighlight[g, {InfraSolidOfRevolution[axis, {2, 2}], axis}]]
```
