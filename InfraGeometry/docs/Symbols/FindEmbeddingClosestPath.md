---
Template: Symbol
Name: FindEmbeddingClosestPath
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindEmbeddingClosestPath
---

## Usage

`FindEmbeddingClosestPath[graph, curve]` snaps an arbitrary embedded curve to a graph walk and returns the walk graph tracing it: each sampled curve point is mapped to its nearest vertex under the graph embedding, consecutive repeats are dropped, and successive anchors are joined by shortest paths. curve is a Line / BSplineCurve / BezierCurve or a list of plane points in the embedding's coordinates.

## Details & Options

Unlike EmbeddingClosest (which selects from a supplied bundle), this constructs the path, so it works for shapes with no enumerable bundle (spirals, figure-eights).
