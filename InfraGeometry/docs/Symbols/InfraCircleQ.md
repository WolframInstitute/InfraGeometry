---
Template: Symbol
Name: InfraCircleQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCircleQ
Keywords: [circle, metric circle, shell, cycle, test, predicate, bipartite]
SeeAlso: [InfraCircle, RandomInfraCircle, InfraShell, InfraShellQ, InfraEllipseQ, InfraBallQ]
---

## Usage

<code>[InfraCircleQ]()[*g*, *cycle*]</code> gives `True` if the closed walk *cycle* is a circle of *g*, and `False` otherwise.

## Details & Options

A circle is a cycle whose vertex set is a shell *Sᵣ(c) = {v : d(c, v) = r}*: the vertices are distinct, each is adjacent to the next and the last to the first, and together they are all the vertices at distance *r* from some vertex *c*.

The cycle can be a vertex list, with or without the first vertex repeated at the end, or a cycle graph. A list of cycle graphs gives `True` when every one is a circle.

In the plane every sphere about a point is a circle. On a graph a shell need not be a cycle. On a bipartite graph such as the square grid, two vertices at the same distance from *c* are never adjacent, so no cycle is a circle.

In an [InfraScene](), <code>[InfraCircleQ]()[*cycle*]</code> tests *cycle* on the scene's graph.

## Basic Examples

On the mesh the shell of radius 3 is a cycle, and the cycle is a circle:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 3], All]},
  InfraSubstrateHighlight[g, {InfraWalk[Append[cycle, First @ cycle]], c}, PlotLabel -> InfraCircleQ[g, cycle], ImageSize -> Medium]]
```

On the grid the shell has no edges, so it carries no cycle:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[c, 3], "VertexDensity"]},
  {EdgeCount @ Subgraph[g, shell], InfraCircleQ[g, shell]}]
```

## Scope

The cycle may be closed, with its first vertex repeated at the end:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {cycle = First @ RandomInfraCircle[g, InfraCircle[c, 2], All]},
  {InfraCircleQ[g, cycle], InfraCircleQ[g, Append[cycle, First @ cycle]]}]
```

## Properties and Relations

A cycle on part of a shell is not a circle. The boundary of a square face of the grid is a cycle, but not a shell:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {square = First /@ First @ FindCycle[NeighborhoodGraph[g, c, 2], {4}]},
  {square, InfraCircleQ[g, square]}]
```
