---
Template: Symbol
Name: PathSubgraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PathSubgraph
SeeAlso: [InfraSegment, InfraMeasurement, FindPath, Subgraph, GraphUnion]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

`PathSubgraph[graph, u, v]` returns the union of all shortest u-v paths.

`PathSubgraph[graph, u, v, k]` (or UpTo[k]) caps path length; PathSubgraph[graph, u, v, All] returns the full simple-path subgraph.

## Details & Options

The option `"Directed" -> True` orients each path from *u* to *v*. Use `"Directed" -> False` for its undirected edge union.

The length cap counts edges. The default equals the segment graph on an unweighted substrate. A larger cap adds detours, which the segment excludes. `All` includes every simple path between the endpoints.

This is a union of path **edges**, not the subgraph induced on their vertices. The latter can contain additional edges that violate the cap. The graph does not retain which edges belonged to the same path.

The construction uses the built-ins `FindPath`, `PathGraph` and `GraphUnion`. Enumerating all simple paths can be expensive.

## Basic Examples

On a six-cycle, the two routes from 1 to 3 have lengths 2 and 4. Increasing the cap adds the longer route.

```wl
SeedRandom[1];
With[
  { graph = CycleGraph[6] },
  GraphicsRow[PathSubgraph[graph, 1, 3, #, "Directed" -> False] & /@ {2, 4}]]
```

The default segment has just the short route. Its support subgraph is available through the measurement API.

```wl
SeedRandom[1];
With[
  { graph = CycleGraph[6] },
  {PathSubgraph[graph, 1, 3],
   InfraMeasurement[graph, InfraSegment[1, 3], "Graph"],
   InfraMeasurement[graph, InfraSegment[1, 3], "Subgraph"]}]
```
