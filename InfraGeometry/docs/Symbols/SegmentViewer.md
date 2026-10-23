---
Template: Symbol
Name: SegmentViewer
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SegmentViewer
Keywords: [viewer, interactive, segment, shortest path, Manipulate]
SeeAlso: [InfraSegment, RandomInfraSegment, SelectInfraWalk, CircleViewer, ShellViewer, PointViewer]
---

## Usage

<code>[SegmentViewer]()[*g*]</code> is an interactive viewer of the segments of the graph *g*.

## Details & Options

The viewer draws <code>[InfraSegment]()[*p*, *q*]</code> on *g*, all its shortest paths at once. Clicking a vertex makes the second endpoint the first and the clicked vertex the second. The first endpoints are two random vertices.

Controls:

| Control | Values |
|---|---|
| Segments | the number of members drawn, 1 to 12 |
| Select | `None` draws the segment object; `"Central"`, `"Peripheral"` and `"EmbeddingClosest"` draw the members chosen by that rule |
| Resample | two new random endpoints |

## Basic Examples

The viewer on the square grid. The seed fixes the first endpoints, here 54 and 27, 20 shortest paths apart:

```wl
BlockRandom[SegmentViewer[InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]],
  RandomSeeding -> 14]
```
