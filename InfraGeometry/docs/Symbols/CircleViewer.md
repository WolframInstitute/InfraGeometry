---
Template: Symbol
Name: CircleViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CircleViewer
Keywords: [viewer, interactive, circle, separating cycle, Manipulate]
SeeAlso: [InfraCircle, RandomInfraCircle, InfraCircleQ, ShellViewer, PointViewer]
---

## Usage

<code>[CircleViewer]()[*g*]</code> is an interactive viewer of the circles of the graph *g*.

## Details & Options

The viewer draws <code>[InfraCircle]()[*p*, *r*]</code> on *g*. Clicking a vertex makes it the centre *p*; the first centre is a random vertex.

Controls:

| Control | Values |
|---|---|
| Radius | *r* from 1 to the diameter of *g* |
| Circles | the number of circles drawn, 1 to 12 |
| Select | `None` draws the circle object; `"Central"`, `"Peripheral"`, `"MinLength"`, `"MaxLength"` and `"EmbeddingClosest"` draw the cycles of [RandomInfraCircle]() chosen by that rule |
| Resample | a new random centre |

## Basic Examples

The viewer on the square mesh. The seed fixes the first centre, here the centre of the mesh, with the circle of radius 4 about it:

```wl
BlockRandom[CircleViewer[InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]], RandomSeeding -> 5]
```

## Possible Issues

About a vertex near the rim a circle of a large radius does not separate, and the viewer draws nothing.
