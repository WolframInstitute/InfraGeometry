---
Template: Symbol
Name: InfraEllipse
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraEllipse
Keywords: [ellipse, foci, distance sum, separating cycle, conic, symbolic object]
SeeAlso: [RandomInfraEllipse, InfraEllipseQ, InfraCircle, InfraQuadric, RandomInfraPoint]
---

## Usage

<code>[InfraEllipse]()[{*p*, *q*}, *s*]</code> is the ellipse with foci *p* and *q* and distance sum *s*: the shortest cycles on the level set *d(p, v) + d(q, v) = s* that separate its inside from its outside.

<code>[InfraEllipse]()[{*p*, *q*}, {*s1*, *s2*}]</code> is the ellipse on the band *s1 ≤ d(p, v) + d(q, v) ≤ s2*.

## Details & Options

The band is *E = {v : s₁ ≤ d(p, v) + d(q, v) ≤ s₂}*. A member of the ellipse is a cycle of the subgraph induced on *E*. By default it must separate a vertex with sum below *s₁* from a vertex with sum above *s₂*, and only the shortest such cycles count.

[InfraEllipse]() is a symbolic object: [RandomInfraEllipse]() draws its members as directed cycle graphs, and [RandomInfraPoint]() reads it as the region of their vertices.

In the plane every level is a closed curve. On a graph an exact level often carries no separating cycle, and a band of width 1 or 2 does.

With equal foci, <code>[InfraEllipse]()[{*c*, *c*}, 2*r*]</code> is the circle <code>[InfraCircle]()[*c*, *r*]</code>.

Options, given inside the head:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `{"Separating", "Shortest"}` | any subset; `{}` keeps every cycle of the band |

## Basic Examples

The ellipse on the band of sums 6 to 8, with the centre and a point at distance 2 as foci:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {RandomInfraEllipse[g, InfraEllipse[{c, q}, {6, 8}], RandomSeeding -> 1], c, q}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of members for the level 6 and the bands {6, 7} and {6, 8}. The exact level carries none:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small"]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    Table[Length @ RandomInfraEllipse[g, InfraEllipse[{c, q}, s], All], {s, {6, {6, 7}, {6, 8}}}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

With equal foci and sum *2r* the ellipse is the circle of radius *r*:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Sort[Sort @* VertexList /@ RandomInfraEllipse[g, InfraEllipse[{c, c}, 6], All]] ==
    Sort[Sort /@ RandomInfraCircle[g, InfraCircle[c, 3], All]]]
```

Without the separating condition the whole cycle graph is an ellipse for antipodal foci, every vertex having sum 3:

```wl
RandomInfraEllipse[CycleGraph[6], InfraEllipse[{1, 4}, 3, Properties -> {}], All]
```
