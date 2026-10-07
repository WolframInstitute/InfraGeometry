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

Definition: the rim of a graph is the set of vertices whose neighbourhood is not closed. The neighbourhood of a vertex *v* is closed in one of two ways:

- when every vertex lies on a triangle, it is the link of *v*, the subgraph induced on the neighbours of *v*. On a triangulated surface the link of an interior vertex is one cycle; in a mesh of tetrahedra it is a triangulated sphere, so it has no edge lying on exactly one of its triangles.
- otherwise it is the full neighbourhood, and *v* is interior when its degree is the largest degree of the graph.

The first case is a mesh, the second a lattice or a tiling; the graph tells which, and no method is chosen. For a mesh region of dimension *d*, the rim is the set of vertices of the (*d* − 1)-cells that lie in exactly one *d*-cell: its exact boundary, given as positions in [MeshCoordinates](). A region of dimension 1 or less has none.

On the graph of a triangle or tetrahedron mesh the rim equals that of the mesh region. A graph that is neither, a tree say, gives the vertices of less than full degree.

The rim is that of the whole graph. The boundary of a set of vertices inside the graph is [InfraBoundary]().

## Basic Examples

The rim of the square, hexagonal and triangular tilings.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    InfraSubstrateHighlight[g, {GraphExteriorBoundary[g]}]],
  {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]
```

The rim of the graph of a triangulated disk: the vertices on its circle, the same as the boundary of the mesh region.

```wl
With[
  {mesh = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
  {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  {rim = GraphExteriorBoundary[graph]},
  {InfraSubstrateHighlight[graph, {rim}], Length[rim], Sort[rim] === Sort @ GraphExteriorBoundary[mesh]}]
```

## Scope

A solid: the boundary of a tetrahedral mesh of the ball is the sphere, on the mesh region and on its graph.

```wl
With[
  {mesh = DiscretizeRegion[Ball[], MaxCellMeasure -> 0.05]},
  {rim = GraphExteriorBoundary[mesh]},
  {Graph3D[Subgraph[IndexGraph @ MeshConnectivityGraph[mesh, 0], rim]], MinMax[Norm /@ MeshCoordinates[mesh][[rim]]]}]
```

## Properties and Relations

[BoundarylessGraph]() deletes the edges between rim vertices, so the contour disappears and the vertices with an edge inward stay as whiskers.

```wl
With[
  {g = GridGraph[{8, 8}]},
  {rim = GraphExteriorBoundary[g]},
  {GraphicsRow[{InfraSubstrateHighlight[g, {rim}], BoundarylessGraph[g]}], Length[rim]}]
```

## Possible Issues

The rule reads the graph alone. A corner of a tetrahedral mesh that lies on three tetrahedra has the complete graph on four vertices as its link, the same as a vertex inside four tetrahedra, so no rule on the graph can tell the two apart; the rim of such a graph misses these corners. The mesh region has no such ambiguity.
