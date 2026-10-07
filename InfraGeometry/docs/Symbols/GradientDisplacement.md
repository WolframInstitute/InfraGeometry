---
Template: Symbol
Name: GradientDisplacement
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GradientDisplacement
Keywords: [displacement, gradient, steepest ascent, vertex function, local maximum, flow]
SeeAlso: [PolarDisplacements, TranslationDisplacement, RandomDisplacement, DisplacementPlot]
RelatedGuides: [InfraAnalysis]
---

## Usage

<code>[GradientDisplacement]()[*g*, *f*]</code> is the steepest-ascent displacement of the vertex function *f*, an association *v* -> *value*: each vertex moves to its neighbours of largest *f* when that exceeds *f*(*v*), and stays otherwise.

## Details & Options

Definition: *grad f(v)* is the set of neighbours *u* of *v* at which *f(u)* is largest, when that largest value exceeds *f(v)*, and {*v*} otherwise.

The fixed points are the local maxima of *f*: the vertices where no neighbour has a larger value. Ties among the neighbours are kept. The gradient of the distance from a vertex *c* is the outward radial displacement of [PolarDisplacements]().

*f* needs a value at every vertex of *g*.

## Basic Examples

The gradient of a random height on the discretized plane, the square tiling and the hexagonal tiling. Each vertex climbs to its highest neighbour, and the arrows gather at the local maxima, which stay. Their number is given.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {gradients = GradientDisplacement[#, (SeedRandom[1]; AssociationThread[VertexList[#], RandomReal[1, VertexCount[#]]])] & /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, gradients}]], Count[KeyValueMap[{v, w} |-> w === {v}, #], True] & /@ gradients}]
```

The gradient of the second coordinate of the embedding: every vertex climbs to its highest neighbours, and the vertices of the top rim, the local maxima, stay.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {gradients = GradientDisplacement[#, AssociationThread[VertexList[#], Last /@ GraphEmbedding[#]]] & /@ graphs},
  {GraphicsRow[MapThread[DisplacementPlot, {graphs, gradients}]], Count[KeyValueMap[{v, w} |-> w === {v}, #], True] & /@ gradients}]
```

## Properties and Relations

The gradient of the distance from the centre is the outward radial displacement.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {gradient = GradientDisplacement[g, AssociationThread[VertexList[g], GraphDistance[g, c]]]},
  {DisplacementPlot[g, gradient], gradient === First @ PolarDisplacements[g, c]}]
```

Ties are kept. A height that grows along a step of the square tiling has a single highest neighbour at every vertex; a height that grows between two steps has two, wherever both exist.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {gradients = Table[GradientDisplacement[g, AssociationThread[VertexList[g], GraphEmbedding[g] . direction]], {direction, {{1, 1}, {1, 0}}}]},
  {GraphicsRow[DisplacementPlot[g, #] & /@ gradients], DisplacementSingleValuedQ /@ gradients}]
```
