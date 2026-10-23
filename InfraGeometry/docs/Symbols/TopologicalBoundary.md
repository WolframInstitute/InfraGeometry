---
Template: Symbol
Name: TopologicalBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalBoundary
Keywords: [boundary, frontier, ball topology, finite topology, closure, interior]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalInterior, TopologicalNeighborhood, InfraBoundary]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalBoundary]()[*topo*, *s*]</code> gives the boundary of the vertex list *s* in the topology of the digraph *topo*: its closure minus its interior.

## Details & Options

The boundary is *bd(s) = cl(s) ∖ int(s) = cl(s) ∩ cl(V ∖ s)*, with *V* the vertices of *topo*, *cl* the [TopologicalClosure]() and *int* the [TopologicalInterior]().

The boundary is two-sided: it can hold vertices outside *s*, and *s* and *V ∖ s* have the same boundary. It is empty exactly when *s* is open and closed.

On a patch of the grid a vertex far from the rim is open and closed in the ball topology, so it is never on a boundary. This is unlike the combinatorial boundary, the vertices of *s* with a neighbour outside *s*: that is [InfraBoundary](). <code>[InfraBoundary]()[*g*, *s*, Method -> {"Alexandrov", "Radius" -> *r*}]</code> is the topological boundary.

The result is a sorted vertex list.

## Basic Examples

The ring outside a ball about the centre, in the ball topology of radius 2, on the square grid and on the square mesh. The ring is drawn with its boundary on top. The boundary lies outside the ring:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, VertexEccentricity[g, c] - 2], "VertexDensity"]},
    {ring = Complement[VertexList[g], ball]},
    InfraSubstrateHighlight[g, {ring, TopologicalBoundary[BallTopology[g, 2], ring]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The balls of radius 5 to 8 about the centre of the grid, at radius 2. The boundary is empty while the ball keeps away from the rim and grows as it comes near, to 0, 4, 16 and 28 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {topo = BallTopology[g, 2]},
  GraphicsRow @ Table[
    With[{ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], k], "VertexDensity"]},
      {bd = TopologicalBoundary[topo, ball]},
      InfraSubstrateHighlight[g, {ball, bd}, PlotLabel -> Length[bd]]],
    {k, 5, 8}]]
```

## Properties and Relations

A set and its complement have one boundary, the intersection of their closures. [InfraBoundary]() with the method `"Alexandrov"` gives the same set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {topo = BallTopology[g, 2]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 8], "VertexDensity"]},
  {rest = Complement[VertexList[g], ball], bd = TopologicalBoundary[topo, ball]},
  {bd === TopologicalBoundary[topo, rest],
   bd === Intersection[TopologicalClosure[topo, ball], TopologicalClosure[topo, rest]],
   bd === InfraBoundary[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```

The combinatorial boundary of the ball of radius 5 on the grid is its circle of 20 vertices. Its topological boundary is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 5], "VertexDensity"]},
  {Length @ InfraBoundary[g, ball], TopologicalBoundary[BallTopology[g, 2], ball]}]
```
