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
- a vertex list that is an induced path or an induced cycle in its own order, as every shortest path is: the walk through it;
- any other vertex list: a set, `1` on its vertices, no edges;
- an [InfraUnion]() or any other list — of vertex lists, graphs, heads or walks, such as the members of a head or a bundle: the sum of its members, drawn in one color, with no edges when a member has none.

An object with edges is a line, drawn by its edge counts. Any other object is drawn as dots, sized by its masses, with the edges between its vertices in its color, at the bottom of `"OpacityRange"` and at the base thickness. Where a line uses such an edge, the line's stroke wins.

Density `1` draws at the base: the substrate's own vertex size and edge thickness, in the object's color. Within one object the lightest mass draws at the base and the heaviest at the top, by default four times the base for a stroke and three times for a dot. An object whose masses are all equal, such as a set, a region or a walk that never repeats an edge, looks like the substrate itself, colored.

The opacity follows each mass divided by the object's heaviest, along `"OpacityRange"`. A single walk is opaque, so a walk that reuses edges stays one path, its repeated edges thicker.

A density may carry negative masses. A positive mass is a filled dot and a negative mass an empty ring of the same size, both in the object's color; size and opacity follow the absolute mass, as above. A zero mass is not drawn: the vertex keeps the substrate's own style. Edges are not signed.

The objects are then summed. At each vertex and edge the strength is the sum, capped at `1`, and the color is the blend of the objects' colors weighted by their masses. Where objects overlap, the figure shows both.

A head draws the edges its members use, never the chords of its support. An object with one member is drawn as one joined stroke; a family is drawn edge by edge.

`"Arrowheads" -> True` puts a head on the last vertex of each walk, broader than long, its length growing with the stroke under it, black on a light stroke and gold on a dark one. An `Arrowheads` spec draws that spec instead.

The list is read like a `Graphics` list. A `Directive` styles every object after it, until the next `Directive`. An entry `obj -> style` styles one object. A color in either replaces the palette color.

Options:

| Option | Values | Default |
|---|---|---|
| `"OpacityRange"` | `None`, a scalar, or `{min, max}` | `{0.4, 1.}` |
| `"ThicknessRange"` | `Automatic`, `None`, a base, or `{base, top}` | the substrate's own thickness, top four times it |
| `"PointSizeRange"` | `Automatic`, `None`, a base, or `{base, top}` | the substrate's own vertex size, top three times it |
| `"Arrowheads"` | `Automatic`, `True`, or an `Arrowheads` spec | off |
| `"Palette"` | a list of colors | `ColorData[112]` |

A size is in printer points, and `Automatic` is the substrate's own. For `"OpacityRange"` a scalar is the value at full strength and a pair is an envelope, interpolated by strength.

An object's own style beats the option, given in the call or by `SetOptions`, which beats the default. `AbsoluteThickness[t]` or `AbsolutePointSize[s]` in an object's style fixes that object's base. The option sizes the dots of the objects without edges; a line gets dots only from its own style. An explicit `Opacity`, any other thickness or a `PointSize` turns that object's range off. `VertexSize` is in graph units.

## Basic Examples

Three heads, in palette order: a segment, a closed arc (the circles through a point) and an arc.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 5]])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, InfraShell[c, 5]])},
  InfraSubstrateHighlight[g,
    {InfraSegment[c, p], InfraArc[c, {p, p}, "RadiusDelta" -> 1], InfraArc[c, {p, q}, "RadiusDelta" -> 1]}]]
```

A `Directive` colors the objects after it.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 5]])},
  InfraSubstrateHighlight[g,
    {RandomInfraRepresentative[g, InfraBall[c, 3]], InfraArc[c, {p, p}, "RadiusDelta" -> 1]}]]
```

Overlaps add. The two segments share their start and blend there. The walk is one stroke.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 5]])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, InfraShell[c, 5]])},
  {walk = RandomInfraRepresentative[g, InfraSegment[p, q]]},
  InfraSubstrateHighlight[g, {InfraSegment[c, p], InfraSegment[c, q], InfraWalk[walk]}, "Arrowheads" -> True]]
```

A negative mass is an empty ring. The boundary of a walk from *p* to *q* is *q* minus *p*: a dot at the end, a ring at the start, drawn with the walk.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {p = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {q = (SeedRandom[2]; RandomInfraPoint[g, InfraShell[c, 4]])},
  {walk = RandomInfraRepresentative[g, InfraSegment[p, q]]},
  InfraSubstrateHighlight[g, {InfraWalk[walk], <|q -> 1, p -> -1|>}]]
```

The difference of two balls is a density too: dots on the first ball, rings on the second. Where they overlap the masses cancel to `0`, and a zero mass is not drawn.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 3]])},
  InfraSubstrateHighlight[g, {InfraUnion[InfraBall[a, 3], -InfraMeasurement[g, InfraBall[b, 3], "VertexDensity"]]}]]
```

## Properties and Relations

The palette is Jeremy's strike-out sequence: three segments drawn in its first three colours.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {ends = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[c, 5], 3])},
  {InfraSubstrateHighlight[g, Table[InfraSegment[c, end], {end, ends}]], Take[ColorData[112, "ColorList"], 3]}]
```

A list of vertex lists is one object, the sum of its members: here the shortest paths of a segment, which draw as the head does.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = (SeedRandom[1]; RandomInfraPoint[g, InfraShell[a, 4]])},
  GraphicsRow[{
    InfraSubstrateHighlight[g, {RandomInfraRepresentative[g, InfraSegment[a, b], All]}],
    InfraSubstrateHighlight[g, {InfraSegment[a, b]}]}]]
```

A list of heads is one object too: two crossing segments in one color.

```wl
With[
  {g = GridGraph[{9, 9}]},
  InfraSubstrateHighlight[g, {{InfraSegment[37, 45], InfraSegment[5, 77]}}, ImageSize -> 250]]
```
