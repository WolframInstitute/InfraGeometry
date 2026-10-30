---
Template: Symbol
Name: InfraInfiniteLineQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraInfiniteLineQ
Keywords: [line, inextensible shortest path, predicate]
SeeAlso: [RandomInfraInfiniteLine, InfraInfiniteLine, InfraSegmentQ, InfraHalfLineQ]
RelatedGuides: [Experimental]
---

## Usage

<code>[InfraInfiniteLineQ]()[*g*, *walk*]</code> tests whether the vertex list *walk* is a line in *g*: a shortest path that no neighbour of either end prolongs.

<code>[InfraInfiniteLineQ]()[*g*, {*walk₁*, *walk₂*, …}]</code> tests every walk of a list.

## Details & Options

A line *v₀, …, vₖ* is a shortest path, *k = d(v₀, vₖ)*, such that no neighbour of *v₀* lies at distance *k* + 1 from *vₖ* and no neighbour of *vₖ* at distance *k* + 1 from *v₀*.

A line is a [InfraHalfLineQ]() ray from either end. It need not reach the rim of the graph: it ends where no neighbour is farther from the other end.

A list of fewer than two vertices is not a line. A walk graph, such as a directed path graph from [FindInfraPerpendicular](), is read as its walks. The test takes a line itself, not the head [InfraInfiniteLine]()[*p*, *q*], which names the family of lines through *p* and *q*; membership in that family is [InfraMemberQ]()[*g*, [InfraInfiniteLine]()[*p*, *q*], *walk*].

## Basic Examples

A line through the centre and a vertex at distance 2, and the same walk without its last vertex, which can be prolonged:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
    {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {line, c},
      PlotLabel -> {InfraInfiniteLineQ[g, line], InfraInfiniteLineQ[g, Most @ line]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the 6-cycle the lines are the shortest paths to the opposite vertex:

```wl
{InfraInfiniteLineQ[CycleGraph[6], {1, 2, 3, 4}], InfraInfiniteLineQ[CycleGraph[6], {1, 2, 3}]}
```

## Scope

A list of walks is tested as a whole. All lines through the centre and a vertex at distance 2 on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {lines = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {Length[lines], InfraInfiniteLineQ[g, lines]}]
```

A directed path graph is read as its walk:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {line = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  InfraInfiniteLineQ[g, PathGraph[line, DirectedEdges -> True]]]
```

## Properties and Relations

A row of the square grid runs from rim to rim and is a line; a piece of it is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {y = AssociationThread[VertexList[g], GraphEmbedding[g][[All, 2]]]}, {row = Select[VertexList[g], y[#] == y[c] &]},
  InfraSubstrateHighlight[g, {row}, PlotLabel -> {InfraInfiniteLineQ[g, row], InfraInfiniteLineQ[g, Take[row, 5]]},
    ImageSize -> Medium]]
```

A line through *p* and *q* is a member of the family [InfraInfiniteLine]()[*p*, *q*]; the same walk without its last vertex is not:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {q = RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1]},
  {line = RandomInfraInfiniteLine[g, c, q, RandomSeeding -> 1]},
  {InfraMemberQ[g, InfraInfiniteLine[c, q], line], InfraMemberQ[g, InfraInfiniteLine[c, q], Most @ line]}]
```
