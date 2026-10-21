---
Template: Symbol
Name: InfraShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraShell
Keywords: [shell, sphere, level set, region, symbolic object, area, counting measure, Riemannian measure]
SeeAlso: [InfraBall, InfraSphere, InfraMeasurement, InfraInterior, InfraBoundary, InfraShellQ]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[InfraShell]()[*c*, *r*]</code> is the shell of radius *r* about the vertex *c*: the vertices at distance exactly *r* from *c*.

<code>[InfraShell]()[*c*, {*r*, *s*}]</code> is the band of the vertices at distance between *r* and *s* from *c*.

## Details & Options

The shell is *Sᵣ(c) = {v : d(c, v) = r}*, a level set of the distance from *c*. The band is *{v : r ≤ d(c, v) ≤ s}*.

The centre can be a vertex list *C*. Then *d(v, C) = min d(v, c)* over *c* in *C*.

[InfraShell]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph and [InfraSubstrateHighlight]() draws it.

A shell is not a curve. On the square grid no two of its vertices are adjacent. The connected subsets of a shell that separate the centre from the outside form [InfraSphere]().

A shell is all boundary, so its two measures part completely:

| Measure | Value |
|---|---|
| `"CountingMeasure"` | the number of vertices of the shell, the area *A(r)* |
| `"RiemannianMeasure"` | 0: every vertex of the shell has a neighbour outside it |

On the square grid, away from the rim, *A(r) = 4r* for *r ≥ 1*; on the cubic grid *A(r) = 4r² + 2*. In general *A(r)* is the difference of consecutive ball volumes. On a Riemannian manifold of dimension *n*, *A(r) = n ωₙ rⁿ⁻¹ (1 − R r² / (6n) + O(r⁴))*, with *R* the scalar curvature at *c*.

The Riemannian measure of a band drops its two rims. On the square grid, away from the rim, the band {*r*, *s*} with *r* ≥ 1 has the Riemannian measure of the counting measure of the band {*r* + 1, *s* − 1}.

A radius past the eccentricity of *c* gives the empty shell.

In an [InfraScene](), <code>[InfraShell]()[*p*, *r*]</code> is the shell about the point *p*.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 3 | To describe a circle with any centre and distance; the shell is its locus. |
| Tarski | Equidistance | The points at the same distance from a centre. |
| Hilbert | (defined) | Not primitive; defined through segment congruence. |

## Basic Examples

The shell of radius 3 about the centre, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraShell[c, 3], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The shell area against the radius. On the grid it is *4r* until the shell reaches the rim:

```wl
ListLinePlot[Table[
    With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
      Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 10}]],
    {name, {"SquareGridGraph", "SquareMeshGraph"}}],
  DataRange -> {1, 10}, PlotMarkers -> Automatic, PlotLegends -> {"SquareGridGraph", "SquareMeshGraph"}]
```

The band of radii 1 to 3, with its interior drawn over it. The Riemannian measure counts the interior; on the grid it is the middle shell:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {band = InfraShell[c, {1, 3}]},
    InfraSubstrateHighlight[g, {band, InfraInterior[g, Keys @ InfraMeasurement[g, band, "VertexDensity"]]},
      PlotLabel -> InfraMeasurement[g, band, {"CountingMeasure", "RiemannianMeasure"}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

The shells of radius 1 to 5 about the centre of the grid. Each has Riemannian measure 0:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {shells = Table[InfraShell[c, r], {r, 1, 5}]},
  InfraSubstrateHighlight[g, shells, PlotLabel -> InfraMeasurement[g, shells, "RiemannianMeasure"],
    ImageSize -> Medium]]
```

The shell of radius 2 about a shortest path, the vertices at distance 2 from it:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {path = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraShell[path, 2], InfraWalk[path]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Properties and Relations

The shell areas are the differences of the ball volumes:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 6}],
   Differences @ Table[InfraMeasurement[g, InfraBall[c, r], "CountingMeasure"], {r, 0, 6}]}]
```

On the grid no two vertices of a shell are adjacent; on the mesh the shells contain edges. The number of edges inside the shells of radius 1 to 5:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    Table[EdgeCount @ InfraMeasurement[g, InfraShell[c, r], "Subgraph"], {r, 1, 5}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the cubic grid the shell area is *4r² + 2* until the shell reaches the rim, here at radius 3:

```wl
With[{g = InfraSubstrate["CubicGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {Table[InfraMeasurement[g, InfraShell[c, r], "CountingMeasure"], {r, 1, 5}], Table[4 r^2 + 2, {r, 1, 5}]}]
```

## Possible Issues

Past the eccentricity the shell is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {VertexEccentricity[g, c], InfraMeasurement[g, InfraShell[c, 12], "CountingMeasure"]}]
```
