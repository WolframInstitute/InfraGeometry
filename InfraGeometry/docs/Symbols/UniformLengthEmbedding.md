---
Template: Symbol
Name: UniformLengthEmbedding
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniformLengthEmbedding
Keywords: [embedding, unit distance, unit edges, edge length, layout, spring relaxation]
SeeAlso: [UniformLengthGraph, TessellationGraph, GraphEmbedding]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[UniformLengthEmbedding]()[*g*]</code> gives coordinates in space for the vertices of *g*, in the order of [VertexList](), under which the edges of *g* are relaxed towards length 1: from the spring-electrical layout, by edge springs.

## Details & Options

Construction: start from the spring-electrical layout of *g* in dimension *d*, scaled so that the mean edge length is 1. At each step, every edge {*u*, *v*} moves *u* and *v* by half of what brings it to length 1, a vertex moving at most `"MaxStepPerVertex"`; stop when no vertex moves more than `"Tolerance"`, or after `"MaxIterations"` steps.

An embedding with every edge of length 1 is a unit-distance embedding. The relaxation finds one for small graphs that have one, such as the Platonic solids in space, and it keeps one it is started from. A graph without one, such as the complete graph on four vertices in the plane, ends with edges spread about 1.

The result has the shape of <code>[GraphEmbedding]()[*g*]</code>: draw it with <code>[Graph]()[*g*, [VertexCoordinates]() -> [UniformLengthEmbedding]()[*g*]]</code>.

[UniformLengthGraph]() goes the other way: it discretizes a region by a graph with edges of one length.

| Option | Default | |
|---|---|---|
| `"Dimension"` | 3 | the dimension *d* of the space |
| `"MaxIterations"` | 500 | the number of relaxation steps |
| `"Tolerance"` | 10.^-7 | the largest move at which the relaxation stops |
| `"MaxStepPerVertex"` | 0.15 | the largest move of a vertex in one step |
| `"NonEdgeRepulsion"` | 0. | how strongly two vertices with no edge closer than 0.9 push apart |
| `"InitialEmbedding"` | [Automatic]() | the starting coordinates, in place of the spring-electrical layout |

A starting layout that is flat in three dimensions is jittered at random, so [SeedRandom]() fixes the result.

## Basic Examples

The graphs of the octahedron, the icosahedron and the dodecahedron, which [TessellationGraph]() builds without coordinates, placed in space with every edge of length 1; the shortest and the longest edge of each.

```wl
With[
  {solids = TessellationGraph /@ {{3, 4}, {3, 5}, {5, 3}}},
  {GraphicsRow @ Table[Graph[solid, VertexCoordinates -> UniformLengthEmbedding[solid]], {solid, solids}],
   Table[With[{coordinates = UniformLengthEmbedding[solid]}, MinMax[EuclideanDistance @@ coordinates[[List @@ #]] & /@ EdgeList[solid]]], {solid, solids}]}]
```

## Scope

In the plane: a ball of the hexagonal tiling, the 6 × 6 grid and the 12-cycle.

```wl
With[
  {graphs = IndexGraph /@ {TessellationNeighborhoodGraph[{6, 3}, 5], GridGraph[{6, 6}], CycleGraph[12]}},
  {GraphicsRow @ Table[Graph[g, VertexCoordinates -> UniformLengthEmbedding[g, "Dimension" -> 2]], {g, graphs}],
   Table[With[{coordinates = UniformLengthEmbedding[g, "Dimension" -> 2]}, MinMax[EuclideanDistance @@ coordinates[[List @@ #]] & /@ EdgeList[g]]], {g, graphs}]}]
```

## Options

### MaxIterations

The third Sierpinski graph needs more than the default 500 steps: after 500 its edges lie between 0.88 and 1.18, after 5000 they have length 1.

```wl
With[
  {g = IndexGraph @ SierpinskiGraph[3]},
  {GraphicsRow @ Table[Graph[g, VertexCoordinates -> UniformLengthEmbedding[g, "MaxIterations" -> steps]], {steps, {500, 5000}}],
   Table[With[{coordinates = UniformLengthEmbedding[g, "MaxIterations" -> steps]}, MinMax[EuclideanDistance @@ coordinates[[List @@ #]] & /@ EdgeList[g]]], {steps, {500, 5000}}]}]
```

### NonEdgeRepulsion

The four-dimensional cube in space: with unit edges, two vertices without an edge come within 0.35 of each other. Repulsion keeps them at least 0.58 apart, and the edges give way.

```wl
With[
  {g = HypercubeGraph[4]},
  {coordinates = Table[UniformLengthEmbedding[g, "NonEdgeRepulsion" -> repulsion], {repulsion, {0., 1.}}]},
  {GraphicsRow @ Table[Graph[g, VertexCoordinates -> c], {c, coordinates}],
   Table[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], {c, coordinates}],
   Table[Min[EuclideanDistance @@ c[[#]] & /@ Select[Subsets[Range[16], {2}], ! EdgeQ[g, UndirectedEdge @@ #] &]], {c, coordinates}]}]
```

### InitialEmbedding

A ball of the triangular tiling has unit edges in the plane in the coordinates of the tiling. Started from them, the relaxation keeps the unit edges; the default start does not reach them (see Possible Issues).

```wl
With[
  {g = IndexGraph @ TessellationNeighborhoodGraph[{3, 6}, 3]},
  {coordinates = {UniformLengthEmbedding[g, "Dimension" -> 2], UniformLengthEmbedding[g, "Dimension" -> 2, "InitialEmbedding" -> GraphEmbedding[g]]}},
  {GraphicsRow @ Table[Graph[g, VertexCoordinates -> c], {c, coordinates}],
   Table[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], {c, coordinates}]}]
```

## Possible Issues

A graph that has a unit-distance embedding need not end in it: the relaxation from the spring-electrical layout stops short. The ball of radius 3 of the triangular tiling has unit edges in the plane, yet its edges end between 0.86 and 1.15.

```wl
With[
  {g = IndexGraph @ TessellationNeighborhoodGraph[{3, 6}, 3]},
  {coordinates = UniformLengthEmbedding[g, "Dimension" -> 2]},
  {Graph[g, VertexCoordinates -> coordinates], MinMax[EuclideanDistance @@ coordinates[[List @@ #]] & /@ EdgeList[g]]}]
```

Four points in the plane cannot be pairwise at distance 1, so the complete graph on four vertices gets no unit edges there.

```wl
With[
  {coordinates = UniformLengthEmbedding[CompleteGraph[4], "Dimension" -> 2]},
  {Graph[CompleteGraph[4], VertexCoordinates -> coordinates], MinMax[EuclideanDistance @@ coordinates[[List @@ #]] & /@ EdgeList[CompleteGraph[4]]]}]
```
