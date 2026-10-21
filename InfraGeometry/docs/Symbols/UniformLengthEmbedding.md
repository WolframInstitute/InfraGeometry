---
Template: Symbol
Name: UniformLengthEmbedding
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/UniformLengthEmbedding
Keywords: [embedding, unit distance, unit edges, edge length, layout, spring relaxation, rigidity]
SeeAlso: [UniformLengthGraph, TessellationGraph, GraphEmbedding]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[UniformLengthEmbedding]()[*g*]</code> gives coordinates for the vertices of *g*, in the order of [VertexList](), under which the edges of *g* are relaxed towards length 1.

## Details & Options

A unit-distance embedding is a map *f : V → ℝᵈ* with *‖f(u) − f(v)‖ = 1* for every edge *uv*. [UniformLengthEmbedding]() looks for one: it starts from the spring-electrical layout scaled to mean edge length 1, and at every step moves the two ends of each edge by half of what brings it to length 1.

A flexible graph, such as a grid or a ball of the hexagonal tiling, has many unit-distance embeddings and the relaxation finds one. A rigid one, such as a ball of the triangular tiling, has essentially one, and the relaxation can stop short of it. A graph with no unit-distance embedding in ℝᵈ, such as the complete graph on four vertices in the plane, ends with edges spread about 1.

The result has the shape of [GraphEmbedding]()[*g*]: draw it with <code>[Graph]()[*g*, [VertexCoordinates]() -> [UniformLengthEmbedding]()[*g*]]</code>. [UniformLengthGraph]() goes the other way, from a region to a graph with edges of one length.

| Option | Default | Values |
|---|---|---|
| `"Dimension"` | 3 | the dimension *d* |
| `"MaxIterations"` | 500 | the number of relaxation steps |
| `"Tolerance"` | 10⁻⁷ | the largest move at which the relaxation stops |
| `"MaxStepPerVertex"` | 0.15 | the largest move of a vertex in one step |
| `"NonEdgeRepulsion"` | 0. | how strongly two vertices with no edge closer than 0.9 push apart |
| `"InitialEmbedding"` | [Automatic]() | the starting coordinates |

A start that is flat in three dimensions is jittered at random, so [SeedRandom]() fixes the result.

## Basic Examples

The octahedron, the icosahedron and the dodecahedron, which [TessellationGraph]() builds without coordinates, in space with unit edges; labelled with the shortest and the longest edge:

```wl
GraphicsRow @ Table[
  With[{g = TessellationGraph[spec]}, {c = UniformLengthEmbedding[g]},
    Graph[g, VertexCoordinates -> c, PlotLabel -> Round[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], 0.01]]],
  {spec, {{3, 4}, {3, 5}, {5, 3}}}]
```

In the plane: a ball of the hexagonal tiling, the 6 × 6 grid and the 12-cycle, all flexible:

```wl
GraphicsRow @ Table[
  With[{g = IndexGraph[graph]}, {c = UniformLengthEmbedding[g, "Dimension" -> 2]},
    Graph[g, VertexCoordinates -> c, PlotLabel -> Round[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], 0.01]]],
  {graph, {TessellationNeighborhoodGraph[{6, 3}, 5], GridGraph[{6, 6}], CycleGraph[12]}}]
```

## Options

### MaxIterations

The third Sierpinski graph needs more than 500 steps. After 500 its edges lie between 0.88 and 1.18, after 5000 they have length 1:

```wl
With[{g = IndexGraph @ SierpinskiGraph[3]},
  GraphicsRow @ Table[With[{c = UniformLengthEmbedding[g, "MaxIterations" -> steps]},
    Graph[g, VertexCoordinates -> c, PlotLabel -> Round[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], 0.01]]],
    {steps, {500, 5000}}]]
```

### NonEdgeRepulsion

The four-dimensional cube in space. With unit edges two vertices without an edge come within 0.35 of each other; repulsion keeps them at least 0.58 apart, and the edges give way:

```wl
With[{g = HypercubeGraph[4]}, {far = Select[Subsets[Range[16], {2}], ! EdgeQ[g, UndirectedEdge @@ #] &]},
  Table[With[{c = UniformLengthEmbedding[g, "NonEdgeRepulsion" -> r]},
    {MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], Min[EuclideanDistance @@ c[[#]] & /@ far]}], {r, {0., 1.}}]]
```

### InitialEmbedding

A ball of the triangular tiling is rigid. Started from the coordinates of the tiling, the relaxation keeps its unit edges:

```wl
With[{g = IndexGraph @ TessellationNeighborhoodGraph[{3, 6}, 3]},
  {c = UniformLengthEmbedding[g, "Dimension" -> 2, "InitialEmbedding" -> GraphEmbedding[g]]},
  Graph[g, VertexCoordinates -> c, PlotLabel -> Round[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], 0.01],
    ImageSize -> Medium]]
```

## Possible Issues

From the default start the same rigid ball stops short of unit edges, which end between 0.86 and 1.15:

```wl
With[{g = IndexGraph @ TessellationNeighborhoodGraph[{3, 6}, 3]}, {c = UniformLengthEmbedding[g, "Dimension" -> 2]},
  Graph[g, VertexCoordinates -> c, PlotLabel -> Round[MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]], 0.01],
    ImageSize -> Medium]]
```

Four points in the plane cannot be pairwise at distance 1, so the complete graph on four vertices gets no unit edges there:

```wl
With[{g = CompleteGraph[4]}, {c = UniformLengthEmbedding[g, "Dimension" -> 2]},
  MinMax[EuclideanDistance @@ c[[List @@ #]] & /@ EdgeList[g]]]
```
