---
Template: Symbol
Name: TopologicalInterior
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalInterior
Keywords: [interior, open set, ball topology, finite topology, specialization preorder]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalBoundary, TopologicalNeighborhood, InfraInterior]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalInterior]()[*topo*, *s*]</code> gives the interior of the vertex list *s* in the topology of the digraph *topo*: the vertices of *s* from which no directed path leaves *s*.

## Details & Options

The interior is *int(s) = V ∖ cl(V ∖ s)*, with *V* the vertices of *topo* and *cl* the [TopologicalClosure](). It is the largest open set inside *s*.

In <code>[BallTopology]()[*g*, *r*]</code> a vertex *p* of *s* is interior when every vertex *q* with *Bᵣ(q) ⊆ Bᵣ(p)* lies in *s*.

The interior lies in *s*. The interior of the interior is the interior, and the interior of an intersection is the intersection of the interiors. A set is open when it is its own interior.

On a patch of the grid a vertex far from the rim is open, so every set of such vertices is open. This is unlike the combinatorial interior, the vertices of *s* all of whose neighbours lie in *s*: that is [InfraInterior](). <code>[InfraInterior]()[*g*, *s*, Method -> {"Alexandrov", "Radius" -> *r*}]</code> is the topological interior.

The result is a sorted vertex list.

## Basic Examples

The interior of a ball about the centre that comes within two steps of the rim, in the ball topology of radius 2, on the square grid and on the square mesh. The ball is drawn with its interior on top:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, VertexEccentricity[g, c] - 2], "VertexDensity"]},
    InfraSubstrateHighlight[g, {ball, TopologicalInterior[BallTopology[g, 2], ball]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Away from the rim a ball is open. The ball of radius 5 on the grid is its own interior, all 61 vertices; its combinatorial interior is the ball of radius 4, 41 vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 5], "VertexDensity"]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {ball, int}, PlotLabel -> Length[int]],
    {int, {TopologicalInterior[BallTopology[g, 2], ball], InfraInterior[g, ball]}}]]
```

## Scope

A circle far from the rim is open: the 20 vertices at distance 5 from the centre are their own interior. The combinatorial interior of the circle is empty:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]},
  {shell = Keys @ InfraMeasurement[g, InfraShell[First @ GraphCenter[g], 5], "VertexDensity"]},
  {TopologicalInterior[BallTopology[g, 2], shell] === shell, InfraInterior[g, shell]}]
```

## Properties and Relations

The interior is open: it is its own interior and its own smallest open neighbourhood. [InfraInterior]() with the method `"Alexandrov"` gives the same set:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]}, {topo = BallTopology[g, 2]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 8], "VertexDensity"]}, {int = TopologicalInterior[topo, ball]},
  {TopologicalInterior[topo, int] === int, TopologicalNeighborhood[topo, int] === int,
   int === InfraInterior[g, ball, Method -> {"Alexandrov", "Radius" -> 2}]}]
```

The interior is the complement of the closure of the complement:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {c = First @ GraphCenter[g]}, {topo = BallTopology[g, 2]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[c, 8], "VertexDensity"]},
  TopologicalInterior[topo, ball] === Complement[VertexList[g], TopologicalClosure[topo, Complement[VertexList[g], ball]]]]
```
