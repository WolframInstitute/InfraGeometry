---
Template: Symbol
Name: InfraUnion
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraUnion
---

## Usage

`InfraUnion[graph, obj1, obj2, ...]` returns the vertex-set union of the given shapes on graph — vertex lists, densities, walk graphs — as a sorted List.

`InfraUnion[obj1, obj2]` of two Euclidean heads is itself an inert head; InfraMeasurement evaluates it on a graph.

## Details & Options

On heads, InfraMeasurement gives the union its "VertexDensity" — the sum of the two densities — its "Subgraph" and the four volumes. It is not a family of walks, so it has no "Graph", "Cardinality", "Length", "EdgeDensity" or "Faithful".

Inside InfraScene hypotheses `InfraUnion[c1, c2]` is the union token, the engine supplying the graph.

## Basic Examples

The union of two vertex lists.

```wl
InfraUnion[GridGraph[{5, 5}], {1, 2, 3}, {3, 8, 13}]
```

Two crossing segments on a grid: the density of their union is the sum of theirs.

```wl
InfraMeasurement[GridGraph[{5, 5}], InfraUnion[InfraSegment[1, 13], InfraSegment[7, 19]], "VertexDensity"]
```
