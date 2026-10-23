---
Template: Symbol
Name: DisplacementPlot
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/DisplacementPlot
Keywords: [displacement, plot, arrows, vector field, flow]
SeeAlso: [TranslationDisplacement, PolarDisplacements, RandomDisplacement, GradientDisplacement, DisplacementScale]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[DisplacementPlot]()[*g*, *d*]</code> draws the displacement *d* as arrows over the embedding of *g*.

<code>[DisplacementPlot]()[*g*, {*d1*, *d2*, …}]</code> draws several displacements, each in its own colour.

## Details & Options

Each step from *v* to a vertex *w ≠ v* of *d*(*v*) is an arrow from *v* to *w*, bent to its right, so that the two arrows of an exchanged pair do not overlap. A vertex whose value is {*v*} draws nothing; the identity draws the bare graph.

The graph is drawn in light gray at the coordinates [GraphEmbedding]() gives. The colours are, in turn, [StandardBlue](), [StandardRed](), [StandardGreen](), [StandardOrange](), [StandardPurple](), [StandardCyan](), [StandardBrown]() and [StandardPink]().

The embedding must be planar. With three-dimensional coordinates the call stays unevaluated.

[DisplacementPlot]() takes the options of [Graphics]().

## Basic Examples

A random displacement of magnitude 1 on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, RandomDisplacement[g, 1, RandomSeeding -> 1]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Two displacements in two colours: the radial displacement about the centre of the mesh in blue, the angular one in red:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, PolarDisplacements[g, First @ GraphCenter[g]]]]
```

## Scope

A displacement given at a few vertices draws only there. The four steps from the centre of the grid, scaled by 1, 2 and 3:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  DisplacementPlot[g, Table[DisplacementScale[g, <|c -> AdjacencyList[g, c]|>, t], {t, 3}]]]
```

## Options

### PlotLabel

A label carries a number with the picture, here the magnitude:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {d = RandomDisplacement[g, 2, RandomSeeding -> 1]},
  DisplacementPlot[g, d, PlotLabel -> DisplacementMagnitude[g, d]]]
```

## Possible Issues

A vertex that stays is not drawn. The grid is bipartite, so the angular displacement fixes every vertex, and only the radial one shows:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  DisplacementPlot[g, PolarDisplacements[g, First @ GraphCenter[g]]]]
```

With three-dimensional coordinates the call stays unevaluated:

```wl
With[{g = InfraSubstrate["CubicGridGraph", "Small", "KeepCoordinates" -> True]},
  Head @ DisplacementPlot[g, RandomDisplacement[g, 1, RandomSeeding -> 1]]]
```
