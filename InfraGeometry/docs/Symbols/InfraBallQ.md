---
Template: Symbol
Name: InfraBallQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBallQ
Keywords: [ball, disk, metric ball, test, predicate]
SeeAlso: [InfraBall, InfraShellQ, InfraCircleQ, InfraEllipseQ, InfraBallHull]
---

## Usage

<code>[InfraBallQ]()[*g*, *s*]</code> gives `True` if the vertex set *s* is a closed ball of *g*, and `False` otherwise.

## Details & Options

The set *s* is a ball when *s = Bᵣ(c) = {v : d(c, v) ≤ r}* for some vertex *c* and radius *r*. The centre lies in the ball, so only the vertices of *s* are tried, each with *r* = the largest distance from it to *s*.

The set can be a vertex list or a density. A list of sets gives `True` when every set is a ball.

The empty set is not a ball. A single vertex is the ball of radius 0, and the whole graph is a ball about any vertex.

On the square grid, away from the rim, a ball is a square standing on a corner, so neither a rectangle nor the neighbourhood of an edge is a ball.

In an [InfraScene](), <code>[InfraBallQ]()[*s*]</code> tests *s* on the scene's graph.

## Basic Examples

The ball of radius 3 about the centre is a ball:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]},
    InfraSubstrateHighlight[g, {ball, c}, PlotLabel -> InfraBallQ[g, ball]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The neighbourhood of radius 2 of an edge is not a ball:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {set = Keys @ InfraMeasurement[g, InfraBall[{c, First @ AdjacencyList[g, c]}, 2], "VertexDensity"]},
    InfraSubstrateHighlight[g, {set, c, First @ AdjacencyList[g, c]}, PlotLabel -> InfraBallQ[g, set]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Scope

A density is read as its support:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  InfraBallQ[g, InfraMeasurement[g, InfraBall[c, 2], "VertexDensity"]]]
```

## Properties and Relations

A single vertex and the whole graph are balls; a shell and the empty set are not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
  {InfraBallQ[g, {c}], InfraBallQ[g, VertexList[g]], InfraBallQ[g, shell], InfraBallQ[g, {}]}]
```

The interval of a segment, a rectangle on the grid, is not a ball:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {interval = Keys @ InfraMeasurement[g, InfraSegment[c, RandomInfraPoint[g, InfraShell[c, 4], RandomSeeding -> 1]], "VertexDensity"]},
  InfraSubstrateHighlight[g, {interval}, PlotLabel -> InfraBallQ[g, interval], ImageSize -> Medium]]
```
