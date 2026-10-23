---
Template: Symbol
Name: InfraFiberedGraphViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberedGraphViewer
Keywords: [fibered graph, viewer, hover, fiber, section, connection, lift]
SeeAlso: [InfraFiberedGraphHighlight, InfraFiberedGraph, InfraSection, InfraConnection, InfraFiber, InfraBaseSpace]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberedGraphViewer]()[*fib*]</code> shows the total graph of *fib* next to its base, and highlights the fiber over a vertex under the mouse.

<code>[InfraFiberedGraphViewer]()[*fib*, {*obj1*, *obj2*, …}]</code> shows the objects as [InfraFiberedGraphHighlight]() does and inspects them by hovering.

## Details & Options

The total graph is on the left, drawn by [InfraFiberedGraphHighlight](); the base is on the right, in the plane.

Hovering:

| Under the mouse | Highlighted |
|---|---|
| a total vertex or a base vertex | its fiber, and the values of the sections in it |
| a base edge | the section values and connection edges over it |

The viewer takes the objects, the styles and the options of [InfraFiberedGraphHighlight](), including [Method](), `"BaseGraphLayout"`, `"BaseVertexCoordinates"` and `"FiberRadius"`. The layout is fixed when the viewer is made; hovering changes only the highlights. Hovering needs the notebook front end.

## Basic Examples

The 3 × 3 grid covered three times, with its connection:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{3, 3}], "VerticalVertexCount" -> {3}, Properties -> {"Covering"},
    RandomSeeding -> 2]},
  InfraFiberedGraphViewer[fib, {RandomInfraConnection[fib, RandomSeeding -> 1]}]]
```

## Scope

A continuous section and a connection over the hexagon, with the fibers drawn upright:

```wl
With[{fib = RandomInfraFiberedGraph[CycleGraph[6], "VerticalVertexCount" -> {3}, Properties -> {"Fibration"},
    RandomSeeding -> 3]},
  {section = RandomInfraSection[fib, Properties -> {"Continuous"}, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphViewer[fib, {section, conn}, Method -> "3DFiber"]]
```
