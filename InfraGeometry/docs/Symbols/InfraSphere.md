---
Template: Symbol
Name: InfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSphere
Keywords: [sphere, separating set, minimal separator, shell, family, symbolic object]
SeeAlso: [RandomInfraSphere, InfraShell, InfraBall, InfraCircle, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSphere]()[*c*, *r*]</code> is the sphere of radius *r* about *c*: the family of minimal connected subsets of the shell of radius *r* that separate *c* from the far side.

<code>[InfraSphere]()[*c*, {*r*, *s*}]</code> is the sphere in the band of radii *r* to *s*.

## Details & Options

A member is a set *T* of vertices with *r ≤ d(c, v) ≤ s* such that

- *T* is connected,
- deleting *T* leaves the component of *c* within distance *(r + s)/2* of *c* and every other vertex beyond it,
- no proper subset of *T* has both properties.

The shell is a set of points; the sphere is a family of connected surfaces in it. It can be empty or have many members.

On a bipartite graph, such as the square grid, no two vertices at the same distance from *c* are adjacent. A shell of one radius then has no connected subset of more than one vertex, and the sphere of one radius is empty. A band of two radii carries spheres. On the square mesh the shell is a connected ring and is its own sphere.

[InfraSphere]() is a symbolic object. Its members are found by search, not read off a graph, and [InfraMeasurement]() searches all of them:

| Property | Value |
|---|---|
| `"Cardinality"` | the number of members |
| `"VertexDensity"` | the number of members containing each vertex |
| `"CountingMeasure"` | the number of vertices in some member |
| `"RiemannianMeasure"` | the number of those vertices all of whose neighbours are in some member |

A sphere has no `"Graph"`, and `"Faithful"` stays unevaluated. [RandomInfraSphere]() draws members, one by default.

## Basic Examples

A sphere of radius 3 about the centre, drawn over its shell. On the grid it needs the band of radii 2 and 3; on the mesh it is the whole shell of radius 3:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[First @ spec, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, Last @ spec], RandomInfraSphere[g, InfraSphere[c, Last @ spec], RandomSeeding -> 1], c}]],
  {spec, {{"SquareGridGraph", {2, 3}}, {"SquareMeshGraph", 3}}}]
```

The four members of the sphere in the band of radii 1 and 2 on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {member, c}], {member, RandomInfraSphere[g, InfraSphere[c, {1, 2}], All]}]]
```

## Scope

On the grid the sphere of one radius is empty; on the mesh it has one member:

```wl
Table[With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]}, InfraMeasurement[g, InfraSphere[c, 3], "Cardinality"]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

In the band of radii 1 and 2 on the grid the four members together cover 8 of the 12 vertices of the band:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {InfraMeasurement[g, InfraSphere[c, {1, 2}], "Cardinality"], InfraMeasurement[g, InfraSphere[c, {1, 2}], "CountingMeasure"],
   InfraMeasurement[g, InfraShell[c, {1, 2}], "CountingMeasure"]}]
```

## Properties and Relations

Every member is connected and lies in the band:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {band = Keys @ InfraMeasurement[g, InfraShell[c, {1, 2}], "VertexDensity"]},
  AllTrue[RandomInfraSphere[g, InfraSphere[c, {1, 2}], All], ConnectedGraphQ[Subgraph[g, #]] && SubsetQ[band, #] &]]
```

On the mesh the sphere of radius 3 is the shell:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraSphere[g, InfraSphere[c, 3], RandomSeeding -> 1] == Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]]
```
