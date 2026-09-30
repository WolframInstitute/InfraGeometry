---
Template: Symbol
Name: InfraSubstrateHighlight
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight
Keywords: [visualization, diffuse rendering, density, highlight, palette]
SeeAlso: [InfraSceneViewer, InfraScene, InfraMeasurement, $InfraPalette, InfraDensity, InfraWalk]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[InfraSubstrateHighlight]()[*g*, {*obj1*, *obj2*, ...}]</code> draws the sum of the objects' densities on *g*, the *i*-th object in the *i*-th palette color.

<code>[InfraSubstrateHighlight]()[*g*, *obj*]</code> draws a single object.

## Details & Options

This is the only rendering primitive in the paclet. Every viewer and every figure calls it. The name follows `HighlightGraph`.

Every object becomes a vertex density and an edge density:

- a vertex, or a density `<|v -> m|>`: its own mass, no edges;
- `InfraWalk[{p1, ..., pk}]`: visit counts and the traversal counts of its steps;
- a Euclidean head — [InfraSegment](), [InfraCircle]() and the rest: its `"VertexDensity"` and `"EdgeDensity"` from [InfraMeasurement]();
- a walk graph, a cycle graph or a DAG: its occupation;
- a leg chain: the walk through its legs, with its knots drawn on top;
- a vertex list: a region, `1` on its vertices and on the edges of its induced subgraph;
- a list of vertex lists or of graphs, such as the members of a head or a bundle: the sum of its members.

A list of heads or of walks is not one object; give them as separate entries, styled alike with a `Directive`.

Each object is divided by its own heaviest mass, so every object reaches full strength somewhere. The objects are then summed. At each vertex and edge the strength is the sum, capped at `1`, and the color is the blend of the objects' colors weighted by their masses. Where objects overlap, the figure shows both.

A head draws the edges its members use, never the chords of its support. An object with one member is drawn as one joined stroke; a family is drawn edge by edge.

The list is read like a `Graphics` list. A `Directive` styles every object after it, until the next `Directive`. An entry `obj -> style` styles one object. A color in either replaces the palette color.

Options:

| Option | Values | Default |
|---|---|---|
| `"OpacityRange"` | `None`, a scalar, or `{min, max}` | `{0.4, 1.}` |
| `"ThicknessRange"` | `None`, a scalar, or `{min, max}` | base `9.` |
| `"PointSizeRange"` | `None`, a scalar, or `{min, max}` | base `6` for an object with no edges |
| `"Arrowheads"` | `Automatic`, `True`, or an `Arrowheads` spec | off |
| `"Palette"` | a list of colors | [$InfraStrikeOutPalette]() |

A scalar is the value at full strength. A pair is an envelope, interpolated by strength. An explicit `Opacity`, thickness or point size in an object's style turns that object's range off. `VertexSize` is in graph units.

## Basic Examples

Three heads, in palette order.

```wl
With[{g = GridGraph[{21, 21}]},
  InfraSubstrateHighlight[g,
    {InfraSegment[221, 226], InfraCircle[221, 226, "RadiusDelta" -> 1],
     InfraArc[221, {226, 116}, "RadiusDelta" -> 1]}]]
```

A `Directive` colors the objects after it.

```wl
With[{g = GridGraph[{21, 21}]},
  InfraSubstrateHighlight[g,
    {FindInfraBall[g, 221, 3], Directive[$InfraCircleColor],
     InfraCircle[221, 226, "RadiusDelta" -> 1]}]]
```

Overlaps add. The two segments share the edge at their start and blend there. The walk is one stroke.

```wl
With[{g = GridGraph[{21, 21}]},
  InfraSubstrateHighlight[g,
    {InfraSegment[221, 266], InfraSegment[221, 180],
     InfraWalk[{215, 216, 217, 238, 259, 260, 261}]},
    "Arrowheads" -> True]]
```

## Properties and Relations

The palette is Jeremy's strike-out sequence.

```wl
Take[$InfraStrikeOutPalette, 3]
```

A list of vertex lists is one object, the sum of its members: here the six geodesics of a segment, which draw as the head does.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {InfraSubstrateHighlight[g, {InfraVertexList[g, InfraSegment[41, 61], All]}, ImageSize -> 250],
   InfraSubstrateHighlight[g, {InfraSegment[41, 61]}, ImageSize -> 250]}]
```
