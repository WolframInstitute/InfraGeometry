---
Template: Symbol
Name: InfraIntersection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIntersection
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`InfraIntersection[graph, obj1, obj2, ...]` returns the vertex-set intersection of the given shapes on graph — vertex lists, densities, walk graphs — as a sorted List.

`InfraIntersection[obj1, obj2]` of two Euclidean heads is itself a symbolic object; InfraMeasurement evaluates it on a graph.

## Details & Options

On heads, InfraMeasurement gives the intersection its "VertexDensity" — the product of the two densities on their common vertices — its "Subgraph" and the two measures. It is not a family of walks, so it has no "Graph", "Cardinality", "Length", "EdgeDensity" or "Faithful".

Inside InfraScene hypotheses `InfraIntersection[c1, c2]` is the token for where two named objects meet: every common vertex is one branch. Evaluation is postponed until the bindings resolve and the scene engine supplies the graph.

## Basic Examples

The common vertices of two vertex lists.

```wl
InfraIntersection[GridGraph[{5, 5}], {1, 2, 3, 8}, {3, 8, 13}]
```

Two crossing segments on a grid: the density of their intersection is the product of theirs.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraIntersection[InfraSegment[1, 13], InfraSegment[7, 19]], "VertexDensity"]
```
