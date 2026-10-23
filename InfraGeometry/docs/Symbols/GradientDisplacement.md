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

<code>[GradientDisplacement]()[*g*, *f*]</code> is the steepest-ascent displacement of the function *f* on the vertices of *g*, given as an association *v* -> *f*(*v*).

## Details & Options

The gradient is *∇f(v) = {u ∼ v : f(u) is largest}* when that largest value exceeds *f(v)*, and *{v}* otherwise.

The fixed points are the local maxima of *f*: the vertices with no neighbour of larger value.

Ties among the neighbours are kept. On the square grid the gradient of *x + y* has two values at every inner vertex, the steps right and up; in the plane it is one vector, the diagonal.

The gradient of the distance from a vertex *c* is the outward radial displacement of [PolarDisplacements]().

*f* needs a value at every vertex of *g*.

## Basic Examples

The gradient of the first coordinate, on the square grid and on the square mesh. Each vertex moves to its neighbour furthest right. On the grid the right column and the pendant vertices of the top and bottom rows stay; on the mesh only 6 vertices of the right rim:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    DisplacementPlot[g, GradientDisplacement[g, AssociationThread[VertexList[g], First /@ GraphEmbedding[g]]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The gradient of a random height on the mesh. The arrows run into the local maxima, which stay:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {f = (SeedRandom[1]; AssociationThread[VertexList[g], RandomReal[1, VertexCount[g]]])},
  DisplacementPlot[g, GradientDisplacement[g, f]]]
```

## Scope

Ties are kept. The gradient of *x + y* on the grid has two values at each of the 64 inner vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {gradient = GradientDisplacement[g, AssociationThread[VertexList[g], Total /@ GraphEmbedding[g]]]},
  DisplacementPlot[g, gradient, PlotLabel -> KeySort @ Counts[Length /@ gradient]]]
```

## Properties and Relations

The fixed points are the local maxima. Their numbers for a random height on the mesh:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {f = (SeedRandom[1]; AssociationThread[VertexList[g], RandomReal[1, VertexCount[g]]])},
  {gradient = GradientDisplacement[g, f]},
  {Count[Keys[gradient], v_ /; gradient[v] === {v}], Count[VertexList[g], v_ /; f[v] > Max[f /@ AdjacencyList[g, v]]]}]
```

The gradient of the distance from the centre is the outward radial displacement:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  GradientDisplacement[g, AssociationThread[VertexList[g], GraphDistance[g, c]]] === First @ PolarDisplacements[g, c]]
```
