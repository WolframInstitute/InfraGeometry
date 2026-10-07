---
Template: Symbol
Name: DisplacementPlot
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementPlot
Keywords: [displacement, plot, arrows, vector field, flow, visualization]
SeeAlso: [RandomDisplacement, PolarDisplacements, TranslationDisplacement, DisplacementCompose, InfraSubstrateHighlight]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementPlot]()[*g*, *d*]</code> draws the displacement *d* as bent arrows over the embedding of *g*.

<code>[DisplacementPlot]()[*g*, {*d1*, *d2*, ...}]</code> draws several displacements, the *k*-th in the *k*-th colour of the default plot palette.

## Details & Options

Each step from *v* to a vertex *w ≠ v* of *d*(*v*) is an arrow from the coordinates of *v* to those of *w*, bent to its right, so that the two arrows of an exchanged pair do not overlap. A vertex whose value is {*v*} draws nothing, and the identity draws the bare graph.

The graph is drawn in light gray at the coordinates [GraphEmbedding]() gives: its own [VertexCoordinates]() when it has them, a computed layout otherwise. The colours are those of <code>[ColorData]()[97]</code>.

[DisplacementPlot]() takes the options of [Graphics]().

## Basic Examples

Random displacements of magnitude at most 2 on the discretized plane, the square tiling and the hexagonal tiling.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, (SeedRandom[1]; RandomDisplacement[g, 2])]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

Two displacements in two colours: the radial and the angular displacement about the centre of the triangular tiling.

```wl
With[
  {g = InfraSubstrate["TriangularTilingGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, PolarDisplacements[g, First @ GraphCenter[g]]]]
```

## Scope

A displacement given at a few vertices draws only there. Each step from the centre of the hexagonal tiling, with twice and three times it.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {steps = <|First @ GraphCenter[g] -> AdjacencyList[g, First @ GraphCenter[g]]|>},
  DisplacementPlot[g, Table[DisplacementScale[g, steps, t], {t, 3}]]]
```

## Options

[PlotRange]() shows a part of the graph: the centre of the square tiling under a random displacement.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, (SeedRandom[1]; RandomDisplacement[g, 2]), PlotRange -> {{-3, 5}, {-4, 4}}]]
```

## Possible Issues

A vertex that stays is not drawn. The angular displacement of the square tiling fixes every vertex, and only the radial one shows.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {polar = PolarDisplacements[g, First @ GraphCenter[g]]},
  {DisplacementPlot[g, polar], AllTrue[Keys[Last[polar]], Last[polar][#] === {#} &]}]
```

The arrows are planar. A substrate with three-dimensional coordinates, such as the tori and the sphere mesh with `"KeepCoordinates"` -> `True`, cannot be drawn; without the option it is drawn at a planar layout. The translation of the square torus by one step:

```wl
With[
  {g = InfraSubstrate["SquareTorusGraph", "Small"]},
  DisplacementPlot[g, FindKillingDisplacement[g]]]
```
