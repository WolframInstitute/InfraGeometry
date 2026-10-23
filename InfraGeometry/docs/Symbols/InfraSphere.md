---
Template: Symbol
Name: InfraSphere
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSphere
Keywords: [sphere, separating set, minimal separator, shell, family, symbolic object]
SeeAlso: [RandomInfraSphere, InfraShell, InfraBall, InfraMemberQ, InfraMeasurement]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSphere]()[*c*, *r*]</code> is the sphere of radius *r* about *c*: the family of connected minimal subsets of the shell of radius *r* that separate *c* from the vertices beyond it.

<code>[InfraSphere]()[*c*, {*r*, *s*}]</code> is the sphere in the band of radii *r* to *s*.

## Details & Options

A member is a set *S ⊆ L = {v ≠ c : r ≤ d(c, v) ≤ s}* such that

- every path from *c* to a vertex *v* with *d(c, v) > s* meets *S*,
- no proper subset of *S* has this property,
- *S* is connected.

The shell is a set of vertices; the sphere is a family of vertex sets in it. It can be empty or have many members.

On the square mesh a shell of radius 1 to 4 about the centre is a ring and the only member of its sphere. On the square grid a minimal separator about the centre is not connected, and the sphere is empty; [RandomInfraSphere]() with `Properties -> {"Separating"}` gives the minimal separators.

[InfraSphere]() is a symbolic object. [InfraMeasurement]() reads the family of all its members:

| Property | Value |
|---|---|
| `"Cardinality"` | the number of members |
| `"VertexDensity"` | the number of members containing each vertex |
| `"EdgeDensity"` | the number of members whose subgraph contains each edge |
| `"CountingMeasure"` | the number of vertices in some member |
| `"RiemannianMeasure"` | the number of those vertices all of whose neighbours are in some member |

A sphere has no `"Graph"`, and `"Faithful"` stays unevaluated. [RandomInfraSphere]() draws members, one by default, and [InfraMemberQ]() tests a vertex set.

## Basic Examples

The sphere in the band of radii 1 and 2 about the centre, one member drawn, labelled with the number of members. On the grid it is empty:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {sphere = InfraSphere[c, {1, 2}]}, {member = RandomInfraSphere[g, sphere, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[c, {1, 2}], member, c}, PlotLabel -> InfraMeasurement[g, sphere, "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Four members of that sphere on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {member, c}],
    {member, RandomInfraSphere[g, InfraSphere[c, {1, 2}], 4, RandomSeeding -> 1]}]]
```

## Scope

The number of members for the radius 3 and the bands {1, 2} and {2, 3}, on the grid and on the mesh:

```wl
Table[With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    InfraMeasurement[g, InfraSphere[c, #], "Cardinality"] & /@ {3, {1, 2}, {2, 3}}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The 60 members of the mesh band {1, 2} together cover all 19 vertices of the band:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraMeasurement[g, #[c, {1, 2}], "CountingMeasure"] & /@ {InfraSphere, InfraShell}]
```

## Properties and Relations

On the mesh the shell of radius 3 is a member, while the whole band {1, 2} separates but is not minimal:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraMemberQ[g, InfraSphere[c, #], Keys @ InfraMeasurement[g, InfraShell[c, #], "VertexDensity"]] & /@ {3, {1, 2}}]
```

## Possible Issues

On the grid the band {1, 2} has 16 minimal separators, none connected, so the sphere has no member:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {InfraMeasurement[g, InfraSphere[c, {1, 2}], "Cardinality"],
   Length @ RandomInfraSphere[g, c, {1, 2}, All, Properties -> {"Separating"}]}]
```
