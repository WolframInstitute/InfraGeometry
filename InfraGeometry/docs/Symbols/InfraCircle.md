---
Template: Symbol
Name: InfraCircle
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircle
Keywords: [circle, radius, band, separating cycle, symbolic object]
SeeAlso: [InfraCircleThrough, InfraArc, InfraMeasurement, RandomInfraCircle, InfraShell]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraCircle]()[*c*, *r*]</code> is the family of circles around *c* in the shell of radius *r*.

<code>[InfraCircle]()[*c*, {*r*, *s*}]</code> is the family of circles around *c* in the band *r ≤ d(c, v) ≤ s*.

## Details & Options

Let *W = {v : r ≤ d(c, v) ≤ s}*. A circle of *W* is a shortest cycle of the subgraph induced on *W* among those whose removal cuts *c* off from every vertex beyond *W*. When nothing lies beyond *W* the condition is empty.

A circle need not exist. On a bipartite graph, such as the square grid, no two vertices of one shell are adjacent, so a single shell carries no circle. On the square grid the band {*r*, *r* + 1} does. On the mesh a single shell usually carries one.

A circle need not be unique. On the square grid, away from the rim, the band {*r*, *r* + 1} carries one circle and the band {*r*, *r* + 2} carries *16ʳ⁻¹*, all of length *8r*: the circle of the ℓ¹ norm.

[InfraCircle]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [RandomInfraCircle]() draws members. A member is a cyclic vertex list; its first vertex is not repeated, and its length is its number of vertices.

| Property | Value |
|---|---|
| `"Graph"` | a list of DAGs; each runs from a vertex *x* to a copy `{x, 3/2}` of it, and its paths are the circles through *x* opened at *x* |
| `"Cardinality"` | the number of circles |
| `"Length"` | their common length; `{}` when there is none |
| `"VertexDensity"` | the number of circles through each vertex |

The circles of the band of *p* that pass through *p* are the closed arc <code>[InfraArc]()[*c*, {*p*}]</code>. [InfraCircleThrough]() asks for circles through several given points.

In an [InfraScene](), <code>[InfraCircle]()[*c*, *r*]</code> is the circle about the point *c*.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To describe a circle with any centre and distance. |
| Hilbert | (not primitive) | Circles are defined from congruence. |
| Tarski | Equidistance | The points at a fixed distance from a centre, from the congruence relation. |

## Basic Examples

The circles of the band {3, 4} about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraCircle[c, {3, 4}], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Their number and length. The grid has one circle, the mesh many:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraMeasurement[g, InfraCircle[c, {3, 4}], {"Cardinality", "Length"}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

One circle of the mesh, drawn as a closed walk:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {circle = RandomInfraCircle[g, InfraCircle[c, {3, 4}], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[circle, First @ circle]], c}, ImageSize -> Medium]]
```

## Scope

The shell of radius 3 alone. It carries no circle on the grid and one on the mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 3], InfraCircle[c, 3], c}, PlotLabel -> InfraMeasurement[g, InfraCircle[c, 3], "Cardinality"]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A thicker band gives more circles. On the grid the band {2, 4} carries 16 circles of length 16, each edge drawn by the number of circles through it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, {InfraCircle[c, {2, 4}], c},
    PlotLabel -> InfraMeasurement[g, InfraCircle[c, {2, 4}], {"Cardinality", "Length"}], ImageSize -> Medium]]
```

## Properties and Relations

On the square grid the bands {*r*, *r* + 1} and {*r*, *r* + 2}: one circle and *16ʳ⁻¹* circles, of length *8r*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  Table[{InfraMeasurement[g, InfraCircle[c, {r, r + 1}], "Cardinality"], InfraMeasurement[g, InfraCircle[c, {r, r + 2}], "Cardinality"],
    16^(r - 1), InfraMeasurement[g, InfraCircle[c, {r, r + 2}], "Length"]}, {r, 1, 5}]]
```

Every circle separates: without it, the vertices still joined to *c* lie within distance 3, inside the band {3, 4}:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  Union @ Table[Max[GraphDistance[g, c, #] & /@ First @ ConnectedComponents[VertexDelete[g, circle], {c}]],
    {circle, RandomInfraCircle[g, InfraCircle[c, {3, 4}], All]}]]
```

The members of the closed arc through *p* are the circles through *p*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  Sort[Sort /@ RandomInfraArc[g, InfraArc[c, {p}, "RadiusDelta" -> 1], All]] ===
    Sort[Sort /@ Select[RandomInfraCircle[g, InfraCircle[c, {3, 4}], All], MemberQ[#, p] &]]]
```
