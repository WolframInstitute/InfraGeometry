---
Template: Symbol
Name: InfraPerpendicularQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPerpendicularQ
Keywords: [perpendicular, right angle, projection, foot, tolerance]
SeeAlso: [FindInfraPerpendicular, InfraParallelQ, InfraAngle, InfraEqualQ, InfraInfiniteLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraPerpendicularQ]()[*g*, *l1*, *l2*]</code> tests whether the lines *l1* and *l2* of *g* are perpendicular at every vertex they share.

## Details & Options

With the default method, *l1* and *l2* are perpendicular at a common vertex when the feet of the perpendiculars from the vertices of each line onto the other lie in *l1 ∩ l2*. The foot of *x* on a line is the midpoint of two vertices of the line at equal distance from *x*.

Lines that do not meet are not perpendicular. Lines on a graph can meet in more than one vertex; the test must then hold at each.

There is no single right angle on a graph. The methods are not equivalent:

| Method | Perpendicular when |
|---|---|
| `"Projection"` (default) | the feet lie in the intersection |
| `"Coordinate"` | the feet are balanced about the meeting point, measured along each line |
| `"Arclength"` | the four angles at the meeting point are equal, each measured as a detour around a ball |
| `"Alexandrov"` | the four comparison angles at the meeting point are equal |

Sub-options go inside the method: `{"Projection", "Equality" -> e}` compares the feet with the intersection by [InfraEqualQ](), with `e` one of `"Subset"` (default), `"Set"`, `"Multiset"`, `"Diffuse"`, `"Overlap"`; `{"Coordinate", "ZeroTest" -> z}`; `{"Arclength", "Tolerance" -> t}` and `{"Alexandrov", "Tolerance" -> t, "Curvature" -> k}`, with *t* in radians.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Projection"` | a method or `{method, subopts}` |
| `"Radius"` | `All` | *r*: test only within distance *r* of the meeting point |

The default test is strict: a perpendicular built by [FindInfraPerpendicular]() as in Euclid I.12 generally fails it and passes with `"Equality" -> "Overlap"`.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Definition I.10 | A line standing on a line makes the adjacent angles equal; each is right. |
| Euclid | Postulate 4 | All right angles are equal. |

## Basic Examples

The row and the column through the centre of the square grid are perpendicular; the row and a staircase through the centre are not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {vertexAt = AssociationThread[Round @ GraphEmbedding[g], VertexList[g]]},
  {row = vertexAt /@ Table[{x, 5}, {x, 10}], column = vertexAt /@ Table[{5, y}, {y, 10}],
   stairs = vertexAt /@ Catenate @ Table[{{k, k + 1}, {k + 1, k + 1}}, {k, 8}]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraWalk[row], InfraWalk[l]}, PlotLabel -> InfraPerpendicularQ[g, row, l]],
    {l, {column, stairs}}]]
```

A perpendicular from a vertex to a line through the centre, constructed by [FindInfraPerpendicular](). The default test rejects it, the `"Overlap"` equality accepts it:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    {l1 = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
    {p = RandomInfraPoint[g, Complement[RandomInfraPoint[g, InfraShell[c, 2], All], l1], RandomSeeding -> 1]},
    {l2 = VertexList @ First @ FindInfraPerpendicular[g, l1, p, 1, "Radius" -> 3]},
    InfraSubstrateHighlight[g, {InfraWalk[l1], InfraWalk[l2], p},
      PlotLabel -> {InfraPerpendicularQ[g, l1, l2],
        InfraPerpendicularQ[g, l1, l2, Method -> {"Projection", "Equality" -> "Overlap"}]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Options

### Method

The four methods on the constructed perpendicular of the mesh. Only the `"Overlap"` equality accepts it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {l1 = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
  {p = RandomInfraPoint[g, Complement[RandomInfraPoint[g, InfraShell[c, 2], All], l1], RandomSeeding -> 1]},
  {l2 = VertexList @ First @ FindInfraPerpendicular[g, l1, p, 1, "Radius" -> 3]},
  AssociationMap[InfraPerpendicularQ[g, l1, l2, Method -> #] &,
    {"Projection", {"Projection", "Equality" -> "Overlap"}, "Coordinate", "Arclength", "Alexandrov"}]]
```

## Properties and Relations

Of all perpendiculars [FindInfraPerpendicular]() constructs within distance 3 of the vertex, the number constructed, the number the default test accepts and the number `"Overlap"` accepts:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {a = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
    {l1 = RandomInfraInfiniteLine[g, c, a, RandomSeeding -> 1]},
    {p = RandomInfraPoint[g, Complement[RandomInfraPoint[g, InfraShell[c, 2], All], l1], RandomSeeding -> 1]},
    {perps = VertexList /@ FindInfraPerpendicular[g, l1, p, All, "Radius" -> 3]},
    {Length[perps], Count[InfraPerpendicularQ[g, l1, #] & /@ perps, True],
     Count[InfraPerpendicularQ[g, l1, #, Method -> {"Projection", "Equality" -> "Overlap"}] & /@ perps, True]}],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Possible Issues

A line passes the default test with itself: it has no vertex outside the intersection, so there is no foot to check. Lines that do not meet are never perpendicular:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {vertexAt = AssociationThread[Round @ GraphEmbedding[g], VertexList[g]]},
  {row = vertexAt /@ Table[{x, 5}, {x, 10}], other = vertexAt /@ Table[{x, 7}, {x, 10}]},
  {InfraPerpendicularQ[g, row, row], InfraPerpendicularQ[g, row, other]}]
```
