---
Template: Symbol
Name: InfraFiberedGraphHighlight
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphHighlight
Keywords: [fibered graph, fibration, highlight, visualization, section, connection, lift]
SeeAlso: [InfraFiberedGraphViewer, InfraSubstrateHighlight, InfraFiberedGraph, InfraSection, InfraConnection, InfraHorizontalLift, InfraFiber]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphHighlight]()[*fib*]</code> draws the fibered graph *fib*.

<code>[InfraFiberedGraphHighlight]()[*fib*, {*object1*, *object2*, ...}]</code> highlights sections, connections, walks and ordinary total-graph objects on *fib*.

<code>[InfraFiberedGraphHighlight]()[*fib*, *object*]</code> highlights a single object.

## Details & Options

The result is a native [Graph]() or [Graph3D]() with the same vertices and edges as [InfraTotalSpace]()[*fib*].
Drawing coordinates belong to this result; the fibered graph itself remains unchanged.

- [InfraSection]() highlights its selected vertices and existing image edges.
- [InfraConnection]() highlights its chosen edges, without adding vertex mass.
  A later connection can restyle section image edges while leaving section vertex marks visible.
- [InfraWalk]() preserves the ordered lift, repeated visits and repeated traversals.
- A native fiber graph, such as [InfraFiber]()[*fib*, *p*], highlights its vertices and edges.
- A vertex density association uses the ordinary [InfraSubstrateHighlight]() semantics.
- A list of alternative sections or connections draws separate members, not one mathematical section or connection.
  Styles around such a family apply to each member.
  Literal list-valued vertices, walks, densities and native graph aggregates retain their ordinary meaning.

Styling uses the [InfraSubstrateHighlight]() grammar.
A [Directive]() entry styles subsequent objects.
`Style[object, style]` and `object -> style` style one object.
Put an object-style rule inside the item list; top-level rules are options.
The single-object form excludes lists and rules.
For a list of options, supply the item list explicitly, as in `InfraFiberedGraphHighlight[fib, {}, {Method -> "3DFiber"}]`.

| Option | Default | Meaning |
|---|---|---|
| [Method]() | `"CircularFiber"` | `"CircularFiber"`, `"3DFiber"` or `"HighlightFiber"` |
| `"BaseGraphLayout"` | [Automatic]() | A native graph layout for the reconstructed base |
| `"BaseVertexCoordinates"` | [Automatic]() | An association from literal base vertices to planar coordinates |
| `"FiberRadius"` | [Automatic]() | A positive drawing scale for the circular and three-dimensional views |

`"CircularFiber"` arranges each fiber on a small circle around its base vertex.
`"3DFiber"` places the fiber on an upright ellipse above that vertex.
`"HighlightFiber"` colors the fibers in the total graph's own layout.
All three views draw every supplied overlay.

Explicit base coordinates override the base layout.
The automatic fiber radius is one third of the shortest positive drawn base-edge length, capped at one third.
When the base has no positive drawn edge length, the radius is one third.
The total-layout view computes neither a base embedding nor a fiber radius.
Singleton fibers sit at the base point in the circular view, and above it in the three-dimensional view.
The base-coordinate options do not change the total-layout view.

Graph options and [InfraSubstrateHighlight]() options are forwarded with their ordinary meanings.
The first occurrence of a repeated option takes precedence.
Unsupported method names, malformed base-coordinate selectors and nonpositive fiber radii leave the call unevaluated.

The function performs no section or connection sampling.
Any stochastic layout is presentation work; use explicit coordinates for a fixed drawing.

## Basic Examples

A partial section, a continuous extension and a connection over the hexagon.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 0 },
    Properties -> { "IsomorphicFibers" }, "HorizontalEdgeCount" -> All]},
  {partial = RandomInfraSection[fib, {1, 3}]},
  {section = RandomInfraSection[fib, partial, Properties -> {"Continuous"}]},
  {connection = RandomInfraConnection[fib]},
  InfraFiberedGraphHighlight[fib, {partial, section, connection}]]
```

The same structure in three views.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> All]},
  {section = RandomInfraSection[fib, Properties -> {"Continuous"}]},
  {connection = RandomInfraConnection[fib]},
  GraphicsRow[InfraFiberedGraphHighlight[fib, {section, connection}, Method -> #] & /@
    {"CircularFiber", "3DFiber", "HighlightFiber"}]]
```

## Scope

Repeated traversals of a lifted walk retain their strength.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[4], "VerticalVertexCount" -> { 2 }, "HorizontalEdgeCount" -> All]},
  {connection = RandomInfraConnection[fib]},
  {start = First @ VertexList @ InfraFiber[fib, 1]},
  {lift = InfraHorizontalLift[fib, connection, start, {1, 2, 1, 2, 3}]},
  InfraFiberedGraphHighlight[fib, {connection -> StandardBlue, Style[InfraWalk[lift], StandardRed]},
    "Arrowheads" -> True]]
```

A fiber is an ordinary graph-shaped highlight.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[4], "VerticalVertexCount" -> { 3 }, "VerticalEdgeCount" -> { 2 }]},
  InfraFiberedGraphHighlight[fib, {Directive[StandardRed], InfraFiber[fib, 1]}, Method -> "HighlightFiber"]]
```

## Possible Issues

An unsupported view stays unevaluated.

```wl
InfraFiberedGraphHighlight[InfraFiberedGraph[CycleGraph[4], Identity], {}, Method -> "Unrecognized"]
```

The empty fibered graph still has a native graph drawing.

```wl
InfraFiberedGraphHighlight[InfraFiberedGraph[Graph[{}, {}], <||>]]
```
