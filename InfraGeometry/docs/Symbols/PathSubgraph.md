---
Template: Symbol
Name: PathSubgraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/PathSubgraph
Keywords: [shortest path, simple path, detour, path union, segment]
SeeAlso: [IntervalGraph, InfraSegment, InfraMeasurement, FindPath, GraphUnion]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[PathSubgraph]()[*g*, *u*, *v*]</code> gives the union of all shortest paths from *u* to *v*.

<code>[PathSubgraph]()[*g*, *u*, *v*, *k*]</code> gives the union of all simple paths from *u* to *v* with at most *k* edges.

<code>[PathSubgraph]()[*g*, *u*, *v*, All]</code> gives the union of all simple paths from *u* to *v*.

## Details & Options

The graph is *⋃ {P : P a simple path from u to v, |P| ≤ k}*, with *|P|* the number of edges. The default cap is *k = d(u, v)*, so the default is the union of the shortest paths, the same edges as the [IntervalGraph]().

A cap above *d(u, v)* adds detours. On a bipartite graph such as the square grid every path from *u* to *v* has the parity of *d(u, v)*, so the caps *d(u, v) + 2j* and *d(u, v) + 2j + 1* give the same graph.

It is a union of path edges, not the subgraph induced on their vertices: an edge joining two path vertices is left out unless it lies on a path within the cap.

A cap below *d(u, v)* gives the empty graph. For *u* = *v* the result is the single vertex *u*. `UpTo[k]` is the same as *k*.

Options:

| Option | Default | Values |
|---|---|---|
| `"Directed"` | `True` | `True` orients every path from *u* to *v*; `False` gives undirected edges |

Enumerating all simple paths grows fast with the cap.

## Basic Examples

The paths of length at most *d(u, v) + 2* between the centre and a vertex at distance 3, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {u = First @ GraphCenter[g]},
    {v = RandomInfraPoint[g, InfraShell[u, 3], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {PathSubgraph[g, u, v, 5, "Directed" -> False], u, v}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid, the caps 3 and 4 give the same graph, and so do 5 and 6. The vertex and edge counts:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 3], RandomSeeding -> 1]},
  Table[k -> {VertexCount[#], EdgeCount[#]} & @ PathSubgraph[g, u, v, k], {k, 3, 6}]]
```

## Options

### Directed

`"Directed" -> False` keeps the same edges without orientation:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 3], RandomSeeding -> 1]},
  DirectedGraphQ /@ {PathSubgraph[g, u, v], PathSubgraph[g, u, v, "Directed" -> False]}]
```

## Properties and Relations

With the default cap the edges are those of the [IntervalGraph]():

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 4], RandomSeeding -> 1]},
  Sort @ EdgeList @ PathSubgraph[g, u, v] === Sort @ EdgeList @ IntervalGraph[g, u, v]]
```

## Possible Issues

With detours the directed union is not acyclic: two paths can cross an edge in opposite directions. The edges used both ways:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 3], RandomSeeding -> 1]}, {h = PathSubgraph[g, u, v, 5]},
  {AcyclicGraphQ[h], Select[EdgeList[h], MemberQ[EdgeList[h], Reverse[#]] &]}]
```

Draw such a union with `"Directed" -> False`.

A cap below the distance gives the empty graph:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {u = First @ GraphCenter[g]},
  {v = RandomInfraPoint[g, InfraShell[u, 3], RandomSeeding -> 1]},
  {VertexCount @ PathSubgraph[g, u, v, 2], EmptyGraphQ @ PathSubgraph[g, u, v, 2]}]
```
