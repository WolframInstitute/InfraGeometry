---
Template: Symbol
Name: GraphExteriorBoundary
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/GraphExteriorBoundary
Keywords: [boundary, rim, closed neighbourhood, link, mesh boundary, patch, substrate preparation]
SeeAlso: [BoundarylessGraph, CenterGraph, InfraSubstrate, InfraBoundary]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[GraphExteriorBoundary]()[*g*]</code> gives the rim of the graph *g*: the vertices whose neighbourhood is not closed.

<code>[GraphExteriorBoundary]()[*mr*]</code> gives the vertices on the boundary of the mesh region *mr*.

## Details & Options

The rule depends on the graph:

| Graph | Rim *∂g* |
|---|---|
| every vertex on a triangle, some link a cycle of length ≥ 4 (a surface) | *{v : lk(v) is not a cycle}* |
| every vertex on a triangle, no such cycle (a mesh of tetrahedra) | *{v : some edge of lk(v) lies on exactly one triangle of lk(v)}* |
| otherwise (a lattice, a tiling, a tree) | *{v : deg v < Δ}*, *Δ* the largest degree |

The link *lk(v)* is the subgraph induced on the neighbours of *v*. On a triangulated surface the link of an inner vertex is a cycle; in a mesh of tetrahedra it is a triangulated sphere, every edge on two triangles.

For a mesh region of dimension *d*, the rim is the set of vertices of the (*d* − 1)-cells that lie on exactly one *d*-cell, given as positions in [MeshCoordinates](). A region of dimension 1 or less has none.

The rim belongs to the whole graph. The boundary of a set of vertices inside the graph is [InfraBoundary]().

## Basic Examples

The rim of the square grid and of the square mesh. These substrates are windows with the contour removed, so the rim is what is left of it: on the grid the whiskers, on the mesh the old rim vertices and the vertices whose links lost an edge with the contour:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {rim = GraphExteriorBoundary[g]},
    InfraSubstrateHighlight[g, {rim}, PlotLabel -> Length[rim]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The rim of the 10 × 10 grid and of the graph of a triangulated square, from which the two substrates are made. On the mesh the rim of the graph is the boundary of the region:

```wl
With[{mesh = DiscretizeRegion[Rectangle[], MaxCellMeasure -> 0.0085]}, {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  GraphicsRow[{InfraSubstrateHighlight[GridGraph[{10, 10}], {GraphExteriorBoundary @ GridGraph[{10, 10}]}],
    InfraSubstrateHighlight[graph, {GraphExteriorBoundary[graph]},
      PlotLabel -> (Sort @ GraphExteriorBoundary[graph] === Sort @ GraphExteriorBoundary[mesh])]}]]
```

## Scope

A solid. The rim of a tetrahedral mesh of the ball lies on the unit sphere, up to the faceting:

```wl
With[{mesh = DiscretizeRegion[ImplicitRegion[x^2 + y^2 + z^2 <= 1, {x, y, z}], MaxCellMeasure -> 0.005]},
  {rim = GraphExteriorBoundary[mesh]},
  {Length[rim], MeshCellCount[mesh, 0], MinMax[Norm /@ MeshCoordinates[mesh][[rim]]]}]
```

## Properties and Relations

[BoundarylessGraph]() deletes the edges between two rim vertices:

```wl
With[{g = GridGraph[{10, 10}]}, {rim = GraphExteriorBoundary[g]},
  EdgeCount[g] - EdgeCount[BoundarylessGraph[g]] == EdgeCount[Subgraph[g, rim]]]
```

## Possible Issues

The graph alone cannot always see the boundary. Three tetrahedra around an edge have the complete graph on five vertices as their graph. Every link is then the complete graph on four vertices, as at a vertex inside four tetrahedra, so the graph has no rim while the mesh region is all rim:

```wl
With[{mesh = MeshRegion[{{0, 0, 0}, {0, 0, 1}, {1, 0, 0}, {-1/2, Sqrt[3]/2, 0}, {-1/2, -Sqrt[3]/2, 0}},
    Tetrahedron /@ {{1, 2, 3, 4}, {1, 2, 4, 5}, {1, 2, 5, 3}}]},
  {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  {GraphExteriorBoundary[mesh], GraphExteriorBoundary[graph], IsomorphicGraphQ[graph, CompleteGraph[5]]}]
```
