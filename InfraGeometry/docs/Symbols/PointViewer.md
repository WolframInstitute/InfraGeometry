---
Template: Symbol
Name: PointViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PointViewer
Keywords: [viewer, interactive, random point, pairwise distance, Manipulate]
SeeAlso: [RandomInfraPoint, InfraPoint, SegmentViewer, ShellViewer, CircleViewer]
---

## Usage

<code>[PointViewer]()[*g*]</code> is an interactive viewer of random points of the graph *g*.

<code>[PointViewer]()[*g*, *sym*]</code> also assigns the points drawn to the symbol *sym*.

## Details & Options

The viewer draws points of [RandomInfraPoint]() and redraws them on each change.

Controls:

| Control | Values |
|---|---|
| Points | the number of points |
| Region | `"Random"`: any vertex; `"Center"`: the vertices of [GraphCenter](); `"Periphery"`: those of [GraphPeriphery]() |
| Separation | `"None"`; `"Max"`: pairwise as far apart as possible; `"Range"`: pairwise at distances in the Distance range |
| Distance | the range of pairwise distances under `"Range"` |
| Resample | a new draw |

## Basic Examples

The viewer on the square mesh:

```wl
PointViewer[InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]]
```
