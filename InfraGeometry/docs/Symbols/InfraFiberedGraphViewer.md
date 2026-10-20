---
Template: Symbol
Name: InfraFiberedGraphViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphViewer
Keywords: [fibered graph, fibration, viewer, hover, section, connection, lift]
SeeAlso: [InfraFiberedGraphHighlight, InfraFiberedGraph, InfraSection, InfraConnection, InfraFiber, InfraBaseSpace]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphViewer]()[*fib*]</code> interactively displays the total graph and the reconstructed base of *fib*.

<code>[InfraFiberedGraphViewer]()[*fib*, {*object1*, *object2*, ...}]</code> displays the supplied sections, connections and other highlights while inspecting fibers and lifts.

<code>[InfraFiberedGraphViewer]()[*fib*, *object*]</code> displays one highlighted object.

## Details & Options

The viewer uses [InfraFiberedGraphHighlight]() and accepts the same object list, style grammar and options.
Graph structure and styling options apply to the total view.
Image size, background, labels and text styling also apply to the base view; its coordinates and layout use the base-specific options.
The total graph appears on the left and the reconstructed base on the right.
The result is a [DynamicModule]().
For a list of options, supply the item list explicitly, as in `InfraFiberedGraphViewer[fib, {}, {Method -> "3DFiber"}]`.

- Hover a total vertex or a base vertex to highlight its fiber and the supplied section values in that fiber.
- Hover a base edge to highlight the supplied sections and connection edges above that edge.
- Supplied sections and connections retain their individual identity; several objects are not combined into one mathematical section or connection.
- A walk retains its repeated visits and traversals through the shared highlighting operation.

The viewer materializes the supplied structure and its layout when created.
Hovering changes highlights only.
It never calls a random section, connection or fibration sampler.

[Method]() accepts `"CircularFiber"`, `"3DFiber"` and `"HighlightFiber"`.
The base is drawn in the plane in every view.
`"BaseGraphLayout"`, `"BaseVertexCoordinates"` and `"FiberRadius"` have the same meanings as in [InfraFiberedGraphHighlight]().
Unsupported view names remain unevaluated.
Live hovering requires the Wolfram notebook front end.

## Basic Examples

Inspect a continuous section and a connection over the hexagon.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> { 3 },
    Properties -> { "IsomorphicFibers" }, "HorizontalEdgeCount" -> All, RandomSeeding -> 7]},
  {partial = RandomInfraSection[fib, {1, 3}, RandomSeeding -> 7]},
  {section = RandomInfraSection[fib, partial, Properties -> {"Continuous"}, RandomSeeding -> 7]},
  {connection = RandomInfraConnection[fib, RandomSeeding -> 7]},
  InfraFiberedGraphViewer[fib, {partial, section, connection}]]
```

## Scope

Inspect the same kind of object with upright three-dimensional fibers.

```wl
SeedRandom[7];
With[
  {fib = RandomInfraFiberedGraph[CycleGraph[4], "VerticalVertexCount" -> { 3 }, "HorizontalEdgeCount" -> All, RandomSeeding -> 7]},
  {connection = RandomInfraConnection[fib, RandomSeeding -> 7]},
  InfraFiberedGraphViewer[fib, {connection -> StandardBlue}, Method -> "3DFiber"]]
```

## Possible Issues

The viewer leaves an unsupported view unevaluated.

```wl
InfraFiberedGraphViewer[InfraFiberedGraph[CycleGraph[4], Identity], {}, Method -> "Unrecognized"]
```
