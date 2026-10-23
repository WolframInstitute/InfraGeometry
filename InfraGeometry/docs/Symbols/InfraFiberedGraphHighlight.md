---
Template: Symbol
Name: InfraFiberedGraphHighlight
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphHighlight
Keywords: [fibered graph, highlight, drawing, fiber, section, connection, lift]
SeeAlso: [InfraFiberedGraphViewer, InfraSubstrateHighlight, InfraFiberedGraph, InfraSection, InfraConnection, InfraHorizontalLift, InfraFiber]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphHighlight]()[*fib*]</code> draws the fibered graph *fib*, each fiber placed at its base vertex.

<code>[InfraFiberedGraphHighlight]()[*fib*, {*obj1*, *obj2*, …}]</code> draws *fib* with fibers, sections, connections, walks and other objects highlighted.

## Details & Options

The result is a [Graph]() or [Graph3D]() with the vertices and edges of the total graph. Only the drawing has coordinates; *fib* is unchanged.

The three views:

| [Method]() | Drawing |
|---|---|
| `"CircularFiber"` | each fiber on a small circle around its base vertex |
| `"3DFiber"` | each fiber on an upright ellipse above its base vertex |
| `"HighlightFiber"` | the total graph in its own layout, the fibers told apart by colour |

The objects:

| Object | Highlights |
|---|---|
| a vertex, a list of vertices, <code>[InfraFiber]()[*fib*, *p*]</code> | vertices and the edges between them |
| <code>[InfraSection]()[*s*]</code> | the chosen vertices and the edges joining them |
| <code>[InfraConnection]()[*edges*]</code> | the chosen edges |
| <code>[InfraWalk]()[*w*]</code> | a walk in the total graph, such as a lift from [InfraHorizontalLift]() |
| `<\|v -> m, …\|>` | a density on the total vertices |

A list of sections or connections draws each member separately.

Styling follows [InfraSubstrateHighlight](): a [Directive]() styles the objects after it, and `Style[obj, style]` or `obj -> style` inside the list styles one object.

Options:

| Option | Default | Values |
|---|---|---|
| [Method]() | `"CircularFiber"` | `"CircularFiber"`, `"3DFiber"`, `"HighlightFiber"` |
| `"BaseGraphLayout"` | [Automatic]() | a [GraphLayout]() value for the base |
| `"BaseVertexCoordinates"` | [Automatic]() | planar coordinates of the base vertices, as a list or an association |
| `"FiberRadius"` | [Automatic]() | the radius of the fiber circles; by default a third of the shortest base edge, at most 1/3 |

Options of [Graph]() and [InfraSubstrateHighlight]() are passed on.

## Basic Examples

The fiber over 6 in the product of the 4 × 4 grid with a triangle, and in the displacement bundle of the grid:

```wl
GraphicsRow @ Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]}, InfraFiberedGraphHighlight[fib, {InfraFiber[fib, 6]}]],
  {name, {"GridProductBundle", "GridDisplacementBundle"}}]
```

A covering of the 3 × 3 grid with three sheets, and the lift of the face 1, 2, 5, 4 from the vertex {1, 1}. It ends on another sheet:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, Properties -> {"Covering"},
    RandomSeeding -> 2]},
  {lift = InfraHorizontalLift[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {1, 1}, {1, 2, 5, 4, 1}]},
  InfraFiberedGraphHighlight[fib, {InfraWalk[lift]}, PlotLabel -> Last[lift], ImageSize -> Medium]]
```

## Scope

A fibration over the hexagon with fibers of three points. A continuous section, and a connection:

```wl
With[{fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> {3}, Properties -> {"Fibration"},
    RandomSeeding -> 3]},
  {section = RandomInfraSection[fib, Properties -> {"Continuous"}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  GraphicsRow[{InfraFiberedGraphHighlight[fib, {section}], InfraFiberedGraphHighlight[fib, {conn}]}]]
```

A partial section over the vertices 1 and 3, and a style for one object:

```wl
With[{fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> {3}, Properties -> {"Fibration"},
    RandomSeeding -> 3]},
  {partial = RandomInfraSection[fib, {1, 3}, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {partial, InfraFiber[fib, 5] -> StandardBlue}, ImageSize -> Medium]]
```

## Options

### Method

The lifted face of the grid covering in the three views:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, Properties -> {"Covering"},
    RandomSeeding -> 2]},
  {lift = InfraHorizontalLift[fib, RandomInfraConnection[fib, RandomSeeding -> 1], {1, 1}, {1, 2, 5, 4, 1}]},
  GraphicsRow @ Table[InfraFiberedGraphHighlight[fib, {InfraWalk[lift]}, Method -> m],
    {m, {"CircularFiber", "3DFiber", "HighlightFiber"}}]]
```

### BaseVertexCoordinates

A random double covering of the square grid, drawn over the grid's own coordinates. Where two edges cross, the sheets are exchanged:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, Properties -> {"Covering"},
    RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, "BaseVertexCoordinates" -> GraphEmbedding[g], ImageSize -> Medium]]
```

## Possible Issues

An unknown view leaves the call unevaluated:

```wl
Head @ InfraFiberedGraphHighlight[InfraFiberedSubstrate["CycleDoubleCover", "Small"], {}, Method -> "Unknown"]
```
