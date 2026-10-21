---
Template: Symbol
Name: InfraSubstrateHighlight
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight
Keywords: [visualization, highlight, density, palette, figure]
SeeAlso: [InfraMeasurement, InfraWalk, InfraScenePlot, InfraSceneViewer, InfraSubstrate, HighlightGraph]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraSubstrateHighlight]()[*g*, {*obj1*, *obj2*, …}]</code> draws the objects on the graph *g*, the *i*-th in the *i*-th palette colour, a later one over an earlier.

<code>[InfraSubstrateHighlight]()[*g*, *obj*]</code> draws one object.

## Details & Options

[InfraSubstrateHighlight]() is the graph analogue of [HighlightGraph]() for densities. Every object becomes a vertex density and an edge density:

| Object | Vertex density | Edge density |
|---|---|---|
| a vertex *v* | 1 at *v* | none |
| a density `<\|v -> m, …\|>` | the masses *m* | none |
| a vertex list | 1 on each vertex; a list that is a path in its own order is drawn as the walk | none, or the walk |
| <code>[InfraWalk]()[{*v1*, …, *vk*}]</code> | the visits | the traversals of its steps |
| a family: [InfraSegment](), [InfraHalfLine](), [InfraCircle](), … | `"VertexDensity"` of [InfraMeasurement]() | `"EdgeDensity"` |
| a region: [InfraBall](), [InfraShell](), [InfraTube](), [InfraIntersection](), … | `"VertexDensity"` | none |
| a subgraph of *g*, a walk graph, a directed acyclic graph | its occupation | its occupation |
| a list of such objects | the sum, in one colour | the sum |

An object with edges is drawn as a line, the stroke along each edge growing with its count; any other object as dots on its vertices, sized by mass. A mass of 1 draws at the substrate's own vertex size and edge thickness, in the object's colour; the heaviest mass of an object draws at the top of the range, by default 3 times the base size for a dot and 4 times for a stroke. The opacity follows mass over the heaviest mass, along `"OpacityRange"`.

A negative mass is drawn as an empty ring, a positive one as a filled dot; a zero mass is not drawn.

Where objects overlap, their strengths add and their colours blend.

In the list, a [Directive]() styles every object after it, and `obj -> style` one object. A colour there replaces the palette colour.

| Option | Default | Values |
|---|---|---|
| `"OpacityRange"` | `{0.4, 1.}` | `None`, a value, or {*min*, *max*} |
| `"ThicknessRange"` | `Automatic` | `None`, a base, or {*base*, *top*}, in printer points |
| `"PointSizeRange"` | `Automatic` | `None`, a base, or {*base*, *top*}, in printer points |
| `"Arrowheads"` | `Automatic` | `True` puts a head at the end of each walk, or an [Arrowheads]() spec |
| `"Palette"` | `Automatic` | a list of colours; `Automatic` is [ColorData]()[112] |

Options of [Graph]() are passed on.

## Basic Examples

A ball, a segment and a vertex on the square grid and the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {b = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraBall[c, 2], InfraSegment[c, b], b}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A density is drawn by its masses. The number of shortest paths from the centre through each vertex of the ball of radius 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 4], "VertexDensity"]},
  InfraSubstrateHighlight[g, AssociationMap[InfraMeasurement[g, InfraSegment[c, #], "Cardinality"] &, ball], ImageSize -> Medium]]
```

Two segments from the centre and a walk between their ends, with an arrowhead at its end. Where objects meet, their colours blend:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1]}, {q = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 5]},
  InfraSubstrateHighlight[g, {InfraSegment[c, p], InfraSegment[c, q], InfraWalk[RandomInfraSegment[g, p, q, RandomSeeding -> 1]]},
    "Arrowheads" -> True, ImageSize -> Medium]]
```

## Scope

A negative mass is an empty ring. The boundary of a walk from *p* to *q* is *q* minus *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]}, {q = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 2]},
  InfraSubstrateHighlight[g, {InfraWalk[RandomInfraSegment[g, p, q, RandomSeeding -> 1]], <|q -> 1, p -> -1|>}, ImageSize -> Medium]]
```

The difference of two balls: dots on the first, rings on the second, nothing where they cancel:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 3], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {InfraUnion[InfraBall[a, 3], -InfraMeasurement[g, InfraBall[b, 3], "VertexDensity"]]}, ImageSize -> Medium]]
```

A [Directive]() colours the objects after it; a rule colours one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, {Directive[StandardBlue], InfraShell[c, 2], InfraShell[c, 4], c -> StandardRed}, ImageSize -> Medium]]
```

## Options

### ThicknessRange

A wider range makes the busy edges of a segment stand out:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {seg = InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 6], RandomSeeding -> 1]]},
  GraphicsRow[{InfraSubstrateHighlight[g, {seg}], InfraSubstrateHighlight[g, {seg}, "ThicknessRange" -> {1, 8}]}]]
```

### Palette

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, Table[InfraShell[c, r], {r, 1, 4}], "Palette" -> {StandardRed, StandardOrange, StandardGreen, StandardBlue},
    ImageSize -> Medium]]
```

## Properties and Relations

The list of all members of a segment draws as the segment:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {a = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[a, 4], RandomSeeding -> 1]},
  InfraSubstrateHighlight[g, {RandomInfraSegment[g, a, b, All]}] === InfraSubstrateHighlight[g, {InfraSegment[a, b]}]]
```
