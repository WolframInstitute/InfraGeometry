---
Template: Symbol
Name: InfraSubstrateHighlight
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraSubstrateHighlight
Keywords: [visualization, diffuse rendering, density, highlight, palette]
SeeAlso: [InfraSceneViewer, InfraScene, InfraMeasurement, InfraDensity, InfraWalk]
RelatedGuides: [EuclideanInfrageometry]
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
- a region head — [InfraBall](), [InfraShell]() and the rest — or an [InfraIntersection](): its `"VertexDensity"`, no edges;
- a walk graph, a cycle graph or a DAG: its occupation;
- a leg chain: the walk through its legs, with its knots drawn on top;
- a vertex list that is an induced path or an induced cycle in its own order, as every geodesic is: the walk through it;
- any other vertex list: a set, `1` on its vertices, no edges;
- an [InfraUnion]() or any other list — of vertex lists, graphs, heads or walks, such as the members of a head or a bundle: the sum of its members, drawn in one color, with no edges when a member has none.

An object with edges is a line, drawn by its edge counts. Any other object is drawn as dots, sized by its masses, with the edges between its vertices in its color, at the bottom of `"OpacityRange"` and at the substrate's own thickness. Where a line uses such an edge, the line's stroke wins.

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
| `"Palette"` | a list of colors | `ColorData[112]` |

A scalar is the value at full strength. A pair is an envelope, interpolated by strength. An explicit `Opacity`, thickness or point size in an object's style turns that object's range off. `VertexSize` is in graph units.

## Basic Examples

Three heads, in palette order: a segment, a closed arc (the circles through a point) and an arc.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 5]])},
  {q = (SeedRandom[2]; FindInfraPoint[g, InfraShell[c, 5]])},
  InfraSubstrateHighlight[g,
    {InfraSegment[c, p], InfraArc[c, {p, p}, "RadiusDelta" -> 1], InfraArc[c, {p, q}, "RadiusDelta" -> 1]}]]
```

A `Directive` colors the objects after it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 5]])},
  InfraSubstrateHighlight[g,
    {FindInfraRepresentative[g, InfraBall[c, 3]], InfraArc[c, {p, p}, "RadiusDelta" -> 1]}]]
```

Overlaps add. The two segments share their start and blend there. The walk is one stroke.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 5]])},
  {q = (SeedRandom[2]; FindInfraPoint[g, InfraShell[c, 5]])},
  {walk = FindInfraRepresentative[g, InfraSegment[p, q]]},
  InfraSubstrateHighlight[g, {InfraSegment[c, p], InfraSegment[c, q], InfraWalk[walk]}, "Arrowheads" -> True]]
```

## Properties and Relations

The palette is Jeremy's strike-out sequence: three segments drawn in its first three colours.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {ends = (SeedRandom[1]; FindInfraPoint[g, InfraShell[c, 5], 3])},
  {InfraSubstrateHighlight[g, Table[InfraSegment[c, end], {end, ends}]], Take[ColorData[112, "ColorList"], 3]}]
```

A list of vertex lists is one object, the sum of its members: here the shortest paths of a segment, which draw as the head does.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; FindInfraPoint[g, InfraShell[a, 4]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {FindInfraRepresentative[g, InfraSegment[a, b], All]}],
    InfraSubstrateHighlight[g, {InfraSegment[a, b]}]}]]
```

A list of heads is one object too: two crossing segments in one color.

```wl
With[
  {g = GridGraph[{9, 9}]},
  InfraSubstrateHighlight[g, {{InfraSegment[37, 45], InfraSegment[5, 77]}}, ImageSize -> 250]]
```
