---
Template: Symbol
Name: BoundarylessGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BoundarylessGraph
Keywords: [boundary, rim, open window, substrate preparation, mesh, patch]
SeeAlso: [GraphExteriorBoundary, CenterGraph, InfraSubstrate, TessellationNeighborhoodGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BoundarylessGraph]()[*g*]</code> deletes every edge of *g* whose two ends lie on its rim, then the vertices this leaves without an edge.

<code>[BoundarylessGraph]()[*mr*]</code> does the same on the edges of the mesh region *mr*, whose rim is its boundary.

## Details & Options

Definition: let *∂g* be the rim, <code>[GraphExteriorBoundary]()[*g*]</code>. The result is *g* without the edges {*u*, *v*} with *u*, *v* ∈ *∂g*, and without the vertices that then have no edge.

The contour of the rim disappears, while a rim vertex with an edge inward stays as a whisker. The graph models an open window onto the geometry, a patch with no contour drawn round it.

The vertex coordinates are kept, in their own dimension; `"KeepCoordinates"` -> [False]() drops them. The rim of a graph is the one of [GraphExteriorBoundary](), with no method to choose; the rim of a mesh region is exact, and its vertices are numbered as in [MeshCoordinates](). [Graph]() options are passed on to the graph.

The patches of [InfraSubstrate]() are made this way: the tilings from balls of [TessellationNeighborhoodGraph](), the grids from [GridGraph](), the meshes from their mesh regions.

## Basic Examples

The 8 × 8 grid, a ball of the triangular tiling and a triangulated disk with the rim contour removed, and the number of edges removed from each.

```wl
With[
  {mesh = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
  {graphs = {GridGraph[{8, 8}], TessellationNeighborhoodGraph[{3, 6}, 4], MeshConnectivityGraph[mesh, 0]}},
  {windows = {BoundarylessGraph[graphs[[1]]], BoundarylessGraph[graphs[[2]]], BoundarylessGraph[mesh]}},
  {GraphicsRow[windows], EdgeCount /@ graphs - EdgeCount /@ windows}]
```

## Options

### KeepCoordinates

Without the coordinates the graph is laid out by springs.

```wl
GraphicsRow @ Table[BoundarylessGraph[GridGraph[{8, 8}], "KeepCoordinates" -> keep], {keep, {True, False}}]
```

## Properties and Relations

The square tiling substrate is the ball of radius 7 of the square tiling without its rim contour.

```wl
With[
  {window = BoundarylessGraph[TessellationNeighborhoodGraph[{4, 4}, 7]]},
  {window, Sort[EdgeList[window]] === Sort[EdgeList @ InfraSubstrate["SquareTilingGraph", "Small"]]}]
```

The removed edges are the edges among the rim vertices, drawn thick.

```wl
With[
  {g = TessellationNeighborhoodGraph[{3, 6}, 4]},
  {rim = GraphExteriorBoundary[g]},
  {InfraSubstrateHighlight[g, {rim}],
   EdgeCount[g] - EdgeCount[BoundarylessGraph[g]] == EdgeCount[Subgraph[g, rim]]}]
```

The graph of a mesh gives the same window as the mesh region: the disk without its rim from the graph and from the mesh region, and the numbers of edges removed.

```wl
With[
  {mesh = DiscretizeRegion[Disk[], MaxCellMeasure -> 0.01]},
  {graph = IndexGraph @ MeshConnectivityGraph[mesh, 0]},
  {windows = {BoundarylessGraph[graph], BoundarylessGraph[mesh]}},
  {GraphicsRow[windows], EdgeCount[graph] - EdgeCount /@ windows}]
```
