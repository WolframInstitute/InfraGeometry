---
Template: Symbol
Name: ShellViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ShellViewer
Keywords: [viewer, interactive, shell, sphere, separating set, Manipulate]
SeeAlso: [InfraShell, InfraSphere, RandomInfraSphere, InfraShellQ, CircleViewer, SegmentViewer, PointViewer]
---

## Usage

<code>[ShellViewer]()[*g*]</code> is an interactive viewer of the shells and spheres of the graph *g*.

## Details & Options

The viewer draws the spheres of [RandomInfraSphere]() about a centre *p* at radius *r*. Clicking a vertex makes it the centre; the first centre is a random vertex.

Controls:

| Control | Values |
|---|---|
| Radius | *r* from 1 to the diameter of *g*; at first a third of it |
| Shells | the number of spheres drawn, 1 to 12 |
| Properties | `"Level set"`: the shell *{v : d(p, v) = r}*; `"Separating"`: its minimal separating subsets; `"Sep+Conn"`: its minimal connected separating subsets |
| Resample | a new random centre |

## Basic Examples

The viewer on the square grid. The seed fixes the first centre, here the centre of the grid, with the shell of radius 5 about it:

```wl
BlockRandom[ShellViewer[InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]],
  RandomSeeding -> 26]
```
