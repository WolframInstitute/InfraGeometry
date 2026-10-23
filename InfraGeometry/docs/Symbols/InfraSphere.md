---
Template: Symbol
Name: InfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSphere
Keywords: [sphere, wall, separating set, minimal separator, shell, family, symbolic object]
SeeAlso: [RandomInfraSphere, InfraShell, InfraBall, InfraCircle, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSphere]()[*c*, *r*]</code> is the sphere of radius *r* about *c*: the family of the walls about *c* in the shell of radius *r*.

<code>[InfraSphere]()[*c*, {*r*, *s*}]</code> is the sphere in the band of radii *r* to *s*.

## Details & Options

In the band *B = {v ≠ c : r ≤ d(c, v) ≤ s}* a wall is a set *W ⊆ B* that separates *c* from the vertices beyond *s*, induces a connected subgraph, and has no proper subset that does both. The members of the sphere are its walls.

*W* separates when every path from *c* to a vertex *v* with *d(c, v) > s* meets *W*. A connected separating set is a wall exactly when no single vertex can be removed from it with both properties kept.

The shell is a set of points; the sphere is a family of connected surfaces in it. It can be empty or have many members.

A wall need not be a minimal separator. On the square grid, which is bipartite, no two vertices at one distance from *c* are adjacent, no minimal separator about *c* is connected, and the sphere of one radius is empty; in a band of two radii a wall is a closed zigzag between the two shells. On the square mesh the minimal separators are connected, and the walls are the minimal separators.

[InfraSphere]() is a symbolic object. Its members are found by search, and [InfraMeasurement]() searches all of them. The family grows fast with the width of the band: on the Small grid the band {1, 2} about the centre has 4 members and the band {1, 3} has 128.

| Property | Value |
|---|---|
| `"Cardinality"` | the number of members |
| `"VertexDensity"` | the number of members containing each vertex |
| `"CountingMeasure"` | the number of vertices in some member |
| `"RiemannianMeasure"` | the number of those vertices all of whose neighbours are in some member |

A sphere has no `"Graph"`, and `"Faithful"` stays unevaluated. [RandomInfraSphere]() draws members by a random greedy search, one by default, and [InfraMemberQ]() tests a vertex set without the search.

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

On the grid the minimal separators of the band {1, 2} are not connected, and none is a member:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {separators = RandomInfraSphere[g, c, {1, 2}, All, Properties -> {"Separating"}]},
  {Length[separators], Count[separators, s_ /; ConnectedGraphQ[Subgraph[g, s]]], AnyTrue[separators, InfraMemberQ[g, InfraSphere[c, {1, 2}], #] &]}]
```

On the mesh the members of the band {1, 2} are its minimal separators:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  RandomInfraSphere[g, c, {1, 2}, All] === RandomInfraSphere[g, c, {1, 2}, All, Properties -> {"Separating"}]]
```

On the mesh the sphere of radius 3 is the shell:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort @ RandomInfraSphere[g, InfraSphere[c, 3], RandomSeeding -> 1] == Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]]
```
